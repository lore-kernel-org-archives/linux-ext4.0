From: akpm@linux-foundation.org
Subject: + use-page_cache_xxx-in-fs-ext4.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:19:14 -0800
Message-ID: <200802181020.m1IAKCsS019979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: clameter@sgi.com, dgc@sgi.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     Use page_cache_xxx in fs/ext4
has been added to the -mm tree.  Its filename is
     use-page_cache_xxx-in-fs-ext4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in fs/ext4
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in fs/ext4

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/dir.c   |    3 ++-
 fs/ext4/inode.c |   34 +++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff -puN fs/ext4/dir.c~use-page_cache_xxx-in-fs-ext4 fs/ext4/dir.c
--- a/fs/ext4/dir.c~use-page_cache_xxx-in-fs-ext4
+++ a/fs/ext4/dir.c
@@ -132,7 +132,8 @@ static int ext4_readdir(struct file * fi
 		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
-					(PAGE_CACHE_SHIFT - inode->i_blkbits);
+				(page_cache_size(inode->i_mapping)
+					- inode->i_blkbits);
 			if (!ra_has_index(&filp->f_ra, index))
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_inode->i_mapping,
diff -puN fs/ext4/inode.c~use-page_cache_xxx-in-fs-ext4 fs/ext4/inode.c
--- a/fs/ext4/inode.c~use-page_cache_xxx-in-fs-ext4
+++ a/fs/ext4/inode.c
@@ -1142,8 +1142,8 @@ static int ext4_write_begin(struct file 
  	pgoff_t index;
  	unsigned from, to;
 
- 	index = pos >> PAGE_CACHE_SHIFT;
- 	from = pos & (PAGE_CACHE_SIZE - 1);
+ 	index = page_cache_index(mapping, pos);
+ 	from = page_cache_offset(mapping, pos);
  	to = from + len;
 
 retry:
@@ -1238,7 +1238,7 @@ static int ext4_ordered_write_end(struct
 	unsigned from, to;
 	int ret = 0, ret2;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	ret = walk_page_buffers(handle, page_buffers(page),
@@ -1308,7 +1308,7 @@ static int ext4_journalled_write_end(str
 	int partial = 0;
 	unsigned from, to;
 
-	from = pos & (PAGE_CACHE_SIZE - 1);
+	from = page_cache_offset(mapping, pos);
 	to = from + len;
 
 	if (copied < len) {
@@ -1611,6 +1611,7 @@ static int ext4_ordered_writepage(struct
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	J_ASSERT(PageLocked(page));
 
@@ -1633,8 +1634,7 @@ static int ext4_ordered_writepage(struct
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
 	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext4_get_block, wbc);
 
@@ -1651,13 +1651,12 @@ static int ext4_ordered_writepage(struct
 	 * and generally junk.
 	 */
 	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+		err = walk_page_buffers(handle, page_bufs, 0, pagesize,
 					NULL, jbd2_journal_dirty_data_fn);
 		if (!ret)
 			ret = err;
 	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
+	walk_page_buffers(handle, page_bufs, 0, pagesize, NULL, bput_one);
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
@@ -1709,6 +1708,7 @@ static int ext4_journalled_writepage(str
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	int pagesize = page_cache_size(inode->i_mapping);
 
 	if (ext4_journal_current_handle())
 		goto no_write;
@@ -1725,17 +1725,16 @@ static int ext4_journalled_writepage(str
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext4_get_block);
+		ret = block_prepare_write(page, 0, pagesize, ext4_get_block);
 		if (ret != 0) {
 			ext4_journal_stop(handle);
 			goto out_unlock;
 		}
 		ret = walk_page_buffers(handle, page_buffers(page), 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+			pagesize, NULL, do_journal_get_write_access);
 
 		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
+			pagesize, NULL, write_end_fn);
 		if (ret == 0)
 			ret = err;
 		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
@@ -1976,8 +1975,8 @@ void ext4_set_aops(struct inode *inode)
 int ext4_block_truncate_page(handle_t *handle, struct page *page,
 		struct address_space *mapping, loff_t from)
 {
-	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	ext4_fsblk_t index = page_cache_index(mapping, from);
+	unsigned offset = page_cache_offset(mapping, from);
 	unsigned blocksize, length, pos;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
@@ -1986,7 +1985,8 @@ int ext4_block_truncate_page(handle_t *h
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
-	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = index <<
+		(page_cache_shift(mapping) - inode->i_sb->s_blocksize_bits);
 
 	/*
 	 * For "nobh" option,  we can only work if we don't need to
@@ -2466,7 +2466,7 @@ void ext4_truncate(struct inode *inode)
 		page = NULL;
 	} else {
 		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
+				page_cache_index(mapping, inode->i_size));
 		if (!page)
 			return;
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

define-functions-for-page-cache-handling.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
