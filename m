From: akpm@linux-foundation.org
Subject: [merged] ext4-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext4-nameic.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:33:02 -0800
Message-ID: <200902241933.n1OJX2Mx004485@imap1.linux-foundation.org>
To: yjwei@cn.fujitsu.com, linux-ext4@vger.kernel.org, tytso@mit.edu,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757766AbZBXTh0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 14:37:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: use unsigned instead of int for type of blocksize in fs/ext4/namei.c
has been removed from the -mm tree.  Its filename was
     ext4-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext4-nameic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: use unsigned instead of int for type of blocksize in fs/ext4/namei.c
From: Wei Yongjun <yjwei@cn.fujitsu.com>

- Use unsigned instead of int for the parameter which carries a
  blocksize.  (ported from Wei Yongjun's ext3 patch).

- coding-style fixes

- rename `size' to `blocksize']

Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/namei.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/ext4/namei.c~ext4-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext4-nameic fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext4-nameic
+++ a/fs/ext4/namei.c
@@ -161,12 +161,12 @@ static struct dx_frame *dx_probe(const s
 				 struct dx_frame *frame,
 				 int *err);
 static void dx_release(struct dx_frame *frames);
-static int dx_make_map(struct ext4_dir_entry_2 *de, int size,
+static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
 		       struct dx_hash_info *hinfo, struct dx_map_entry map[]);
 static void dx_sort_map(struct dx_map_entry *map, unsigned count);
 static struct ext4_dir_entry_2 *dx_move_dirents(char *from, char *to,
 		struct dx_map_entry *offsets, int count);
-static struct ext4_dir_entry_2* dx_pack_dirents(char *base, int size);
+static struct ext4_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize);
 static void dx_insert_block(struct dx_frame *frame,
 					u32 hash, ext4_lblk_t block);
 static int ext4_htree_next_block(struct inode *dir, __u32 hash,
@@ -713,15 +713,14 @@ errout:
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
  */
-static int dx_make_map (struct ext4_dir_entry_2 *de, int size,
-			struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
+static int dx_make_map(struct ext4_dir_entry_2 *de, unsigned blocksize,
+		struct dx_hash_info *hinfo, struct dx_map_entry *map_tail)
 {
 	int count = 0;
-	char *base = (char *) de;
+	char *base = (char *)de;
 	struct dx_hash_info h = *hinfo;
 
-	while ((char *) de < base + size)
-	{
+	while ((char *) de < base + blocksize) {
 		if (de->name_len && de->inode) {
 			ext4fs_dirhash(de->name, de->name_len, &h);
 			map_tail--;
@@ -1130,13 +1129,14 @@ dx_move_dirents(char *from, char *to, st
  * Compact each dir entry in the range to the minimal rec_len.
  * Returns pointer to last entry in range.
  */
-static struct ext4_dir_entry_2* dx_pack_dirents(char *base, int size)
+static struct ext4_dir_entry_2 *dx_pack_dirents(char *base, unsigned blocksize)
 {
-	struct ext4_dir_entry_2 *next, *to, *prev, *de = (struct ext4_dir_entry_2 *) base;
+	struct ext4_dir_entry_2 *next, *to, *prev;
+	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)base;
 	unsigned rec_len = 0;
 
 	prev = to = de;
-	while ((char*)de < base + size) {
+	while ((char *)de < base + blocksize) {
 		next = ext4_next_entry(de);
 		if (de->inode && de->name_len) {
 			rec_len = EXT4_DIR_REC_LEN(de->name_len);
_

Patches currently in -mm which might be from yjwei@cn.fujitsu.com are

linux-next.patch
fs-jffs2-mallocc-kmem_cache_alloc-memset-kmem_cache_zalloc.patch
scsi-used-kmem_cache_zalloc-instead-of-kmem_cache_alloc-memset.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix.patch
ext3-use-unsigned-instead-of-int-for-type-of-blocksize-in-fs-ext3-nameic-fix-checkpatch-fixes.patch

