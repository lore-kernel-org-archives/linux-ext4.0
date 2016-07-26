From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv1, RFC 20/33] thp: introduce hpage_size() and hpage_mask()
Date: Tue, 26 Jul 2016 03:35:22 +0300
Message-ID: <1469493335-3622-21-git-send-email-kirill.shutemov@linux.intel.com>
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

Introduce new helpers which return size/mask of the page:
HPAGE_PMD_SIZE/HPAGE_PMD_MASK if the page is PageTransHuge() and
PAGE_SIZE/PAGE_MASK otherwise.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 6f14de45b5ce..de2789b4402c 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -138,6 +138,20 @@ static inline int hpage_nr_pages(struct page *page)
 	return 1;
 }
 
+static inline int hpage_size(struct page *page)
+{
+	if (unlikely(PageTransHuge(page)))
+		return HPAGE_PMD_SIZE;
+	return PAGE_SIZE;
+}
+
+static inline unsigned long hpage_mask(struct page *page)
+{
+	if (unlikely(PageTransHuge(page)))
+		return HPAGE_PMD_MASK;
+	return PAGE_MASK;
+}
+
 extern int do_huge_pmd_numa_page(struct fault_env *fe, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
@@ -163,6 +177,8 @@ void put_huge_zero_page(void);
 #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
+#define hpage_size(x) PAGE_SIZE
+#define hpage_mask(x) PAGE_MASK
 
 #define transparent_hugepage_enabled(__vma) 0
 
-- 
2.8.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
