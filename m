From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH][RFC]Ext4: Use get_cpu()/put_cpu() in preemptible context
Date: Fri, 02 Nov 2007 17:35:08 -0700
Message-ID: <1194050108.3966.18.camel@localhost.localdomain>
References: <E1Inx4A-0002PQ-00@kernel>
	 <1194044898.3966.6.camel@localhost.localdomain>
	 <472BB037.5010606@linux.vnet.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53207 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971AbXKCAfa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Nov 2007 20:35:30 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA30ZF8h006964
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 20:35:15 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA30Z5NE140814
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 20:35:15 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA30Z554016268
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 20:35:05 -0400
Received: from [9.47.17.70] (w-ming-laptop.beaverton.ibm.com [9.47.17.70])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id lA30Z5eM016239
	for <linux-ext4@vger.kernel.org>; Fri, 2 Nov 2007 20:35:05 -0400
In-Reply-To: <472BB037.5010606@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fix the warning of:

printk: 369 messages suppressed.
BUG: using smp_processor_id() in preemptible [00000001] code: fsx-linux/31702
caller is ext4_mb_new_blocks+0x2aa/0x1319

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/mballoc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc1/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/ext4/mballoc.c	2007-11-02 17:22:18.000000000 -0700
+++ linux-2.6.24-rc1/fs/ext4/mballoc.c	2007-11-02 17:23:02.000000000 -0700
@@ -4006,7 +4006,8 @@ static void ext4_mb_group_or_file(struct
 		return;
 
 	BUG_ON(ac->ac_lg != NULL);
-	ac->ac_lg = &sbi->s_locality_groups[smp_processor_id()];
+	ac->ac_lg = &sbi->s_locality_groups[get_cpu()];
+	put_cpu();
 
 	/* we're going to use group allocation */
 	ac->ac_flags |= EXT4_MB_HINT_GROUP_ALLOC;
