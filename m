From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 37/41] ext4: make EXT4_IOC_MOVE_EXT work with huge pages
Date: Fri, 12 Aug 2016 21:38:20 +0300
Message-ID: <1471027104-115213-38-git-send-email-kirill.shutemov@linux.intel.com>
References: <1471027104-115213-1-git-send-email-kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471027104-115213-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adjust how we find relevant block within page and how we clear the
required part of the page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/move_extent.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index a920c5d29fac..f3efdd0e0eaf 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -210,7 +210,9 @@ mext_page_mkuptodate(struct page *page, unsigned from, unsigned to)
 				return err;
 			}
 			if (!buffer_mapped(bh)) {
-				zero_user(page, block_start, blocksize);
+				zero_user(page + block_start / PAGE_SIZE,
+						block_start % PAGE_SIZE,
+						blocksize);
 				set_buffer_uptodate(bh);
 				continue;
 			}
@@ -267,10 +269,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	unsigned int tmp_data_size, data_size, replaced_size;
 	int i, err2, jblocks, retries = 0;
 	int replaced_count = 0;
-	int from = data_offset_in_page << orig_inode->i_blkbits;
+	int from;
 	int blocks_per_page = PAGE_SIZE >> orig_inode->i_blkbits;
 	struct super_block *sb = orig_inode->i_sb;
 	struct buffer_head *bh = NULL;
+	int diff;
 
 	/*
 	 * It needs twice the amount of ordinary journal buffers because
@@ -355,6 +358,9 @@ again:
 		goto unlock_pages;
 	}
 data_copy:
+	diff = (pagep[0] - compound_head(pagep[0])) * blocks_per_page;
+	from = (data_offset_in_page + diff) << orig_inode->i_blkbits;
+	pagep[0] = compound_head(pagep[0]);
 	*err = mext_page_mkuptodate(pagep[0], from, from + replaced_size);
 	if (*err)
 		goto unlock_pages;
@@ -384,7 +390,7 @@ data_copy:
 	if (!page_has_buffers(pagep[0]))
 		create_empty_buffers(pagep[0], 1 << orig_inode->i_blkbits, 0);
 	bh = page_buffers(pagep[0]);
-	for (i = 0; i < data_offset_in_page; i++)
+	for (i = 0; i < data_offset_in_page + diff; i++)
 		bh = bh->b_this_page;
 	for (i = 0; i < block_len_in_page; i++) {
 		*err = ext4_get_block(orig_inode, orig_blk_offset + i, bh, 0);
-- 
2.8.1
