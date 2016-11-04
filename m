From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/6] fs: Add helper to clean bdev aliases under a bh and use it
Date: Fri,  4 Nov 2016 18:08:15 +0100
Message-ID: <1478279296-6575-6-git-send-email-jack@suse.cz>
References: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478279296-6575-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a helper function that clears buffer heads from a block device
aliasing passed bh. Use this helper function from filesystems instead of
the original unmap_underlying_metadata() to save some boiler plate code
and also have a better name for the functionalily since it is not
unmapping anything for a *long* time.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 8 +++-----
 fs/ext4/inode.c             | 3 +--
 fs/ext4/page-io.c           | 2 +-
 fs/mpage.c                  | 3 +--
 fs/ntfs/aops.c              | 2 +-
 fs/ntfs/file.c              | 5 ++---
 fs/ocfs2/aops.c             | 2 +-
 fs/ufs/balloc.c             | 3 +--
 fs/ufs/inode.c              | 3 +--
 include/linux/buffer_head.h | 4 ++++
 10 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 05f30838cec3..f96c079e181d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1821,8 +1821,7 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				clean_bdev_bh_alias(bh);
 			}
 		}
 		bh = bh->b_this_page;
@@ -2068,8 +2067,7 @@ int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 			}
 
 			if (buffer_new(bh)) {
-				unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+				clean_bdev_bh_alias(bh);
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
@@ -2709,7 +2707,7 @@ int nobh_write_begin(struct address_space *mapping,
 		if (!buffer_mapped(bh))
 			is_mapped_to_disk = 0;
 		if (buffer_new(bh))
-			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+			clean_bdev_bh_alias(bh);
 		if (PageUptodate(page)) {
 			set_buffer_uptodate(bh);
 			continue;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7c7cc4ae4b8e..2f8127601bef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1123,8 +1123,7 @@ static int ext4_block_write_begin(struct page *page, loff_t pos, unsigned len,
 			if (err)
 				break;
 			if (buffer_new(bh)) {
-				unmap_underlying_metadata(bh->b_bdev,
-							  bh->b_blocknr);
+				clean_bdev_bh_alias(bh);
 				if (PageUptodate(page)) {
 					clear_buffer_new(bh);
 					set_buffer_uptodate(bh);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 0094923e5ebf..feed6a161e56 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -457,7 +457,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		}
 		if (buffer_new(bh)) {
 			clear_buffer_new(bh);
-			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+			clean_bdev_bh_alias(bh);
 		}
 		set_buffer_async_write(bh);
 		nr_to_submit++;
diff --git a/fs/mpage.c b/fs/mpage.c
index d2413af0823a..a15e0292a000 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -555,8 +555,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
 			goto confused;
 		if (buffer_new(&map_bh))
-			unmap_underlying_metadata(map_bh.b_bdev,
-						map_bh.b_blocknr);
+			clean_bdev_bh_alias(&map_bh);
 		if (buffer_boundary(&map_bh)) {
 			boundary_block = map_bh.b_blocknr;
 			boundary_bdev = map_bh.b_bdev;
diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index fe251f187ff8..571d0f933080 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -764,7 +764,7 @@ static int ntfs_write_block(struct page *page, struct writeback_control *wbc)
 			}
 			// TODO: Instantiate the hole.
 			// clear_buffer_new(bh);
-			// unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+			// clean_bdev_bh_alias(bh);
 			ntfs_error(vol->sb, "Writing into sparse regions is "
 					"not supported yet. Sorry.");
 			err = -EOPNOTSUPP;
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index bf72a2c58b75..99510d811a8c 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -740,8 +740,7 @@ static int ntfs_prepare_pages_for_non_resident_write(struct page **pages,
 					set_buffer_uptodate(bh);
 				if (unlikely(was_hole)) {
 					/* We allocated the buffer. */
-					unmap_underlying_metadata(bh->b_bdev,
-							bh->b_blocknr);
+					clean_bdev_bh_alias(bh);
 					if (bh_end <= pos || bh_pos >= end)
 						mark_buffer_dirty(bh);
 					else
@@ -784,7 +783,7 @@ static int ntfs_prepare_pages_for_non_resident_write(struct page **pages,
 				continue;
 			}
 			/* We allocated the buffer. */
-			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+			clean_bdev_bh_alias(bh);
 			/*
 			 * If the buffer is fully outside the write, zero it,
 			 * set it uptodate, and mark it dirty so it gets
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c5c5b9748ea3..e8f65eefffca 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -630,7 +630,7 @@ int ocfs2_map_page_blocks(struct page *page, u64 *p_blkno,
 
 		if (!buffer_mapped(bh)) {
 			map_bh(bh, inode->i_sb, *p_blkno);
-			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
+			clean_bdev_bh_alias(bh);
 		}
 
 		if (PageUptodate(page)) {
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 67e085d591d8..92b4acd4b0aa 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -306,8 +306,7 @@ static void ufs_change_blocknr(struct inode *inode, sector_t beg,
 			     (unsigned long long)(pos + newb), pos);
 
 			bh->b_blocknr = newb + pos;
-			unmap_underlying_metadata(bh->b_bdev,
-						  bh->b_blocknr);
+			clean_bdev_bh_alias(bh);
 			mark_buffer_dirty(bh);
 			++j;
 			bh = bh->b_this_page;
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 190d64be22ed..45ceb94e89e4 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -1070,8 +1070,7 @@ static int ufs_alloc_lastblock(struct inode *inode, loff_t size)
 
        if (buffer_new(bh)) {
 	       clear_buffer_new(bh);
-	       unmap_underlying_metadata(bh->b_bdev,
-					 bh->b_blocknr);
+	       clean_bdev_bh_alias(bh);
 	       /*
 		* we do not zeroize fragment, because of
 		* if it maped to hole, it already contains zeroes
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 9c9c73ce7d4f..d1ab91fc6d43 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -171,6 +171,10 @@ int sync_mapping_buffers(struct address_space *mapping);
 void unmap_underlying_metadata(struct block_device *bdev, sector_t block);
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
+static inline void clean_bdev_bh_alias(struct buffer_head *bh)
+{
+	clean_bdev_aliases(bh->b_bdev, bh->b_blocknr, 1);
+}
 
 void mark_buffer_async_write(struct buffer_head *bh);
 void __wait_on_buffer(struct buffer_head *);
-- 
2.6.6

