From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 19/41] block: define BIO_MAX_PAGES to HPAGE_PMD_NR if huge page cache enabled
Date: Fri, 12 Aug 2016 21:38:02 +0300
Message-ID: <1471027104-115213-20-git-send-email-kirill.shutemov@linux.intel.com>
References: <1471027104-115213-1-git-send-email-kirill.shutemov@linux.intel.com>
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
In-Reply-To: <1471027104-115213-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We are going to do IO a huge page a time. So we need BIO_MAX_PAGES to be
at least HPAGE_PMD_NR. For x86-64, it's 512 pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/bio.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 583c10810e32..c7104a77e0db 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -40,7 +40,11 @@
 #define BIO_BUG_ON
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGE_PAGECACHE
+#define BIO_MAX_PAGES		(HPAGE_PMD_NR > 256 ? HPAGE_PMD_NR : 256)
+#else
 #define BIO_MAX_PAGES		256
+#endif
 
 #define bio_prio(bio)			(bio)->bi_ioprio
 #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
-- 
2.8.1
