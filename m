From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] New: Write performance of ext4 degrades linearly as
 volume fills
Date: Sun, 22 Jun 2014 05:44:36 +0000
Message-ID: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaFVFom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jun 2014 01:44:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CD75120253
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 05:44:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 020D02022A
	for <linux-ext4@vger.kernel.org>; Sun, 22 Jun 2014 05:44:37 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

            Bug ID: 78651
           Summary: Write performance of ext4 degrades linearly as volume
                    fills
           Product: File System
           Version: 2.5
    Kernel Version: 3.14.8-200.fc20.x86_64
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: joe@josephdwagner.info
        Regression: No

Created attachment 140591
  --> https://bugzilla.kernel.org/attachment.cgi?id=140591&action=edit
dumpe2fs info for ext4 backup destinaton

Background:
- I use lvm snapshots on ext4 for backup.  I use dump to backup the snapshots. 
The backup goes to an external hard drive over usb 3.0. The external hard drive
has 1 partition formatted with ext4.

- This bug report is based upon a conversation on the ext4 mailing list.  I am
filing it, because I now have more information and examples.

Summary:
- I've noticed the performance of dump to my ext4 backup degrades linearly as
the disk fills.

Details:
Exhibit A (below) is what I am seeing.  It seemed to do well up until 20%, but
then performance drops.  Between 31% and 33%, I reran dumpe2fs in case this was
some sort of cache poison issue.  As you can see, it didn't improve performance
at the time.

Exhibit B is the same thing, only I reformatted the destination for XFS.  XFS
is able to complete the backup in 4:24:16, whereas EXT4 takes 6:27:29.  XFS
does not dip below 115 mB/s until 64.22%.  Even then, the loss in
minimal so that performance never drops below 108 mB/s (6% loss).
EXT4, on the other hand, drops below 115 mB/s at 21.72%.  Performance
continues to drop precipitously until reaching 74 mB/s (35% loss).

Exhibit C, run at Theo's suggestion, is EXT4 but with the destination file
broken into smaller, multiple files.  The purprose was to determine if the
performance was related to the increase in the file size or the decrease in
volume free space.  As you can see, performance did not reset with a new file. 
It continued to degrade right were the previous file left off.

I am using journal=writeback.

Any help you can provide would be appreciated.

Joseph D. Wagner

(FYI, lvbackup is a script I wrote to 1) create to lvm snapshot, 2) run dump,
and 3) drop the snapshot.)

