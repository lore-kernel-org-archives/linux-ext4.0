From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-ext2.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:48:00 -0800
Message-ID: <200803041948.m24Jm0SM025714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Use page_cache_xxx in ext2
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-ext2.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in ext2
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx functions in fs/ext2/*

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c |   41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff -puN fs/ext2/dir.c~use-page_cache_xxx-in-ext2 fs/ext2/dir.c
--- a/fs/ext2/dir.c~use-page_cache_xxx-in-ext2
+++ a/fs/ext2/dir.c
@@ -63,7 +63,7 @@ static inline void ext2_put_page(struct 
 
 static inline unsigned long dir_pages(struct inode *inode)
 {
-	return (inode->i_size+PAGE_CACHE_SIZE-1)>>PAGE_CACHE_SHIFT;
+	return page_cache_next(inode->i_mapping, inode->i_size);
 }
 
 /*
@@ -74,10 +74,11 @@ static unsigned
 ext2_last_byte(struct inode *inode, unsigned long page_nr)
 {
 	unsigned last_byte = inode->i_size;
+	struct address_space *mapping = inode->i_mapping;
 
-	last_byte -= page_nr << PAGE_CACHE_SHIFT;
-	if (last_byte > PAGE_CACHE_SIZE)
-		last_byte = PAGE_CACHE_SIZE;
+	last_byte -= page_cache_pos(mapping, page_nr, 0);
+	if (last_byte > page_cache_size(mapping))
+		last_byte = page_cache_size(mapping);
 	return last_byte;
 }
 
@@ -105,18 +106,19 @@ static int ext2_commit_chunk(struct page
 
 static void ext2_check_page(struct page *page)
 {
-	struct inode *dir = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *dir = mapping->host;
 	struct super_block *sb = dir->i_sb;
 	unsigned chunk_size = ext2_chunk_size(dir);
 	char *kaddr = page_address(page);
 	u32 max_inumber = le32_to_cpu(EXT2_SB(sb)->s_es->s_inodes_count);
 	unsigned offs, rec_len;
-	unsigned limit = PAGE_CACHE_SIZE;
+	unsigned limit = page_cache_size(mapping);
 	ext2_dirent *p;
 	char *error;
 
-	if ((dir->i_size >> PAGE_CACHE_SHIFT) == page->index) {
-		limit = dir->i_size & ~PAGE_CACHE_MASK;
+	if (page_cache_index(mapping, dir->i_size) == page->index) {
+		limit = page_cache_offset(mapping, dir->i_size);
 		if (limit & (chunk_size - 1))
 			goto Ebadsize;
 		if (!limit)
@@ -168,7 +170,7 @@ Einumber:
 bad_entry:
 	ext2_error (sb, "ext2_check_page", "bad entry in directory #%lu: %s - "
 		"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
-		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		dir->i_ino, error, page_cache_pos(mapping, page->index, offs),
 		(unsigned long) le32_to_cpu(p->inode),
 		rec_len, p->name_len);
 	goto fail;
@@ -177,7 +179,7 @@ Eend:
 	ext2_error (sb, "ext2_check_page",
 		"entry in directory #%lu spans the page boundary"
 		"offset=%lu, inode=%lu",
-		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
+		dir->i_ino, page_cache_pos(mapping, page->index, offs),
 		(unsigned long) le32_to_cpu(p->inode));
 fail:
 	SetPageChecked(page);
@@ -276,8 +278,9 @@ ext2_readdir (struct file * filp, void *
 	loff_t pos = filp->f_pos;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
-	unsigned int offset = pos & ~PAGE_CACHE_MASK;
-	unsigned long n = pos >> PAGE_CACHE_SHIFT;
+	struct address_space *mapping = inode->i_mapping;
+	unsigned int offset = page_cache_offset(mapping, pos);
+	unsigned long n = page_cache_index(mapping, pos);
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
 	unsigned char *types = NULL;
@@ -298,14 +301,14 @@ ext2_readdir (struct file * filp, void *
 			ext2_error(sb, __FUNCTION__,
 				   "bad page in #%lu",
 				   inode->i_ino);
-			filp->f_pos += PAGE_CACHE_SIZE - offset;
+			filp->f_pos += page_cache_size(mapping) - offset
 			return PTR_ERR(page);
 		}
 		kaddr = page_address(page);
 		if (unlikely(need_revalidate)) {
 			if (offset) {
 				offset = ext2_validate_entry(kaddr, offset, chunk_mask);
-				filp->f_pos = (n<<PAGE_CACHE_SHIFT) + offset;
+				filp->f_pos = page_cache_pos(mapping, n, offset);
 			}
 			filp->f_version = inode->i_version;
 			need_revalidate = 0;
@@ -328,7 +331,7 @@ ext2_readdir (struct file * filp, void *
 
 				offset = (char *)de - kaddr;
 				over = filldir(dirent, de->name, de->name_len,
-						(n<<PAGE_CACHE_SHIFT) | offset,
+						page_cache_pos(mapping, n, offset),
 						le32_to_cpu(de->inode), d_type);
 				if (over) {
 					ext2_put_page(page);
@@ -354,6 +357,7 @@ struct ext2_dir_entry_2 * ext2_find_entr
 			struct dentry *dentry, struct page ** res_page)
 {
 	const char *name = dentry->d_name.name;
+	struct address_space *mapping = dir->i_mapping;
 	int namelen = dentry->d_name.len;
 	unsigned reclen = EXT2_DIR_REC_LEN(namelen);
 	unsigned long start, n;
@@ -395,7 +399,7 @@ struct ext2_dir_entry_2 * ext2_find_entr
 		if (++n >= npages)
 			n = 0;
 		/* next page is past the blocks we've got */
-		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+		if (unlikely(n > (dir->i_blocks >> (page_cache_shift(mapping) - 9)))) {
 			ext2_error(dir->i_sb, __FUNCTION__,
 				"dir %lu size %lld exceeds block count %llu",
 				dir->i_ino, dir->i_size,
@@ -466,6 +470,7 @@ void ext2_set_link(struct inode *dir, st
 int ext2_add_link (struct dentry *dentry, struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
+	struct address_space *mapping = inode->i_mapping;
 	const char *name = dentry->d_name.name;
 	int namelen = dentry->d_name.len;
 	unsigned chunk_size = ext2_chunk_size(dir);
@@ -495,7 +500,7 @@ int ext2_add_link (struct dentry *dentry
 		kaddr = page_address(page);
 		dir_end = kaddr + ext2_last_byte(dir, n);
 		de = (ext2_dirent *)kaddr;
-		kaddr += PAGE_CACHE_SIZE - reclen;
+		kaddr += page_cache_size(mapping) - reclen;
 		while ((char *)de <= kaddr) {
 			if ((char *)de == dir_end) {
 				/* We hit i_size */
@@ -531,7 +536,7 @@ int ext2_add_link (struct dentry *dentry
 got_it:
 	pos = page_offset(page) +
 		(char*)de - (char*)page_address(page);
-	err = __ext2_write_begin(NULL, page->mapping, pos, rec_len, 0,
+	err = __ext2_write_begin(NULL, mapping, pos, rec_len, 0,
 							&page, NULL);
 	if (err)
 		goto out_unlock;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

