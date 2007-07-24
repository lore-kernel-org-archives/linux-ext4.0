From: Fengguang Wu <fengguang.wu@gmail.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Date: Tue, 24 Jul 2007 08:47:28 +0800
Message-ID: <385238729.01475@ustc.edu.cn>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com> <20070722081010.GA6317@mail.ustc.edu.cn> <1185093236.6344.87.camel@localhost.localdomain> <46A46E4B.7050007@yahoo.com.au> <385201377.00678@ustc.edu.cn> <20070723124009.5fcf4fef.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	riel <riel@redhat.com>, Tim Pepper <lnxninja@us.ibm.com>,
	Chris Snook <csnook@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-ext4@vger.kernel.org,
	Mingming Cao <cmm@us.ibm.com>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Chris Ahna <christopher.j.ahna@intel.com>,
	David Mosberger-Tang <davidm@hpl.hp.com>,
	Kyle McMartin <kyle@parisc-linux.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.ustc.edu.cn ([202.38.64.16]:45447 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756615AbXGXA7A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 20:59:00 -0400
Message-ID: <20070724004728.GA8026@mail.ustc.edu.cn>
Content-Disposition: inline
In-Reply-To: <20070723124009.5fcf4fef.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 23, 2007 at 12:40:09PM -0700, Andrew Morton wrote:
> On Mon, 23 Jul 2007 22:24:57 +0800
> Fengguang Wu <fengguang.wu@gmail.com> wrote:
> 
> > On Mon, Jul 23, 2007 at 07:00:59PM +1000, Nick Piggin wrote:
> > > Rusty Russell wrote:
> > > >On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> > > 
> > > >>So I opt for it being made tunable, safe, and turned off by default.
> > > 
> > > I hate tunables :) Unless we have workload A that gets a reasonable
> > > benefit from something and workload B that gets a significant regression,
> > > and no clear way to reconcile them...
> > 
> > Me too ;)
> > 
> > But sometimes we really want to avoid flushing the cache.
> > Andrew's user space LD_PRELOAD+fadvise based tool fit nicely here.
> 
> It's the only way to go in some situations.  Sometimes the kernel just
> cannot predict the future sufficiently well, and the costs of making a
> mistake are terribly high.  We need human help.  And it should be
> administration-time help, not programming-time help.

Agreed. I feel that drop behind is not a universal applicable.
Cost based reclaim sounds better, but who knows before field use ;)

> > > >I'd like to see it turned on by default in -mm, and try to come up with
> > > >some server-like workload to measure the effect.  Should be easy to
> > > >simulate something (eg. apache server, where clients grab some files in
> > > >preference, and apache server where clients grab different files).
> > > 
> > > I don't like this kind of conditional information going from something
> > > like readahead into page reclaim. Unless it is for readahead _specific_
> > > data such as "I got these all wrong, so you can reclaim them" (which
> > > this isn't).
> > > 
> > > Possibly it makes sense to realise that the given pages are cheaper
> > > to read back in as they are apparently being read-ahead very nicely.
> > 
> > In fact I have talked to Jens about it in last year's kernel summit.
> > The patch below explains itself.
> > ---
> > Subject: cost based page reclaim
> > 
> > Cost based page reclaim - a minimalist implementation.
> > 
> > Suppose we cached 32 small files each with 1 page, and one 32-page chunk from a
> > large file.  Should we first drop the 32-pages which are read in one I/O, or
> > drop the 32 distinct pages, each costs one I/O? (Given that the files are of
> > equal hotness.)
> > 
> > Page replacement algorithms should be designed to minimize the number of I/Os,
> > instead of the number of page faults. Dividing the cost of I/O by the number of
> > pages it bring in, we get the cost of the page. The bigger page cost, the more
> > 'lives/bloods' the page should have.
> > 
> > This patch adds life to costly pages by pretending that they are
> > referenced more times. Possible downsides:
> > - burdens the pressure of vmscan
> > - active pages are no longer that 'active'
> > 
> 
> This is all fun stuff, but how do we find out that changes like this are
> good ones, apart from shipping it and seeing who gets hurt 12 months later?

One thing I can imagine now is that the first pages may get more life
because of the conservative initial readahead size.

Generally file servers use sendfile(wholefile), so not a problem.

> > +#define log2(n) fls(n)
> 
> <look at include/linux/log2.h>

Thank you, this comment lead to another patch :)
---
Subject: convert ill defined log2() to ilog2()

It's *wrong* to have
			#define log2(n) ffz(~(n))
It should be *reversed*:
			#define log2(n) flz(~(n))
or
			#define log2(n) fls(n)
or just use
			ilog2(n) defined in linux/log2.h.

This patch follows the last solution, recommended by Andrew Morton.

//Or are they simply the wrong naming, and is in fact correct in behavior?

