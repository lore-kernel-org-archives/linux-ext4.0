From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv5 24/36] ext4: make ext4_mpage_readpages() hugepage-aware
Date: Tue, 29 Nov 2016 14:22:52 +0300
Message-ID: <20161129112304.90056-25-kirill.shutemov@linux.intel.com>
References: <20161129112304.90056-1-kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Hugh Dickins <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
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
	Jan Kara <jack@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161129112304.90056-1-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

As BIO_MAX_PAGES is smaller (on x86) than HPAGE_PMD_NR, we cannot use
the optimization ext4_mpage_readpages() provides.

So, for huge pages, we fallback directly to block_read_full_page().

This should be re-visited once we get multipage bvec upstream.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/ext4/readpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index a81b829d56de..b865df0c0973 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -134,7 +134,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 				goto next_page;
 		}
 
-		if (page_has_buffers(page))
+		if (page_has_buffers(page) || PageTransHuge(page))
 			goto confused;
 
 		block_in_file = (sector_t)page->index << (PAGE_SHIFT - blkbits);
-- 
2.10.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
