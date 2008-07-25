From: akpm@linux-foundation.org
Subject: - ext3-validate-directory-entry-data-before-use-v5.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:56:54 -0700
Message-ID: <200807252256.m6PMusZv003132@imap1.linux-foundation.org>
To: duaneg@dghda.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854AbYGYW5Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Jul 2008 18:57:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: validate directory entry data before use
has been removed from the -mm tree.  Its filename was
     ext3-validate-directory-entry-data-before-use-v5.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: validate directory entry data before use
From: "Duane Griffin" <duaneg@dghda.com>

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
---

 fs/ext3/namei.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/ext3/namei.c~ext3-validate-directory-entry-data-before-use-v5 fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-validate-directory-entry-data-before-use-v5
+++ a/fs/ext3/namei.c
@@ -991,19 +991,21 @@ static struct buffer_head * ext3_dx_find
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
_

Patches currently in -mm which might be from duaneg@dghda.com are

origin.patch

