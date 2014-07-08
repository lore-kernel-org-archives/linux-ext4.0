From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Tue, 08 Jul 2014 13:42:19 +0000
Message-ID: <bug-78651-13602-2MPQ03SQUo@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43257 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaGHNmW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 09:42:22 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7BB04202F8
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:42:20 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 6A85F2015A
	for <linux-ext4@vger.kernel.org>; Tue,  8 Jul 2014 13:42:19 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #9 from Joseph D. Wagner <joe@josephdwagner.info> ---
This is entirely unexpected.  Performance wasn't that bad.  The only thing I
did differently was using this option in mke2fs:
"-E lazy_itable_init=0,lazy_journal_init=0"

Could the lazy initialization be tripping it up?  That doesn't make much sense,
because I had been having this problem for some time before doing all these
formatting experiments.

I will attach ftrace and memstats shortly.

Joseph D. Wagner

####
#### Exhibit G
####
#### EXT4 256 MB journal
####
# su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password: 
/sys/kernel/debug/tracing/events/jbd2/jbd2_checkpoint/filter
/sys/kernel/debug/tracing/events/jbd2/jbd2_run_stats/filter
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Mon Jul  7 22:32:53 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140707.223252-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1664540695 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140707.223252-0.qfa
  DUMP: Volume 1 started with block 1 at: Mon Jul  7 22:33:10 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.52% done at 84065 kB/s, finished in 5:25
  DUMP: 3.38% done at 93765 kB/s, finished in 4:45
  DUMP: 5.21% done at 95705 kB/s, finished in 4:34
  DUMP: 7.13% done at 98469 kB/s, finished in 4:21
  DUMP: 9.16% done at 101232 kB/s, finished in 4:08
  DUMP: 11.09% done at 102248 kB/s, finished in 4:01
  DUMP: 13.24% done at 104623 kB/s, finished in 3:50
  DUMP: 15.25% done at 105362 kB/s, finished in 3:43
  DUMP: 17.08% done at 104930 kB/s, finished in 3:39
  DUMP: 19.05% done at 105326 kB/s, finished in 3:33
  DUMP: 21.08% done at 106019 kB/s, finished in 3:26
  DUMP: 22.80% done at 105141 kB/s, finished in 3:23
  DUMP: 24.57% done at 104591 kB/s, finished in 3:20
  DUMP: 26.17% done at 103451 kB/s, finished in 3:18
  DUMP: 28.00% done at 103348 kB/s, finished in 3:13
  DUMP: 29.65% done at 102589 kB/s, finished in 3:10
  DUMP: 31.33% done at 102054 kB/s, finished in 3:06
  DUMP: 32.94% done at 101356 kB/s, finished in 3:03
  DUMP: 34.72% done at 101206 kB/s, finished in 2:58
  DUMP: 36.69% done at 101617 kB/s, finished in 2:52
  DUMP: 38.28% done at 100972 kB/s, finished in 2:49
  DUMP: 39.92% done at 100523 kB/s, finished in 2:45
  DUMP: 41.82% done at 100747 kB/s, finished in 2:40
  DUMP: 43.61% done at 100688 kB/s, finished in 2:35
  DUMP: 45.59% done at 101036 kB/s, finished in 2:29
  DUMP: 47.33% done at 100878 kB/s, finished in 2:24
  DUMP: 48.89% done at 100304 kB/s, finished in 2:21
  DUMP: 50.36% done at 99618 kB/s, finished in 2:18
  DUMP: 51.93% done at 99191 kB/s, finished in 2:14
  DUMP: 53.74% done at 99175 kB/s, finished in 2:09
  DUMP: 55.55% done at 99220 kB/s, finished in 2:04
  DUMP: 57.41% done at 99354 kB/s, finished in 1:58
  DUMP: 59.29% done at 99500 kB/s, finished in 1:53
  DUMP: 61.40% done at 100007 kB/s, finished in 1:47
  DUMP: 62.90% done at 99529 kB/s, finished in 1:43
  DUMP: 64.38% done at 98954 kB/s, finished in 1:39
  DUMP: 65.86% done at 98497 kB/s, finished in 1:36
  DUMP: 67.41% done at 98173 kB/s, finished in 1:32
  DUMP: 68.88% done at 97749 kB/s, finished in 1:28
  DUMP: 70.55% done at 97621 kB/s, finished in 1:23
  DUMP: 72.06% done at 97286 kB/s, finished in 1:19
  DUMP: 73.46% done at 96809 kB/s, finished in 1:16
  DUMP: 75.17% done at 96766 kB/s, finished in 1:11
  DUMP: 76.74% done at 96552 kB/s, finished in 1:06
  DUMP: 78.29% done at 96316 kB/s, finished in 1:02
  DUMP: 79.98% done at 96264 kB/s, finished in 0:57
  DUMP: 81.59% done at 96111 kB/s, finished in 0:53
  DUMP: 83.19% done at 95963 kB/s, finished in 0:48
  DUMP: 84.59% done at 95591 kB/s, finished in 0:44
  DUMP: 85.90% done at 95129 kB/s, finished in 0:41
  DUMP: 87.31% done at 94801 kB/s, finished in 0:37
  DUMP: 88.88% done at 94635 kB/s, finished in 0:32
  DUMP: 90.40% done at 94436 kB/s, finished in 0:28
  DUMP: 92.01% done at 94342 kB/s, finished in 0:23
  DUMP: 93.66% done at 94287 kB/s, finished in 0:18
  DUMP: 95.48% done at 94409 kB/s, finished in 0:13
  DUMP: 97.04% done at 94271 kB/s, finished in 0:08
  DUMP: 98.43% done at 93972 kB/s, finished in 0:04
  DUMP: 99.76% done at 93637 kB/s, finished in 0:00
  DUMP: Closing /mnt/backup/backup-data-home-20140707.223252-0.img
  DUMP: Volume 1 completed at: Tue Jul  8 03:29:43 2014
  DUMP: Volume 1 1664675072 blocks (1625659.25MB)
  DUMP: Volume 1 took 4:56:33
  DUMP: Volume 1 transfer rate: 93557 kB/s
  DUMP: 1664675072 blocks (1625659.25MB) on 1 volume(s)
  DUMP: finished in 17783 seconds, throughput 93610 kBytes/sec
  DUMP: Date of this level 0 dump: Mon Jul  7 22:32:53 2014
  DUMP: Date this dump completed:  Tue Jul  8 03:29:43 2014
  DUMP: Average transfer rate: 93557 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140707.223252-0.toc
  DUMP: DUMP IS DONE
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0
bytes: 1400
oldest event ts: 24220.806656
now ts: 25076.920627
dropped events: 0
read events: 614

