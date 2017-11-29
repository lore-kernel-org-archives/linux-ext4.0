From: Ashlie Martinez <ashmrtn@utexas.edu>
Subject: Re: ext4 fix for interaction between i_size, fallocate, and delalloc
 after a crash
Date: Wed, 29 Nov 2017 13:58:53 -0600
Message-ID: <CAFk8rvY9_-GxghCA43G9JoVqw-8NTG7-oRxEcV_cudcgDcy=rQ@mail.gmail.com>
References: <CAFk8rvZYEN4kGP9dF_FQxhP+UGfAY55uKrdsGr4-6ztWSoUp6w@mail.gmail.com>
 <20171122180317.nvymp7eedhswga7l@thunk.org> <CAFk8rvZ=EAUcAzxgi4bk+Qh2Y3ACZEv8unaowi0jvPNRB97XMA@mail.gmail.com>
 <20171127161137.4ghjcxfklpurk2eo@thunk.org> <CAFk8rvbxaQ72rvOg6NXDQYG1rXtuZsdzJ5SrbR=C6ftAU0YyPA@mail.gmail.com>
 <20171128204525.ijpis74t75f4bbsc@thunk.org> <CAFk8rvZQopSupfc3nakAR+1ORbHSZF+ypzhZA12w=g=MNstHrA@mail.gmail.com>
 <20171129061307.f6hekryi3bppo26y@thunk.org> <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Vijay Chidambaram <vvijay03@gmail.com>,
        Ext4 <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:38004 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdK2T6z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Nov 2017 14:58:55 -0500
Received: by mail-ua0-f179.google.com with SMTP id i4so4218415uab.5
        for <linux-ext4@vger.kernel.org>; Wed, 29 Nov 2017 11:58:55 -0800 (PST)
In-Reply-To: <CAOQ4uxiU3gu5+CRTSKig8r-Bpk=W0-J5N+MBL7s6XSrNUMrAKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted,

1.      write 0x137dd 0xdc69 0x0
2.      fallocate 0xb531 0xb5ad 0x21446
3.      collapse_range 0x1c000 0x4000 0x21446
4.      write 0x3e5ec 0x1a14 0x21446
5.      zero_range 0x20fac 0x6d9c 0x40000 keep_size

I have made a CrashMonkey test that runs the same operations run by
xfstests generic/456 as I wanted a bit more control over the test. My
test runs operations 1-3 from the list above, and then runs sleep(30).
After that, it runs operations 4 and 5 (I skipped operation 6 as it
doesn't seem to be related to the underlying cause of the bug).
CrashMonkey then waits a further 120 seconds for IO to trickle down to
the block device. After that, CrashMonkey replays the operations and I
have obtained the following output from fsck (run with -yf flags):

e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Inode 12 has an invalid extent node (blk 8476, lblk 45)
Clear? yes

Inode 12, i_blocks is 168, should be 0.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(8451--8476) -(8481--8512) -(8550--8575)
Fix? yes

Free blocks count wrong for group #1 (7850, counted=7934).
Fix? yes

Free blocks count wrong (93420, counted=93504).
Fix? yes


/dev/cow_ram_snapshot1_0: ***** FILE SYSTEM WAS MODIFIED *****
/dev/cow_ram_snapshot1_0: 12/25688 files (0.0% non-contiguous),
8896/102400 blocks

I get that the errors fixed in later passes are likely due to the
i_blocks and invalid extent issue found earlier (this is not shown in
xfstests as it usually runs with -nf). I think this output may be
related to what Amir found in generic/456, but I can't seem to
reproduce his output exactly. It almost seems like the crash I'm
getting with CrashMonkey is happening before any of the operations
have a chance to update the inode on disk. This seems to make sense if
you assume the write in operation 1 is delay allocated and the
subsequent fallocate calls don't adjust i_disksize in any way. If the
first write is delay allocated, then I am confused how Amir got the
output he did (with an updated i_disksize) as it seems like he should
get something similar to what I got.

On Wed, Nov 29, 2017 at 2:07 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Nov 29, 2017 at 8:13 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Tue, Nov 28, 2017 at 03:27:47PM -0600, Ashlie Martinez wrote:
>>>
>>> Unfortunately this timing bug only reproduces on some machines. Xiao
>>> and I have been unable to reproduce this bug (I've tried kvm-xfstests,
>>> my own kvm VMs, VMs without kvm, VMs with/without virtio drivers, and
>>> another bare metal system). generic/456 basically sets up a race
>>> condition between a kernel flusher thread and triggering dm-flakey, so
>>> I think things like system load, core count, etc. might cause
>>> different test results.
>>
>> Hmm, now I remember the details.  It reproduced reliably on
>> gce-xfstests, but I was able to use kvm-xfstests to debug the problem
>> (by invocations of debugfs to dump the file system state as I had
>> described).  That's because debugfs operates on the buffer cache, and
>> before the jbd2 commit, the changes to the inode structure are in the
>> buffer cache, but they aren't allowed to be persisted on disk until
>> after the journal commit.  And I was using debugfs to dump the inode's
>> extent tree (as it exists in the buffer cache) before triggering
>> dm-flakey.
>>
>> Now that we understand what is happening, it should be simple to
>> adjust the test so it reliably reproduces, by adding a "sleep 6"
>> before _flakey_drop_and_remote.  Since the delayed allocation write
>> won't get resolved until 30 seconds after the inode was first dirtied,
>> and the default jbd2 timer value is 5 seconds, this should guarantee
>> that the jbd2 commit has taken place so that the inode changes made by
>> fallocate are persisted onto the journal, while still allowing the
>> delayed allocation write to be remain unresolved.
>>
>
> Sorry, sleep 6 didn't work for me.
> Must be some other subtle detail.
> If you could work out how to fix the test to catch the bug in kvm-xfstests
> that would be nice.
>
> Better yet, if you can figure out how to configure kvm-xfstests differently
> so it catches the bug without modifying g/456 that would be much better,
> because I currently cannot use kvm-xfstest to debug ANY of the
> dm-log-writes crash test dummies.
>
> Thanks,
> Amir.