####
#### Exhibit A
####
#### EXT4 - all in one file
####
# su -c 'cd /root; dumpe2fs /dev/mapper/backup > /dev/null; nice ionice -c3
/usr/local/bin/lvbackup /dev/data/home /mnt/backup'
Password:
dumpe2fs 1.42.8 (20-Jun-2013)
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Mon Jun 16 20:08:57 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140616.200856-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1722505007 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140616.200856-0.qfa
  DUMP: Volume 1 started with block 1 at: Mon Jun 16 20:09:11 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.92% done at 110516 kB/s, finished in 4:14
  DUMP: 4.05% done at 116142 kB/s, finished in 3:57
  DUMP: 6.27% done at 119939 kB/s, finished in 3:44
  DUMP: 8.51% done at 122095 kB/s, finished in 3:35
  DUMP: 10.73% done at 123209 kB/s, finished in 3:28
  DUMP: 12.89% done at 123382 kB/s, finished in 3:22
  DUMP: 14.98% done at 122868 kB/s, finished in 3:18
  DUMP: 17.05% done at 122380 kB/s, finished in 3:14
  DUMP: 18.98% done at 121068 kB/s, finished in 3:12
  DUMP: 20.37% done at 116976 kB/s, finished in 3:15
  DUMP: 21.72% done at 113360 kB/s, finished in 3:18
  DUMP: 23.12% done at 110641 kB/s, finished in 3:19
  DUMP: 24.40% done at 107777 kB/s, finished in 3:21
  DUMP: 25.76% done at 105628 kB/s, finished in 3:21
  DUMP: 27.08% done at 103641 kB/s, finished in 3:21
  DUMP: 28.30% done at 101527 kB/s, finished in 3:22
  DUMP: 29.50% done at 99508 kB/s, finished in 3:23
  DUMP: 30.79% done at 98101 kB/s, finished in 3:22
  DUMP: 31.88% done at 96210 kB/s, finished in 3:23
  DUMP: 33.31% done at 95509 kB/s, finished in 3:20
  DUMP: 34.50% done at 94219 kB/s, finished in 3:19
  DUMP: 35.86% done at 93449 kB/s, finished in 3:17
  DUMP: 37.25% done at 92860 kB/s, finished in 3:14
  DUMP: 38.64% done at 92323 kB/s, finished in 3:10
  DUMP: 39.91% done at 91559 kB/s, finished in 3:08
  DUMP: 41.18% done at 90845 kB/s, finished in 3:05
  DUMP: 42.59% done at 90476 kB/s, finished in 3:02
  DUMP: 43.88% done at 89885 kB/s, finished in 2:59
  DUMP: 45.09% done at 89188 kB/s, finished in 2:56
  DUMP: 46.45% done at 88794 kB/s, finished in 2:53
  DUMP: 47.77% done at 88370 kB/s, finished in 2:49
  DUMP: 49.12% done at 88029 kB/s, finished in 2:45
  DUMP: 50.36% done at 87518 kB/s, finished in 2:42
  DUMP: 51.53% done at 86929 kB/s, finished in 2:40
  DUMP: 52.65% done at 86276 kB/s, finished in 2:37
  DUMP: 53.97% done at 85979 kB/s, finished in 2:33
  DUMP: 55.30% done at 85720 kB/s, finished in 2:29
  DUMP: 56.58% done at 85388 kB/s, finished in 2:25
  DUMP: 57.91% done at 85158 kB/s, finished in 2:21
  DUMP: 59.30% done at 85024 kB/s, finished in 2:17
  DUMP: 60.66% done at 84848 kB/s, finished in 2:13
  DUMP: 61.94% done at 84576 kB/s, finished in 2:09
  DUMP: 63.21% done at 84299 kB/s, finished in 2:05
  DUMP: 64.24% done at 83730 kB/s, finished in 2:02
  DUMP: 65.37% done at 83309 kB/s, finished in 1:59
  DUMP: 66.48% done at 82892 kB/s, finished in 1:56
  DUMP: 67.69% done at 82599 kB/s, finished in 1:52
  DUMP: 68.76% done at 82161 kB/s, finished in 1:49
  DUMP: 69.90% done at 81788 kB/s, finished in 1:45
  DUMP: 70.95% done at 81365 kB/s, finished in 1:42
  DUMP: 72.13% done at 81094 kB/s, finished in 1:38
  DUMP: 73.33% done at 80861 kB/s, finished in 1:34
  DUMP: 74.42% done at 80510 kB/s, finished in 1:31
  DUMP: 75.51% done at 80186 kB/s, finished in 1:27
  DUMP: 76.65% done at 79919 kB/s, finished in 1:23
  DUMP: 77.72% done at 79577 kB/s, finished in 1:20
  DUMP: 78.74% done at 79212 kB/s, finished in 1:17
  DUMP: 79.92% done at 79016 kB/s, finished in 1:12
  DUMP: 81.00% done at 78728 kB/s, finished in 1:09
  DUMP: 82.20% done at 78564 kB/s, finished in 1:05
  DUMP: 83.33% done at 78344 kB/s, finished in 1:01
  DUMP: 84.39% done at 78048 kB/s, finished in 0:57
  DUMP: 85.19% done at 77542 kB/s, finished in 0:54
  DUMP: 86.20% done at 77237 kB/s, finished in 0:51
  DUMP: 87.19% done at 76919 kB/s, finished in 0:47
  DUMP: 88.13% done at 76568 kB/s, finished in 0:44
  DUMP: 89.14% done at 76289 kB/s, finished in 0:40
  DUMP: 90.08% done at 75961 kB/s, finished in 0:37
  DUMP: 91.20% done at 75791 kB/s, finished in 0:33
  DUMP: 92.34% done at 75646 kB/s, finished in 0:29
  DUMP: 93.56% done at 75563 kB/s, finished in 0:24
  DUMP: 94.69% done at 75415 kB/s, finished in 0:20
  DUMP: 95.77% done at 75203 kB/s, finished in 0:16
  DUMP: 96.83% done at 74995 kB/s, finished in 0:12
  DUMP: 97.79% done at 74733 kB/s, finished in 0:08
  DUMP: 98.74% done at 74465 kB/s, finished in 0:04
  DUMP: 99.67% done at 74171 kB/s, finished in 0:01
  DUMP: Closing /mnt/backup/backup-data-home-20140616.200856-0.img
  DUMP: Volume 1 completed at: Tue Jun 17 02:36:40 2014
  DUMP: Volume 1 1722545856 blocks (1682173.69MB)
  DUMP: Volume 1 took 6:27:29
  DUMP: Volume 1 transfer rate: 74091 kB/s
  DUMP: 1722545856 blocks (1682173.69MB) on 1 volume(s)
  DUMP: finished in 23249 seconds, throughput 74091 kBytes/sec
  DUMP: Date of this level 0 dump: Mon Jun 16 20:08:57 2014
  DUMP: Date this dump completed:  Tue Jun 17 02:36:40 2014
  DUMP: Average transfer rate: 74091 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140616.200856-0.toc
  DUMP: DUMP IS DONE
  Logical volume "backup-data-home" successfully removed 

