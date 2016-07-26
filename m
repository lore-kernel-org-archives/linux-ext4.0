From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv1, RFC 12/33] truncate: make sure invalidate_mapping_pages() can discard huge pages
Date: Tue, 26 Jul 2016 03:35:14 +0300
Message-ID: <1469493335-3622-13-git-send-email-kirill.shutemov@linux.intel.com>
References: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

invalidate_inode_page() has expectation about page_count() of the page
-- if it's not 2 (one to caller, one to radix-tree), it will not be
dropped. That condition almost never met for THPs -- tail pages are
pinned to the pagevec.

Let's drop them, before calling invalidate_inode_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/truncate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/truncate.c b/mm/truncate.c
index a01cce450a26..ce904e4b1708 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -504,10 +504,21 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 				/* 'end' is in the middle of THP */
 				if (index ==  round_down(end, HPAGE_PMD_NR))
 					continue;
+				/*
+				 * invalidate_inode_page() expects
+				 * page_count(page) == 2 to drop page from page
+				 * cache -- drop tail pages references.
+				 */
+				get_page(page);
+				pagevec_release(&pvec);
 			}
 
 			ret = invalidate_inode_page(page);
 			unlock_page(page);
+
+			if (PageTransHuge(page))
+				put_page(page);
+
 			/*
 			 * Invalidation is a hint that the page is no longer
 			 * of interest and try to speed up its reclaim.
-- 
2.8.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
