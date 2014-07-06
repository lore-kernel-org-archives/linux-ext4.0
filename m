From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Sun, 06 Jul 2014 12:52:41 +0000
Message-ID: <bug-78651-13602-iN2fYfBfvx@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51490 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaGFMwp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Jul 2014 08:52:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 51D3620265
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 12:52:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id B0CC320266
	for <linux-ext4@vger.kernel.org>; Sun,  6 Jul 2014 12:52:41 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #4 from Joseph D. Wagner <joe@josephdwagner.info> ---
Another piece to this puzzle.  I added a journal but mounted with nodelalloc. 
Performance was about 42 mB/s (36%) worse than without a journal.  Does delayed
allocation work without a journal?

Joseph D. Wagner

####
#### Exhibit E
####
#### EXT4 nodelalloc (journal=writeback)
####
#  su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password: 
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Sat Jul  5 22:32:02 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140705.223201-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1681821740 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140705.223201-0.qfa
  DUMP: Volume 1 started with block 1 at: Sat Jul  5 22:32:19 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 1.31% done at 73586 kB/s, finished in 6:15
  DUMP: 2.70% done at 75693 kB/s, finished in 6:00
  DUMP: 4.07% done at 75953 kB/s, finished in 5:54
  DUMP: 5.48% done at 76649 kB/s, finished in 5:45
  DUMP: 6.95% done at 77753 kB/s, finished in 5:35
  DUMP: 8.46% done at 78880 kB/s, finished in 5:25
  DUMP: 10.04% done at 80296 kB/s, finished in 5:14
  DUMP: 11.55% done at 80829 kB/s, finished in 5:06
  DUMP: 12.99% done at 80580 kB/s, finished in 5:02
  DUMP: 14.50% done at 80968 kB/s, finished in 4:56
  DUMP: 15.98% done at 81181 kB/s, finished in 4:50
  DUMP: 17.25% done at 80318 kB/s, finished in 4:48
  DUMP: 18.47% done at 79445 kB/s, finished in 4:47
  DUMP: 19.74% done at 78843 kB/s, finished in 4:45
  DUMP: 20.97% done at 78122 kB/s, finished in 4:43
  DUMP: 22.18% done at 77472 kB/s, finished in 4:41
  DUMP: 23.32% done at 76680 kB/s, finished in 4:40
  DUMP: 24.56% done at 76288 kB/s, finished in 4:37
  DUMP: 25.79% done at 75880 kB/s, finished in 4:34
  DUMP: 26.82% done at 74889 kB/s, finished in 4:33
  DUMP: 27.95% done at 74327 kB/s, finished in 4:31
  DUMP: 29.05% done at 73752 kB/s, finished in 4:29
  DUMP: 30.06% done at 73005 kB/s, finished in 4:28
  DUMP: 31.29% done at 72833 kB/s, finished in 4:24
  DUMP: 32.43% done at 72439 kB/s, finished in 4:21
  DUMP: 33.71% done at 72335 kB/s, finished in 4:16
  DUMP: 35.02% done at 72379 kB/s, finished in 4:11
  DUMP: 36.28% done at 72291 kB/s, finished in 4:07
  DUMP: 37.52% done at 72184 kB/s, finished in 4:02
  DUMP: 38.73% done at 72045 kB/s, finished in 3:58
  DUMP: 39.93% done at 71853 kB/s, finished in 3:54
  DUMP: 41.22% done at 71815 kB/s, finished in 3:49
  DUMP: 42.48% done at 71726 kB/s, finished in 3:44
  DUMP: 43.71% done at 71612 kB/s, finished in 3:40
  DUMP: 44.97% done at 71594 kB/s, finished in 3:35
  DUMP: 46.16% done at 71404 kB/s, finished in 3:31
  DUMP: 47.46% done at 71436 kB/s, finished in 3:26
  DUMP: 48.62% done at 71273 kB/s, finished in 3:22
  DUMP: 49.63% done at 70838 kB/s, finished in 3:19
  DUMP: 50.62% done at 70453 kB/s, finished in 3:16
  DUMP: 51.67% done at 70170 kB/s, finished in 3:13
  DUMP: 52.74% done at 69937 kB/s, finished in 3:09
  DUMP: 53.89% done at 69806 kB/s, finished in 3:05
  DUMP: 54.98% done at 69580 kB/s, finished in 3:01
  DUMP: 56.13% done at 69420 kB/s, finished in 2:57
  DUMP: 57.21% done at 69230 kB/s, finished in 2:53
  DUMP: 58.37% done at 69147 kB/s, finished in 2:48
  DUMP: 59.45% done at 68962 kB/s, finished in 2:44
  DUMP: 60.57% done at 68834 kB/s, finished in 2:40
  DUMP: 61.64% done at 68662 kB/s, finished in 2:36
  DUMP: 62.58% done at 68354 kB/s, finished in 2:33
  DUMP: 63.62% done at 68164 kB/s, finished in 2:29
  DUMP: 64.71% done at 68023 kB/s, finished in 2:25
  DUMP: 65.79% done at 67893 kB/s, finished in 2:21
  DUMP: 66.89% done at 67774 kB/s, finished in 2:16
  DUMP: 67.91% done at 67586 kB/s, finished in 2:13
  DUMP: 68.95% done at 67427 kB/s, finished in 2:09
  DUMP: 70.08% done at 67319 kB/s, finished in 2:04
  DUMP: 71.22% done at 67244 kB/s, finished in 1:59
  DUMP: 72.32% done at 67147 kB/s, finished in 1:55
  DUMP: 73.36% done at 67006 kB/s, finished in 1:51
  DUMP: 74.43% done at 66891 kB/s, finished in 1:47
  DUMP: 75.52% done at 66776 kB/s, finished in 1:42
  DUMP: 76.58% done at 66641 kB/s, finished in 1:38
  DUMP: 77.67% done at 66555 kB/s, finished in 1:34
  DUMP: 78.66% done at 66390 kB/s, finished in 1:30
  DUMP: 79.71% done at 66275 kB/s, finished in 1:25
  DUMP: 80.81% done at 66207 kB/s, finished in 1:21
  DUMP: 81.95% done at 66148 kB/s, finished in 1:16
  DUMP: 83.01% done at 66054 kB/s, finished in 1:12
  DUMP: 84.03% done at 65931 kB/s, finished in 1:07
  DUMP: 84.90% done at 65691 kB/s, finished in 1:04
  DUMP: 85.88% done at 65541 kB/s, finished in 1:00
  DUMP: 86.85% done at 65398 kB/s, finished in 0:56
  DUMP: 87.81% done at 65240 kB/s, finished in 0:52
  DUMP: 88.83% done at 65074 kB/s, finished in 0:48
  DUMP: 89.79% done at 64922 kB/s, finished in 0:44
  DUMP: 90.84% done at 64848 kB/s, finished in 0:39
  DUMP: 91.94% done at 64805 kB/s, finished in 0:34
  DUMP: 93.02% done at 64688 kB/s, finished in 0:30
  DUMP: 94.06% done at 64605 kB/s, finished in 0:25
  DUMP: 95.10% done at 64518 kB/s, finished in 0:21
  DUMP: 96.11% done at 64418 kB/s, finished in 0:16
  DUMP: 97.07% done at 64296 kB/s, finished in 0:12
  DUMP: 97.98% done at 64133 kB/s, finished in 0:08
  DUMP: 98.93% done at 64006 kB/s, finished in 0:04
  DUMP: 99.78% done at 63799 kB/s, finished in 0:00
  DUMP: Closing /mnt/backup/backup-data-home-20140705.223201-0.img
  DUMP: Volume 1 completed at: Sun Jul  6 05:52:02 2014
  DUMP: Volume 1 1681955840 blocks (1642535.00MB)
  DUMP: Volume 1 took 7:19:43
  DUMP: Volume 1 transfer rate: 63751 kB/s
  DUMP: 1681955840 blocks (1642535.00MB) on 1 volume(s)
  DUMP: finished in 26383 seconds, throughput 63751 kBytes/sec
  DUMP: Date of this level 0 dump: Sat Jul  5 22:32:02 2014
  DUMP: Date this dump completed:  Sun Jul  6 05:52:02 2014
  DUMP: Average transfer rate: 63751 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140705.223201-0.toc
  DUMP: DUMP IS DONE
  Logical volume "backup-data-home" successfully removed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