####
#### Exhibit B
####
#### XFS - all in one file
####
# su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password:
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Fri Jun 20 10:24:39 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140620.102438-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1716954416 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140620.102438-0.qfa
  DUMP: Volume 1 started with block 1 at: Fri Jun 20 10:24:53 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.94% done at 110770 kB/s, finished in 4:13
  DUMP: 4.05% done at 115842 kB/s, finished in 3:57
  DUMP: 6.11% done at 116545 kB/s, finished in 3:50
  DUMP: 8.25% done at 118041 kB/s, finished in 3:42
  DUMP: 10.38% done at 118825 kB/s, finished in 3:35
  DUMP: 12.54% done at 119635 kB/s, finished in 3:29
  DUMP: 14.73% done at 120414 kB/s, finished in 3:22
  DUMP: 16.94% done at 121214 kB/s, finished in 3:16
  DUMP: 19.03% done at 121000 kB/s, finished in 3:11
  DUMP: 21.18% done at 121245 kB/s, finished in 3:06
  DUMP: 23.23% done at 120878 kB/s, finished in 3:01
  DUMP: 25.20% done at 120198 kB/s, finished in 2:58
  DUMP: 27.24% done at 119910 kB/s, finished in 2:53
  DUMP: 28.93% done at 118256 kB/s, finished in 2:51
  DUMP: 30.84% done at 117652 kB/s, finished in 2:48
  DUMP: 32.62% done at 116691 kB/s, finished in 2:45
  DUMP: 34.37% done at 115692 kB/s, finished in 2:42
  DUMP: 36.41% done at 115770 kB/s, finished in 2:37
  DUMP: 38.50% done at 115959 kB/s, finished in 2:31
  DUMP: 40.37% done at 115530 kB/s, finished in 2:27
  DUMP: 42.48% done at 115778 kB/s, finished in 2:22
  DUMP: 44.53% done at 115851 kB/s, finished in 2:17
  DUMP: 46.61% done at 115969 kB/s, finished in 2:11
  DUMP: 48.73% done at 116211 kB/s, finished in 2:06
  DUMP: 50.66% done at 115975 kB/s, finished in 2:01
  DUMP: 52.36% done at 115249 kB/s, finished in 1:58
  DUMP: 54.28% done at 115050 kB/s, finished in 1:53
  DUMP: 56.27% done at 115023 kB/s, finished in 1:48
  DUMP: 58.35% done at 115161 kB/s, finished in 1:43
  DUMP: 60.43% done at 115292 kB/s, finished in 1:38
  DUMP: 62.49% done at 115363 kB/s, finished in 1:33
  DUMP: 64.22% done at 114853 kB/s, finished in 1:29
  DUMP: 65.87% done at 114234 kB/s, finished in 1:25
  DUMP: 67.65% done at 113869 kB/s, finished in 1:21
  DUMP: 69.25% done at 113243 kB/s, finished in 1:17
  DUMP: 70.97% done at 112823 kB/s, finished in 1:13
  DUMP: 72.77% done at 112554 kB/s, finished in 1:09
  DUMP: 74.52% done at 112228 kB/s, finished in 1:04
  DUMP: 76.30% done at 111963 kB/s, finished in 1:00
  DUMP: 78.04% done at 111662 kB/s, finished in 0:56
  DUMP: 79.68% done at 111220 kB/s, finished in 0:52
  DUMP: 81.46% done at 111001 kB/s, finished in 0:47
  DUMP: 83.39% done at 110994 kB/s, finished in 0:42
  DUMP: 84.95% done at 110498 kB/s, finished in 0:38
  DUMP: 86.41% done at 109899 kB/s, finished in 0:35
  DUMP: 87.96% done at 109433 kB/s, finished in 0:31
  DUMP: 89.49% done at 108970 kB/s, finished in 0:27
  DUMP: 91.21% done at 108756 kB/s, finished in 0:23
  DUMP: 93.21% done at 108869 kB/s, finished in 0:17
  DUMP: 95.23% done at 109007 kB/s, finished in 0:12
  DUMP: 97.05% done at 108905 kB/s, finished in 0:07
  DUMP: 98.71% done at 108645 kB/s, finished in 0:03
  DUMP: Closing /mnt/backup/backup-data-home-20140620.102438-0.img
  DUMP: Volume 1 completed at: Fri Jun 20 14:49:09 2014
  DUMP: Volume 1 1716994432 blocks (1676752.38MB)
  DUMP: Volume 1 took 4:24:16
  DUMP: Volume 1 transfer rate: 108286 kB/s
  DUMP: 1716994432 blocks (1676752.38MB) on 1 volume(s)
  DUMP: finished in 15854 seconds, throughput 108300 kBytes/sec
  DUMP: Date of this level 0 dump: Fri Jun 20 10:24:39 2014
  DUMP: Date this dump completed:  Fri Jun 20 14:49:09 2014
  DUMP: Average transfer rate: 108286 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140620.102438-0.toc
  DUMP: DUMP IS DONE
  Logical volume "backup-data-home" successfully removed 