Cc: linux-ext4@vger.kernel.org
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Chris Ahna <christopher.j.ahna@intel.com>
Cc: David Mosberger-Tang <davidm@hpl.hp.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 drivers/char/agp/hp-agp.c     |    9 +++------
 drivers/char/agp/i460-agp.c   |    5 ++---
 drivers/char/agp/parisc-agp.c |    7 ++-----
 fs/ext4/super.c               |    6 ++----
 4 files changed, 9 insertions(+), 18 deletions(-)

--- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/hp-agp.c
+++ linux-2.6.22-rc6-mm1/drivers/char/agp/hp-agp.c
@@ -14,15 +14,12 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/agp_backend.h>
+#include <linux/log2.h>
 
 #include <asm/acpi-ext.h>
 
 #include "agp.h"
 
-#ifndef log2
-#define log2(x)		ffz(~(x))
-#endif
-
 #define HP_ZX1_IOC_OFFSET	0x1000  /* ACPI reports SBA, we want IOC */
 
 /* HP ZX1 IOC registers */
@@ -256,7 +253,7 @@ hp_zx1_configure (void)
 		readl(hp->ioc_regs+HP_ZX1_IMASK);
 		writel(hp->iova_base|1, hp->ioc_regs+HP_ZX1_IBASE);
 		readl(hp->ioc_regs+HP_ZX1_IBASE);
-		writel(hp->iova_base|log2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
+		writel(hp->iova_base|ilog2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
 		readl(hp->ioc_regs+HP_ZX1_PCOM);
 	}
 
@@ -284,7 +281,7 @@ hp_zx1_tlbflush (struct agp_memory *mem)
 {
 	struct _hp_private *hp = &hp_private;
 
-	writeq(hp->gart_base | log2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
+	writeq(hp->gart_base | ilog2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
 	readq(hp->ioc_regs+HP_ZX1_PCOM);
 }
 
--- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/i460-agp.c
+++ linux-2.6.22-rc6-mm1/drivers/char/agp/i460-agp.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/agp_backend.h>
+#include <linux/log2.h>
 
 #include "agp.h"
 
@@ -59,8 +60,6 @@
  */
 #define WR_FLUSH_GATT(index)	RD_GATT(index)
 
-#define log2(x)			ffz(~(x))
-
 static struct {
 	void *gatt;				/* ioremap'd GATT area */
 
@@ -148,7 +147,7 @@ static int i460_fetch_size (void)
 		 * values[i].size.
 		 */
 		values[i].num_entries = (values[i].size << 8) >> (I460_IO_PAGE_SHIFT - 12);
-		values[i].page_order = log2((sizeof(u32)*values[i].num_entries) >> PAGE_SHIFT);
+		values[i].page_order = ilog2((sizeof(u32)*values[i].num_entries) >> PAGE_SHIFT);
 	}
 
 	for (i = 0; i < agp_bridge->driver->num_aperture_sizes; i++) {
--- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/parisc-agp.c
+++ linux-2.6.22-rc6-mm1/drivers/char/agp/parisc-agp.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/klist.h>
 #include <linux/agp_backend.h>
+#include <linux/log2.h>
 
 #include <asm-parisc/parisc-device.h>
 #include <asm-parisc/ropes.h>
@@ -27,10 +28,6 @@
 #define DRVNAME	"quicksilver"
 #define DRVPFX	DRVNAME ": "
 
-#ifndef log2
-#define log2(x)		ffz(~(x))
-#endif
-
 #define AGP8X_MODE_BIT		3
 #define AGP8X_MODE		(1 << AGP8X_MODE_BIT)
 
@@ -92,7 +89,7 @@ parisc_agp_tlbflush(struct agp_memory *m
 {
 	struct _parisc_agp_info *info = &parisc_agp_info;
 
-	writeq(info->gart_base | log2(info->gart_size), info->ioc_regs+IOC_PCOM);
+	writeq(info->gart_base | ilog2(info->gart_size), info->ioc_regs+IOC_PCOM);
 	readq(info->ioc_regs+IOC_PCOM);	/* flush */
 }
 
--- linux-2.6.22-rc6-mm1.orig/fs/ext4/super.c
+++ linux-2.6.22-rc6-mm1/fs/ext4/super.c
@@ -1433,8 +1433,6 @@ static void ext4_orphan_cleanup (struct 
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
 
-#define log2(n) ffz(~(n))
-
 /*
  * Maximal file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
@@ -1706,8 +1704,8 @@ static int ext4_fill_super (struct super
 	sbi->s_desc_per_block = blocksize / EXT4_DESC_SIZE(sb);
 	sbi->s_sbh = bh;
 	sbi->s_mount_state = le16_to_cpu(es->s_state);
-	sbi->s_addr_per_block_bits = log2(EXT4_ADDR_PER_BLOCK(sb));
-	sbi->s_desc_per_block_bits = log2(EXT4_DESC_PER_BLOCK(sb));
+	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
+	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 	for (i=0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
