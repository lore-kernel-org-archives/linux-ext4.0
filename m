From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3 17/41] filemap: handle huge pages in filemap_fdatawait_range()
Date: Thu, 15 Sep 2016 14:54:59 +0300
Message-ID: <20160915115523.29737-18-kirill.shutemov@linux.intel.com>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
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
In-Reply-To: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

We writeback whole huge page a time.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 05b42d3e5ed8..53da93156e60 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -372,9 +372,14 @@ static int __filemap_fdatawait_range(struct address_space *mapping,
 			if (page->index > end)
 				continue;
 
+			page = compound_head(page);
 			wait_on_page_writeback(page);
 			if (TestClearPageError(page))
 				ret = -EIO;
+			if (PageTransHuge(page)) {
+				index = page->index + HPAGE_PMD_NR;
+				i += index - pvec.pages[i]->index - 1;
+			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