####
#### Exhibit C
####
#### EXT4 - multiple files max 512 GiB
####
# su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password: 
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Sat Jun 21 12:00:26 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140621.120025-0.img001
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1718217407 blocks on 3.20 tape(s).
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140621.120025-0.qfa
  DUMP: Dumping volume 1 on
/mnt/backup/backup-data-home-20140621.120025-0.img001
  DUMP: Volume 1 started with block 1 at: Sat Jun 21 12:00:42 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.64% done at 94129 kB/s, finished in 4:59
  DUMP: 3.35% done at 96074 kB/s, finished in 4:48
  DUMP: 5.23% done at 99826 kB/s, finished in 4:31
  DUMP: 6.88% done at 97657 kB/s, finished in 4:33
  DUMP: 8.84% done at 100622 kB/s, finished in 4:19
  DUMP: 10.41% done at 98807 kB/s, finished in 4:19
  DUMP: 12.09% done at 98448 kB/s, finished in 4:15
  DUMP: 13.85% done at 98746 kB/s, finished in 4:09
  DUMP: 15.65% done at 99248 kB/s, finished in 4:03
  DUMP: 17.30% done at 98760 kB/s, finished in 3:59
  DUMP: 18.71% done at 97100 kB/s, finished in 3:59
  DUMP: 20.00% done at 95147 kB/s, finished in 4:00
  DUMP: 21.30% done at 93573 kB/s, finished in 4:00
  DUMP: 22.72% done at 92703 kB/s, finished in 3:58
  DUMP: 23.99% done at 91372 kB/s, finished in 3:58
  DUMP: 25.18% done at 89908 kB/s, finished in 3:58
  DUMP: 26.47% done at 88963 kB/s, finished in 3:56
  DUMP: 27.66% done at 87791 kB/s, finished in 3:55
  DUMP: 28.79% done at 86590 kB/s, finished in 3:55
  DUMP: 30.20% done at 86291 kB/s, finished in 3:51
  DUMP: Closing /mnt/backup/backup-data-home-20140621.120025-0.img001
  DUMP: Volume 1 completed at: Sat Jun 21 13:45:37 2014
  DUMP: Volume 1 536870912 blocks (524288.00MB)
  DUMP: Volume 1 took 1:44:55
  DUMP: Volume 1 transfer rate: 85285 kB/s
  DUMP: Dumping volume 2 on
