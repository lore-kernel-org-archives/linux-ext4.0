From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Thu, 30 Nov 2017 09:40:24 -0600
Message-ID: <CAFk8rvaBukRhJy+2sw02mB2ur2ZBzgzpP7=Omc7p4+gkKOn9Bg@mail.gmail.com>
References: <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org> <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
 <20171130004816.pdzfqjluchtvfq6u@thunk.org> <CAFk8rvakptuN_rP5CRfLNNLEwntkvvcbdjn55O_E-RQyLUB=MQ@mail.gmail.com>
 <20171130044649.xfgwhd2wzdc5mwql@thunk.org> <CAFk8rvaPOd-XEOqnYSXVgp2Dw7wFYc98-q7JrdAAd-R8LJF=Ag@mail.gmail.com>
 <20171130152713.aeyxhns57lhou4de@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:37014 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdK3Pk0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Nov 2017 10:40:26 -0500
Received: by mail-vk0-f54.google.com with SMTP id x140so3673998vke.4
        for <linux-ext4@vger.kernel.org>; Thu, 30 Nov 2017 07:40:25 -0800 (PST)
In-Reply-To: <20171130152713.aeyxhns57lhou4de@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 30, 2017 at 9:27 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Nov 30, 2017 at 08:51:45AM -0600, Ashlie Martinez wrote:
>>
>> Even though CrashMonkey *records* all the disk operations, it doesn't
>> have to replay all of them when generating crash states. For example,
>> it could choose to fully replay (and preserve the ordering of) all
>> operations before the 3rd barrier operation in a trace with 5
>> different barrier operations in it (we dub each set of operations from
>> just after the previous barrier operation up to and including the next
>> barrier operation a "disk write epoch" or "disk epoch").
>
> OK, but then it won't replay any operations after the 4th barrier
> opration, correct?  And in the case where you are stopping somewhere
> between the 3rd and the 4th replay, you will drop and reorder random
> operations after the 3rd barrier op, but before the 4th, correct?
>
> So what would be good is to understand where it stopped replaying
> operations ---- and if you can get a strace -ttt of the workload, and
> the fine-grained timestamps from block I/O trace, so we can understand
> how far we had gotten in the workload.  And then, to also to include
> the output of debugfs's "logdump -ac" command before the journal is
> replayed.
>
> From a file system developer's perspective, what is most useful is
> when we can see the minimal reproduction test case where Crashmonkey
> is only rearranging block I/O's of the last full "disk write epock".
> And getting the timestampped strace logs and block I/O logs will help
> us do that.
>
> Otherwise, we have no idea where to look for a potential problem, only
> that it's one of the several I/O commands.

These are good suggestions that I will work on adding into my current
testing flow. Right now, I have CrashMonkey dump the recorded bios to
a file in binary (so it can be hexdumped) and also record the bios
that were used to generate each crash state it tests.

>
>
> Anyway, looking back at your original question, is your question why
> the first write isn't delay allocated?  That's because the
> collapse_range operation needs to resolve any delayed allocation
> writes on the portion of the extent tree which will be affected by the
> collapse_range operation.  See the calls to
> filemap_write_and_wait_range() in ext4_collapse_range().

I also ran a few more tests on this, it appears that when fsx does
mapwrite operations it calls msync after mmap (for obvious reasons).
Adding the mmap/msync operations to the end of my CrashMonkey workload
produced output similar to Amir's reported output, but with slightly
different values for i_blocks. There may be another interaction there
that we hadn't thought of based on this information. The top fsck
output below is from CrashMonkey with mmap/msync at the end of the
workload. The fsck output below that is from Amir's original post
about the bug. Note that my test is running on a much smaller file
system than Amir's, so the logical/physical blocks will differ.

e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, end of extent exceeds allowed value
  (logical block 131, physical block 8465, len 11)
Clear? yes

Inode 12, i_blocks is 168, should be 146.  Fix? yes


e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, end of extent exceeds allowed value
       (logical block 33, physical block 33441, len 7)
Clear? no
Inode 12, i_blocks is 184, should be 128.  Fix? no


>
> Note that if you want to try to understand what is going on, there are
> a large number of ext4 and jbd2 tracepoints.  Enabling these
> tracepoints (you may need to omit some of the much more chatty jbd2
> trace points from the ones that you enable) and dumping those
> timestamps alongside the strace -ttt and block I/O timestamps should
> be especially illuminating.
>
> Cheers,
>
>                                                 - Ted
>
> P.S.  Another set of tracepoints that might be useful for
> understanding when delayed write allocations are getting resolved are
> the writeback tracepoints --- although you can probably infer those
> from the ext4_writepages traces, since when the writeback is triggered
> this will trigger calls to ext4_writepages.
>
