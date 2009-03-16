From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix bb_prealloc_list corruption due to wrong group	locking
Date: Mon, 16 Mar 2009 10:03:49 -0500
Message-ID: <49BE6A55.9040406@redhat.com>
References: <49BAD6D9.3010505@redhat.com> <20090316054427.GA17376@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46043 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbZCPPEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 11:04:02 -0400
In-Reply-To: <20090316054427.GA17376@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Mar 13, 2009 at 04:57:45PM -0500, Eric Sandeen wrote:
>> This is for Red Hat bug 490026,
>> EXT4 panic, list corruption in ext4_mb_new_inode_pa
>>
>> (this was on backported ext4 from 2.6.29)
>>
>> We hit a BUG() in __list_add from  ext4_mb_new_inode_pa()
>> because the list head pointed to a removed item:
>>
>> list_add corruption. next->prev should be ffff81042f2fe158,
>> but was 0000000000200200
>>
>> (0000000000200200 is LIST_POISON2, set when the item is deleted)
>>
>> ext4_lock_group(sb, group) is supposed to protect this list for
>> each group, and a common code flow is this:
>>
>>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>>     ext4_lock_group(sb, grp);
>>     list_del(&pa->pa_group_list);
>>     ext4_unlock_group(sb, grp);
>>
>> so its critical that we get the right group number back for
>> this pa->pa_pstart block.
>>
>> however, ext4_mb_put_pa passes in (pa->pa_pstart - 1) with a 
>> comment, "-1 is to protect from crossing allocation group"
>>
>> Other list-manipulators do not use the "-1" so we have the 
>> potential to lock the wrong group and race.  Given how the 
>> ext4_get_group_no_and_offset() function works, it doesn't seem
>> to me that the subtraction is correct.
>>
>> I've not been able to reproduce the bug, so this is by inspection.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> Index: linux-2.6/fs/ext4/mballoc.c
>> ===================================================================
>> --- linux-2.6.orig/fs/ext4/mballoc.c
>> +++ linux-2.6/fs/ext4/mballoc.c
>> @@ -3603,8 +3603,7 @@ static void ext4_mb_put_pa(struct ext4_a
>>  	pa->pa_deleted = 1;
>>  	spin_unlock(&pa->pa_lock);
>>
>> -	/* -1 is to protect from crossing allocation group */
>> -	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
>> +	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>>
>>  	/*
>>  	 * possible race:
>>
> 
> 
> But the change is needed for lg prealloc space because locality group
> prealloc reduce pa_pstart on block allocation and once fully allocated
> pa_pstart can point to the next block group. 

Right, that's what I followed up with Friday, missed it the first go-round.

> But what you found is also
> correct for inode prealloc space. I guess the code broke due to FLEX_BG
> because without FLEX_BG pa_pstart will never be the first block in the
> group so even for inode prealloc space pa_pstart - 1 would be in the
> same group. 

Hm, so for inode it's initialized as:

pa->pa_pstart = ext4_grp_offs_to_block(sb, &ac->ac_b_ex);
regardless of flex?  well, anyway...

You may want to do

<aneesh's patch moving the grp calculation>

The only thing I don't like about that is we're calculating grp a lot
when we don't actually need it.  How about just:

Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c
+++ linux-2.6/fs/ext4/mballoc.c
@@ -3603,8 +3603,11 @@ static void ext4_mb_put_pa(struct ext4_a
 	pa->pa_deleted = 1;
 	spin_unlock(&pa->pa_lock);

-	/* -1 is to protect from crossing allocation group */
-	ext4_get_group_no_and_offset(sb, pa->pa_pstart - 1, &grp, NULL);
+	/* If linear, pa_pstart is in next block group when used up */
+	if (pa->pa_linear)
+		pa->pa_pstart--;
+
+	ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);

 	/*
 	 * possible race:

-Eric
