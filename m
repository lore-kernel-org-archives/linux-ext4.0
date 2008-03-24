From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Export needed symbol for ZERO_PAGE usage in modules.
Date: Mon, 24 Mar 2008 22:34:57 +0530
Message-ID: <1206378298-10341-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1206378298-10341-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1206378298-10341-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:35350 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYCXRFP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 13:05:15 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2OH4eYD026590
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:04:40 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OH8tGc267878
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:08:55 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OH57Wt002171
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 04:05:08 +1100
In-Reply-To: <1206378298-10341-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
different symbols in different arch for the usage of ZERO_PAGE
in modules.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/arm/mm/mmu.c               |    1 +
 arch/m68k/mm/init.c             |    1 +
 arch/powerpc/kernel/ppc_ksyms.c |    2 ++
 arch/sparc/kernel/sparc_ksyms.c |    2 ++
 arch/sparc64/mm/init.c          |    1 +
 5 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index d41a75e..2d6d682 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -35,6 +35,7 @@ extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
  * zero-initialized data and COW.
  */
 struct page *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
 
 /*
  * The pmd table for the upper-most set of pages.
diff --git a/arch/m68k/mm/init.c b/arch/m68k/mm/init.c
index f42caa7..ee27ed2 100644
--- a/arch/m68k/mm/init.c
+++ b/arch/m68k/mm/init.c
@@ -69,6 +69,7 @@ void __init m68k_setup_node(int node)
  */
 
 void *empty_zero_page;
+EXPORT_SYMBOL(empty_zero_page);
 
 void show_mem(void)
 {
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index 9c98424..93fb09a 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -192,3 +192,5 @@ EXPORT_SYMBOL(intercept_table);
 EXPORT_SYMBOL(__mtdcr);
 EXPORT_SYMBOL(__mfdcr);
 #endif
+
+EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index c1025e5..e902846 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -295,3 +295,5 @@ EXPORT_SYMBOL(do_BUG);
 
 /* Sun Power Management Idle Handler */
 EXPORT_SYMBOL(pm_idle);
+
+EXPORT_SYMBOL(empty_zero_page);
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
index b5c3041..2d15f92 100644
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -159,6 +159,7 @@ extern unsigned int sparc_ramdisk_image;
 extern unsigned int sparc_ramdisk_size;
 
 struct page *mem_map_zero __read_mostly;
+EXPORT_SYMBOL(mem_map_zero);
 
 unsigned int sparc64_highest_unlocked_tlb_ent __read_mostly;
 
-- 
1.5.5.rc0.16.g02b00.dirty

