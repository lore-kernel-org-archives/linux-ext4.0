From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3 22/41] thp: do not threat slab pages as huge in hpage_{nr_pages,size,mask}
Date: Thu, 15 Sep 2016 14:55:04 +0300
Message-ID: <20160915115523.29737-23-kirill.shutemov@linux.intel.com>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
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
In-Reply-To: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Slab pages can be compound, but we shouldn't threat them as THP for
pupose of hpage_* helpers, otherwise it would lead to confusing results.

For instance, ext4 uses slab pages for journal pages and we shouldn't
confuse them with THPs. The easiest way is to exclude them in hpage_*
helpers.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/huge_mm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index de2789b4402c..5c5466ba37df 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -133,21 +133,21 @@ static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 }
 static inline int hpage_nr_pages(struct page *page)
 {
-	if (unlikely(PageTransHuge(page)))
+	if (unlikely(!PageSlab(page) && PageTransHuge(page)))
 		return HPAGE_PMD_NR;
 	return 1;
 }
 
 static inline int hpage_size(struct page *page)
 {
-	if (unlikely(PageTransHuge(page)))
+	if (unlikely(!PageSlab(page) && PageTransHuge(page)))
 		return HPAGE_PMD_SIZE;
 	return PAGE_SIZE;
 }
 
 static inline unsigned long hpage_mask(struct page *page)
 {
-	if (unlikely(PageTransHuge(page)))
+	if (unlikely(!PageSlab(page) && PageTransHuge(page)))
 		return HPAGE_PMD_MASK;
 	return PAGE_MASK;
 }
-- 
2.9.3
