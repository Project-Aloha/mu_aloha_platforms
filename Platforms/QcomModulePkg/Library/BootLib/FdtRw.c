/*
 * Copyright (c) 2020, The Linux Foundation. All rights reserved.
 * Copyright (C) 2006 David Gibson, IBM Corporation.
 *
 * libfdt is dual licensed: you can use it either under the terms of
 * the GPL, or the BSD license, at your option.
 *
 *  a) This library is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License as
 *     published by the Free Software Foundation; either version 2 of the
 *     License, or (at your option) any later version.
 *
 *     This library is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public
 *     License along with this library; if not, write to the Free
 *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
 *     MA 02110-1301 USA
 *
 * Alternatively,
 *
 *  b) Redistribution and use in source and binary forms, with or
 *     without modification, are permitted provided that the following
 *     conditions are met:
 *
 *     1. Redistributions of source code must retain the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer.
 *     2. Redistributions in binary form must reproduce the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer in the documentation and/or other materials
 *        provided with the distribution.
 *
 *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 *     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 *     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *     CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *     NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *     CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 *     OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *     EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "AutoGen.h"
#include <Library/PrintLib.h>
#include <Library/DebugLib.h>
#include <libfdt_env.h>
#include <fdt.h>
#include <libfdt.h>

#include <Library/FdtRw.h>

#include <Library/MemoryAllocationLib.h>

STATIC FDT_FIRST_LEVEL_NODE *NodeList;

STATIC VOID FdtDeleteNodeList (VOID)
{
  FDT_FIRST_LEVEL_NODE *Current = NodeList;
  FDT_FIRST_LEVEL_NODE *Next;

  while (Current != NULL) {
    Next = Current->Next;
    FreePool (Current);
    Current = Next;
  }
  NodeList = NULL;
}

STATIC UINT32 GetNodeNameLen (CONST CHAR8 *NodeName)
{
  CONST CHAR8 *Ptr = NULL;
  CONST CHAR8 *End = NodeName + AsciiStrLen (NodeName);
  UINT32 NameLen = 0;

  if (! *NodeName) {
    return NameLen;
  }
  Ptr = strchr (NodeName, '{');
  if (! Ptr) {
    Ptr = End;
  }

  NameLen = Ptr - NodeName;
  return NameLen;
}

STATIC BOOLEAN IsNodeAdded (CONST CHAR8 *NodeName, UINT32 NameLen)
{
  FDT_FIRST_LEVEL_NODE *Node = NULL;

  for (Node = NodeList; Node; Node = Node->Next) {
    if (!AsciiStrnCmp (Node->NodeName, NodeName, NameLen)) {
      return TRUE;
    }
  }
  return FALSE;
}

STATIC VOID FdtAppendToNodeList (CONST CHAR8 *NodeName, INT32 NodeOffset)
{
  FDT_FIRST_LEVEL_NODE *Node;
  UINT32 NameLen;

  NameLen = GetNodeNameLen (NodeName);
  if (IsNodeAdded (NodeName, NameLen)) {
    return;
  }

  Node = AllocateZeroPool (sizeof (*Node));
  if (Node) {
    Node->Next = NodeList;
    NodeList = Node;
    Node->NodeName = AllocateZeroPool (NameLen + 1);
    if (Node->NodeName) {
      CopyMem ((VOID *)Node->NodeName, NodeName, NameLen);

      Node->NodeOffset = NodeOffset;
    } else {
        FdtDeleteNodeList ();
    }
  } else {
    FdtDeleteNodeList ();
  }
}

STATIC BOOLEAN FdtFindNodeFromList (CONST CHAR8 *Name,
                                        UINT32 NameLen,
                                        INT32 *NodeOffset)
{
  FDT_FIRST_LEVEL_NODE *Node = NULL;

  *NodeOffset = 0;
  if (NodeList) {
    /* Put the ptr of node offset to the last one */
    *NodeOffset = NodeList->NodeOffset;

    for (Node = NodeList; Node; Node = Node->Next) {
      if (!AsciiStrnCmp (Node->NodeName, Name, NameLen)) {
        *NodeOffset = Node->NodeOffset;
        return TRUE;
      }
    }
  }
  return FALSE;
}

