From: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Date: Sun, 20 May 2007 11:09:04 +0800
Message-ID: <379630538.31710@ustc.edu.cn>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355695.83536@ustc.edu.cn> <20070518232824.9917d794.akpm@linux-foundation.org> <379577826.15160@ustc.edu.cn> <20070519082504.8baa8d19.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:52428 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759098AbXETDJF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 May 2007 23:09:05 -0400
Message-ID: <20070520030904.GA9176@mail.ustc.edu.cn>
Content-Disposition: inline
In-Reply-To: <20070519082504.8baa8d19.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, May 19, 2007 at 08:25:04AM -0700, Andrew Morton wrote:
> On Sat, 19 May 2007 20:30:31 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > On Fri, May 18, 2007 at 11:28:24PM -0700, Andrew Morton wrote:
> > > On Thu, 17 May 2007 06:47:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > > 
> > > > Introduce a new page flag: PG_readahead.
> > > 
> > > Is there any way in which we can avoid adding a new page flag?
> > > 
> > > We have the advantage that if the kernel very occasionally gets the wrong
> > > result for PageReadahead(page), nothing particularly bad will happen, so we
> > > can do racy things.
> > > 
> > > >From a quick peek, it appears that PG_readahead is only ever set against
> > > non-uptodate pages.  If true we could perhaps exploit that: say,
> > > PageReadahead(page) == PG_referenced && !PG_uptodate?
> > 
> > PG_uptodate will flip to 1 before the reader touches the page :(
> 
> OK.
> 
> > However, it may be possible to share the same bit with PG_reclaim or PG_booked.
> > Which one would be preferred?
> 
> I'd like PG_booked to go away too - I don't think we've put that under the
> microscope yet.  If it remains then its scope will be "defined by the
> filesystem", so readahead shouldn't use it.  PG_reclaim belongs to core VFS
> so that's much better.
> 
> Let's not do anything ugly, slow or silly in there, but please do take a
> look, see if there is an opportunity here.

The reuse code would look like the attached one.
It still needs more testing, and would fail if Christoph reuses
PG_reclaim in higher order pagecache in the future.

Fengguang Wu
---

Subject: mm: share PG_readahead and PG_reclaim

Share the same page flag bit for PG_readahead and PG_reclaim.

One is used only on file reads, another is only for emergency writes.
One is used mostly for fresh/young pages, another is for old pages.

Combinations of possible interactions are:

a) clear PG_reclaim => implicit clear of PG_readahead
	it will delay an asynchronous readahead into a synchronous one
	it actually does _good_ for readahead:
		the pages will be reclaimed soon, it's readahead thrashing!
		in this case, synchronous readahead makes more sense.

b) clear PG_readahead => implicit clear of PG_reclaim
	one(and only one) page will not be reclaimed in time
	it can be avoided by checking PageWriteback(page) in readahead first

c) set PG_reclaim => implicit set of PG_readahead
	will confuse readahead and make it restart the size rampup process
	it's a trivial problem, and can mostly be avoided by checking
	PageWriteback(page) first in readahead

d) set PG_readahead => implicit set of PG_reclaim
	PG_readahead will never be set on already cached pages.
	PG_reclaim will always be cleared on dirtying a page.
	so not a problem.

In summary,
	a)   we get better behavior
	b,d) possible interactions can be avoided
	c)   racy condition exists that might affect readahead, but the chance
	     is _really_ low, and the hurt on readahead is trivial.

Compound pages also use PG_reclaim, but for now they do not interact with
reclaim/readahead code.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/page-flags.h |    4 +++-
 mm/page-writeback.c        |    1 +
 mm/readahead.c             |    4 ++++
 3 files changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc1-mm1.orig/include/linux/page-flags.h
+++ linux-2.6.22-rc1-mm1/include/linux/page-flags.h
@@ -92,7 +92,9 @@
 #define PG_lazyfree		20	/* MADV_FREE potential throwaway */
 
 #define PG_booked		21	/* Has blocks reserved on-disk */
-#define PG_readahead		22	/* Reminder to do async read-ahead */
+
+/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
+#define PG_readahead		PG_reclaim	/* Reminder to do async read-ahead */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
 #define PG_checked		PG_owner_priv_1 /* Used by some filesystems */
--- linux-2.6.22-rc1-mm1.orig/mm/page-writeback.c
+++ linux-2.6.22-rc1-mm1/mm/page-writeback.c
@@ -922,6 +922,7 @@ int clear_page_dirty_for_io(struct page 
 
 	BUG_ON(!PageLocked(page));
 
+	ClearPageReclaim(page);
 	if (mapping && mapping_cap_account_dirty(mapping)) {
 		/*
 		 * Yes, Virginia, this is indeed insane.
--- linux-2.6.22-rc1-mm1.orig/mm/readahead.c
+++ linux-2.6.22-rc1-mm1/mm/readahead.c
@@ -447,6 +447,10 @@ page_cache_readahead_ondemand(struct add
 	if (!ra->ra_pages)
 		return 0;
 
+	/* It's PG_reclaim! */
+	if (PageWriteback(page))
+		return 0;
+
 	if (page) {
 		ClearPageReadahead(page);
 
