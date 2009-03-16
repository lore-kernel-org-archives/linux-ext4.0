From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V3] fix bb_prealloc_list corruption due to wrong group
 locking
Date: Mon, 16 Mar 2009 12:48:16 -0500
Message-ID: <49BE90E0.3090309@redhat.com>
References: <49BAD6D9.3010505@redhat.com> <49BE82A9.4000407@redhat.com>	 <49BE8C30.5030901@redhat.com> <1237225369.3964.4.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbZCPRsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 13:48:32 -0400
In-Reply-To: <1237225369.3964.4.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Frank Mayhar wrote:
> On Mon, 2009-03-16 at 12:28 -0500, Eric Sandeen wrote:
>> This is for Red Hat bug 490026,
>> EXT4 panic, list corruption in ext4_mb_new_inode_pa
>>
>> ext4_lock_group(sb, group) is supposed to protect this list for
>> each group, and a common code flow to remove an album is like
>> this:
>>
>>     ext4_get_group_no_and_offset(sb, pa->pa_pstart, &grp, NULL);
>>     ext4_lock_group(sb, grp);
>>     list_del(&pa->pa_group_list);
>>     ext4_unlock_group(sb, grp);
>>
>> so it's critical that we get the right group number back for
>> this prealloc context, to lock the right group (the one 
>> associated with this pa) and prevent concurrent list manipulation.
> 
> Eric, this may just be coincidence, but is it possible that this may be
> related to our bitmap problem I described last week?  We haven't tracked
> it down yet but it certainly smells like a race and your fix corrects
> just such a race in the same code.
> 
> The bitmap problem, btw, involves stuff apparently being marked as used
> when it's really free (or something very much like that), ultimately
> resulting in double frees.

Hi Frank - I don't *think* so just because deleted items are poisoned
and I would expect that we'd trip over a bad pointer in the corrupted
list item as the first indicator of trouble... but I could be wrong.

I think you said you could reproduce it, right?  So certainly worth
testing with this fix I suppose.

Thanks,
-Eric
