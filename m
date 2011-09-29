From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] libext2fs: use ext2fs byte swap functions for portability
Date: Wed, 28 Sep 2011 20:30:15 -0400
Message-ID: <1317256215-12544-2-git-send-email-tytso@mit.edu>
References: <1317256215-12544-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56470 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab1I2AaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 20:30:18 -0400
In-Reply-To: <1317256215-12544-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The functions htole32(), le32toh(), be32toh(), htobe32() aren't
defined in all environments.  Use the ext2fs byte swap functions for
portability.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/crc32c_defs.h |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/crc32c_defs.h b/lib/ext2fs/crc32c_defs.h
index 1752970..ced4f67 100644
--- a/lib/ext2fs/crc32c_defs.h
+++ b/lib/ext2fs/crc32c_defs.h
@@ -42,18 +42,19 @@
 		(((uint32_t)(x) & (uint32_t)0xff000000UL) >> 24)))
 
 
+#include "ext2fs.h"
 #ifdef WORDS_BIGENDIAN
 #define __constant_cpu_to_le32(x) ___constant_swab32((x))
 #define __constant_cpu_to_be32(x) (x)
 #define __be32_to_cpu(x) (x)
 #define __cpu_to_be32(x) (x)
-#define __cpu_to_le32(x) (htole32((x)))
-#define __le32_to_cpu(x) (le32toh((x)))
+#define __cpu_to_le32(x) (ext2fs_cpu_to_le32((x)))
+#define __le32_to_cpu(x) (ext2fs_le32_to_cpu((x)))
 #else
 #define __constant_cpu_to_le32(x) (x)
 #define __constant_cpu_to_be32(x) ___constant_swab32((x))
-#define __be32_to_cpu(x) (be32toh((x)))
-#define __cpu_to_be32(x) (htobe32((x)))
+#define __be32_to_cpu(x) (ext2fs_be32_to_cpu((x)))
+#define __cpu_to_be32(x) (ext2fs_cpu_to_be32((x)))
 #define __cpu_to_le32(x) (x)
 #define __le32_to_cpu(x) (x)
 #endif
-- 
1.7.4.1.22.gec8e1.dirty

