From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH] ext4: Fix kernel BUG at fs/ext4/mballoc.c:910!
Date: Wed, 13 Feb 2008 18:19:32 +0100
Message-ID: <1202923172.3508.3.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "cmm@us.ibm.com" <cmm@us.ibm.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35272 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYBMROD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2008 12:14:03 -0500
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

This patch fixes the oops.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b0f84b4..0275150 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -907,7 +907,7 @@ static void ext4_mb_mark_free_simple(struct super_block *sb,
 	unsigned short chunk;
 	unsigned short border;
 
-	BUG_ON(len >= EXT4_BLOCKS_PER_GROUP(sb));
+	BUG_ON(len > EXT4_BLOCKS_PER_GROUP(sb));
 
 	border = 2 << sb->s_blocksize_bits;
 
@@ -3286,7 +3286,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size >= EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 
