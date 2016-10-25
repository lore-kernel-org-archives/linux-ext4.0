From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 36/43] ext4: handle huge pages in ext4_da_write_end()
Date: Tue, 25 Oct 2016 03:13:35 +0300
Message-ID: <20161025001342.76126-37-kirill.shutemov@linux.intel.com>
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
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Call ext4_da_should_update_i_disksize() for head page with offset
relative to head page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1eae6801846c..59cd2b113eb2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3015,7 +3015,6 @@ static int ext4_da_write_end(struct file *file,
 	int ret = 0, ret2;
 	handle_t *handle = ext4_journal_current_handle();
 	loff_t new_i_size;
-	unsigned long start, end;
 	int write_mode = (int)(unsigned long)fsdata;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC)
@@ -3023,8 +3022,6 @@ static int ext4_da_write_end(struct file *file,
 				      len, copied, page, fsdata);
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
-	start = pos & (PAGE_SIZE - 1);
-	end = start + copied - 1;
 
 	/*
 	 * generic_write_end() will run mark_inode_dirty() if i_size
@@ -3033,8 +3030,10 @@ static int ext4_da_write_end(struct file *file,
 	 */
 	new_i_size = pos + copied;
 	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
+		struct page *head = compound_head(page);
+		unsigned long end = (pos & ~hpage_mask(head)) + copied - 1;
 		if (ext4_has_inline_data(inode) ||
-		    ext4_da_should_update_i_disksize(page, end)) {
+		    ext4_da_should_update_i_disksize(head, end)) {
 			ext4_update_i_disksize(inode, new_i_size);
 			/* We need to mark inode dirty even if
 			 * new_i_size is less that inode->i_size
-- 
2.9.3