/mnt/backup/backup-data-home-20140621.120025-0.img002
  DUMP: Volume 2 started with block 536870913 at: Sat Jun 21 13:45:37 2014
  DUMP: Volume 2 begins with blocks from inode 72884598
  DUMP: 31.35% done at 103402 kB/s, finished in 3:50
  DUMP: 32.72% done at 79585 kB/s, finished in 3:46
  DUMP: 33.86% done at 72674 kB/s, finished in 3:45
  DUMP: 35.17% done at 73506 kB/s, finished in 3:41
  DUMP: 36.64% done at 76084 kB/s, finished in 3:36
  DUMP: 37.99% done at 76331 kB/s, finished in 3:32
  DUMP: 39.34% done at 76531 kB/s, finished in 3:28
  DUMP: 40.59% done at 75612 kB/s, finished in 3:25
  DUMP: 42.05% done at 76594 kB/s, finished in 3:20
  DUMP: 43.44% done at 76949 kB/s, finished in 3:15
  DUMP: 44.67% done at 76327 kB/s, finished in 3:12
  DUMP: 46.06% done at 76613 kB/s, finished in 3:07
  DUMP: 47.41% done at 76573 kB/s, finished in 3:03
  DUMP: 48.79% done at 76742 kB/s, finished in 2:58
  DUMP: 50.11% done at 76661 kB/s, finished in 2:54
  DUMP: 51.20% done at 75751 kB/s, finished in 2:51
  DUMP: 52.38% done at 75231 kB/s, finished in 2:48
  DUMP: 53.53% done at 74696 kB/s, finished in 2:45
  DUMP: 54.91% done at 74892 kB/s, finished in 2:40
  DUMP: 56.25% done at 75005 kB/s, finished in 2:35
  DUMP: 57.56% done at 74987 kB/s, finished in 2:31
  DUMP: 58.97% done at 75267 kB/s, finished in 2:26
  DUMP: 60.28% done at 75223 kB/s, finished in 2:21
  DUMP: 61.66% done at 75385 kB/s, finished in 2:17
  DUMP: Closing /mnt/backup/backup-data-home-20140621.120025-0.img002
  DUMP: Volume 2 completed at: Sat Jun 21 15:44:26 2014
  DUMP: Volume 2 536870912 blocks (524288.00MB)
  DUMP: Volume 2 took 1:58:49
  DUMP: Volume 2 transfer rate: 75308 kB/s
  DUMP: Dumping volume 3 on