CPU: 1
entries: 0
overrun: 0
commit overrun: 0
bytes: 3168
oldest event ts: 23960.588658
now ts: 25076.920710
dropped events: 0
read events: 756

CPU: 2
entries: 0
overrun: 0
commit overrun: 0
bytes: 1092
oldest event ts: 24801.889841
now ts: 25076.920772
dropped events: 0
read events: 865

CPU: 3
entries: 0
overrun: 0
commit overrun: 0
bytes: 1700
oldest event ts: 24551.112688
now ts: 25076.920828
dropped events: 0
read events: 702

CPU: 4
entries: 0
overrun: 0
commit overrun: 0
bytes: 400
oldest event ts: 24162.567661
now ts: 25076.920883
dropped events: 0
read events: 85

CPU: 5
entries: 0
overrun: 0
commit overrun: 0
bytes: 2168
oldest event ts: 22049.515769
now ts: 25076.920936
dropped events: 0
read events: 144

CPU: 6
entries: 0
overrun: 0
commit overrun: 0
bytes: 2868
oldest event ts: 21979.076019
now ts: 25076.920988
dropped events: 0
read events: 233

CPU: 7
entries: 0
overrun: 0
commit overrun: 0
bytes: 900
oldest event ts:  8080.390207
now ts: 25076.921039
dropped events: 0
read events: 9

CPU0 data recorded at offset=0x449000
    65536 bytes in size
CPU1 data recorded at offset=0x459000
    77824 bytes in size
CPU2 data recorded at offset=0x46c000
    90112 bytes in size
CPU3 data recorded at offset=0x482000
    73728 bytes in size
CPU4 data recorded at offset=0x494000
    12288 bytes in size
CPU5 data recorded at offset=0x497000
    16384 bytes in size
CPU6 data recorded at offset=0x49b000
    24576 bytes in size
CPU7 data recorded at offset=0x4a1000
    4096 bytes in size
  Logical volume "backup-data-home" successfully removed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
