From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Mon, 07 Jul 2014 06:53:50 +0000
Message-ID: <bug-78651-13602-7mrBtxuy61@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44281 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbaGGGxy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jul 2014 02:53:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DC42820272
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 06:53:51 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CD81E2024D
	for <linux-ext4@vger.kernel.org>; Mon,  7 Jul 2014 06:53:50 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #7 from Joseph D. Wagner <joe@josephdwagner.info> ---
####
#### Exhibit F
####
#### EXT4 1 GB journal
####
# su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password: 
/sys/kernel/debug/tracing/events/jbd2/jbd2_checkpoint/filter
/sys/kernel/debug/tracing/events/jbd2/jbd2_run_stats/filter
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Sun Jul  6 18:36:26 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140706.183624-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1666619218 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140706.183624-0.qfa
  DUMP: Volume 1 started with block 1 at: Sun Jul  6 18:36:42 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.55% done at 86242 kB/s, finished in 5:17
  DUMP: 3.36% done at 93335 kB/s, finished in 4:47
  DUMP: 5.22% done at 96715 kB/s, finished in 4:32
  DUMP: 7.09% done at 98405 kB/s, finished in 4:22
  DUMP: 8.94% done at 99348 kB/s, finished in 4:14
  DUMP: 10.62% done at 98331 kB/s, finished in 4:12
  DUMP: 12.47% done at 98982 kB/s, finished in 4:05
  DUMP: 14.15% done at 98263 kB/s, finished in 4:02
  DUMP: 15.89% done at 98070 kB/s, finished in 3:58
  DUMP: 17.40% done at 96691 kB/s, finished in 3:57
  DUMP: 19.23% done at 97105 kB/s, finished in 3:51
  DUMP: 21.03% done at 97361 kB/s, finished in 3:45
  DUMP: 22.61% done at 96606 kB/s, finished in 3:42
  DUMP: 24.33% done at 96548 kB/s, finished in 3:37
  DUMP: 25.94% done at 96077 kB/s, finished in 3:34
  DUMP: 27.53% done at 95589 kB/s, finished in 3:30
  DUMP: 29.01% done at 94808 kB/s, finished in 3:27
  DUMP: 30.79% done at 95038 kB/s, finished in 3:22
  DUMP: 32.15% done at 93991 kB/s, finished in 3:20
  DUMP: 33.90% done at 94088 kB/s, finished in 3:15
  DUMP: 35.77% done at 94549 kB/s, finished in 3:08
  DUMP: 37.53% done at 94696 kB/s, finished in 3:03
  DUMP: 39.31% done at 94872 kB/s, finished in 2:57
  DUMP: 41.12% done at 95118 kB/s, finished in 2:51
  DUMP: 43.11% done at 95737 kB/s, finished in 2:45
  DUMP: 44.80% done at 95672 kB/s, finished in 2:40
  DUMP: 46.80% done at 96235 kB/s, finished in 2:33
  DUMP: 48.55% done at 96267 kB/s, finished in 2:28
  DUMP: 49.95% done at 95624 kB/s, finished in 2:25
  DUMP: 51.51% done at 95330 kB/s, finished in 2:21
  DUMP: 53.29% done at 95446 kB/s, finished in 2:15
  DUMP: 54.89% done at 95239 kB/s, finished in 2:11
  DUMP: 56.79% done at 95557 kB/s, finished in 2:05
  DUMP: 58.40% done at 95315 kB/s, finished in 2:01
  DUMP: 60.23% done at 95500 kB/s, finished in 1:55
  DUMP: 61.75% done at 95187 kB/s, finished in 1:51
  DUMP: 62.96% done at 94432 kB/s, finished in 1:48
  DUMP: 64.49% done at 94186 kB/s, finished in 1:44
  DUMP: 65.93% done at 93828 kB/s, finished in 1:40
  DUMP: 67.35% done at 93448 kB/s, finished in 1:37
  DUMP: 68.86% done at 93222 kB/s, finished in 1:32
  DUMP: 70.56% done at 93248 kB/s, finished in 1:27
  DUMP: 71.99% done at 92934 kB/s, finished in 1:23
  DUMP: 73.30% done at 92374 kB/s, finished in 1:20
  DUMP: 74.70% done at 92057 kB/s, finished in 1:16
  DUMP: 76.02% done at 91644 kB/s, finished in 1:12
  DUMP: 77.55% done at 91509 kB/s, finished in 1:08
  DUMP: 78.96% done at 91230 kB/s, finished in 1:04
  DUMP: 80.47% done at 91079 kB/s, finished in 0:59
  DUMP: 81.97% done at 90928 kB/s, finished in 0:55
  DUMP: 83.59% done at 90913 kB/s, finished in 0:50
  DUMP: 84.79% done at 90443 kB/s, finished in 0:46
  DUMP: 85.95% done at 89932 kB/s, finished in 0:43
  DUMP: 87.34% done at 89636 kB/s, finished in 0:39
  DUMP: 88.69% done at 89368 kB/s, finished in 0:35
  DUMP: 89.94% done at 89007 kB/s, finished in 0:31
  DUMP: 91.49% done at 88921 kB/s, finished in 0:26
  DUMP: 92.76% done at 88568 kB/s, finished in 0:22
  DUMP: 94.17% done at 88401 kB/s, finished in 0:18
  DUMP: 95.94% done at 88563 kB/s, finished in 0:12
  DUMP: 97.21% done at 88271 kB/s, finished in 0:08
  DUMP: 98.70% done at 88179 kB/s, finished in 0:04
  DUMP: 99.90% done at 87843 kB/s, finished in 0:00
  DUMP: Closing /mnt/backup/backup-data-home-20140706.183624-0.img
  DUMP: Volume 1 completed at: Sun Jul  6 23:53:22 2014
  DUMP: Volume 1 1666753856 blocks (1627689.31MB)
  DUMP: Volume 1 took 5:16:40
  DUMP: Volume 1 transfer rate: 87723 kB/s
  DUMP: 1666753856 blocks (1627689.31MB) on 1 volume(s)
  DUMP: finished in 18982 seconds, throughput 87807 kBytes/sec
  DUMP: Date of this level 0 dump: Sun Jul  6 18:36:26 2014
  DUMP: Date this dump completed:  Sun Jul  6 23:53:22 2014
  DUMP: Average transfer rate: 87723 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140706.183624-0.toc
  DUMP: DUMP IS DONE
