Return-Path: <SRS0=RWfY=OV=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:44195 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbeLLNsC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 12 Dec 2018 08:48:02 -0500
Subject: Re: [PATCH 1/2] ext4: try to merge unwritten extents who are also not
 under io
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz,
        Eric Whitney <enwlinux@gmail.com>
References: <20181125085031.7141-1-xiaoguang.wang@linux.alibaba.com>
 <7fef258e-0095-cfa2-aeb4-5d4d99cfd2e6@linux.alibaba.com>
 <20181210055307.GI1840@mit.edu>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <e9c4114c-ffbb-2fc8-1ac6-ab8ef3d425a3@linux.alibaba.com>
Date: Wed, 12 Dec 2018 21:47:15 +0800
MIME-Version: 1.0
In-Reply-To: <20181210055307.GI1840@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

> On Sun, Nov 25, 2018 at 05:06:41PM +0800, Xiaoguang Wang wrote:
>> Hi,
>>
>> There will be no [PATCH 2/2], which was caused by my mistake, sorry, only one patch in this mail.
>> I have run xfstests "-g auto" for this patch, most test cases work well, such
>> cases will fail:
>> generic/107 generic/223 generic/347 generic/388 generic/422 generic/475 generic/484, but
>> even though I do not apply this patch, these cases still may fail.
>>
>> No matter whether this patch is applied, generic/107, generic/388 and generic/475 sometimes pass,
>> sometimes fail, other 4 test cases always fail.
>>
>> Apply LiuBo's "Ext4: fix slow writeback under dioread_nolock and nodelalloc" and this patch, this
>> slow writeback issue described in Liu Bo's patch will go.
> 
> Hi, my apologies for not responding earlier.  I had been
> waiting/hoping that Eric Whitney, who has last made a lot of changes
> around the extent status tree management, would take a look at your
> changes and comment.
I see, that's ok.

> 
> The other thing which I'm very much wondering about is why you are
> seeing such a large number of test failures.  What sort of file system
> configuration and kernel version are you seeing these failures?  My
> current test runs aren't showing anything like this --- and neeither
> is Eric Whitney's testing.  I've attached a recent test report below.
I run a new tests against newest upstream kernel without my patches:
ext4/034 ext4/305 generic/223 generic/371 generic/422 generic/484 shared/004 failed,

ext4/034: liubo has sent a patch to fix this bug.
ext/305 shared/004: umount failed, but maybe my environment issuse.
Look like other 4 test cases maybe related to fs or test cases bugs.
I attach test results here, later when I have some free time, I'll look into them.

Regards,
Xiaoguang Wang
[lege@localhost xfstests-dev]$ sudo ./check ext4/034 ext4/305 generic/223 generic/371 generic/422 generic/484 shared/004
FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 localhost 4.20.0-rc6+
MKFS_OPTIONS  -- /dev/sda6
MOUNT_OPTIONS -- -o dioread_nolock,nodelalloc /dev/sda6 /mnt/scratch

