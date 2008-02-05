From: akpm@linux-foundation.org
Subject: [patch 068/265] Pagecache zeroing: zero_user_segment, zero_user_segments and zero_user
Date: Mon, 04 Feb 2008 22:28:29 -0800
Message-ID: <200802050628.m156SASo006669@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, clameter@sgi.com, aia21@cantab.net,
	bfields@fieldses.org, dgc@sgi.com, linux-ext4@vger.kernel.org,
	mark.fasheh@oracle.com, mhalcrow@us.ibm.com, sfrench@us.ibm.com,
	swhiteho@redhat.com, trond.myklebust@fys.uio.no
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbYBEGpQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2008 01:45:16 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Christoph Lameter <clameter@sgi.com>

Simplify page cache zeroing of segments of pages through 3 functions

zero_user_segments(page, start1, end1, start2, end2)

        Zeros two segments of the page. It takes the position where to
        start and end the zeroing which avoids length calculations and
	makes code clearer.

zero_user_segment(page, start, end)

        Same for a single segment.

zero_user(page, start, length)

        Length variant for the case where we know the length.

We remove the zero_user_page macro. Issues:

1. Its a macro. Inline functions are preferable.

2. The KM_USER0 macro is only defined for HIGHMEM.

   Having to treat this special case everywhere makes the
   code needlessly complex. The parameter for zeroing is always
   KM_USER0 except in one single case that we open code.

Avoiding KM_USER0 makes a lot of code not having to be dealing
with the special casing for HIGHMEM anymore. Dealing with
kmap is only necessary for HIGHMEM configurations. In those
configurations we use KM_USER0 like we do for a series of other
functions defined in highmem.h.

Since KM_USER0 is depends on HIGHMEM the existing zero_user_page
function could not be a macro. zero_user_* functions introduced
here can be be inline because that constant is not used when these
functions are called.

Also extract the flushing of the caches to be outside of the kmap.

[akpm@linux-foundation.org: fix nfs and ntfs build]
[akpm@linux-foundation.org: fix ntfs build some more]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: David Chinner <dgc@sgi.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Steven French <sfrench@us.ibm.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                |   44 ++++++++++----------------------
 fs/cifs/inode.c            |    2 -
 fs/direct-io.c             |    4 +-
 fs/ecryptfs/mmap.c         |    5 +--
 fs/ext3/inode.c            |    4 +-
 fs/ext4/inode.c            |    4 +-
 fs/gfs2/bmap.c             |    2 -
 fs/gfs2/ops_address.c      |    2 -
 fs/libfs.c                 |   11 ++------
 fs/mpage.c                 |    7 +----
 fs/nfs/read.c              |   10 +++----
 fs/nfs/write.c             |    4 --
 fs/ntfs/aops.c             |   20 ++++++++------
 fs/ntfs/compress.c         |    2 -
 fs/ntfs/file.c             |   32 ++++++++++-------------
 fs/ocfs2/alloc.c           |    2 -
 fs/ocfs2/aops.c            |    6 ++--
 fs/reiserfs/inode.c        |    4 +-
 fs/xfs/linux-2.6/xfs_lrw.c |    2 -
 include/linux/highmem.h    |   48 +++++++++++++++++++++--------------
 mm/filemap_xip.c           |    2 -
 mm/truncate.c              |    2 -
 22 files changed, 103 insertions(+), 116 deletions(-)

diff -puN fs/buffer.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/buffer.c
--- a/fs/buffer.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/buffer.c
@@ -1798,7 +1798,7 @@ void page_zero_new_buffers(struct page *
 					start = max(from, block_start);
 					size = min(to, block_end) - start;
 
-					zero_user_page(page, start, size, KM_USER0);
+					zero_user(page, start, size);
 					set_buffer_uptodate(bh);
 				}
 
@@ -1861,19 +1861,10 @@ static int __block_prepare_write(struct 
 					mark_buffer_dirty(bh);
 					continue;
 				}
-				if (block_end > to || block_start < from) {
-					void *kaddr;
-
-					kaddr = kmap_atomic(page, KM_USER0);
-					if (block_end > to)
-						memset(kaddr+to, 0,
-							block_end-to);
-					if (block_start < from)
-						memset(kaddr+block_start,
-							0, from-block_start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
-				}
+				if (block_end > to || block_start < from)
+					zero_user_segments(page,
+						to, block_end,
+						block_start, from);
 				continue;
 			}
 		}
