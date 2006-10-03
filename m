From: linux@horizon.com
Subject: e2fsck 1.39 bug report
Date: 2 Oct 2006 20:40:44 -0400
Message-ID: <20061003004044.22788.qmail@science.horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:49959 "HELO
	science.horizon.com") by vger.kernel.org with SMTP id S965548AbWJCAku
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Oct 2006 20:40:50 -0400
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Yes, an actual bug.  e2fsck 1.39, taken from Debian binary e2fsprogs_1.39-1.

I had a drive eat itself in a new and interesting way, which corrupted the
first batch of inodes on the disk, leading to losing the root directry
and much gnashing of teeth.  All of the top-level directories ended up
attached under /lost+found.

(I'm a little mystified HOW this happened in the first place, given
that the system has mirrored drives, ext3 journaling, and ECC RAM, but
I neglected to have the logs go to a separate machine, so the history
of what happened after the hard drive started erroring is murky.
I suspect it wrote data to the wrong place.)

Anyway, after some ext2fs runs, I got a clean file system.  Before
starting on the nasty work of piecing together the system from what got
dumped in lost+found and the last backup, I ran e2fsck one more time
(with -f) just to be sure, and got a dozen of these:

Pass 2: Checking directory structure
Entry '..' in /lost+found/#4563658/1148529338.15087.science/usr/src/linux-2.6/ipc/.sem.o.cmd (1203943) has an incorrect filetype (was 1, should be 2)
Fix<y>? yes
Entry '..' in /lost+found/#4563658/1148490363.19043.science (4563661) has an incorrect filetype (was 1, should be 2)
Fix<y>? yes
Entry '..' in /lost+found/#4563658 (4563658) has an incorrect filetype (was 1, should be 2)
Fix<y>?

Note that the maildir file (with all the numbers) and .sem.o.cmd were both
originally files before this mess, but they got turned into directories.

I should have thought to e2image the file system before attempting
repair, but I didn't realize how bad it was going to be before I got
into it; sorry.

Not too big a deal, but I think a file system is not supposed to be marked
clean while containing detectable errors.


Two e2fsck feature requests:
1) A way to save a log of actions to a file.  If I can mount a tmpfs somewhere, or
   reformat a swap partition, I can use the list to see what needs to be restored from
   backup.
2) A way to say, in response to an interactive prompt, "yes, and fix all
   future problems of this type as well."  I'm quite happy to skip over
   dtime, and free block count problems, but I'd like to examine inodes
   getting cleared a little more carefully.
