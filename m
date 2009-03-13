From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] fix bb_prealloc_list corruption due to wrong group locking
Date: Fri, 13 Mar 2009 17:20:19 -0500
Message-ID: <49BADC23.3060605@redhat.com>
References: <49BAD6D9.3010505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZCMWUb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2009 18:20:31 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n2DMKREU009972
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 18:20:27 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2DMKRui009897
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 18:20:27 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n2DMKQGO008716
	for <linux-ext4@vger.kernel.org>; Fri, 13 Mar 2009 18:20:27 -0400
In-Reply-To: <49BAD6D9.3010505@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> This is for Red Hat bug 490026,
> EXT4 panic, list corruption in ext4_mb_new_inode_pa
> 
> (this was on backported ext4 from 2.6.29)
> 
> We hit a BUG() in __list_add from  ext4_mb_new_inode_pa()
> because the list head pointed to a removed item:
> 
> list_add corruption. next->prev should be ffff81042f2fe158,
> but was 0000000000200200
> 
> (0000000000200200 is LIST_POISON2, set when the item is deleted)
> 
> ext4_lock_group(sb, group) is supposed to protect this list for
> each group, and a common code flow is this:
> 
>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>     ext4_lock_group(sb, grp);
>     list_del(&pa->pa_group_list);
>     ext4_unlock_group(sb, grp);
> 
> so its critical that we get the right group number back for
> this pa->pa_pstart block.
> 
> however, ext4_mb_put_pa passes in (pa->pa_pstart - 1) with a 
> comment, "-1 is to protect from crossing allocation group"
> 
> Other list-manipulators do not use the "-1" so we have the 
> potential to lock the wrong group and race.  Given how the 
> ext4_get_group_no_and_offset() function works, it doesn't seem
> to me that the subtraction is correct.

Hm, unless pa_pstart gets advanced to the point where it's in the next
group when it's used up...  might be more reading to do here.

-Eric