Kernel buffer statistics:
  Note: "entries" are the entries left in the kernel ring buffer and are not
        recorded in the trace data. They should all be zero.

CPU: 0
entries: 0
overrun: 0
commit overrun: 0
bytes: 2700
oldest event ts: 20069.317440
now ts: 20510.416153
dropped events: 0
read events: 2031

CPU: 1
entries: 0
overrun: 0
commit overrun: 0
bytes: 2892
oldest event ts: 19851.942578
now ts: 20510.416250
dropped events: 0
read events: 1350

CPU: 2
entries: 0
overrun: 0
commit overrun: 0
bytes: 300
oldest event ts: 20470.055223
now ts: 20510.416299
dropped events: 0
read events: 1087

CPU: 3
entries: 0
overrun: 0
commit overrun: 0
bytes: 3484
oldest event ts: 19290.268932
now ts: 20510.416342
dropped events: 0
read events: 761

CPU: 4
entries: 0
overrun: 0
commit overrun: 0
bytes: 992
oldest event ts: 18981.386433
now ts: 20510.416382
dropped events: 0
read events: 130

CPU: 5
entries: 0
overrun: 0
commit overrun: 0
bytes: 500
oldest event ts: 20037.773385
now ts: 20510.416420
dropped events: 0
read events: 166

CPU: 6
entries: 0
overrun: 0
commit overrun: 0
bytes: 3160
oldest event ts: 17983.470194
now ts: 20510.416457
dropped events: 0
read events: 235

CPU: 7
entries: 0
overrun: 0
commit overrun: 0
bytes: 3200
oldest event ts:  1610.477599
now ts: 20510.416493
dropped events: 0
read events: 32

CPU0 data recorded at offset=0x448000
    208896 bytes in size
CPU1 data recorded at offset=0x47b000
    139264 bytes in size
CPU2 data recorded at offset=0x49d000
    114688 bytes in size
CPU3 data recorded at offset=0x4b9000
    77824 bytes in size
CPU4 data recorded at offset=0x4cc000
    16384 bytes in size
CPU5 data recorded at offset=0x4d0000
    20480 bytes in size
CPU6 data recorded at offset=0x4d5000
    24576 bytes in size
CPU7 data recorded at offset=0x4db000
    4096 bytes in size
  Logical volume "backup-data-home" successfully removed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
