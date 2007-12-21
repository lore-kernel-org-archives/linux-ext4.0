From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Subject: [PATCH] Fix dirty page accounting leak with ext3 data=journal
Date: Fri, 21 Dec 2007 21:42:13 +0100
Message-ID: <20071221204213.GA32138@atjola.homenet>
References: <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl> <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org> <20071220141217.GA4745@atjola.homenet> <alpine.LFD.0.9999.0712200753040.21557@woody.linux-foundation.org> <20071220222816.GB4745@atjola.homenet> <Pine.LNX.4.64.0712212049001.24477@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
	bugme-daemon@bugzilla.kernel.org, sct@redhat.com,
	adilget@clusterfs.com, linux-ext4@vger.kernel.org
To: Krzysztof Oledzki <olel@ans.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753233AbXLUUmT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2007 15:42:19 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712212049001.24477@bizon.gios.gov.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In 46d2277c796f9f4937bfa668c40b2e3f43e93dd0, try_to_free_buffers was
changed to bail out if the page was dirty. That caused
truncate_complete_page to leak massive amounts of memory, because the
dirty bit was only cleared after the call to try_to_free_buffers. So th=
e
call to cancel_dirty_page was moved up to have the dirty bit cleared
early in 3e67c0987d7567ad666641164a153dca9a43b11d.

The problem with that fix is, that the page can be redirtied after
cancel_dirty_page was called, eg. like this:

truncate_complete_page()
  cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
  do_invalidatepage()
    ext3_invalidatepage()
      journal_invalidatepage()
        journal_unmap_buffer()
          __dispose_buffer()
            __journal_unfile_buffer()
              __journal_temp_unlink_buffer()
                mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

And then we end up with dirty pages being wrongly accounted.

In ecdfc9787fe527491baefc22dce8b2dbd5b2908d the changes to
try_to_free_buffers were reverted, so the original reason for the
massive memory leak is gone, so we can also revert the move of
the call to cancel_dirty_page from truncate_complete_page and get the
accounting right again.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

---
I'm not sure if it matters, but opposed to the final check in
__remove_from_page_cache, this one also cares about the task io
accounting, so maybe we want to use this instead, although it's not
quite the clean fix either.

diff --git a/mm/truncate.c b/mm/truncate.c
index cadc156..2974903 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -98,11 +98,11 @@ truncate_complete_page(struct address_space *mappin=
g, struct page *page)
 	if (page->mapping !=3D mapping)
 		return;
=20
-	cancel_dirty_page(page, PAGE_CACHE_SIZE);
-
 	if (PagePrivate(page))
 		do_invalidatepage(page, 0);
=20
+	cancel_dirty_page(page, PAGE_CACHE_SIZE);
+
 	remove_from_page_cache(page);
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
