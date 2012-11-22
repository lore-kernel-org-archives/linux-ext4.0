From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH 1/2] mm: Introduce page flag to indicate stable page
 status
Date: Wed, 21 Nov 2012 18:36:08 -0800
Message-ID: <20121122023608.GA32182@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
 <20121121211319.GA32202@blackbox.djwong.org>
 <20121121213333.GF30250@quack.suse.cz>
 <20121122084713.69e5b1fc@notabene.brown>
 <20121122014755.GH8740@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, lucho@ionkov.net,
	ericvh@gmail.com, tytso@mit.edu, rminnich@sandia.gov,
	viro@zeniv.linux.org.uk, martin.petersen@oracle.com,
	david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121122014755.GH8740@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds yet another page flag, PG_stable, to indicate that the page's
contents must not be changed because the page is undergoing some sort of
integrity operation (checksumming, digest calculation, etc.)  This change
should enable us to reduce page write latency in userspace apps, particularly
for things like networked filesystems where the page contents needn't be held
stable after a write request is transmitted, even though PG_writeback is still
set.

Also, convert wait_for_stable_page to use this new page flag.  By default,
PG_stable is set for the same duration as PG_writeback.

Signed-off-by: Darick J. Wong <darrick.wong@oracle.com>
---
 include/linux/page-flags.h |    2 ++
 include/linux/pagemap.h    |    1 +
 mm/filemap.c               |    8 ++++++++
 mm/page-writeback.c        |    7 ++++++-
 mm/page_alloc.c            |    3 +++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index b5d1384..83f41bf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -109,6 +109,7 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+	PG_stable,		/* page is immutable during a writeout */
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -208,6 +209,7 @@ PAGEFLAG(Pinned, pinned) TESTSCFLAG(Pinned, pinned)	/* Xen */
 PAGEFLAG(SavePinned, savepinned);			/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)
+PAGEFLAG(Stable, stable) TESTSETFLAG(Stable, stable)
 
 __PAGEFLAG(SlobFree, slob_free)
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ea631ee..0e0a006 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -399,6 +399,7 @@ static inline void wait_on_page_writeback(struct page *page)
 
 extern void end_page_writeback(struct page *page);
 void wait_for_stable_page(struct page *page);
+void clear_page_stable(struct page *page);
 
 /*
  * Add an arbitrary waiter to a page's wait queue
diff --git a/mm/filemap.c b/mm/filemap.c
index 5577dc8..88dc3b7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -534,6 +534,13 @@ static inline void wake_up_page(struct page *page, int bit)
 	__wake_up_bit(page_waitqueue(page), &page->flags, bit);
 }
 
+void clear_page_stable(struct page *page)
+{
+	ClearPageStable(page);
+	wake_up_page(page, PG_stable);
+}
+EXPORT_SYMBOL_GPL(clear_page_stable);
+
 void wait_on_page_bit(struct page *page, int bit_nr)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
@@ -608,6 +615,7 @@ void end_page_writeback(struct page *page)
 
 	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_writeback);
+	wake_up_page(page, PG_stable);
 }
 EXPORT_SYMBOL(end_page_writeback);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 1bc0edf..2cd8155 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2209,6 +2209,7 @@ int test_clear_page_writeback(struct page *page)
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
+		ClearPageStable(page);
 		ret = TestClearPageWriteback(page);
 		if (ret) {
 			radix_tree_tag_clear(&mapping->page_tree,
@@ -2221,6 +2222,7 @@ int test_clear_page_writeback(struct page *page)
 		}
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
+		ClearPageStable(page);
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
@@ -2240,6 +2242,7 @@ int test_set_page_writeback(struct page *page)
 		unsigned long flags;
 
 		spin_lock_irqsave(&mapping->tree_lock, flags);
+		SetPageStable(page);
 		ret = TestSetPageWriteback(page);
 		if (!ret) {
 			radix_tree_tag_set(&mapping->page_tree,
@@ -2257,6 +2260,7 @@ int test_set_page_writeback(struct page *page)
 				     PAGECACHE_TAG_TOWRITE);
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
 	} else {
+		SetPageStable(page);
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret)
@@ -2291,6 +2295,7 @@ void wait_for_stable_page(struct page *page)
 	if (!bdi_cap_stable_pages_required(bdi))
 		return;
 
-	wait_on_page_writeback(page);
+	if (PageStable(page))
+		wait_on_page_bit(page, PG_stable);
 }
 EXPORT_SYMBOL_GPL(wait_for_stable_page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7bb35ac..2b308d2 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6056,6 +6056,9 @@ static const struct trace_print_flags pageflag_names[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	{1UL << PG_stable,		"stable" },
+#endif
 };
 
 static void dump_page_flags(unsigned long flags)
