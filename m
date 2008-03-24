From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] sparc: Export needed symbol for ZERO_PAGE usage in modules.
Date: Mon, 24 Mar 2008 23:32:57 +0530
Message-ID: <1206381777-12671-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org, davem@davemloft.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48618 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbYCXSDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 14:03:04 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2OI399H006652
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:09 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OI31Hd4559032
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:01 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OI31Me007957
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:01 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
different symbols in different arch for the usage of ZERO_PAGE
in modules.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/sparc/kernel/sparc_ksyms.c |    2 ++
 arch/sparc64/mm/init.c          |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

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

