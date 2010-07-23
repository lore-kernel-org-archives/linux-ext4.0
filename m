From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Ext4: batched discard support - simplified version
Date: Fri, 23 Jul 2010 11:13:52 -0400
Message-ID: <x49hbjqjknj.fsf@segfault.boston.devel.redhat.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
	<20100723143604.GF13090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	rwheeler@redhat.com, linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759510Ab0GWPN4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 11:13:56 -0400
In-Reply-To: <20100723143604.GF13090@thunk.org> (Ted Ts'o's message of "Fri,
	23 Jul 2010 10:36:04 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Ted Ts'o" <tytso@mit.edu> writes:

> On Wed, Jul 07, 2010 at 09:53:30AM +0200, Lukas Czerner wrote:
>> 
>> Hi all,
>> 
>> since my last post I have done some more testing with various SSD's and the
>> trend is clear. Trim performance is getting better and the performance loss
>> without trim is getting lower. So I have decided to abandon the initial idea
>> to track free blocks within some internal data structure - it takes time and
>> memory.
>
> Do you have some numbers about how bad trim actually might be on
> various devices?

I'll let Lukas answer that when he gets back to the office next week.
The performance of the trim command itself varies by vendor, of course.

> I can imagine some devices where it might be better (for wear
> levelling and better write endurance if nothing else) where it's
> better to do the trim right away instead of batching things.

I don't think so.  In all of the configurations tested, I'm pretty sure
we saw a performance hit from doing the TRIMs right away.  The queue
flush really hurts.  Of course, I have no idea what you had in mind for
the amount of time in between batched discards.

> So what I'm thinking about doing is keeping the "discard" mount option
> to mean non-batched discard.  If you want to use the explicit FITRIM
> ioctl, I don't think we need to test to see if the dicard mount option
> is set; if the user issues the ioctl, then we should do the batched
> discard, and if we don't trust the user to do that, then well, the
> ioctl should be restricted to privileged users only --- especially if
> it could take up to a minute.

That sounds reasonable to me.

Cheers,
Jeff