/mnt/backup/backup-data-home-20140621.120025-0.img003
  DUMP: Volume 3 started with block 1073741825 at: Sat Jun 21 15:44:26 2014
  DUMP: Volume 3 begins with blocks from inode 73008151
  DUMP: 62.92% done at 70800 kB/s, finished in 2:12
  DUMP: 64.05% done at 66272 kB/s, finished in 2:09
  DUMP: 65.20% done at 65845 kB/s, finished in 2:05
  DUMP: 66.32% done at 65453 kB/s, finished in 2:02
  DUMP: 67.52% done at 66171 kB/s, finished in 1:58
  DUMP: 68.54% done at 64677 kB/s, finished in 1:54
  DUMP: 69.66% done at 64530 kB/s, finished in 1:51
  DUMP: 70.85% done at 65029 kB/s, finished in 1:47
  DUMP: 71.98% done at 65002 kB/s, finished in 1:43
  DUMP: 73.10% done at 64898 kB/s, finished in 1:39
  DUMP: 74.23% done at 64856 kB/s, finished in 1:35
  DUMP: 75.29% done at 64495 kB/s, finished in 1:32
  DUMP: 76.44% done at 64603 kB/s, finished in 1:28
  DUMP: 77.58% done at 64634 kB/s, finished in 1:23
  DUMP: 78.65% done at 64423 kB/s, finished in 1:20
  DUMP: 79.75% done at 64317 kB/s, finished in 1:16
  DUMP: 80.81% done at 64101 kB/s, finished in 1:12
  DUMP: 82.02% done at 64408 kB/s, finished in 1:08
  DUMP: 83.15% done at 64405 kB/s, finished in 1:03
  DUMP: 84.18% done at 64132 kB/s, finished in 1:00
  DUMP: 85.11% done at 63617 kB/s, finished in 0:56
  DUMP: 86.08% done at 63220 kB/s, finished in 0:53
  DUMP: 87.09% done at 62987 kB/s, finished in 0:49
  DUMP: 88.09% done at 62750 kB/s, finished in 0:46
  DUMP: 89.01% done at 62316 kB/s, finished in 0:42
  DUMP: 89.95% done at 61974 kB/s, finished in 0:39
  DUMP: 91.03% done at 61976 kB/s, finished in 0:35
  DUMP: 92.16% done at 62074 kB/s, finished in 0:30
  DUMP: 93.28% done at 62154 kB/s, finished in 0:26
  DUMP: Closing /mnt/backup/backup-data-home-20140621.120025-0.img003
  DUMP: Volume 3 completed at: Sat Jun 21 18:08:21 2014
  DUMP: Volume 3 536870912 blocks (524288.00MB)
  DUMP: Volume 3 took 2:23:55
  DUMP: Volume 3 transfer rate: 62173 kB/s
  DUMP: Dumping volume 4 on
/mnt/backup/backup-data-home-20140621.120025-0.img004
  DUMP: Volume 4 started with block 1610612737 at: Sat Jun 21 18:08:21 2014
  DUMP: Volume 4 begins with blocks from inode 85721100
  DUMP: 94.43% done at 66325 kB/s, finished in 0:21
  DUMP: 95.62% done at 66893 kB/s, finished in 0:17
  DUMP: 96.63% done at 63366 kB/s, finished in 0:13
  DUMP: 97.56% done at 60584 kB/s, finished in 0:09
  DUMP: 98.49% done at 59004 kB/s, finished in 0:05
  DUMP: 99.41% done at 57866 kB/s, finished in 0:02
  DUMP: Closing /mnt/backup/backup-data-home-20140621.120025-0.img004
  DUMP: Volume 4 completed at: Sat Jun 21 18:40:14 2014
  DUMP: Volume 4 107596224 blocks (105074.44MB)
  DUMP: Volume 4 took 0:31:53
  DUMP: Volume 4 transfer rate: 56244 kB/s
  DUMP: 1718208960 blocks (1677938.44MB) on 4 volume(s)
  DUMP: finished in 23972 seconds, throughput 71675 kBytes/sec
  DUMP: Date of this level 0 dump: Sat Jun 21 12:00:26 2014
  DUMP: Date this dump completed:  Sat Jun 21 18:40:14 2014
  DUMP: Average transfer rate: 69752 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140621.120025-0.toc
  DUMP: DUMP IS DONE
  Logical volume "backup-data-home" successfully removed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
