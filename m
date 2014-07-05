From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 78651] Write performance of ext4 degrades linearly as volume
 fills
Date: Sat, 05 Jul 2014 17:14:07 +0000
Message-ID: <bug-78651-13602-lhLQ8A0Chv@https.bugzilla.kernel.org/>
References: <bug-78651-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36709 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045AbaGEROL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 13:14:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 748F32034F
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 17:14:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 47D57202E6
	for <linux-ext4@vger.kernel.org>; Sat,  5 Jul 2014 17:14:07 +0000 (UTC)
In-Reply-To: <bug-78651-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=78651

--- Comment #3 from Joseph D. Wagner <joe@josephdwagner.info> ---
To try to isolate the cause, I reformatted for EXT4 without a journal.  It took
4:57:08, which is 1:30:21 faster than journal=writeback.  The performance is
also in line with XFS -- solid performance until about 60%, then a slow loss.

I think it's reasonable to conclude that the problem is either 1) in the
journal, or 2) exasperated by the journal.  Full details below.

Joseph D. Wagner

####
#### Exhibit D
####
#### EXT4 without a journal
####
#  su -c 'cd /root; nice ionice -c3 /usr/local/bin/lvbackup /dev/data/home
/mnt/backup'
Password: 
  DUMP: mount: bad UUID
  DUMP: Date of this level 0 dump: Fri Jul  4 20:56:18 2014
  DUMP: Dumping /dev/data/backup-data-home (an unlisted file system) to
/mnt/backup/backup-data-home-20140704.205617-0.img
  DUMP: Label: none
  DUMP: Writing 64 Kilobyte records
  DUMP: mapping (Pass I) [regular files]
  DUMP: mapping (Pass II) [directories]
  DUMP: estimated 1683858285 blocks.
  DUMP: writing QFA positions to
/mnt/backup/backup-data-home-20140704.205617-0.qfa
  DUMP: Volume 1 started with block 1 at: Fri Jul  4 20:56:34 2014
  DUMP: dumping (Pass III) [directories]
  DUMP: dumping (Pass IV) [regular files]
  DUMP: 2.07% done at 115916 kB/s, finished in 3:57
  DUMP: 4.06% done at 113802 kB/s, finished in 3:56
  DUMP: 6.16% done at 115264 kB/s, finished in 3:48
  DUMP: 8.22% done at 115393 kB/s, finished in 3:43
  DUMP: 10.22% done at 114721 kB/s, finished in 3:39
  DUMP: 12.24% done at 114460 kB/s, finished in 3:35
  DUMP: 14.13% done at 113336 kB/s, finished in 3:32
  DUMP: 16.08% done at 112677 kB/s, finished in 3:29
  DUMP: 18.06% done at 112519 kB/s, finished in 3:24
  DUMP: 19.92% done at 111700 kB/s, finished in 3:21
  DUMP: 21.74% done at 110805 kB/s, finished in 3:18
  DUMP: 23.41% done at 109263 kB/s, finished in 3:16
  DUMP: 25.23% done at 108728 kB/s, finished in 3:12
  DUMP: 26.88% done at 107565 kB/s, finished in 3:10
  DUMP: 28.76% done at 107411 kB/s, finished in 3:06
  DUMP: 30.24% done at 105899 kB/s, finished in 3:04
  DUMP: 31.88% done at 105088 kB/s, finished in 3:01
  DUMP: 33.34% done at 103814 kB/s, finished in 3:00
  DUMP: 34.70% done at 102363 kB/s, finished in 2:59
  DUMP: 36.17% done at 101378 kB/s, finished in 2:56
  DUMP: 37.71% done at 100673 kB/s, finished in 2:53
  DUMP: 39.44% done at 100494 kB/s, finished in 2:49
  DUMP: 41.38% done at 100855 kB/s, finished in 2:43
  DUMP: 43.05% done at 100558 kB/s, finished in 2:38
  DUMP: 44.90% done at 100692 kB/s, finished in 2:33
  DUMP: 46.76% done at 100787 kB/s, finished in 2:28
  DUMP: 48.71% done at 101101 kB/s, finished in 2:22
  DUMP: 50.25% done at 100583 kB/s, finished in 2:18
  DUMP: 51.99% done at 100462 kB/s, finished in 2:14
  DUMP: 53.77% done at 100449 kB/s, finished in 2:09
  DUMP: 55.59% done at 100497 kB/s, finished in 2:04
  DUMP: 57.36% done at 100404 kB/s, finished in 1:59
  DUMP: 59.07% done at 100261 kB/s, finished in 1:54
  DUMP: 60.89% done at 100320 kB/s, finished in 1:49
  DUMP: 62.66% done at 100288 kB/s, finished in 1:44
  DUMP: 64.16% done at 99842 kB/s, finished in 1:40
  DUMP: 65.73% done at 99529 kB/s, finished in 1:36
  DUMP: 67.26% done at 99174 kB/s, finished in 1:32
  DUMP: 68.50% done at 98419 kB/s, finished in 1:29
  DUMP: 70.10% done at 98196 kB/s, finished in 1:25
  DUMP: 71.73% done at 97990 kB/s, finished in 1:20
  DUMP: 73.28% done at 97734 kB/s, finished in 1:16
  DUMP: 74.80% done at 97447 kB/s, finished in 1:12
  DUMP: 76.43% done at 97252 kB/s, finished in 1:08
  DUMP: 77.87% done at 96884 kB/s, finished in 1:04
  DUMP: 79.49% done at 96739 kB/s, finished in 0:59
  DUMP: 81.09% done at 96596 kB/s, finished in 0:54
  DUMP: 82.91% done at 96708 kB/s, finished in 0:49
  DUMP: 84.45% done at 96502 kB/s, finished in 0:45
  DUMP: 85.60% done at 95864 kB/s, finished in 0:42
  DUMP: 87.12% done at 95659 kB/s, finished in 0:37
  DUMP: 88.67% done at 95490 kB/s, finished in 0:33
  DUMP: 90.15% done at 95260 kB/s, finished in 0:29
  DUMP: 91.97% done at 95387 kB/s, finished in 0:23
  DUMP: 93.62% done at 95328 kB/s, finished in 0:18
  DUMP: 95.20% done at 95216 kB/s, finished in 0:14
  DUMP: 96.63% done at 94950 kB/s, finished in 0:09
  DUMP: 98.19% done at 94824 kB/s, finished in 0:05
  DUMP: 99.64% done at 94595 kB/s, finished in 0:01
  DUMP: Closing /mnt/backup/backup-data-home-20140704.205617-0.img
  DUMP: Volume 1 completed at: Sat Jul  5 01:53:42 2014
  DUMP: Volume 1 1683896576 blocks (1644430.25MB)
  DUMP: Volume 1 took 4:57:08
  DUMP: Volume 1 transfer rate: 94452 kB/s
  DUMP: 1683896576 blocks (1644430.25MB) on 1 volume(s)
  DUMP: finished in 17810 seconds, throughput 94547 kBytes/sec
  DUMP: Date of this level 0 dump: Fri Jul  4 20:56:18 2014
  DUMP: Date this dump completed:  Sat Jul  5 01:53:42 2014
  DUMP: Average transfer rate: 94452 kB/s
  DUMP: Archiving dump to /mnt/backup/backup-data-home-20140704.205617-0.toc
  DUMP: DUMP IS DONE
  Logical volume "backup-data-home" successfully removed

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