VOID FdtUpdateNodeOffsetInList (INT32 NodeOffset, INT32 DiffLen)
{
  FDT_FIRST_LEVEL_NODE *Node = NULL;

  if (!DiffLen) {
    return;
  }

  for (Node = NodeList; Node; Node = Node->Next) {
    if (Node->NodeOffset > NodeOffset) {
      Node->NodeOffset +=  DiffLen;
    } else {
      break;
    }
  }
}

/**
  Compare the node's name
  @param[in] Fdt        A pointer to the device tree blob.
  @param[in] Offset   The offset of the node whose property to find.
  @param[in] Source  The name of the property to find.
  @param[in] Len       The length to compare from source.

  @retval TRUE          Match.
  @retval FALSE         Mismatch.
 **/
STATIC BOOLEAN FdtNodeNameEq (CONST VOID *Fdt, INT32 Offset,
                                   CONST CHAR8 *Source, UINT32 Len)
{
  CONST CHAR8 *Ptr = fdt_offset_ptr (Fdt, Offset + FDT_TAGSIZE, Len + 1);

  if (!Ptr) {
    /* short match: Some error occurs  */
    return FALSE;
  }

  if (CompareMem (Ptr, Source, Len) != 0) {
    return FALSE;
  }

  if (Ptr[Len] == '\0') {
    return TRUE;
  } else if (!ScanMem8 (Source, '@', Len) &&
            (Ptr[Len] == '@')) {
    return TRUE;
  }
  return FALSE;
}

/**
  Find a subnode based on substring
  @param[in] Fdt        A pointer to the device tree blob.
  @param[in] Offset   The structure block offset of a node.
  @param[in] Name    The name of the subnode to locate.
  @param[in] NameLen     The number of characters of name to consider.
  @param[in] Level     The Level of node.

  @retval > 0           Find node subnode successfully.
  @retval other        Some error occurs when searching this subnode.

  Identical to fdt_subnode_offset_namelen(), but only examine the first
  namelen characters of name for matching the subnode name.  This is
  useful for finding subnodes based on a portion of a larger string,
  such as a full path.
 **/
STATIC INT32 FdtSubnodeOffsetNamelen (CONST VOID *Fdt,
                                     INT32 Offset,
                                     CONST CHAR8 *Name,
                                     UINT32 NameLen,
                                     UINT32 Level)
{
  INT32 Depth;
  INT32 Value = 0, Ret;
  CONST CHAR8 *Ptr = NULL;

  if ((Ret = fdt_check_header (Fdt)) != 0) {
    return Ret;
  }

  if (!Level) {
    /* First find the node from the node list.
         * Found: start to search from the level 0's offset
         * Not Found: start to search from the last level 0's offset
         */
    Ret = FdtFindNodeFromList (Name, NameLen, &Offset);
    if (Ret) {
      return Offset;
    }

    if (Offset) {
      /* the depth should be 1 if find the offset from the list */
      Value = 1;
    }
  }

  for (Depth = Value;
      (Offset >= 0) &&
      (Depth >= 0);
       Offset = fdt_next_node (Fdt, Offset, &Depth)) {
    if (Depth == 1) {
      /* Record the level 0's name and offset one by one */
      if (!Ret &&
         !Level) {
        Ptr =
             fdt_offset_ptr (Fdt, Offset + FDT_TAGSIZE, NameLen + 1);
        if (! Ptr) {
          /* short match: Some error occurs  */
          return 0;
        }
        FdtAppendToNodeList (Ptr, Offset);
      }
      /* Return the offset if find the node */
      if (FdtNodeNameEq (Fdt, Offset, Name, NameLen)) {
        return Offset;
      }
    }
  }

  if (Depth < 0) {
    return -1;
  }

  /* Error:  Could not find the node*/
  return Offset;
}

/**
   Find a tree node by its full path
  @param[in] Fdt      A pointer to the device tree blob.
  @param[in] Path    The full path of the node to locate.

  FdtPathOffsetEx() finds a node of a given path in the device tree.
  Each path component may omit the unit address portion, but the
  results of this are undefined if any such path component is
  ambiguous (that is if there are multiple nodes at the relevant
  level matching the given component, differentiated only by unit
  address).

  returns:
    structure block offset of the node with the requested path (>=0), on success
    -FDT_ERR_BADPATH, given path does not begin with '/' or is invalid
    -FDT_ERR_NOTFOUND, if the requested node does not exist
    -FDT_ERR_BADMAGIC,
    -FDT_ERR_BADVERSION,
    -FDT_ERR_BADSTATE,
    -FDT_ERR_BADSTRUCTURE,
    -FDT_ERR_TRUNCATED, standard meanings.
 **/