@@ -2104,8 +2095,7 @@ int block_read_full_page(struct page *pa
 					SetPageError(page);
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user_page(page, i * blocksize, blocksize,
-						KM_USER0);
+				zero_user(page, i * blocksize, blocksize);
 				if (!err)
 					set_buffer_uptodate(bh);
 				continue;
@@ -2218,7 +2208,7 @@ int cont_expand_zero(struct file *file, 
 						&page, &fsdata);
 		if (err)
 			goto out;
-		zero_user_page(page, zerofrom, len, KM_USER0);
+		zero_user(page, zerofrom, len);
 		err = pagecache_write_end(file, mapping, curpos, len, len,
 						page, fsdata);
 		if (err < 0)
@@ -2245,7 +2235,7 @@ int cont_expand_zero(struct file *file, 
 						&page, &fsdata);
 		if (err)
 			goto out;
-		zero_user_page(page, zerofrom, len, KM_USER0);
+		zero_user(page, zerofrom, len);
 		err = pagecache_write_end(file, mapping, curpos, len, len,
 						page, fsdata);
 		if (err < 0)
@@ -2422,7 +2412,6 @@ int nobh_write_begin(struct file *file, 
 	unsigned block_in_page;
 	unsigned block_start, block_end;
 	sector_t block_in_file;
-	char *kaddr;
 	int nr_reads = 0;
 	int ret = 0;
 	int is_mapped_to_disk = 1;
@@ -2493,13 +2482,8 @@ int nobh_write_begin(struct file *file, 
 			continue;
 		}
 		if (buffer_new(bh) || !buffer_mapped(bh)) {
-			kaddr = kmap_atomic(page, KM_USER0);
-			if (block_start < from)
-				memset(kaddr+block_start, 0, from-block_start);
-			if (block_end > to)
-				memset(kaddr + to, 0, block_end - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_segments(page, block_start, from,
+							to, block_end);
 			continue;
 		}
 		if (buffer_uptodate(bh))
@@ -2636,7 +2620,7 @@ int nobh_writepage(struct page *page, ge
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
@@ -2709,7 +2693,7 @@ has_buffers:
 		if (page_has_buffers(page))
 			goto has_buffers;
 	}
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	set_page_dirty(page);
 	err = 0;
 
@@ -2785,7 +2769,7 @@ int block_truncate_page(struct address_s
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	mark_buffer_dirty(bh);
 	err = 0;
 
@@ -2831,7 +2815,7 @@ int block_write_full_page(struct page *p
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	return __block_write_full_page(inode, page, get_block, wbc);
 }
 
diff -puN fs/cifs/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/cifs/inode.c
--- a/fs/cifs/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/cifs/inode.c
@@ -1386,7 +1386,7 @@ static int cifs_truncate_page(struct add
 	if (!page)
 		return -ENOMEM;
 
-	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
+	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	unlock_page(page);
 	page_cache_release(page);
 	return rc;
diff -puN fs/direct-io.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/direct-io.c
--- a/fs/direct-io.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/direct-io.c
@@ -878,8 +878,8 @@ do_holes:
 					page_cache_release(page);
 					goto out;
 				}
-				zero_user_page(page, block_in_page << blkbits,
-						1 << blkbits, KM_USER0);
+				zero_user(page, block_in_page << blkbits,
+						1 << blkbits);
 				dio->block_in_file++;
 				block_in_page++;
 				goto next_block;
diff -puN fs/ecryptfs/mmap.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ecryptfs/mmap.c
@@ -257,8 +257,7 @@ static int fill_zeros_to_end_of_page(str
 	end_byte_in_page = i_size_read(inode) % PAGE_CACHE_SIZE;
 	if (to > end_byte_in_page)
 		end_byte_in_page = to;
-	zero_user_page(page, end_byte_in_page,
-		PAGE_CACHE_SIZE - end_byte_in_page, KM_USER0);
+	zero_user_segment(page, end_byte_in_page, PAGE_CACHE_SIZE);
 out:
 	return 0;
 }
@@ -307,7 +306,7 @@ static int ecryptfs_prepare_write(struct
 	 */
 	if ((i_size_read(page->mapping->host) == prev_page_end_size) &&
 	    (from != 0)) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 	}
 out:
 	return rc;
diff -puN fs/ext3/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ext3/inode.c
--- a/fs/ext3/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ext3/inode.c
@@ -1845,7 +1845,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		zero_user_page(page, offset, length, KM_USER0);
+		zero_user(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1898,7 +1898,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
diff -puN fs/ext4/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ext4/inode.c
--- a/fs/ext4/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ext4/inode.c
@@ -1840,7 +1840,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		zero_user_page(page, offset, length, KM_USER0);
+		zero_user(page, offset, length);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1893,7 +1893,7 @@ int ext4_block_truncate_page(handle_t *h
 			goto unlock;
 	}
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 
 	BUFFER_TRACE(bh, "zeroed end of block");
 
diff -puN fs/gfs2/bmap.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/gfs2/bmap.c
@@ -932,7 +932,7 @@ static int gfs2_block_truncate_page(stru
 	if (!gfs2_is_writeback(ip))
 		gfs2_trans_add_bh(ip->i_gl, bh, 0);
 
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 
 unlock:
 	unlock_page(page);
diff -puN fs/gfs2/ops_address.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/gfs2/ops_address.c
--- a/fs/gfs2/ops_address.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/gfs2/ops_address.c
@@ -446,7 +446,7 @@ static int stuffed_readpage(struct gfs2_
 	 * so we need to supply one here. It doesn't happen often.
 	 */
 	if (unlikely(page->index)) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		return 0;
 	}
 
diff -puN fs/libfs.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/libfs.c
--- a/fs/libfs.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/libfs.c
@@ -341,13 +341,10 @@ int simple_prepare_write(struct file *fi
 			unsigned from, unsigned to)
 {
 	if (!PageUptodate(page)) {
-		if (to - from != PAGE_CACHE_SIZE) {
-			void *kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr, 0, from);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
-		}
+		if (to - from != PAGE_CACHE_SIZE)
+			zero_user_segments(page,
+				0, from,
+				to, PAGE_CACHE_SIZE);
 	}
 	return 0;
 }
diff -puN fs/mpage.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/mpage.c
--- a/fs/mpage.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/mpage.c
@@ -276,9 +276,7 @@ do_mpage_readpage(struct bio *bio, struc
 	}
 
 	if (first_hole != blocks_per_page) {
-		zero_user_page(page, first_hole << blkbits,
-				PAGE_CACHE_SIZE - (first_hole << blkbits),
-				KM_USER0);
+		zero_user_segment(page, first_hole << blkbits, PAGE_CACHE_SIZE);
 		if (first_hole == 0) {
 			SetPageUptodate(page);
 			unlock_page(page);
@@ -571,8 +569,7 @@ page_is_mapped:
 
 		if (page->index > end_index || !offset)
 			goto confused;
-		zero_user_page(page, offset, PAGE_CACHE_SIZE - offset,
-				KM_USER0);
+		zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	}
 
 	/*
diff -puN fs/nfs/read.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/nfs/read.c
--- a/fs/nfs/read.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/nfs/read.c
@@ -79,7 +79,7 @@ void nfs_readdata_release(void *data)
 static
 int nfs_return_empty_page(struct page *page)
 {
-	zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	zero_user(page, 0, PAGE_CACHE_SIZE);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
@@ -103,10 +103,10 @@ static void nfs_readpage_truncate_uninit
 	pglen = PAGE_CACHE_SIZE - base;
 	for (;;) {
 		if (remainder <= pglen) {
-			zero_user_page(*pages, base, remainder, KM_USER0);
+			zero_user(*pages, base, remainder);
 			break;
 		}
-		zero_user_page(*pages, base, pglen, KM_USER0);
+		zero_user(*pages, base, pglen);
 		pages++;
 		remainder -= pglen;
 		pglen = PAGE_CACHE_SIZE;
@@ -130,7 +130,7 @@ static int nfs_readpage_async(struct nfs
 		return PTR_ERR(new);
 	}
 	if (len < PAGE_CACHE_SIZE)
-		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 
 	nfs_list_add_request(new, &one_request);
 	if (NFS_SERVER(inode)->rsize < PAGE_CACHE_SIZE)
@@ -532,7 +532,7 @@ readpage_async_filler(void *data, struct
 		goto out_error;
 
 	if (len < PAGE_CACHE_SIZE)
-		zero_user_page(page, len, PAGE_CACHE_SIZE - len, KM_USER0);
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
 	nfs_pageio_add_request(desc->pgio, new);
 	return 0;
 out_error:
diff -puN fs/nfs/write.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/nfs/write.c
--- a/fs/nfs/write.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/nfs/write.c
@@ -665,9 +665,7 @@ zero_page:
 	 * then we need to zero any uninitalised data. */
 	if (req->wb_pgbase == 0 && req->wb_bytes != PAGE_CACHE_SIZE
 			&& !PageUptodate(req->wb_page))
-		zero_user_page(req->wb_page, req->wb_bytes,
-				PAGE_CACHE_SIZE - req->wb_bytes,
-				KM_USER0);
+		zero_user_segment(req->wb_page, req->wb_bytes, PAGE_CACHE_SIZE);
 	return req;
 }
 
diff -puN fs/ntfs/aops.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ntfs/aops.c
--- a/fs/ntfs/aops.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ntfs/aops.c
@@ -87,13 +87,17 @@ static void ntfs_end_buffer_async_read(s
 		/* Check for the current buffer head overflowing. */
 		if (unlikely(file_ofs + bh->b_size > init_size)) {
 			int ofs;
+			void *kaddr;
 
 			ofs = 0;
 			if (file_ofs < init_size)
 				ofs = init_size - file_ofs;
 			local_irq_save(flags);
-			zero_user_page(page, bh_offset(bh) + ofs,
-					 bh->b_size - ofs, KM_BIO_SRC_IRQ);
+			kaddr = kmap_atomic(page, KM_BIO_SRC_IRQ);
+			memset(kaddr + bh_offset(bh) + ofs, 0,
+					bh->b_size - ofs);
+			flush_dcache_page(page);
+			kunmap_atomic(kaddr, KM_BIO_SRC_IRQ);
 			local_irq_restore(flags);
 		}
 	} else {
@@ -334,7 +338,7 @@ handle_hole:
 		bh->b_blocknr = -1UL;
 		clear_buffer_mapped(bh);
 handle_zblock:
-		zero_user_page(page, i * blocksize, blocksize, KM_USER0);
+		zero_user(page, i * blocksize, blocksize);
 		if (likely(!err))
 			set_buffer_uptodate(bh);
 	} while (i++, iblock++, (bh = bh->b_this_page) != head);
@@ -410,7 +414,7 @@ retry_readpage:
 	/* Is the page fully outside i_size? (truncate in progress) */
 	if (unlikely(page->index >= (i_size + PAGE_CACHE_SIZE - 1) >>
 			PAGE_CACHE_SHIFT)) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		ntfs_debug("Read outside i_size - truncated?");
 		goto done;
 	}
@@ -459,7 +463,7 @@ retry_readpage:
 	 * ok to ignore the compressed flag here.
 	 */
 	if (unlikely(page->index > 0)) {
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		goto done;
 	}
 	if (!NInoAttr(ni))
@@ -788,8 +792,7 @@ lock_retry_remap:
 		if (err == -ENOENT || lcn == LCN_ENOENT) {
 			bh->b_blocknr = -1;
 			clear_buffer_dirty(bh);
-			zero_user_page(page, bh_offset(bh), blocksize,
-					KM_USER0);
+			zero_user(page, bh_offset(bh), blocksize);
 			set_buffer_uptodate(bh);
 			err = 0;
 			continue;
@@ -1414,8 +1417,7 @@ retry_writepage:
 		if (page->index >= (i_size >> PAGE_CACHE_SHIFT)) {
 			/* The page straddles i_size. */
 			unsigned int ofs = i_size & ~PAGE_CACHE_MASK;
-			zero_user_page(page, ofs, PAGE_CACHE_SIZE - ofs,
-					KM_USER0);
+			zero_user_segment(page, ofs, PAGE_CACHE_SIZE);
 		}
 		/* Handle mst protected attributes. */
 		if (NInoMstProtected(ni))
diff -puN fs/ntfs/compress.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ntfs/compress.c
--- a/fs/ntfs/compress.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ntfs/compress.c
@@ -565,7 +565,7 @@ int ntfs_read_compressed_block(struct pa
 	if (xpage >= max_page) {
 		kfree(bhs);
 		kfree(pages);
-		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_CACHE_SIZE);
 		ntfs_debug("Compressed read outside i_size - truncated?");
 		SetPageUptodate(page);
 		unlock_page(page);
diff -puN fs/ntfs/file.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ntfs/file.c
--- a/fs/ntfs/file.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ntfs/file.c
@@ -607,8 +607,8 @@ do_next_page:
 					ntfs_submit_bh_for_read(bh);
 					*wait_bh++ = bh;
 				} else {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -683,9 +683,8 @@ map_buffer_cached:
 						ntfs_submit_bh_for_read(bh);
 						*wait_bh++ = bh;
 					} else {
-						zero_user_page(page,
-							bh_offset(bh),
-							blocksize, KM_USER0);
+						zero_user(page, bh_offset(bh),
+								blocksize);
 						set_buffer_uptodate(bh);
 					}
 				}
@@ -703,8 +702,8 @@ map_buffer_cached:
 			 */
 			if (bh_end <= pos || bh_pos >= end) {
 				if (!buffer_uptodate(bh)) {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 				mark_buffer_dirty(bh);
@@ -743,8 +742,7 @@ map_buffer_cached:
 				if (!buffer_uptodate(bh))
 					set_buffer_uptodate(bh);
 			} else if (!buffer_uptodate(bh)) {
-				zero_user_page(page, bh_offset(bh), blocksize,
-						KM_USER0);
+				zero_user(page, bh_offset(bh), blocksize);
 				set_buffer_uptodate(bh);
 			}
 			continue;
@@ -868,8 +866,8 @@ rl_not_mapped_enoent:
 					if (!buffer_uptodate(bh))
 						set_buffer_uptodate(bh);
 				} else if (!buffer_uptodate(bh)) {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+						blocksize);
 					set_buffer_uptodate(bh);
 				}
 				continue;
@@ -1128,8 +1126,8 @@ rl_not_mapped_enoent:
 
 				if (likely(bh_pos < initialized_size))
 					ofs = initialized_size - bh_pos;
-				zero_user_page(page, bh_offset(bh) + ofs,
-						blocksize - ofs, KM_USER0);
+				zero_user_segment(page, bh_offset(bh) + ofs,
+						blocksize);
 			}
 		} else /* if (unlikely(!buffer_uptodate(bh))) */
 			err = -EIO;
@@ -1269,8 +1267,8 @@ rl_not_mapped_enoent:
 				if (PageUptodate(page))
 					set_buffer_uptodate(bh);
 				else {
-					zero_user_page(page, bh_offset(bh),
-							blocksize, KM_USER0);
+					zero_user(page, bh_offset(bh),
+							blocksize);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1330,7 +1328,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
@@ -1451,7 +1449,7 @@ err_out:
 		len = PAGE_CACHE_SIZE;
 		if (len > bytes)
 			len = bytes;
-		zero_user_page(*pages, 0, len, KM_USER0);
+		zero_user(*pages, 0, len);
 	}
 	goto out;
 }
