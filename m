From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] m68k: Export needed symbol for ZERO_PAGE usage in modules.
Date: Mon, 24 Mar 2008 23:32:21 +0530
Message-ID: <1206381741-12639-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, akpm@linux-foundation.org, geert@linux-m68k.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59855 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389AbYCXSCZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Mar 2008 14:02:25 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2OI2NSd007679
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 23:32:23 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2OI2NQ8958558
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 23:32:23 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2OI2Tqe018403
	for <linux-ext4@vger.kernel.org>; Mon, 24 Mar 2008 18:02:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 use ZERO_PAGE(0) to zero out blocks. We need to export
different symbols in different arch for the usage of ZERO_PAGE
in modules.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 arch/m68k/mm/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
-- 
1.5.5.rc0.16.g02b00.dirty

