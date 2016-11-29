From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv5 25/36] ext4: make ext4_writepage() work on huge pages
Date: Tue, 29 Nov 2016 14:22:53 +0300
Message-ID: <20161129112304.90056-26-kirill.shutemov@linux.intel.com>
References: <20161129112304.90056-1-kirill.shutemov@linux.intel.com>
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
Received: from mga01.intel.com ([192.55.52.88]:37259 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757249AbcK2LXm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 29 Nov 2016 06:23:42 -0500
In-Reply-To: <20161129112304.90056-1-kirill.shutemov@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change ext4_writepage() and underlying ext4_bio_write_page().

It basically removes assumption on page size, infer it from struct page
instead.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/inode.c   | 10 +++++-----
 fs/ext4/page-io.c | 11 +++++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ebccc535b15e..fa4467e4b129 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2037,10 +2037,10 @@ static int ext4_writepage(struct page *page,
 
 	trace_ext4_writepage(page);
 	size = i_size_read(inode);
-	if (page->index == size >> PAGE_SHIFT)
-		len = size & ~PAGE_MASK;
-	else
-		len = PAGE_SIZE;
+
+	len = hpage_size(page);
+	if (page->index + hpage_nr_pages(page) - 1 == size >> PAGE_SHIFT)
+			len = size & ~hpage_mask(page);
 
 	page_bufs = page_buffers(page);
 	/*
@@ -2064,7 +2064,7 @@ static int ext4_writepage(struct page *page,
 				   ext4_bh_delay_or_unwritten)) {
 		redirty_page_for_writepage(wbc, page);
 		if ((current->flags & PF_MEMALLOC) ||
-		    (inode->i_sb->s_blocksize == PAGE_SIZE)) {
+		    (inode->i_sb->s_blocksize == hpage_size(page))) {
 			/*
 			 * For memory cleaning there's no point in writing only
 			 * some buffers. So just bail out. Warn if we came here
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index d83b0f3c5fe9..360c74daec5c 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -413,6 +413,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
+	BUG_ON(PageTail(page));
 
 	if (keep_towrite)
 		set_page_writeback_keepwrite(page);
@@ -429,8 +430,14 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	 * the page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	if (len < PAGE_SIZE)
-		zero_user_segment(page, len, PAGE_SIZE);
+	if (len < hpage_size(page)) {
+		page += len / PAGE_SIZE;
+		if (len % PAGE_SIZE)
+			zero_user_segment(page, len % PAGE_SIZE, PAGE_SIZE);
+		while (page + 1 == compound_head(page))
+			clear_highpage(++page);
+		page = compound_head(page);
+	}
 	/*
 	 * In the first loop we prepare and mark buffers to submit. We have to
 	 * mark all buffers in the page before submitting so that
-- 
2.10.2

