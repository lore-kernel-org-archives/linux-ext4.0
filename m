From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext4-block-reservation.patch
Date: Tue, 19 Jun 2007 15:59:30 +0530
Message-ID: <4677B00A.3010600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: alex@clusterfs.com, linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:46483 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173AbXFSKaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 06:30:07 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5JAV0If3239990
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 20:31:06 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JAXBmM070986
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 20:33:12 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JATcNO011861
	for <linux-ext4@vger.kernel.org>; Tue, 19 Jun 2007 20:29:39 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

In block reservation code while rebalancing the free blocks why are we not 
looking at the reservation slots that have no free blocks left.  Rebalancing
the free blocks equally across all the reservation slots will make sure
we have less chances of failure later when we try to reserve blocks. 


I understand that we consider the CPU slot on which reservation failed while
rebalancing. But what is preventing considering other CPU slot that might have
zero blocks left ?




+void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
+{
+       int i, used_slots = 0;
+       __u64 chunk;
+
+       /* let's know what slots have been used */
+       for (i = 0; i < NR_CPUS; i++)
+               if (rs[i].rs_reserved || i == smp_processor_id())
+                       used_slots++;
+
+       /* chunk is a number of block every used
+        * slot will get. make sure it isn't 0 */
+       chunk = free + used_slots - 1;
+       do_div(chunk, used_slots);
+
+       for (i = 0; i < NR_CPUS; i++) {
+               if (free < chunk)
+                       chunk = free;
+               if (rs[i].rs_reserved || i == smp_processor_id()) {
+                       rs[i].rs_reserved = chunk;
+                       free -= chunk;
+                       BUG_ON(free < 0);
+               }
+       }
+       BUG_ON(free);
+}


-aneesh
