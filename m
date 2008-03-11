From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Export needed symbol for ZERO_PAGE usage in modules.
Date: Tue, 11 Mar 2008 11:16:32 +0530
Message-ID: <1205214392-8236-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:44986 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756442AbYCKFqd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 01:46:33 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2B5kVl6029991
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:16:31 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2B5kVoW1106082
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 11:16:31 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2B5kVl7008602
	for <linux-ext4@vger.kernel.org>; Tue, 11 Mar 2008 05:46:31 GMT
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
index aa9ff35..97dab6e 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -189,3 +189,5 @@ EXPORT_SYMBOL(intercept_table);
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
1.5.4.4.481.g5075.dirty

