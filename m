From: "Duane Griffin" <duaneg@dghda.com>
Subject: [PATCH, v5] ext3: validate directory entry data before use
Date: Mon, 30 Jun 2008 23:00:18 +0100
Message-ID: <1214863218-14828-1-git-send-email-duaneg@dghda.com>
References: <20080630143427.GA5473@dastardly>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>, jochen.voss@googlemail.com,
	Jan Kara <jack@suse.cz>, Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:3880 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763702AbYF3WAX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jun 2008 18:00:23 -0400
In-Reply-To: <20080630143427.GA5473@dastardly>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext3_dx_find_entry uses ext3_next_entry without verifying that the entry is
valid. If its rec_len == 0 this causes an infinite loop. Refactor the loop
to check the validity of entries before checking whether they match and
moving onto the next one.

There are other uses of ext3_next_entry in this file which also look
problematic. They should be reviewed and fixed if/when we have a test-case
that triggers them.

This patch fixes the first case (image hdb.25.softlockup.gz) reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10882.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
--

This is version 5. It is a safer minimal version of the patch that only
fixes the original reported problem. Other potentially dangerous uses of
ext3_next_entry are left untouched until/unless we get test-cases for them.

---

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 0b8cf80..8db2c38 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -991,19 +991,21 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
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
