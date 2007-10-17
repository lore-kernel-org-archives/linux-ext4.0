From: akpm@linux-foundation.org
Subject: - convert-ill-defined-log2-to-ilog2.patch removed from -mm tree
Date: Wed, 17 Oct 2007 02:55:35 -0700
Message-ID: <200710170955.l9H9tZJd014882@imap1.linux-foundation.org>
To: fengguang.wu@gmail.com, airlied@linux.ie, bjorn.helgaas@hp.com,
	christopher.j.ahna@intel.com, cmm@us.ibm.com,
	davej@codemonkey.org.uk, davidm@hpl.hp.com, kyle@parisc-linux.org,
	linux-
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51445 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757246AbXJQJ4n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Oct 2007 05:56:43 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     convert ill defined log2() to ilog2()
has been removed from the -mm tree.  Its filename was
     convert-ill-defined-log2-to-ilog2.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: convert ill defined log2() to ilog2()
From: Fengguang Wu <fengguang.wu@gmail.com>

It's *wrong* to have
			#define log2(n) ffz(~(n))
It should be *reversed*:
			#define log2(n) flz(~(n))
or
			#define log2(n) fls(n)
or just use
			ilog2(n) defined in linux/log2.h.

This patch follows the last solution, recommended by Andrew Morton.

Cc: <linux-ext4@vger.kernel.org>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Chris Ahna <christopher.j.ahna@intel.com>
Cc: David Mosberger-Tang <davidm@hpl.hp.com>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/hp-agp.c     |    9 +++------
 drivers/char/agp/i460-agp.c   |    5 ++---
 drivers/char/agp/parisc-agp.c |    7 ++-----
 fs/ext4/super.c               |    6 ++----
 4 files changed, 9 insertions(+), 18 deletions(-)

diff -puN drivers/char/agp/hp-agp.c~convert-ill-defined-log2-to-ilog2 drivers/char/agp/hp-agp.c
--- a/drivers/char/agp/hp-agp.c~convert-ill-defined-log2-to-ilog2
+++ a/drivers/char/agp/hp-agp.c
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
@@ -257,7 +254,7 @@ hp_zx1_configure (void)
 		readl(hp->ioc_regs+HP_ZX1_IMASK);
 		writel(hp->iova_base|1, hp->ioc_regs+HP_ZX1_IBASE);
 		readl(hp->ioc_regs+HP_ZX1_IBASE);
-		writel(hp->iova_base|log2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
+		writel(hp->iova_base|ilog2(HP_ZX1_IOVA_SIZE), hp->ioc_regs+HP_ZX1_PCOM);
 		readl(hp->ioc_regs+HP_ZX1_PCOM);
 	}
 
@@ -285,7 +282,7 @@ hp_zx1_tlbflush (struct agp_memory *mem)
 {
 	struct _hp_private *hp = &hp_private;
 
-	writeq(hp->gart_base | log2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
+	writeq(hp->gart_base | ilog2(hp->gart_size), hp->ioc_regs+HP_ZX1_PCOM);
 	readq(hp->ioc_regs+HP_ZX1_PCOM);
 }
 
diff -puN drivers/char/agp/i460-agp.c~convert-ill-defined-log2-to-ilog2 drivers/char/agp/i460-agp.c
--- a/drivers/char/agp/i460-agp.c~convert-ill-defined-log2-to-ilog2
+++ a/drivers/char/agp/i460-agp.c
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
diff -puN drivers/char/agp/parisc-agp.c~convert-ill-defined-log2-to-ilog2 drivers/char/agp/parisc-agp.c
--- a/drivers/char/agp/parisc-agp.c~convert-ill-defined-log2-to-ilog2
+++ a/drivers/char/agp/parisc-agp.c
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
 
diff -puN fs/ext4/super.c~convert-ill-defined-log2-to-ilog2 fs/ext4/super.c
--- a/fs/ext4/super.c~convert-ill-defined-log2-to-ilog2
+++ a/fs/ext4/super.c
@@ -1415,8 +1415,6 @@ static void ext4_orphan_cleanup (struct 
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
 
-#define log2(n) ffz(~(n))
-
 /*
  * Maximal file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (2^32 - 1) 512-byte sectors in i_blocks.
@@ -1689,8 +1687,8 @@ static int ext4_fill_super (struct super
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
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

convert-ill-defined-log2-to-ilog2.patch
