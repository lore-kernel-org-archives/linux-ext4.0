From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv6 14/37] thp: introduce hpage_size() and hpage_mask()
Date: Thu, 26 Jan 2017 14:57:56 +0300
Message-ID: <20170126115819.58875-15-kirill.shutemov@linux.intel.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170126115819.58875-1-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Introduce new helpers which return size/mask of the page:
HPAGE_PMD_SIZE/HPAGE_PMD_MASK if the page is PageTransHuge() and
PAGE_SIZE/PAGE_MASK otherwise.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 97e478d6b690..e5c9c26d2439 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -142,6 +142,20 @@ static inline int hpage_nr_pages(struct page *page)
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
 extern int do_huge_pmd_numa_page(struct vm_fault *vmf, pmd_t orig_pmd);
 
 extern struct page *huge_zero_page;
@@ -167,6 +181,8 @@ void mm_put_huge_zero_page(struct mm_struct *mm);
 #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
 
 #define hpage_nr_pages(x) 1
+#define hpage_size(x) PAGE_SIZE
+#define hpage_mask(x) PAGE_MASK
 
 #define transparent_hugepage_enabled(__vma) 0
 
-- 
2.11.0
