From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] use for_each_possible_cpu for reservation slots
Date: Tue, 27 Feb 2007 14:52:48 -0600
Message-ID: <45E49A20.5080604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXB0Uw6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Feb 2007 15:52:58 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l1RKqvcx020099
	for <linux-ext4@vger.kernel.org>; Tue, 27 Feb 2007 15:52:57 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1RKqvCZ026161
	for <linux-ext4@vger.kernel.org>; Tue, 27 Feb 2007 15:52:57 -0500
Received: from [127.0.0.1] (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l1RKqtfC016829
	for <linux-ext4@vger.kernel.org>; Tue, 27 Feb 2007 15:52:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

NR_CPUS is a config-time option that may be much more than your actual
count of runtime possible CPUs... 

compile-tested.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Index: linux-2.6-ext4/fs/ext4/balloc.c
===================================================================
--- linux-2.6-ext4.orig/fs/ext4/balloc.c
+++ linux-2.6-ext4/fs/ext4/balloc.c
@@ -1895,16 +1895,17 @@ void ext4_rebalance_reservation(struct e
 	__u64 chunk;
 
 	/* let's know what slots have been used */
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i) {
 		if (rs[i].rs_reserved || i == smp_processor_id())
 			used_slots++;
+	}
 
 	/* chunk is a number of block every used
 	 * slot will get. make sure it isn't 0 */
 	chunk = free + used_slots - 1;
 	do_div(chunk, used_slots);
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		if (free < chunk)
 			chunk = free;
 		if (rs[i].rs_reserved || i == smp_processor_id()) {
@@ -1926,7 +1927,7 @@ int ext4_reserve_global(struct super_blo
 	rs = sbi->s_reservation_slots;
 
 	/* lock all slots */
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		spin_lock(&rs[i].rs_lock);
 		free += rs[i].rs_reserved;
 	}
@@ -1937,8 +1938,9 @@ int ext4_reserve_global(struct super_blo
 		rc = 0;
 	}
 
-	for (i = 0; i < NR_CPUS; i++)
+	for_each_possible_cpu(i) {
 		spin_unlock(&rs[i].rs_lock);
+	}
 
 	return rc;
 }
@@ -1979,12 +1981,14 @@ int ext4_reserve_init(struct super_block
 	struct ext4_reservation_slot *rs;
 	int i;
 
-	rs = kmalloc(sizeof(struct ext4_reservation_slot) * NR_CPUS, GFP_KERNEL);
+	rs = kmalloc(sizeof(struct ext4_reservation_slot) * 
+			highest_possible_processor_id()+1,
+		     GFP_KERNEL);
 	if (rs == NULL)
 		return -ENOMEM;
 	sbi->s_reservation_slots = rs;
 
-	for (i = 0; i < NR_CPUS; i++) {
+	for_each_possible_cpu(i) {
 		spin_lock_init(&rs[i].rs_lock);
 		rs[i].rs_reserved = 0;
 	}
