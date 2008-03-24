From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] powerpc: Export needed symbol for ZERO_PAGE usage in modules.
Date: Mon, 24 Mar 2008 23:33:45 +0530
Message-ID: <1206381825-12701-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org, paulus@samba.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:35015 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYCXSDu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 14:03:50 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m2OI3KKA025016
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:20 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OI3m5I4382924
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:48 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m2OI3mvY024426
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 05:03:48 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
different symbols in different arch for the usage of ZERO_PAGE
in modules.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/ppc_ksyms.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
-- 
1.5.5.rc0.16.g02b00.dirty