INT32 FdtPathOffsetEx (CONST VOID *Fdt, CONST CHAR8 *Path)
{
  CONST CHAR8 *End = Path + AsciiStrLen (Path);
  CONST CHAR8 *Ptr = Path;
  CONST CHAR8 *Qtr = NULL;
  INT32 Offset = 0;
  UINT32 Level = 0;
  INT32 Ret;

  if (FixedPcdGetBool (EnableNewNodeSearchFuc)) {
    if ((Ret = fdt_check_header (Fdt)) != 0) {
      return Ret;
    }

    /* see if we have an alias */
    if (*Path != '/') {
      Qtr = strchr (Path, '/');
      if (!Qtr) {
        Qtr = End;
      }

      Ptr = fdt_get_alias_namelen (Fdt, Ptr, Qtr - Ptr);
      if (!Ptr) {
        return -FDT_ERR_BADPATH;
      }

      Offset = FdtPathOffsetEx (Fdt, Ptr);
      Ptr = Qtr;
    }

    while (*Ptr) {
      while (*Ptr == '/') {
        Ptr++;
      }
      if (! *Ptr) {
        return Offset;
      }
      Qtr = strchr (Ptr, '/');
      if (! Qtr) {
        Qtr = End;
      }

      Offset = FdtSubnodeOffsetNamelen (Fdt, Offset, Ptr, Qtr - Ptr, Level);
      if (Offset < 0) {
        return Offset;
      }
      Ptr = Qtr;
      Level ++;
    }
  } else {
    Offset = fdt_path_offset (Fdt, Path);
  }

  return Offset;
}

INT32 FdtGetPropLen (VOID *Fdt, INT32 Offset, CONST CHAR8 *Name)
{
  INT32 Len = 0;
  struct fdt_property *Prop = NULL;

  Prop = fdt_get_property_w (Fdt, Offset, Name, &Len);
  if (!Prop ||
    Len < 0) {
    Len = 0;
  }
  return Len;
}

/**
 * FdtSetPropEx - create or change a property
 * @Fdt: pointer to the device tree blob
 * @Offset: offset of the node whose property to change
 * @Name: name of the property to change
 * @Val: pointer to data to set the property value to
 * @Len: length of the property value
 *
 * FdtSetPropEx () sets the value of the named property in the given
 * node to the given value and length, creating the property if it
 * does not already exist.
 *
 * This function may insert or delete data from the blob, and will
 * therefore change the offsets of some existing nodes.
 *
 * returns:
 *  0, on success
 *  -FDT_ERR_NOSPACE, there is insufficient free space in the blob to
 *     contain the new property value
 *  -FDT_ERR_BADOFFSET, nodeoffset did not point to FDT_BEGIN_NODE tag
 *  -FDT_ERR_BADLAYOUT,
 *  -FDT_ERR_BADMAGIC,
 *  -FDT_ERR_BADVERSION,
 *  -FDT_ERR_BADSTATE,
 *  -FDT_ERR_BADSTRUCTURE,
 *  -FDT_ERR_BADLAYOUT,
 *  -FDT_ERR_TRUNCATED, standard meanings
 */
INT32 FdtSetPropEx (VOID *Fdt, INT32 Offset, CONST CHAR8 *Name,
                    CONST VOID *Val, INT32 Len)
{
  INT32 OldLen, NewLen;
  INT32 Ret = 0;

  if (FixedPcdGetBool (EnableNewNodeSearchFuc)) {
    OldLen = FdtGetPropLen (Fdt, Offset, Name);
    Ret = fdt_setprop (Fdt, Offset, Name, Val, Len);
    if (Ret == 0) {
      NewLen = FdtGetPropLen (Fdt, Offset, Name);
    } else {
      return Ret;
    }

    /* New prop */
    if (OldLen == 0 &&
      NewLen) {
      NewLen = sizeof (struct fdt_property) + FDT_TAGALIGN (NewLen);
    }

    /* Update the node's offset in the list */
    FdtUpdateNodeOffsetInList (
       Offset, FDT_TAGALIGN (NewLen) - FDT_TAGALIGN (OldLen));
  } else {
    Ret = fdt_setprop (Fdt, Offset, Name, Val, Len);
  }
  return Ret;
}
