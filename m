From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] ext3: Avoid uninitialized memory references with a corrupted htree directory
Date: Sat, 16 Oct 2010 19:36:59 -0400
Message-ID: <1287272220-1591-1-git-send-email-tytso@mit.edu>
References: <20101016233513.GA31722@thunk.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Brad Spengler <spender@grsecurity.net>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38024 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab0JPXhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Oct 2010 19:37:02 -0400
In-Reply-To: <20101016233513.GA31722@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the first htree directory is missing '.' or '..' but is otherwise a
valid directory, and we do a lookup for '.' or '..', it's possible to
dereference an uninitialized memory pointer in ext3_htree_next_block().
Avoid this.

We avoid this by moving the special case from ext3_dx_find_entry() to
ext3_find_entry(); this also means we can optimize ext3_find_entry()
slightly when NFS looks up "..".

Thanks to Brad Spengler for pointing a Clang warning that led me to
look more closely at this code.  The warning was harmless, but it was
useful in pointing out code that was too ugly to live.  This warning was
also reported by Roman Borisov.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Cc: Brad Spengler <spender@grsecurity.net>
---
 fs/ext3/namei.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 2b35ddb..01f12cc 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -858,6 +858,7 @@ static struct buffer_head *ext3_find_entry(struct inode *dir,
 	struct buffer_head * bh_use[NAMEI_RA_SIZE];
 	struct buffer_head * bh, *ret = NULL;
 	unsigned long start, block, b;
+	const u8 *name = entry->name;
 	int ra_max = 0;		/* Number of bh's in the readahead
 				   buffer, bh_use[] */
 	int ra_ptr = 0;		/* Current index into readahead
@@ -871,6 +872,16 @@ static struct buffer_head *ext3_find_entry(struct inode *dir,
 	namelen = entry->len;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
+	if ((namelen < 2) && (name[0] == '.') &&
+	    (name[1] == '.' || name[1] == '0')) {
+		/*
+		 * "." or ".." will only be in the first block
+		 * NFS may look up ".."; "." should be handled by the VFS
+		 */
+		block = start = 0;
+		nblocks = 1;
+		goto restart;
+	}
 	if (is_dx(dir)) {
 		bh = ext3_dx_find_entry(dir, entry, res_dir, &err);
 		/*
@@ -961,9 +972,8 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 			struct qstr *entry, struct ext3_dir_entry_2 **res_dir,
 			int *err)
 {
-	struct super_block * sb;
+	struct super_block *sb = dir->i_sb;
 	struct dx_hash_info	hinfo;
-	u32 hash;
 	struct dx_frame frames[2], *frame;
 	struct ext3_dir_entry_2 *de, *top;
 	struct buffer_head *bh;
@@ -972,18 +982,8 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 	int namelen = entry->len;
 	const u8 *name = entry->name;
 
-	sb = dir->i_sb;
-	/* NFS may look up ".." - look at dx_root directory block */
-	if (namelen > 2 || name[0] != '.'|| (namelen == 2 && name[1] != '.')) {
-		if (!(frame = dx_probe(entry, dir, &hinfo, frames, err)))
-			return NULL;
-	} else {
-		frame = frames;
-		frame->bh = NULL;			/* for dx_release() */
-		frame->at = (struct dx_entry *)frames;	/* hack for zero entry*/
-		dx_set_block(frame->at, 0);		/* dx_root block is 0 */
-	}
-	hash = hinfo.hash;
+	if (!(frame = dx_probe(entry, dir, &hinfo, frames, err)))
+		return NULL;
 	do {
 		block = dx_get_block(frame->at);
 		if (!(bh = ext3_bread (NULL,dir, block, 0, err)))
@@ -1009,7 +1009,7 @@ static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
 		}
 		brelse (bh);
 		/* Check to see if we should continue to search */
-		retval = ext3_htree_next_block(dir, hash, frame,
+		retval = ext3_htree_next_block(dir, hinfo.hash, frame,
 					       frames, NULL);
 		if (retval < 0) {
 			ext3_warning(sb, __func__,
-- 
1.7.1

