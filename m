From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: quota reservation fixes for -stable?
Date: Mon, 19 Apr 2010 17:56:58 -0500
Message-ID: <4BCCDFBA.4080701@redhat.com>
References: <4BB36BEC.2000207@redhat.com> <20100401082334.GD3322@quack.suse.cz> <4BC8CA8F.1030708@redhat.com> <20100419225209.GK5439@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab0DSW5F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 18:57:05 -0400
In-Reply-To: <20100419225209.GK5439@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
> On Fri 16-04-10 15:37:35, Eric Sandeen wrote:
>> On 04/01/2010 03:23 AM, Jan Kara wrote:
>>
>>>   Ah, I'm testing quotas on non-root fs so I was wondering how come people
>>> hit the warning so often. Now I understand :) For root filesystem on ext4
>>> we don't have a chance to not see this warning. That being said the warning
>>> is pretty useless for ordinary users so I guess we should just hide it
>>> behind #ifdef __DQUOT_PARANOIA and use it for debugging purposes only.
>>>   If noone objects soon, I'll do the change.
>>>
>>> 								Honza
>> Hm, I see this in your tree now, but isn't __DQUOT_PARANOIA defined by
>> default anyway?
>   Ah, good point. Thanks for spotting this. I guess the attached cleanup is
> long overdue... Will push it too Linus this week and then to stable if
> noone objects.
> 
> 								Honza
> 
> 

looks great to me, thanks!

-Eric