ext4/034	_check_generic_filesystem: filesystem on /dev/sda6 is inconsistent
(see /home/lege/xfstests-dev/results//ext4/034.full for details)

ext4/305 2s ... - output mismatch (see /home/lege/xfstests-dev/results//ext4/305.out.bad)
     --- tests/ext4/305.out	2018-11-13 17:38:29.682879168 +0800
     +++ /home/lege/xfstests-dev/results//ext4/305.out.bad	2018-12-12 21:31:00.674010908 +0800
     @@ -1,2 +1,4 @@
      QA output created by 305
      Silence is golden
     +umount: /mnt/scratch: target is busy.
     +mount: /mnt/scratch: /dev/sda6 already mounted on /mnt/scratch.
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/ext4/305.out /home/lege/xfstests-dev/results//ext4/305.out.bad'  to see the entire diff)
generic/223 9s ... - output mismatch (see /home/lege/xfstests-dev/results//generic/223.out.bad)
     --- tests/generic/223.out	2018-11-13 17:38:29.701879505 +0800
     +++ /home/lege/xfstests-dev/results//generic/223.out.bad	2018-12-12 21:31:17.689483781 +0800
     @@ -204,47 +204,47 @@
      SCRATCH_MNT/file-1-131072-falloc: well-aligned
      SCRATCH_MNT/file-1-131072-write: well-aligned
      SCRATCH_MNT/file-2-131072-falloc: well-aligned
     -SCRATCH_MNT/file-2-131072-write: well-aligned
     +SCRATCH_MNT/file-2-131072-write: Start block 34320 not multiple of sunit 32
      SCRATCH_MNT/file-3-131072-falloc: well-aligned
      SCRATCH_MNT/file-3-131072-write: well-aligned
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/generic/223.out /home/lege/xfstests-dev/results//generic/223.out.bad'  to see the entire diff)
generic/371 13s ... - output mismatch (see /home/lege/xfstests-dev/results//generic/371.out.bad)
     --- tests/generic/371.out	2018-11-13 17:38:29.712879700 +0800
     +++ /home/lege/xfstests-dev/results//generic/371.out.bad	2018-12-12 21:31:31.390059348 +0800
     @@ -1,2 +1,6 @@
      QA output created by 371
      Silence is golden
     +pwrite: No space left on device
     +pwrite: No space left on device
     +pwrite: No space left on device
     +pwrite: No space left on device
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/generic/371.out /home/lege/xfstests-dev/results//generic/371.out.bad'  to see the entire diff)
generic/422 1s ... - output mismatch (see /home/lege/xfstests-dev/results//generic/422.out.bad)
     --- tests/generic/422.out	2018-11-13 17:38:29.717879788 +0800
     +++ /home/lege/xfstests-dev/results//generic/422.out.bad	2018-12-12 21:31:33.022008791 +0800
     @@ -17,4 +17,4 @@
      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
      wrote 65536/65536 bytes at offset 0
      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
     -Space used before and after writeback is equal
     +Files /mnt/scratch/422.before and /mnt/scratch/422.after differ
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/generic/422.out /home/lege/xfstests-dev/results//generic/422.out.bad'  to see the entire diff)
generic/484	- output mismatch (see /home/lege/xfstests-dev/results//generic/484.out.bad)
     --- tests/generic/484.out	2018-11-13 17:38:29.721879859 +0800
     +++ /home/lege/xfstests-dev/results//generic/484.out.bad	2018-12-12 21:31:33.307999931 +0800
     @@ -1,2 +1,3 @@
      QA output created by 484
     +record lock is not preserved across execve(2)
      Silence is golden
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/generic/484.out /home/lege/xfstests-dev/results//generic/484.out.bad'  to see the entire diff)
shared/004	[failed, exit status 1]- output mismatch (see /home/lege/xfstests-dev/results//shared/004.out.bad)
     --- tests/shared/004.out	2018-11-13 17:38:29.729880001 +0800
     +++ /home/lege/xfstests-dev/results//shared/004.out.bad	2018-12-12 21:31:33.718987199 +0800
     @@ -1,2 +1,6 @@
      QA output created by 004
      Silence is golden
     +umount: /mnt/scratch: target is busy.
     +mount: /mnt/scratch: /dev/sda6 already mounted on /mnt/scratch.
     +mount failed
     +(see /home/lege/xfstests-dev/results//shared/004.full for details)
     ...
     (Run 'diff -u /home/lege/xfstests-dev/tests/shared/004.out /home/lege/xfstests-dev/results//shared/004.out.bad'  to see the entire diff)
Ran: ext4/034 ext4/305 generic/223 generic/371 generic/422 generic/484 shared/004
Failures: ext4/034 ext4/305 generic/223 generic/371 generic/422 generic/484 shared/004
Failed 7 of 7 tests




> 
> 					- Ted
> 
> TESTRUNID: ltm-20181208020855
> KERNEL:    kernel 4.20.0-rc4-xfstests-00010-ge647e29196b7 #772 SMP Wed Dec 5 19:38:26 EST 2018 x86_64
> CMDLINE:   full --kernel gs://gce-xfstests/bzImage
> CPUS:      2
> MEM:       7680
> 
> ext4/4k: 444 tests, 2 failures, 42 skipped, 4272 seconds
>    Failures: ext4/034 generic/388
> ext4/1k: 455 tests, 4 failures, 54 skipped, 4624 seconds
>    Failures: ext4/034 generic/383 generic/388 generic/454
> ext4/ext3: 503 tests, 3 failures, 104 skipped, 3857 seconds
>    Failures: ext4/034 generic/235 generic/388
> ext4/encrypt: 512 tests, 1 failures, 123 skipped, 2828 seconds
>    Failures: ext4/034
> ext4/nojournal: 494 tests, 2 failures, 95 skipped, 3407 seconds
>    Failures: ext4/301 generic/113
> ext4/ext3conv: 443 tests, 2 failures, 42 skipped, 4240 seconds
>    Failures: ext4/034 generic/388
> ext4/adv: 448 tests, 5 failures, 48 skipped, 4165 seconds
>    Failures: ext4/034 generic/388 generic/399 generic/477 generic/519
> ext4/dioread_nolock: 443 tests, 2 failures, 42 skipped, 4424 seconds
>    Failures: ext4/034 generic/388
> ext4/data_journal: 490 tests, 4 failures, 90 skipped, 4954 seconds
>    Failures: ext4/034 generic/371 generic/388 generic/475
> ext4/bigalloc: 429 tests, 6 failures, 49 skipped, 4957 seconds
>    Failures: ext4/034 generic/204 generic/219 generic/273 generic/388
>      generic/500
> ext4/bigalloc_1k: 443 tests, 7 failures, 63 skipped, 3717 seconds
>    Failures: ext4/034 generic/204 generic/273 generic/383 generic/388
>      generic/454 generic/500
> Totals: 4352 tests, 752 skipped, 38 failures, 0 errors, 45223s
> 
> FSTESTIMG: gce-xfstests/xfstests-201812071306
> FSTESTPRJ: gce-xfstests
> FSTESTVER: blktests b237a09 (Mon, 26 Nov 2018 11:35:33 -0800)
> FSTESTVER: fio  fio-3.2 (Fri, 3 Nov 2017 15:23:49 -0600)
> FSTESTVER: fsverity bdebc45 (Wed, 5 Sep 2018 21:32:22 -0700)
> FSTESTVER: ima-evm-utils 0267fa1 (Mon, 3 Dec 2018 06:11:35 -0500)
> FSTESTVER: quota  59b280e (Mon, 5 Feb 2018 16:48:22 +0100)
> FSTESTVER: stress-ng 977ae357 (Wed, 6 Sep 2017 23:45:03 -0400)
> FSTESTVER: syzkaller 4b6d14f2 (Tue, 27 Nov 2018 13:16:46 +0100)
> FSTESTVER: xfsprogs v4.19.0 (Fri, 9 Nov 2018 14:31:04 -0600)
> FSTESTVER: xfstests-bld c07ca47 (Fri, 7 Dec 2018 12:56:06 -0500)
> FSTESTVER: xfstests linux-v3.8-2234-g8636a571 (Fri, 7 Dec 2018 12:59:13 -0500)
> FSTESTSET: -g auto
> FSTESTOPT: aex
> 
