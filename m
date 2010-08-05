From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Thu, 05 Aug 2010 10:51:22 +0400
Message-ID: <87sk2tk0wl.fsf@dmon-lap.sw.ru>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com>
	<8762zq8lxv.fsf@dmon-lap.sw.ru>
	<alpine.LFD.2.00.1008041704420.2932@localhost>
	<AANLkTikmNCLSuc--k=k4mFSGhgn82Q1n1-66SYnGJH-5@mail.gmail.com>
	<20100805002839.GD2901@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, jmoyer@redhat.com, rwheeler@redhat.com,
	eshishki@redhat.com, sandeen@redhat.com, jack@suse.cz,
	Mark Lord <kernel@teksavvy.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38793 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab0HEGva (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 02:51:30 -0400
Received: by eya25 with SMTP id 25so2245824eya.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Aug 2010 23:51:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o <tytso@mit.edu> writes:

> On Wed, Aug 04, 2010 at 11:26:56AM -0400, Greg Freemyer wrote:
>> 
>> Since the proposed patch is not aggregating discards into multiple
>> ranges per ATA command, I thought some of the non-optimized devices
>> would take minutes / hours?
>> 
>> If true, a way to control the progress from userspace is important.
>> 
>> If in general it is only going to take a few seconds for a full FITRIM
>> to run, it is much less important, but I suppose the the RT project
>> might find even that problematic.
Few second may not being true, We always have to think about crazy
user, and crazy fs-layouts.
My SSD is able to process 8*10^3 requests per second
So in worst case( where 1k fs block are bysy like this 010101010101)
it can process about 10^3/s * 2*1Kb = 16Mb/s
Which is no good.
>
> Even if it without the RT project, if disk activity is slowed or
> completely stopped for a few seconds, I can think of plenty of
> workloads where this would be totally unacceptable.  Suppose you are
> running a web site; it doesn't really matter whether it is at Google,
> Facebook, Twitter, etc.  If this means that one or more web pages get
> stalled by "a few seconds" while the FITRIM is going on, this is
> generally not considered acceptable.  Even if it slows down the server
> by 30-50%, for some sites this would also be quite unacceptable.
>
> This is a hard problem to solve, though, especially if there is an
> insistence to solve it in a fs-independent fashion.  I could imagine
> doing this at work, by doing things one block group at a time, and
> then I could measure, for our specific hardware, how badly disk
> performance would get hit, and for how long, and then the userspace
> daemon could control how many block groups to do per unit time.
> But this would be of necessity ext2/3/4 specific....
>
> So I'm not sure what to suggest here.  Maybe the answer is we can have
> a fs-independent ioctl for desktop workloads, and one which gives more
> fine-grained control for those who need it?  That seems ugly, but it
> might be the best compromise.
Why do we have to invent a wheel again?
We already have  BLKDISCARD which has following arguments:
uint64_t range[2]

So IMHO it is reasonable that FITRIM should have following arguments 
uint64_t start, uint64_t len, uint64_t minlen.
No problems with compat, no problems with interactivity.
User who does not care about interactivity may just call
ioctl(fd, FITRIM, 0, LLONG_MAX, 0), 

>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
