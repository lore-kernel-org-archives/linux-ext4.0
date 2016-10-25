From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 34/43] ext4: handle huge pages in __ext4_block_zero_page_range()
Date: Tue, 25 Oct 2016 03:13:33 +0300
Message-ID: <20161025001342.76126-35-kirill.shutemov@linux.intel.com>
References: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:34084 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965760AbcJYAPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Oct 2016 20:15:25 -0400
In-Reply-To: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As the function handles zeroing range only within one block, the
required changes are trivial, just remove assuption on page size.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5ceb72c7bac1..c1728d2bf47b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3685,7 +3685,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	ext4_fsblk_t index = from >> PAGE_SHIFT;
-	unsigned offset = from & (PAGE_SIZE-1);
+	unsigned offset;
 	unsigned blocksize, pos;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
@@ -3698,6 +3698,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	if (!page)
 		return -ENOMEM;
 
+	page = compound_head(page);
+	offset = from & ~hpage_mask(page);
+
 	blocksize = inode->i_sb->s_blocksize;
 
 	iblock = index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
@@ -3752,7 +3755,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		if (err)
 			goto unlock;
 	}
-	zero_user(page, offset, length);
+	zero_user(page + offset / PAGE_SIZE, offset % PAGE_SIZE, length);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	if (ext4_should_journal_data(inode)) {
-- 
2.9.3