diff -puN fs/ocfs2/alloc.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ocfs2/alloc.c
@@ -5670,7 +5670,7 @@ static void ocfs2_map_and_dirty_page(str
 		mlog_errno(ret);
 
 	if (zero)
-		zero_user_page(page, from, to - from, KM_USER0);
+		zero_user_segment(page, from, to);
 
 	/*
 	 * Need to set the buffers we zero'd into uptodate
diff -puN fs/ocfs2/aops.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/ocfs2/aops.c
@@ -307,7 +307,7 @@ static int ocfs2_readpage(struct file *f
 	 * XXX sys_readahead() seems to get that wrong?
 	 */
 	if (start >= i_size_read(inode)) {
-		zero_user_page(page, 0, PAGE_SIZE, KM_USER0);
+		zero_user(page, 0, PAGE_SIZE);
 		SetPageUptodate(page);
 		ret = 0;
 		goto out_alloc;
@@ -869,7 +869,7 @@ int ocfs2_map_page_blocks(struct page *p
 		if (block_start >= to)
 			break;
 
-		zero_user_page(page, block_start, bh->b_size, KM_USER0);
+		zero_user(page, block_start, bh->b_size);
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 
@@ -1034,7 +1034,7 @@ static void ocfs2_zero_new_buffers(struc
 					start = max(from, block_start);
 					end = min(to, block_end);
 
-					zero_user_page(page, start, end - start, KM_USER0);
+					zero_user_segment(page, start, end);
 					set_buffer_uptodate(bh);
 				}
 
diff -puN fs/reiserfs/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/reiserfs/inode.c
@@ -2143,7 +2143,7 @@ int reiserfs_truncate_file(struct inode 
 		/* if we are not on a block boundary */
 		if (length) {
 			length = blocksize - length;
-			zero_user_page(page, offset, length, KM_USER0);
+			zero_user(page, offset, length);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2367,7 +2367,7 @@ static int reiserfs_write_full_page(stru
 			unlock_page(page);
 			return 0;
 		}
-		zero_user_page(page, last_offset, PAGE_CACHE_SIZE - last_offset, KM_USER0);
+		zero_user_segment(page, last_offset, PAGE_CACHE_SIZE);
 	}
 	bh = head;
 	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
diff -puN fs/xfs/linux-2.6/xfs_lrw.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user fs/xfs/linux-2.6/xfs_lrw.c
--- a/fs/xfs/linux-2.6/xfs_lrw.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/fs/xfs/linux-2.6/xfs_lrw.c
@@ -155,7 +155,7 @@ xfs_iozero(
 		if (status)
 			break;
 
-		zero_user_page(page, offset, bytes, KM_USER0);
+		zero_user(page, offset, bytes);
 
 		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
 					page, fsdata);
diff -puN include/linux/highmem.h~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user include/linux/highmem.h
--- a/include/linux/highmem.h~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/include/linux/highmem.h
@@ -124,28 +124,40 @@ static inline void clear_highpage(struct
 	kunmap_atomic(kaddr, KM_USER0);
 }
 
-/*
- * Same but also flushes aliased cache contents to RAM.
- *
- * This must be a macro because KM_USER0 and friends aren't defined if
- * !CONFIG_HIGHMEM
- */
-#define zero_user_page(page, offset, size, km_type)		\
-	do {							\
-		void *kaddr;					\
-								\
-		BUG_ON((offset) + (size) > PAGE_SIZE);		\
-								\
-		kaddr = kmap_atomic(page, km_type);		\
-		memset((char *)kaddr + (offset), 0, (size));	\
-		flush_dcache_page(page);			\
-		kunmap_atomic(kaddr, (km_type));		\
-	} while (0)
+static inline void zero_user_segments(struct page *page,
+	unsigned start1, unsigned end1,
+	unsigned start2, unsigned end2)
+{
+	void *kaddr = kmap_atomic(page, KM_USER0);
+
+	BUG_ON(end1 > PAGE_SIZE || end2 > PAGE_SIZE);
+
+	if (end1 > start1)
+		memset(kaddr + start1, 0, end1 - start1);
+
+	if (end2 > start2)
+		memset(kaddr + start2, 0, end2 - start2);
+
+	kunmap_atomic(kaddr, KM_USER0);
+	flush_dcache_page(page);
+}
+
+static inline void zero_user_segment(struct page *page,
+	unsigned start, unsigned end)
+{
+	zero_user_segments(page, start, end, 0, 0);
+}
+
+static inline void zero_user(struct page *page,
+	unsigned start, unsigned size)
+{
+	zero_user_segments(page, start, start + size, 0, 0);
+}
 
 static inline void __deprecated memclear_highpage_flush(struct page *page,
 			unsigned int offset, unsigned int size)
 {
-	zero_user_page(page, offset, size, KM_USER0);
+	zero_user(page, offset, size);
 }
 
 #ifndef __HAVE_ARCH_COPY_USER_HIGHPAGE
diff -puN mm/filemap_xip.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user mm/filemap_xip.c
--- a/mm/filemap_xip.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/mm/filemap_xip.c
@@ -431,7 +431,7 @@ xip_truncate_page(struct address_space *
 		else
 			return PTR_ERR(page);
 	}
-	zero_user_page(page, offset, length, KM_USER0);
+	zero_user(page, offset, length);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xip_truncate_page);
diff -puN mm/truncate.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user mm/truncate.c
--- a/mm/truncate.c~pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user
+++ a/mm/truncate.c
@@ -48,7 +48,7 @@ void do_invalidatepage(struct page *page
 
 static inline void truncate_partial_page(struct page *page, unsigned partial)
 {
-	zero_user_page(page, partial, PAGE_CACHE_SIZE - partial, KM_USER0);
+	zero_user_segment(page, partial, PAGE_CACHE_SIZE);
 	if (PagePrivate(page))
 		do_invalidatepage(page, partial);
 }
_
