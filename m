From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Thu, 30 Nov 2017 08:51:45 -0600
Message-ID: <CAFk8rvaPOd-XEOqnYSXVgp2Dw7wFYc98-q7JrdAAd-R8LJF=Ag@mail.gmail.com>
References: <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org> <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
 <20171130004816.pdzfqjluchtvfq6u@thunk.org> <CAFk8rvakptuN_rP5CRfLNNLEwntkvvcbdjn55O_E-RQyLUB=MQ@mail.gmail.com>
 <20171130044649.xfgwhd2wzdc5mwql@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:39836 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753101AbdK3Ovr (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 09:51:47 -0500
Received: by mail-ua0-f178.google.com with SMTP id i20so3834384uak.6
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 06:51:47 -0800 (PST)
In-Reply-To: <20171130044649.xfgwhd2wzdc5mwql@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 10:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Nov 29, 2017 at 07:46:08PM -0600, Ashlie Martinez wrote:
>> > 5.  Since I'm too lazy to wait 120 seconds, just force everything to disk:
>> >
>> >         sync
>>
>> I believe you said in an earlier email that sync would erase any trace
>> of the bug Amir found as it resolves the delayed allocation.
>
> Right, but you're waiting 120 seconds, which is enough time that it
> would resolve the delayed allocation.  So that's why I was trying to
> replicate your Crashmonkey experiment.
>
> And since you stated that you waited 120 seconds as the last step,
> there should have been a barrier, and no I/O operations for
> Crashmonkey to rearrange.  This is why I believe what I listed should
> be exactly the same as your Crashmonkey test, if I understood it
> correctly.
>
> What you said was that you ran the following operations on the test
> file:
>
> 1.      write 0x137dd 0xdc69 0x0
> 2.      fallocate 0xb531 0xb5ad 0x21446
> 3.      collapse_range 0x1c000 0x4000 0x21446
>         <sleep 30>
> 4.      write 0x3e5ec 0x1a14 0x21446
> 5.      zero_range 0x20fac 0x6d9c 0x40000 keep_size
>         <sleep 120>
>
> So what was the block I/O trace?  What operations was crashmonkey
> actually reordering?  There **really** shouldn't have been any....
>
> Can you send the block I/O trace that was observed when you did the
> following, a complete output of dumpe2fs on the file system, and a
> debugfs stat output on the test file?

I'll work on getting you traces, or other information with which you
can recreate the crash with later today or tomorrow. Unfortunately I'm
a bit slammed with work right now (undergrad honors thesis, end of
semester projects, etc.), but I'll try to get it out soon :)

>
>                                                 - Ted
>
> P.S.  I did read the Crashmonkey paper, so I'm aware of what
> Crashmonkey does.  I'm just confused about your workload, since the
> 120 second sleep should have meant there was a barrier followed by
> nothing else, making for a *very* boring crashmonkey replay.
>

Even though CrashMonkey *records* all the disk operations, it doesn't
have to replay all of them when generating crash states. For example,
it could choose to fully replay (and preserve the ordering of) all
operations before the 3rd barrier operation in a trace with 5
different barrier operations in it (we dub each set of operations from
just after the previous barrier operation up to and including the next
barrier operation a "disk write epoch" or "disk epoch"). If
CrashMonkey decides to write out a partial disk epoch at the end, it
can rearrange and/or drop operations from it according to the rules
laid out in my earlier message. This is more or less equivalent to
running dm-log-writes, placing a mark at each barrier operation it
sees, and then replaying up to each mark (and potentially a little
past the mark) to generate a disk image to check.
