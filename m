From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv6 27/37] ext4: handle huge pages in __ext4_block_zero_page_range()
Date: Thu, 26 Jan 2017 14:58:09 +0300
Message-ID: <20170126115819.58875-28-kirill.shutemov@linux.intel.com>
References: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
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
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

As the function handles zeroing range only within one block, the
required changes are trivial, just remove assuption on page size.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a25be1cf4506..7e65a5b78cf1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3785,7 +3785,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	ext4_fsblk_t index = from >> PAGE_SHIFT;
-	unsigned offset = from & (PAGE_SIZE-1);
+	unsigned offset;
 	unsigned blocksize, pos;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
@@ -3798,6 +3798,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	if (!page)
 		return -ENOMEM;
 
+	page = compound_head(page);
+	offset = from & ~hpage_mask(page);
+
 	blocksize = inode->i_sb->s_blocksize;
 
 	iblock = index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
@@ -3853,7 +3856,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		if (err)
 			goto unlock;
 	}
-	zero_user(page, offset, length);
+	zero_user(page + offset / PAGE_SIZE, offset % PAGE_SIZE, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	if (ext4_should_journal_data(inode)) {
-- 
2.11.0

