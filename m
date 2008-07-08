From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH] ext4: validate directory entry data before use
Date: Tue,  8 Jul 2008 15:42:01 +0100
Message-ID: <1215528121-26934-3-git-send-email-duaneg@dghda.com>
References: <1215528121-26934-1-git-send-email-duaneg@dghda.com>
 <1215528121-26934-2-git-send-email-duaneg@dghda.com>
Cc: sct@redhat.com, adilger@clusterfs.com, Mingming <cmm@us.ibm.com>,
	Sami Liedes <sliedes@cc.hut.fi>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Duane Griffin <duaneg@dghda.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2735 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbYGHOmJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2008 10:42:09 -0400
In-Reply-To: <1215528121-26934-2-git-send-email-duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dx_find_entry uses ext4_next_entry without verifying that the entry is
valid. If its rec_len == 0 this causes an infinite loop. Refactor the loop
to check the validity of entries before checking whether they match and
moving onto the next one.

There are other uses of ext4_next_entry in this file which also look
problematic. They should be reviewed and fixed if/when we have a test-case
that triggers them.

This patch fixes the first case (image hdb.25.softlockup.gz) reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is an ext4 version of an ext3 patch queued in -mm.
---

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ab16bea..384f122 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -993,19 +993,21 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
 		de = (struct ext4_dir_entry_2 *) bh->b_data;
 		top = (struct ext4_dir_entry_2 *) ((char *) de + sb->s_blocksize -
 				       EXT4_DIR_REC_LEN(0));
-		for (; de < top; de = ext4_next_entry(de))
-		if (ext4_match (namelen, name, de)) {
-			if (!ext4_check_dir_entry("ext4_find_entry",
-						  dir, de, bh,
-				  (block<<EXT4_BLOCK_SIZE_BITS(sb))
-					  +((char *)de - bh->b_data))) {
-				brelse (bh);
+		for (; de < top; de = ext4_next_entry(de)) {
+			int off = (block << EXT4_BLOCK_SIZE_BITS(sb))
+				  + ((char *) de - bh->b_data);
+
+			if (!ext4_check_dir_entry(__func__, dir, de, bh, off)) {
+				brelse(bh);
 				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
-			*res_dir = de;
-			dx_release (frames);
-			return bh;
+
+			if (ext4_match(namelen, name, de)) {
+				*res_dir = de;
+				dx_release(frames);
+				return bh;
+			}
 		}
 		brelse (bh);
 		/* Check to see if we should continue to search */
