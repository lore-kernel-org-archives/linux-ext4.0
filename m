From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix bb_prealloc_list corruption due to wrong group locking
Date: Fri, 13 Mar 2009 23:41:00 -0500
Message-ID: <49BB355C.2070802@redhat.com>
References: <49BAD6D9.3010505@redhat.com> <49BADC23.3060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38197 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZCNElF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Mar 2009 00:41:05 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n2E4f21b003261
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2009 00:41:02 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2E4f2po024993
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2009 00:41:02 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n2E4f1F1012900
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2009 00:41:01 -0400
In-Reply-To: <49BADC23.3060605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Eric Sandeen wrote:
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
> 
> Hm, unless pa_pstart gets advanced to the point where it's in the next
> group when it's used up...  might be more reading to do here.

Ok I think I was on the right track here.  It looks like for group_pa
(with pa_linear == 1), pa->pa_pstart is advanced as it's used (actually
in ext4_mb_release_context(), but that's a detail) so by the time it is
used up, pa->pa_pstart has advanced into the next group* and therefore
subtracting one to find the group it belong(ed) to is correct.

However, for inode_pa (with pa_linear == 0) only pa_free is decremented,
and pa_pstart does not move.  Therefore subtracting one from pa_pstart
in ext4_mb_put_pa is actually grabbing the previous block group's lock
in the inode case, and we open a race with other threads which are
locking the correct group.

I'll do a bit more testing/reading but I think that what we probably
need is something like:

static void ext4_mb_put_pa(struct ext4_allocation_context *ac, ...)
{
...
        /* -1 is to protect from crossing allocation group */
	if (pa->pa_linear)
		pa->pa_pstart--;
        ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
...

Could probably come up with something clearer, but that's the gist of it.

-Eric


*i.e. if pa_start began at 0, and the group had 512 blocks, when all
blocks are used, pa_start has advanced by 512, and "512" is the first
block in the *next* group, so we need to trim one off in that case.
