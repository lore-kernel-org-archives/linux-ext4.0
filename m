From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Fri, 20 Jun 2014 16:59:09 -0700
Message-ID: <ffadba9d394934f8708bd7070419b5d8@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, adilger@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:46716 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaFTX4d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Jun 2014 19:56:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I think I can prove it's the file system.  I reformatted for XFS, and 
the
results speak for themselves.

XFS is able to complete the backup in 4:24:16, whereas EXT4 takes 
6:27:29.
This difference cannot be explained by the location of the sectors on 
the
disk; nor is caching of free sector maps sufficient to explain a 33%
difference is overall performance.

XFS does not dip below 115 mB/s until 64.22%.  Even then, the loss in
minimal so that performance never drops below 108 mB/s (6% loss).
EXT4, on the other hand, drops below 115 mB/s at 21.72%.  Performance
continues to drop precipitously until reaching 74 mB/s (35% loss).

EXT4 is *doing* *something* to cause a recursive loss in performance.

Joseph D. Wagner

This is xfs.

# su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup 
/dev/data/home /mnt/backup'
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
   DUMP: Archiving dump to 
/mnt/backup/backup-data-home-20140620.102438-0.toc
   DUMP: DUMP IS DONE
   Logical volume "backup-data-home" successfully removed


This is ext4.

# su -c 'cd /root; dumpe2fs /dev/mapper/backup > /dev/null; nice ionice 
-c3 /usr/local/bin/lvbackup /dev/data/home /mnt/backup'
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
   DUMP: Archiving dump to 
/mnt/backup/backup-data-home-20140616.200856-0.toc
   DUMP: DUMP IS DONE
   Logical volume "backup-data-home" successfully removed
