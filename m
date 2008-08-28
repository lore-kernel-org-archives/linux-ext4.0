From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: ext3: stack usage improvement..
Date: Wed, 27 Aug 2008 19:00:36 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0808271843590.3300@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Duane Griffin <duaneg@dghda.com>,
	Akinobu Mita <akinobu.mita@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491AbYH1CBW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Aug 2008 22:01:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Ok, so I don't know who is interested, but I suspect this same issue 
exists in ext4 too, so I'm cc'ing various random people who have doen ext3 
changes and the linux-ext4 list.

This patch fixes a 200+ byte stack usage that just didn't make any sense, 
and actually improves code generation a bit. Sadly, ext3 still has a 
number of other functions that have excessive stack usage:

	ext3_group_add [built-in.o]:		440
	ext3_get_blocks_handle [built-in.o]:	296
	ext3_find_entry [built-in.o]:		296
	ext3_truncate [built-in.o]:		232
	ext3_get_parent [built-in.o]:		232
	ext3_add_entry [built-in.o]:		216
	ext3_warning [built-in.o]:		216
	ext3_abort [built-in.o]:		216
	ext3_error [built-in.o]:		208
	...
and while ext3_get_parent was pretty high up, it's certainly not the 
biggest problem.

The warning/abort/error functions, btw, are due to gcc idiocy with varargs 
handling on x86-64 (it allocates stack for SSE register spilling, even 
though it doesn't spill any SSE registers when in kernel mode). That's a 
compiler issue. But "ext3_group_add()" and the other things up there 
really are just our badness.

At least ext3_group_add() is in a rather shallow callchain. That is not 
true with find_entry and friends.

Anyway, with this patch, one of them is gone, and we get rid of code like

	dotdot.d_parent = child; /* confusing, isn't it! */

that is no longer relevant.



---
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed Aug 27 11:26:52 2008 -0700
Subject: [ext3] Don't use 'struct dentry' for internal lookups

It's more efficient to pass down only the actual parts of the dentry that 
matter: the parent inode and the name.  This actually shrinks the code 
size a bit:
    
   text	   data	    bss	    dec	    hex	filename
  87363	   1024	     16	  88403	  15953	fs/ext3/built-in.o.old
  87327	   1024	     16	  88367	  1592f	fs/ext3/built-in.o.new

but more importantly, it makes it unnecessary to build up a fake 'struct 
dentry' on the stack in ext3_get_parent, so that function entirely 
disappears from the stack footprint list.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ext3/namei.c |   68 ++++++++++++++++++++++++++----------------------------
 1 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index de13e91..ed8c60d 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -159,7 +159,7 @@ static void dx_set_count (struct dx_entry *entries, unsigned value);
 static void dx_set_limit (struct dx_entry *entries, unsigned value);
 static unsigned dx_root_limit (struct inode *dir, unsigned infosize);
 static unsigned dx_node_limit (struct inode *dir);
-static struct dx_frame *dx_probe(struct dentry *dentry,
+static struct dx_frame *dx_probe(const struct qstr *d_name,
 				 struct inode *dir,
 				 struct dx_hash_info *hinfo,
 				 struct dx_frame *frame,
@@ -176,8 +176,10 @@ static int ext3_htree_next_block(struct inode *dir, __u32 hash,
 				 struct dx_frame *frame,
 				 struct dx_frame *frames,
 				 __u32 *start_hash);
-static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
-		       struct ext3_dir_entry_2 **res_dir, int *err);
+static struct buffer_head * ext3_dx_find_entry(struct inode *dir,
+		const struct qstr *d_name,
+		struct ext3_dir_entry_2 **res_dir,
+		int *err);
 static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode);
 
@@ -342,7 +344,7 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
  * back to userspace.
  */
 static struct dx_frame *
-dx_probe(struct dentry *dentry, struct inode *dir,
+dx_probe(const struct qstr *d_name, struct inode *dir,
 	 struct dx_hash_info *hinfo, struct dx_frame *frame_in, int *err)
 {
 	unsigned count, indirect;
@@ -353,8 +355,6 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	u32 hash;
 
 	frame->bh = NULL;
-	if (dentry)
-		dir = dentry->d_parent->d_inode;
 	if (!(bh = ext3_bread (NULL,dir, 0, 0, err)))
 		goto fail;
 	root = (struct dx_root *) bh->b_data;
@@ -370,8 +370,8 @@ dx_probe(struct dentry *dentry, struct inode *dir,
 	}
 	hinfo->hash_version = root->info.hash_version;
 	hinfo->seed = EXT3_SB(dir->i_sb)->s_hash_seed;
-	if (dentry)
-		ext3fs_dirhash(dentry->d_name.name, dentry->d_name.len, hinfo);
+	if (d_name)
+		ext3fs_dirhash(d_name->name, d_name->len, hinfo);
 	hash = hinfo->hash;
 
 	if (root->info.unused_flags & 1) {
@@ -645,7 +645,7 @@ int ext3_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 	}
 	hinfo.hash = start_hash;
 	hinfo.minor_hash = 0;
-	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo, frames, &err);
+	frame = dx_probe(NULL, dir, &hinfo, frames, &err);
 	if (!frame)
 		return err;
 
@@ -803,15 +803,15 @@ static inline int ext3_match (int len, const char * const name,
  */
 static inline int search_dirblock(struct buffer_head * bh,
 				  struct inode *dir,
-				  struct dentry *dentry,
+				  const struct qstr *d_name,
 				  unsigned long offset,
 				  struct ext3_dir_entry_2 ** res_dir)
 {
 	struct ext3_dir_entry_2 * de;
 	char * dlimit;
 	int de_len;
-	const char *name = dentry->d_name.name;
-	int namelen = dentry->d_name.len;
+	const char *name = d_name->name;
+	int namelen = d_name->len;
 
 	de = (struct ext3_dir_entry_2 *) bh->b_data;
 	dlimit = bh->b_data + dir->i_sb->s_blocksize;
@@ -850,7 +850,8 @@ static inline int search_dirblock(struct buffer_head * bh,
  * The returned buffer_head has ->b_count elevated.  The caller is expected
  * to brelse() it when appropriate.
  */
-static struct buffer_head * ext3_find_entry (struct dentry *dentry,
+static struct buffer_head * ext3_find_entry (struct inode *dir,
+					const struct qstr *d_name,
 					struct ext3_dir_entry_2 ** res_dir)
 {
 	struct super_block * sb;
@@ -863,16 +864,15 @@ static struct buffer_head * ext3_find_entry (struct dentry *dentry,
 				   buffer */
 	int num = 0;
 	int nblocks, i, err;
-	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
-	namelen = dentry->d_name.len;
+	namelen = d_name->len;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
-		bh = ext3_dx_find_entry(dentry, res_dir, &err);
+		bh = ext3_dx_find_entry(dir, d_name, res_dir, &err);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -923,7 +923,7 @@ restart:
 			brelse(bh);
 			goto next;
 		}
-		i = search_dirblock(bh, dir, dentry,
+		i = search_dirblock(bh, dir, d_name,
 			    block << EXT3_BLOCK_SIZE_BITS(sb), res_dir);
 		if (i == 1) {
 			EXT3_I(dir)->i_dir_start_lookup = block;
@@ -957,7 +957,7 @@ cleanup_and_exit:
 	return ret;
 }
 
-static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
+static struct buffer_head * ext3_dx_find_entry(struct inode *dir, const struct qstr *d_name,
 		       struct ext3_dir_entry_2 **res_dir, int *err)
 {
 	struct super_block * sb;
@@ -968,14 +968,13 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 	struct buffer_head *bh;
 	unsigned long block;
 	int retval;
-	int namelen = dentry->d_name.len;
-	const u8 *name = dentry->d_name.name;
-	struct inode *dir = dentry->d_parent->d_inode;
+	int namelen = d_name->len;
+	const u8 *name = d_name->name;
 
 	sb = dir->i_sb;
 	/* NFS may look up ".." - look at dx_root directory block */
 	if (namelen > 2 || name[0] != '.'||(name[1] != '.' && name[1] != '\0')){
-		if (!(frame = dx_probe(dentry, NULL, &hinfo, frames, err)))
+		if (!(frame = dx_probe(d_name, dir, &hinfo, frames, err)))
 			return NULL;
 	} else {
 		frame = frames;
@@ -1036,7 +1035,7 @@ static struct dentry *ext3_lookup(struct inode * dir, struct dentry *dentry, str
 	if (dentry->d_name.len > EXT3_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext3_find_entry(dentry, &de);
+	bh = ext3_find_entry(dir, &dentry->d_name, &de);
 	inode = NULL;
 	if (bh) {
 		unsigned long ino = le32_to_cpu(de->inode);
@@ -1059,15 +1058,14 @@ struct dentry *ext3_get_parent(struct dentry *child)
 	unsigned long ino;
 	struct dentry *parent;
 	struct inode *inode;
-	struct dentry dotdot;
+	static const struct qstr dotdot = {
+		.name = "..",
+		.len = 2,
+	};
 	struct ext3_dir_entry_2 * de;
 	struct buffer_head *bh;
 
-	dotdot.d_name.name = "..";
-	dotdot.d_name.len = 2;
-	dotdot.d_parent = child; /* confusing, isn't it! */
-
-	bh = ext3_find_entry(&dotdot, &de);
+	bh = ext3_find_entry(child->d_inode, &dotdot, &de);
 	inode = NULL;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
@@ -1503,7 +1501,7 @@ static int ext3_dx_add_entry(handle_t *handle, struct dentry *dentry,
 	struct ext3_dir_entry_2 *de;
 	int err;
 
-	frame = dx_probe(dentry, NULL, &hinfo, frames, &err);
+	frame = dx_probe(&dentry->d_name, dir, &hinfo, frames, &err);
 	if (!frame)
 		return err;
 	entries = frame->entries;
@@ -2056,7 +2054,7 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 		return PTR_ERR(handle);
 
 	retval = -ENOENT;
-	bh = ext3_find_entry (dentry, &de);
+	bh = ext3_find_entry(dir, &dentry->d_name, &de);
 	if (!bh)
 		goto end_rmdir;
 
@@ -2118,7 +2116,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 		handle->h_sync = 1;
 
 	retval = -ENOENT;
-	bh = ext3_find_entry (dentry, &de);
+	bh = ext3_find_entry(dir, &dentry->d_name, &de);
 	if (!bh)
 		goto end_unlink;
 
@@ -2276,7 +2274,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	if (IS_DIRSYNC(old_dir) || IS_DIRSYNC(new_dir))
 		handle->h_sync = 1;
 
-	old_bh = ext3_find_entry (old_dentry, &old_de);
+	old_bh = ext3_find_entry(old_dir, &old_dentry->d_name, &old_de);
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
 	 *  We might rmdir the source, keep it as pwd of some process
@@ -2289,7 +2287,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		goto end_rename;
 
 	new_inode = new_dentry->d_inode;
-	new_bh = ext3_find_entry (new_dentry, &new_de);
+	new_bh = ext3_find_entry(new_dir, &new_dentry->d_name, &new_de);
 	if (new_bh) {
 		if (!new_inode) {
 			brelse (new_bh);
@@ -2355,7 +2353,7 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		struct buffer_head *old_bh2;
 		struct ext3_dir_entry_2 *old_de2;
 
-		old_bh2 = ext3_find_entry(old_dentry, &old_de2);
+		old_bh2 = ext3_find_entry(old_dir, &old_dentry->d_name, &old_de2);
 		if (old_bh2) {
 			retval = ext3_delete_entry(handle, old_dir,
 						   old_de2, old_bh2);
