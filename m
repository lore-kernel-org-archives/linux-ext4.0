From: marcin.slusarz@gmail.com
Subject: [PATCH 1/3] byteorder: move le32_add_cpu & friends from OCFS2 to core
Date: Sat,  5 Jan 2008 16:36:20 +0100
Message-ID: <1199547382-29969-2-git-send-email-marcin.slusarz@gmail.com>
References: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>,
	OCFS2-devel <ocfs2-devel@oss.oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, xfs-masters@oss.sgi.com,
	Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:13146 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYAEPfM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jan 2008 10:35:12 -0500
Received: by fg-out-1718.google.com with SMTP id e21so3845935fga.17
        for <linux-ext4@vger.kernel.org>; Sat, 05 Jan 2008 07:35:11 -0800 (PST)
In-Reply-To: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
CC: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/endian.h         |   30 ------------------------
 fs/ocfs2/cluster/nodemanager.c    |    1 -
 fs/ocfs2/dlm/dlmast.c             |    1 -
 fs/ocfs2/endian.h                 |   45 -------------------------------------
 fs/ocfs2/ocfs2.h                  |    1 -
 include/linux/byteorder/generic.h |   30 ++++++++++++++++++++++++
 6 files changed, 30 insertions(+), 78 deletions(-)
 delete mode 100644 fs/ocfs2/cluster/endian.h
 delete mode 100644 fs/ocfs2/endian.h

diff --git a/fs/ocfs2/cluster/endian.h b/fs/ocfs2/cluster/endian.h
deleted file mode 100644
index 2df9082..0000000
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
diff --git a/fs/ocfs2/cluster/nodemanager.c b/fs/ocfs2/cluster/nodemanager.c
index af2070d..709fba2 100644
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -24,7 +24,6 @@
 #include <linux/sysctl.h>
 #include <linux/configfs.h>
 
-#include "endian.h"
 #include "tcp.h"
 #include "nodemanager.h"
 #include "heartbeat.h"
diff --git a/fs/ocfs2/dlm/dlmast.c b/fs/ocfs2/dlm/dlmast.c
index 2fd8bde..644bee5 100644
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -43,7 +43,6 @@
 #include "cluster/heartbeat.h"
 #include "cluster/nodemanager.h"
 #include "cluster/tcp.h"
-#include "cluster/endian.h"
 
 #include "dlmapi.h"
 #include "dlmcommon.h"
diff --git a/fs/ocfs2/endian.h b/fs/ocfs2/endian.h
deleted file mode 100644
index 1942e09..0000000
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
diff --git a/fs/ocfs2/ocfs2.h b/fs/ocfs2/ocfs2.h
index 60a23e1..cda15fd 100644
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -43,7 +43,6 @@
 #include "dlm/dlmapi.h"
 
 #include "ocfs2_fs.h"
-#include "endian.h"
 #include "ocfs2_lockid.h"
 
 /* Most user visible OCFS2 inodes will have very few pieces of
diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
index 3dc715b..d377155 100644
--- a/include/linux/byteorder/generic.h
+++ b/include/linux/byteorder/generic.h
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
-- 
1.5.3.7
