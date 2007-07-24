From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Date: Mon, 23 Jul 2007 18:17:01 -0700
Message-ID: <20070723181701.c5551449.akpm@linux-foundation.org>
References: <20070721210005.000228000@chello.nl>
	<20070722023923.GA6438@mail.ustc.edu.cn>
	<20070722024428.GA724@redhat.com>
	<20070722081010.GA6317@mail.ustc.edu.cn>
	<1185093236.6344.87.camel@localhost.localdomain>
	<46A46E4B.7050007@yahoo.com.au>
	<385201377.00678@ustc.edu.cn>
	<20070723124009.5fcf4fef.akpm@linux-foundation.org>
	<385238729.01475@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
	Kyle McMartin <kyle@parisc-linux.org>,
	Dave Jones <davej@codemonkey.org.uk>,
	Dave Airlie <airlied@linux.ie>
To: Fengguang Wu <fengguang.wu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34669 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760519AbXGXBSo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Jul 2007 21:18:44 -0400
In-Reply-To: <385238729.01475@ustc.edu.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 24 Jul 2007 08:47:28 +0800
Fengguang Wu <fengguang.wu@gmail.com> wrote:

> Subject: convert ill defined log2() to ilog2()
> 
> It's *wrong* to have
> 			#define log2(n) ffz(~(n))
> It should be *reversed*:
> 			#define log2(n) flz(~(n))
> or
> 			#define log2(n) fls(n)
> or just use
> 			ilog2(n) defined in linux/log2.h.
> 
> This patch follows the last solution, recommended by Andrew Morton.
> 
> //Or are they simply the wrong naming, and is in fact correct in behavior?
> 
> Cc: linux-ext4@vger.kernel.org
> Cc: Mingming Cao <cmm@us.ibm.com>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Cc: Chris Ahna <christopher.j.ahna@intel.com>
> Cc: David Mosberger-Tang <davidm@hpl.hp.com>
> Cc: Kyle McMartin <kyle@parisc-linux.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
> ---
>  drivers/char/agp/hp-agp.c     |    9 +++------
>  drivers/char/agp/i460-agp.c   |    5 ++---
>  drivers/char/agp/parisc-agp.c |    7 ++-----
>  fs/ext4/super.c               |    6 ++----
>  4 files changed, 9 insertions(+), 18 deletions(-)

hm, yes, there is a risk that the code was accidentally correct.  Or the
code has only ever dealt with power-of-2 inputs, in which case it happens
to work either way.

David(s) and ext4-people: could we please have a close review of these
changes?

Thanks.

> --- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/hp-agp.c
> +++ linux-2.6.22-rc6-mm1/drivers/char/agp/hp-agp.c
> @@ -14,15 +14,12 @@
>  #include <linux/pci.h>
>  #include <linux/init.h>
>  #include <linux/agp_backend.h>
> +#include <linux/log2.h>
>  
>  #include <asm/acpi-ext.h>
>  
>  #include "agp.h"
>  
> -#ifndef log2
> -#define log2(x)		ffz(~(x))
> -#endif
> -
>  #define HP_ZX1_IOC_OFFSET	0x1000  /* ACPI reports SBA, we want IOC */
>  
>  /* HP ZX1 IOC registers */
> @@ -256,7 +253,7 @@ hp_zx1_configure (void)
>  		readl(hp->ioc_regs+HP_ZX1_IMASK);
>  		writel(hp->iova_base|1, hp->ioc_regs+HP_ZX1_IBASE);
>  		readl(hp->ioc_regs+HP_ZX1_IBASE);
> -		writel(hp->iova_base|log2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
> +		writel(hp->iova_base|ilog2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
>  		readl(hp->ioc_regs+HP_ZX1_PCOM);
>  	}
>  
> @@ -284,7 +281,7 @@ hp_zx1_tlbflush (struct agp_memory *mem)
>  {
>  	struct _hp_private *hp = &hp_private;
>  
> -	writeq(hp->gart_base | log2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
> +	writeq(hp->gart_base | ilog2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
>  	readq(hp->ioc_regs+HP_ZX1_PCOM);
>  }
>  
> --- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/i460-agp.c
> +++ linux-2.6.22-rc6-mm1/drivers/char/agp/i460-agp.c
> @@ -13,6 +13,7 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/agp_backend.h>
> +#include <linux/log2.h>
>  
>  #include "agp.h"
>  
> @@ -59,8 +60,6 @@
>   */
>  #define WR_FLUSH_GATT(index)	RD_GATT(index)
>  
> -#define log2(x)			ffz(~(x))
> -
>  static struct {
>  	void *gatt;				/* ioremap'd GATT area */
>  
> @@ -148,7 +147,7 @@ static int i460_fetch_size (void)
>  		 * values[i].size.
>  		 */
>  		values[i].num_entries = (values[i].size << 8) >> (I460_IO_PAGE_SHIFT - 12);
> -		values[i].page_order = log2((sizeof(u32)*values[i].num_entries) >> PAGE_SHIFT);
> +		values[i].page_order = ilog2((sizeof(u32)*values[i].num_entries) >> PAGE_SHIFT);
>  	}
>  
>  	for (i = 0; i < agp_bridge->driver->num_aperture_sizes; i++) {
> --- linux-2.6.22-rc6-mm1.orig/drivers/char/agp/parisc-agp.c
> +++ linux-2.6.22-rc6-mm1/drivers/char/agp/parisc-agp.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/klist.h>
>  #include <linux/agp_backend.h>
> +#include <linux/log2.h>
>  
>  #include <asm-parisc/parisc-device.h>
>  #include <asm-parisc/ropes.h>
> @@ -27,10 +28,6 @@
>  #define DRVNAME	"quicksilver"
>  #define DRVPFX	DRVNAME ": "
>  
> -#ifndef log2
> -#define log2(x)		ffz(~(x))
> -#endif
> -
>  #define AGP8X_MODE_BIT		3
>  #define AGP8X_MODE		(1 << AGP8X_MODE_BIT)
>  
> @@ -92,7 +89,7 @@ parisc_agp_tlbflush(struct agp_memory *m
>  {
>  	struct _parisc_agp_info *info = &parisc_agp_info;
>  
> -	writeq(info->gart_base | log2(info->gart_size), info->ioc_regs+IOC_PCOM);
> +	writeq(info->gart_base | ilog2(info->gart_size), info->ioc_regs+IOC_PCOM);
>  	readq(info->ioc_regs+IOC_PCOM);	/* flush */
>  }
>  
> --- linux-2.6.22-rc6-mm1.orig/fs/ext4/super.c
> +++ linux-2.6.22-rc6-mm1/fs/ext4/super.c
> @@ -1433,8 +1433,6 @@ static void ext4_orphan_cleanup (struct 
>  	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
>  }
>  
> -#define log2(n) ffz(~(n))
> -
>  /*
>   * Maximal file size.  There is a direct, and {,double-,triple-}indirect
>   * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
> @@ -1706,8 +1704,8 @@ static int ext4_fill_super (struct super
>  	sbi->s_desc_per_block = blocksize / EXT4_DESC_SIZE(sb);
>  	sbi->s_sbh = bh;
>  	sbi->s_mount_state = le16_to_cpu(es->s_state);
> -	sbi->s_addr_per_block_bits = log2(EXT4_ADDR_PER_BLOCK(sb));
> -	sbi->s_desc_per_block_bits = log2(EXT4_DESC_PER_BLOCK(sb));
> +	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
> +	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
>  	for (i=0; i < 4; i++)
>  		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
>  	sbi->s_def_hash_version = es->s_def_hash_version;
