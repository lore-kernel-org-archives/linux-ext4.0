From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] ext3: Use search_dirblock() in ext3_dx_find_entry()
Date: Sat, 16 Oct 2010 19:37:00 -0400
Message-ID: <1287272220-1591-2-git-send-email-tytso@mit.edu>
References: <20101016233513.GA31722@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Brad Spengler <spender@grsecurity.net>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38026 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0JPXhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Oct 2010 19:37:02 -0400
In-Reply-To: <20101016233513.GA31722@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the search_dirblock() in ext3_dx_find_entry().  It makes the code
easier to read, and it takes advantage of common code.  It also saves
100 bytes or so of text space.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Brad Spengler <spender@grsecurity.net>
---
 fs/ext3/namei.c |   33 ++++++++++++---------------------
 1 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 01f12cc..24e15dd 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -975,12 +975,9 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 	struct super_block *sb = dir->i_sb;
 	struct dx_hash_info	hinfo;
 	struct dx_frame frames[2], *frame;
-	struct ext3_dir_entry_2 *de, *top;
 	struct buffer_head *bh;
 	unsigned long block;
 	int retval;
-	int namelen = entry->len;
-	const u8 *name = entry->name;
 
 	if (!(frame = dx_probe(entry, dir, &hinfo, frames, err)))
 		return NULL;
@@ -988,26 +985,20 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 		block = dx_get_block(frame->at);
 		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
 			goto errout;
-		de = (struct ext3_dir_entry_2 *) bh->b_data;
-		top = (struct ext3_dir_entry_2 *) ((char *) de + sb->s_blocksize -
-				       EXT3_DIR_REC_LEN(0));
-		for (; de < top; de = ext3_next_entry(de)) {
-			int off = (block << EXT3_BLOCK_SIZE_BITS(sb))
-				  + ((char *) de - bh->b_data);
-
-			if (!ext3_check_dir_entry(__func__, dir, de, bh, off)) {
-				brelse(bh);
-				*err = ERR_BAD_DX_DIR;
-				goto errout;
-			}
 
-			if (ext3_match(namelen, name, de)) {
-				*res_dir = de;
-				dx_release(frames);
-				return bh;
-			}
+		retval = search_dirblock(bh, dir, entry,
+					 block << EXT3_BLOCK_SIZE_BITS(sb),
+					 res_dir);
+		if (retval == 1) {
+			dx_release(frames);
+			return bh;
 		}
-		brelse (bh);
+		brelse(bh);
+		if (retval == -1) {
+			*err = ERR_BAD_DX_DIR;
+			goto errout;
+		}
+			
 		/* Check to see if we should continue to search */
 		retval = ext3_htree_next_block(dir, hinfo.hash, frame,
 					       frames, NULL);
-- 
1.7.1

