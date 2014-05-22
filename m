From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Fix zeroing of page during writeback
Date: Thu, 22 May 2014 17:06:43 +0200
Message-ID: <1400771203-24260-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>,
	Jan Kara <jack@suse.cz>, stable@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tail of a page straddling inode size must be zeroed when being written
out due to POSIX requirement that modifications of mmaped page beyond
inode size must not be written to the file. ext4_bio_write_page() did
this only for blocks fully beyond inode size but didn't properly zero
blocks partially beyond inode size. Fix this.

The problem has been uncovered by mmap_11-4 test in openposix test suite
(part of LTP).

Reported-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Fixes: 5a0dc7365c240
Fixes: bd2d0210cf22f
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/page-io.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index c18d95b50540..b936388b834f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -418,6 +418,17 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	ClearPageError(page);
 
 	/*
+	 * Comments copied from block_write_full_page_endio:
+	 *
+	 * The page straddles i_size.  It must be zeroed out on each and every
+	 * writepage invocation because it may be mmapped.  "A file is mapped
+	 * in multiples of the page size.  For a file that is not a multiple of
+	 * the page size, the remaining memory is zeroed when mapped, and
+	 * writes to that region are not written out to the file."
+	 */
+	if (len < PAGE_CACHE_SIZE)
+		zero_user_segment(page, len, PAGE_CACHE_SIZE);
+	/*
 	 * In the first loop we prepare and mark buffers to submit. We have to
 	 * mark all buffers in the page before submitting so that
 	 * end_page_writeback() cannot be called from ext4_bio_end_io() when IO
@@ -428,19 +439,6 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	do {
 		block_start = bh_offset(bh);
 		if (block_start >= len) {
-			/*
-			 * Comments copied from block_write_full_page_endio:
-			 *
-			 * The page straddles i_size.  It must be zeroed out on
-			 * each and every writepage invocation because it may
-			 * be mmapped.  "A file is mapped in multiples of the
-			 * page size.  For a file that is not a multiple of
-			 * the  page size, the remaining memory is zeroed when
-			 * mapped, and writes to that region are not written
-			 * out to the file."
-			 */
-			zero_user_segment(page, block_start,
-					  block_start + blocksize);
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;
-- 
1.8.1.4
