From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv4 11/43] thp: handle write-protection faults for file THP
Date: Tue, 25 Oct 2016 03:13:10 +0300
Message-ID: <20161025001342.76126-12-kirill.shutemov@linux.intel.com>
References: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
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
In-Reply-To: <20161025001342.76126-1-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

For filesystems that wants to be write-notified (has mkwrite), we will
encount write-protection faults for huge PMDs in shared mappings.

The easiest way to handle them is to clear the PMD and let it refault as
wriable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 mm/memory.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e18c57bdc75c..e8c04d1d87b8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3452,8 +3452,17 @@ static int wp_huge_pmd(struct fault_env *fe, pmd_t orig_pmd)
 		return fe->vma->vm_ops->pmd_fault(fe->vma, fe->address, fe->pmd,
 				fe->flags);
 
+	if (fe->vma->vm_flags & VM_SHARED) {
+		/* Clear PMD */
+		zap_page_range_single(fe->vma, fe->address & HPAGE_PMD_MASK,
+				HPAGE_PMD_SIZE, NULL);
+		VM_BUG_ON(!pmd_none(*fe->pmd));
+
+		/* Refault to establish writable PMD */
+		return 0;
+	}
+
 	/* COW handled on pte level: split pmd */
-	VM_BUG_ON_VMA(fe->vma->vm_flags & VM_SHARED, fe->vma);
 	split_huge_pmd(fe->vma, fe->pmd, fe->address);
 
 	return VM_FAULT_FALLBACK;
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
