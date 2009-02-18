From: Greg KH <gregkh@suse.de>
Subject: [patch 15/36] ext4: Fix the delalloc writepages to allocate blocks
	at the right offset.
Date: Wed, 18 Feb 2009 14:29:25 -0800
Message-ID: <20090218222925.GP10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757872AbZBRWcG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:06 -0500
Content-Disposition: inline; filename="ext4-fix-the-delalloc-writepages-to-allocate-blocks-at-the-right-offset.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 791b7f08954869d7b8ff438f3dac3cfb39778297)

When iterating through the pages which have mapped buffer_heads, we
failed to update the b_state value. This results in allocating blocks
at logical offset 0.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1648,18 +1648,25 @@ struct mpage_da_data {
  */
 static int mpage_da_submit_io(struct mpage_da_data *mpd)
 {
-	struct address_space *mapping = mpd->inode->i_mapping;
-	int ret = 0, err, nr_pages, i;
-	unsigned long index, end;
+	long pages_skipped;
 	struct pagevec pvec;
+	unsigned long index, end;
+	int ret = 0, err, nr_pages, i;
+	struct inode *inode = mpd->inode;
+	struct address_space *mapping = inode->i_mapping;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
-	pagevec_init(&pvec, 0);
+	/*
+	 * We need to start from the first_page to the next_page - 1
+	 * to make sure we also write the mapped dirty buffer_heads.
+	 * If we look at mpd->lbh.b_blocknr we would only be looking
+	 * at the currently mapped buffer_heads.
+	 */
 	index = mpd->first_page;
 	end = mpd->next_page - 1;
 
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		/* XXX: optimize tail */
 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
@@ -1671,6 +1678,10 @@ static int mpage_da_submit_io(struct mpa
 				break;
 			index++;
 
+			BUG_ON(!PageLocked(page));
+			BUG_ON(PageWriteback(page));
+
+			pages_skipped = mpd->wbc->pages_skipped;
 			err = mapping->a_ops->writepage(page, mpd->wbc);
 			if (!err)
 				mpd->pages_written++;
@@ -1991,11 +2002,29 @@ static int __mpage_da_writepage(struct p
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
+			/*
+			 * We need to try to allocate
+			 * unmapped blocks in the same page.
+			 * Otherwise we won't make progress
+			 * with the page in ext4_da_writepage
+			 */
 			if (buffer_dirty(bh) &&
 				(!buffer_mapped(bh) || buffer_delay(bh))) {
 				mpage_add_bh_to_extent(mpd, logical, bh);
 				if (mpd->io_done)
 					return MPAGE_DA_EXTENT_TAIL;
+			} else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
+				/*
+				 * mapped dirty buffer. We need to update
+				 * the b_state because we look at
+				 * b_state in mpage_da_map_blocks. We don't
+				 * update b_size because if we find an
+				 * unmapped buffer_head later we need to
+				 * use the b_state flag of that buffer_head.
+				 */
+				if (mpd->lbh.b_size == 0)
+					mpd->lbh.b_state =
+						bh->b_state & BH_FLAGS;
 			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);

