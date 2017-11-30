From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 19:46:08 -0600
Message-ID: <CAFk8rvakptuN_rP5CRfLNNLEwntkvvcbdjn55O_E-RQyLUB=MQ@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org> <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
 <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com> <20171130004816.pdzfqjluchtvfq6u@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Amir Goldstein <amir73il@gmail.com>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:35152 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753607AbdK3BqK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Nov 2017 20:46:10 -0500
Received: by mail-ua0-f177.google.com with SMTP id l2so4768046uak.2
        for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2017 17:46:09 -0800 (PST)
In-Reply-To: <20171130004816.pdzfqjluchtvfq6u@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 29, 2017 at 6:48 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Nov 29, 2017 at 01:58:53PM -0600, Ashlie Martinez wrote:
>> Ted,
>>
>> 1.      write 0x137dd 0xdc69 0x0
>> 2.      fallocate 0xb531 0xb5ad 0x21446
>> 3.      collapse_range 0x1c000 0x4000 0x21446
>> 4.      write 0x3e5ec 0x1a14 0x21446
>> 5.      zero_range 0x20fac 0x6d9c 0x40000 keep_size
>>
>> I have made a CrashMonkey test that runs the same operations run by
>> xfstests generic/456 as I wanted a bit more control over the test. My
>> test runs operations 1-3 from the list above, and then runs sleep(30).
>> After that, it runs operations 4 and 5 (I skipped operation 6 as it
>> doesn't seem to be related to the underlying cause of the bug).
>> CrashMonkey then waits a further 120 seconds for IO to trickle down to
>> the block device.
>
> So I'm not sure exactly what Crashmonkey is doing here.  Are you
> forcing a crash, or not?

My apologies, I should have given proper context on CrashMonkey in my
previous email. CrashMonkey is a record-and-replay framework much like
dm-log-writes, but with a few differences. First, it records bio
information when the bios are given to the block device driver, not
when they are completed. Second, CrashMonkey has an option to
re-arrange the recorded bios within a set of ordering rules. These
rules adhere to FUA and flush commands (i.e. they will not move bios
across those barriers) and they may cause some bios between the
previous barrier operation and the next barrier operation to be
dropped if the next barrier operation is not reached. These rules are
meant to help simulate a crash involving a disk with an onboard cache.
In that case, the programmer cannot know what writes were cached on
the device and what writes were persisted when the crash occurs
(unless the crash occurs right after a barrier operation, in which
case everything should be persisted).

>
> So here's my test which I think should replicate what you are doing.
>
> 1.  Start "kvm-xfstests shell"
> 2.  Create the fsxops file:
>
>         cat > /tmp/fsxops
>         write 0x137dd 0xdc69 0x0
>         fallocate 0xb531 0xb5ad 0x21446
>         collapse_range 0x1c000 0x4000 0x21446
>         write 0x3e5ec 0x1a14 0x21446
>         zero_range 0x20fac 0x6d9c 0x40000 keep_size
>         <type control-d>
>
> 3.  Create a scratch file system and mount it:
>
>         mke2fs -Fq -t ext4 /dev/vdc
>         mount /vdc
>
> 4.  Run fsx:
>
>         ./xfstests/ltp/fsx -d --replay-ops /tmp/fsxops /vdc/testfile
>
> 5.  Since I'm too lazy to wait 120 seconds, just force everything to disk:
>
>         sync

I believe you said in an earlier email that sync would erase any trace
of the bug Amir found as it resolves the delayed allocation.

>
> 6a.  Unmount the file system and check it:
>
>         umount /vdc
>         e2fsck -fy /dev/vdc
>
> 6b.   Force a crash, and then restart kvm-xfstests shell, and then check the file system:
>
>         <type control-A followed by 'x'>
>         kvm-xfstests shell
>         e2fsck -fy /dev/vdc
>
> In both cases, e2fsck does not complain.  In the 6b variant, e2fsck
> will replay the journal first, but other than that, no real differences.
>
> So, tell me --- how is what I am doing any different from your Crashmonkey test?

CrashMonkey first records the entire stream of bios, including the
resolution of the delayed allocation. Once the workload has finished,
it writes out subsets of the recorded bios to the disk (restoring the
disk to it's state prior to the workload each time), checking each
resulting "crash state" with fsck to ensure it's consistent. One of
the goals of CrashMonkey is to test many crash states from a single
workload by rearranging the bios logged during the workload.
CrashMonkey also hopes to catch bugs that are caused by reordering
bios between two barrier operations, assuming the crash occurred
before the second barrier operation (this would depend on timing in
systems like xfstests and dm-log-writes, but since CrashMonkey records
and replays, it does not face these timing issues). An overview of
CrashMonkey and slides about can be found at [1].

When I was testing a workload based off Amir's generic/456 test in
CrashMonkey, I noticed the output that I sent to you earlier.

[1] https://www.usenix.org/conference/hotstorage17/program/presentation/martinez

>
>                               - Ted
