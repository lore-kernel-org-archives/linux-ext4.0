From: akpm@linux-foundation.org
Subject: - byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:20 -0800
Message-ID: <200802082016.m18KG1YX010671@imap1.linux-foundation.org>
To: marcin.slusarz@gmail.com, dgc@sgi.com, linux-ext4@vger.kernel.org,
	mark.fasheh@oracle.com, tes@sgi.com, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33821 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358AbYBHVD3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 16:03:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     byteorder: move le32_add_cpu & friends from OCFS2 to core
has been removed from the -mm tree.  Its filename was
     byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: move le32_add_cpu & friends from OCFS2 to core
From: Marcin Slusarz <marcin.slusarz@gmail.com>

This patchset moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
header (1st), converts ext3 filesystem to this API (2nd) and replaces XFS
different named functions with new ones (3rd).

There are many places where these functions will be useful.  Just look at:
grep -r 'cpu_to_[ble12346]*([ble12346]*_to_cpu.*[-+]' linux-src/ Patch for
ext3 is an example how conversions will probably look like.



This patch:

- move inline functions which add native byte order variable to
  little/big endian variable to core header
  * le16_add_cpu(__le16 *var, u16 val)
  * le32_add_cpu(__le32 *var, u32 val)
  * le64_add_cpu(__le64 *var, u64 val)
  * be32_add_cpu(__be32 *var, u32 val)
- add for completeness:
  * be16_add_cpu(__be16 *var, u16 val)
  * be64_add_cpu(__be64 *var, u64 val)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/endian.h         |   30 ------------------
 fs/ocfs2/cluster/nodemanager.c    |    1 
 fs/ocfs2/dlm/dlmast.c             |    1 
 fs/ocfs2/endian.h                 |   45 ----------------------------
 fs/ocfs2/ocfs2.h                  |    1 
 include/linux/byteorder/generic.h |   30 ++++++++++++++++++
 6 files changed, 30 insertions(+), 78 deletions(-)

diff -puN fs/ocfs2/cluster/endian.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core /dev/null
--- a/fs/ocfs2/cluster/endian.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef OCFS2_CLUSTER_ENDIAN_H
-#define OCFS2_CLUSTER_ENDIAN_H
-
-static inline void be32_add_cpu(__be32 *var, u32 val)
-{
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
-}
-
-#endif /* OCFS2_CLUSTER_ENDIAN_H */
diff -puN fs/ocfs2/cluster/nodemanager.c~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core fs/ocfs2/cluster/nodemanager.c
--- a/fs/ocfs2/cluster/nodemanager.c~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -24,7 +24,6 @@
 #include <linux/sysctl.h>
 #include <linux/configfs.h>
 
-#include "endian.h"
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
diff -puN fs/ocfs2/dlm/dlmast.c~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core fs/ocfs2/dlm/dlmast.c
--- a/fs/ocfs2/dlm/dlmast.c~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core
+++ a/fs/ocfs2/dlm/dlmast.c
@@ -43,7 +43,6 @@
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
 #include "cluster/tcp.h"
-#include "cluster/endian.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
diff -puN fs/ocfs2/endian.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core /dev/null
--- a/fs/ocfs2/endian.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* -*- mode: c; c-basic-offset: 8; -*-
- * vim: noexpandtab sw=8 ts=8 sts=0:
- *
- * Copyright (C) 2005 Oracle.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation; either
- * version 2 of the License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public
- * License along with this program; if not, write to the
- * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
- * Boston, MA 021110-1307, USA.
- */
-
-#ifndef OCFS2_ENDIAN_H
-#define OCFS2_ENDIAN_H
-
-static inline void le16_add_cpu(__le16 *var, u16 val)
-{
-	*var = cpu_to_le16(le16_to_cpu(*var) + val);
-}
-
-static inline void le32_add_cpu(__le32 *var, u32 val)
-{
-	*var = cpu_to_le32(le32_to_cpu(*var) + val);
-}
-
-static inline void le64_add_cpu(__le64 *var, u64 val)
-{
-	*var = cpu_to_le64(le64_to_cpu(*var) + val);
-}
-
-static inline void be32_add_cpu(__be32 *var, u32 val)
-{
-	*var = cpu_to_be32(be32_to_cpu(*var) + val);
-}
-
-#endif /* OCFS2_ENDIAN_H */
diff -puN fs/ocfs2/ocfs2.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core
+++ a/fs/ocfs2/ocfs2.h
@@ -43,7 +43,6 @@
 #include "dlm/dlmapi.h"
 
 #include "ocfs2_fs.h"
-#include "endian.h"
 #include "ocfs2_lockid.h"
 
 /* Most user visible OCFS2 inodes will have very few pieces of
diff -puN include/linux/byteorder/generic.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core include/linux/byteorder/generic.h
--- a/include/linux/byteorder/generic.h~byteorder-move-le32_add_cpu-friends-from-ocfs2-to-core
+++ a/include/linux/byteorder/generic.h
@@ -146,6 +146,36 @@
 #define htons(x) ___htons(x)
 #define ntohs(x) ___ntohs(x)
 
+static inline void le16_add_cpu(__le16 *var, u16 val)
+{
+	*var = cpu_to_le16(le16_to_cpu(*var) + val);
+}
+
+static inline void le32_add_cpu(__le32 *var, u32 val)
+{
+	*var = cpu_to_le32(le32_to_cpu(*var) + val);
+}
+
+static inline void le64_add_cpu(__le64 *var, u64 val)
+{
+	*var = cpu_to_le64(le64_to_cpu(*var) + val);
+}
+
+static inline void be16_add_cpu(__be16 *var, u16 val)
+{
+	*var = cpu_to_be16(be16_to_cpu(*var) + val);
+}
+
+static inline void be32_add_cpu(__be32 *var, u32 val)
+{
+	*var = cpu_to_be32(be32_to_cpu(*var) + val);
+}
+
+static inline void be64_add_cpu(__be64 *var, u64 val)
+{
+	*var = cpu_to_be64(be64_to_cpu(*var) + val);
+}
+
 #endif /* KERNEL */
 
 #endif /* _LINUX_BYTEORDER_GENERIC_H */
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
