From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH RESEND] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Thu, 14 Feb 2008 17:35:09 +0100
Message-ID: <1203006909.8970.20.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:52297 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760290AbYBNQ3l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2008 11:29:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix kernel BUG at fs/ext4/mballoc.c:910!

From: Valerie Clement <valerie.clement@bull.net>

With the flex_bg feature enabled, a large file creation oopses the
kernel.
The BUG_ON is:
	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));

As the allocation of the bitmaps and the inode table can be done
outside the block group with flex_bg, this allows to allocate up to
EXT4_BLOCKS_PER_GROUP blocks in a group.
Depending on the group size and the block size, extents might be 
larger than BLOCKS_PER_GROUP(); use EXT_INIT_MAX_LEN instead of 
BLOCKS_PER_GROUP().

This patch fixes the oops.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 fs/ext4/mballoc.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b0f84b4..ccc33e9 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/version.h>
+#include <linux/ext4_fs_extents.h>
 #include "group.h"
 
 /*
@@ -907,7 +908,9 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	unsigned short chunk;
 	unsigned short border;
 
-	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
+	BUG_ON(len > EXT4_HAS_INCOMPAT_FEATURE(sb,
+			EXT4_FEATURE_INCOMPAT_FLEX_BG) ? EXT_INIT_MAX_LEN :
+			EXT4_BLOCKS_PER_GROUP(sb));
 
 	border = 2 << sb->s_blocksize_bits;
 
