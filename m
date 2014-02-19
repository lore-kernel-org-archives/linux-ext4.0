From: Lukas Czerner <lczerner@redhat.com>
Subject: [RHEL5.11 PATCH 2/3] ext3: validate directory entry data before use
Date: Wed, 19 Feb 2014 09:56:55 +0100
Message-ID: <1392800216-7828-2-git-send-email-lczerner@redhat.com>
References: <1392800216-7828-1-git-send-email-lczerner@redhat.com>
Cc: Duane Griffin <duaneg@dghda.com>, <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: rhkernel-list@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaBSI5L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 03:57:11 -0500
In-Reply-To: <1392800216-7828-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Duane Griffin <duaneg@dghda.com>

BZ 1065434
https://bugzilla.redhat.com/show_bug.cgi?id=1065434

BREW 7074551
https://brewweb.devel.redhat.com/taskinfo?taskID=7074551

Upstream commit 275c0a8f1253a7542ad9726956c918d8a1f694c4

ext3_dx_find_entry uses ext3_next_entry without verifying that the entry
is valid.  If its rec_len == 0 this causes an infinite loop.  Refactor the
loop to check the validity of entries before checking whether they match
and moving onto the next one.

There are other uses of ext3_next_entry in this file which also look
problematic.  They should be reviewed and fixed if/when we have a
test-case that triggers them.

This patch fixes the first case (image hdb.25.softlockup.gz) reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ext3/namei.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 8bc0198..69c0540 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -994,19 +994,21 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 		de = (struct ext3_dir_entry_2 *) bh->b_data;
 		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
 				       EXT3_DIR_REC_LEN(0));
-		for (; de < top; de = ext3_next_entry(de))
-		if (ext3_match (namelen, name, de)) {
-			if (!ext3_check_dir_entry("ext3_find_entry",
-						  dir, de, bh,
-				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
-					  +((char *)de - bh->b_data))) {
-				brelse (bh);
+		for (; de < top; de = ext3_next_entry(de)) {
+			int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
+				  + ((char *) de - bh->b_data);
+
+			if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
+				brelse(bh);
 				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
-			*res_dir = de;
-			dx_release (frames);
-			return bh;
+
+			if (ext3_match(namelen, name, de)) {
+				*res_dir = de;
+				dx_release(frames);
+				return bh;
+			}
 		}
 		brelse (bh);
 		/* Check to see if we should continue to search */
-- 
1.8.3.1

