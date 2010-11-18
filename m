From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Wed, 17 Nov 2010 21:18:13 -0600
Message-ID: <4CE49AF5.1080104@redhat.com>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz> <4CE35A6D.2040906@redhat.com> <20101117043845.GA3586@amd> <4CE362B0.6040607@redhat.com> <20101117061057.GA3989@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0KRDS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 22:18:29 -0500
In-Reply-To: <20101117061057.GA3989@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/17/10 12:10 AM, Nick Piggin wrote:
> On Tue, Nov 16, 2010 at 11:05:52PM -0600, Eric Sandeen wrote:
>> On 11/16/10 10:38 PM, Nick Piggin wrote:
>>>> as for the locking problems ... sorry about that!
>>>
>>> That's no problem. So is that an ack? :)
>>>
>>
>> I'd like to test it with the original case it was supposed to solve; will
>> do that tomorrow.
> 
> OK, but it shouldn't make much difference, unless there is a lot of
> strange activity happening on the sb (like mount / umount / remount /
> freeze / etc).
> 

Ok, good point.  And since I failed in my promise anyway, I won't
hold you up;

Acked-by: Eric Sandeen <sandeen@redhat.com>

Thanks,
-Eric
