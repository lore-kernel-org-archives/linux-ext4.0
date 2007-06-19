From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4-block-reservation.patch
Date: Tue, 19 Jun 2007 22:46:48 +0530
Message-ID: <46780F80.8030003@linux.vnet.ibm.com>
References: <4677B00A.3010600@linux.vnet.ibm.com> <4677F0B3.4050805@redhat.com> <46780D76.9040706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030706010505040203010709"
Cc: Eric Sandeen <sandeen@redhat.com>, alex@clusterfs.com,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:54190 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811AbXFSRQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 13:16:55 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5JHI0SJ6664352
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:18:00 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5JHKOMR203934
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:20:24 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5JHGqva019823
	for <linux-ext4@vger.kernel.org>; Wed, 20 Jun 2007 03:16:52 +1000
In-Reply-To: <46780D76.9040706@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------030706010505040203010709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Aneesh Kumar K.V wrote:
> 
> 
> Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>> Hi,
>>>
>>> In block reservation code while rebalancing the free blocks why are 
>>> we not looking at the reservation slots that have no free blocks 
>>> left.  Rebalancing
>>> the free blocks equally across all the reservation slots will make sure
>>> we have less chances of failure later when we try to reserve blocks.
>>>
>>> I understand that we consider the CPU slot on which reservation 
>>> failed while
>>> rebalancing. But what is preventing considering other CPU slot that 
>>> might have
>>> zero blocks left ?
>>>
>>>
>>>
>>>
>>> +void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, 
>>> __u64 free)
>>> +{
>>> +       int i, used_slots = 0;
>>> +       __u64 chunk;
>>> +
>>> +       /* let's know what slots have been used */
>>> +       for (i = 0; i < NR_CPUS; i++)
>>
>> BTW... I think you really want:
>>
>>   +       for_each_possible_cpu(i) {
>>
>> in this and other similar places.
>>
>> NR_CPUS is a config-time option that may be much more than your actual
>> count of runtime possible CPUs... on ia64 it's 512 by default, for
>> example.  That's a lot of pointlessness on a 2, 4 or 8 cpu box :)
>>
>> I can whip up a proper patch for current code to send (again)...
>>
> 
> This is what i have modified. I am yet to build test it. I am looking at 
> forward porting the
> mballoc patches and was planning to send it together.
> 

I build tested the patch. I guess we need the below small patch on top of the previous
patch.


-aneesh

--------------030706010505040203010709
Content-Type: text/plain;
 name="k"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="k"

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index ad3f57c..df6b83c 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1981,7 +1981,7 @@ int ext4_reserve_init(struct super_block *sb)
 	struct ext4_reservation_slot *rs;
 	int i;
 
-	rs = percpu_alloc(sizeof(struct ext4_reservation_slot), GFP_KERNEL);
+	rs = alloc_percpu(struct ext4_reservation_slot);
 	if (rs == NULL)
 		return -ENOMEM;
 	sbi->s_reservation_slots = rs;

--------------030706010505040203010709--
