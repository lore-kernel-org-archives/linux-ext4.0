From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH] ext3: Remove unnecessary casts on bh->b_data
Date: Mon, 11 Oct 2010 02:10:45 +0900
Message-ID: <1286730645-4845-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:36613 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0JJRKz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Oct 2010 13:10:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

bh->b_data is already a pointer to char so casts to 'char *' should
be meaningless. Remove them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext3/balloc.c |    4 ++--
 fs/ext3/super.c  |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 4a32511..a49ce4a 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -792,9 +792,9 @@ find_next_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
 	if (here < 0)
 		here = 0;
 
-	p = ((char *)bh->b_data) + (here >> 3);
+	p = bh->b_data + (here >> 3);
 	r = memscan(p, 0, ((maxblocks + 7) >> 3) - (here >> 3));
-	next = (r - ((char *)bh->b_data)) << 3;
+	next = (r - bh->b_data) << 3;
 
 	if (next < maxblocks && next >= start && ext3_test_allocatable(next, bh))
 		return next;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 4caeffa..421fad7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1654,7 +1654,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	 * Note: s_es must be initialized as soon as possible because
 	 *       some ext3 macro-instructions depend on its value
 	 */
-	es = (struct ext3_super_block *) (((char *)bh->b_data) + offset);
+	es = (struct ext3_super_block *) (bh->b_data + offset);
 	sbi->s_es = es;
 	sb->s_magic = le16_to_cpu(es->s_magic);
 	if (sb->s_magic != EXT3_SUPER_MAGIC)
@@ -1765,7 +1765,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 			       "error: can't read superblock on 2nd try");
 			goto failed_mount;
 		}
-		es = (struct ext3_super_block *)(((char *)bh->b_data) + offset);
+		es = (struct ext3_super_block *)(bh->b_data + offset);
 		sbi->s_es = es;
 		if (es->s_magic != cpu_to_le16(EXT3_SUPER_MAGIC)) {
 			ext3_msg(sb, KERN_ERR,
@@ -2168,7 +2168,7 @@ static journal_t *ext3_get_dev_journal(struct super_block *sb,
 		goto out_bdev;
 	}
 
-	es = (struct ext3_super_block *) (((char *)bh->b_data) + offset);
+	es = (struct ext3_super_block *) (bh->b_data + offset);
 	if ((le16_to_cpu(es->s_magic) != EXT3_SUPER_MAGIC) ||
 	    !(le32_to_cpu(es->s_feature_incompat) &
 	      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
-- 
1.7.0.4

