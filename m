From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: quota reservation fixes for -stable?
Date: Thu, 01 Apr 2010 08:57:52 -0500
Message-ID: <4BB4A660.6030609@redhat.com>
References: <4BB36BEC.2000207@redhat.com> <20100401082334.GD3322@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab0DAQbE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 12:31:04 -0400
In-Reply-To: <20100401082334.GD3322@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Wed 31-03-10 10:36:12, Eric Sandeen wrote:
>> I think we should get the following commits to -stable:
>>
>> 0a5a9c725512461d19397490f3adf29931dca1f2 quota: Fix warning when a delayed write happens before quota is enabled
>> c469070aea5a0ada45a836937c776fd3083dae2b quota: manage reserved space when quota is not active [v2]
>   They are already queued for 2.6.33 and 2.6.32 stable trees. I sent
> them to Greg last week or so.

Oh, good news - sorry I missed that.

...

>> But check this out, with a modified .32 kernel with the above 2 commints,
>> and a change that reports which inodes were modified:
>>
>> VFS (sda12): inode(s) 1064 
>> VFS (sda12): Writes happened before quota was turned on thus quota information is probably inconsistent. Please run quotacheck(8).
>>
>> # find /etc -inum 1064
>> /etc/mtab
>   Ah, I'm testing quotas on non-root fs so I was wondering how come people
> hit the warning so often. Now I understand :) For root filesystem on ext4
> we don't have a chance to not see this warning. That being said the warning
> is pretty useless for ordinary users so I guess we should just hide it
> behind #ifdef __DQUOT_PARANOIA and use it for debugging purposes only.
>   If noone objects soon, I'll do the change.

Yes, I think it's better that way, otherwise we'll keep getting reports about
how they can't seem to make this warning go away.  :)

Thanks,
-Eric

> 
> 								Honza

