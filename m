From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] arm: Export needed symbol for ZERO_PAGE usage in modules.
Date: Mon, 24 Mar 2008 23:31:29 +0530
Message-ID: <1206381689-12600-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org, rmk@arm.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:49354 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYCXSBd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 14:01:33 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2OI1Ve3031711
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 23:31:31 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OI1Vfv1216538
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 23:31:31 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2OI1UU8030409
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 18:01:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
different symbols in different arch for the usage of ZERO_PAGE
in modules.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/arm/mm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
-- 
1.5.5.rc0.16.g02b00.dirty

