From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Improve orphan list scaling
Date: Thu, 15 May 2014 22:17:04 +0200
Message-ID: <1400185026-3972-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56278 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaEOURP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2014 16:17:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  this is my version of patches to improve orphan list scaling by
reducing amount of work done under global s_orphan_mutex. We are
in disagreement with Thavatchai whose patches are better (see thread
http://www.spinics.net/lists/linux-ext4/msg43220.html) so I guess it's
up to Ted or other people on this list to decide.

When running code stressing orphan list operations [1] with these
patches, I see s_orphan_lock to move from number 1 in lock_stat report
to unmeasurable. So with the patches there are other much more
problematic locks (superblock buffer lock and bh_state lock,
j_list_lock, buffer locks for inode buffers when several inodes share a
block...). The average times for 10 runs for the test program to run on my
48-way box with ext4 on ramdisk are:
	Vanilla				Patched
Procs	Avg		Stddev		Avg		Stddev
 1	  2.769200	0.056194	2.890700	0.061727
 2	  5.756500	0.313268	4.383500	0.161629
 4	 11.852500	0.130221	6.542900	0.160039
10	 33.590900	0.394888	27.749500	0.615517
20	 71.035400	0.320914	76.368700	3.734557
40	236.671100	2.856885	228.236800	2.361391

So we can see the biggest speedup was for 2, 4, and 10 threads. For
higher thread counts the contention and cache bouncing prevented any
significant speedup (we can even see a barely-out-of-noise performance
drop for 20 threads). 

Changes since v2:
* Fixed up various bugs in error handling pointed out by Thavatchai and
  some others as well
* Somewhat reduced critical sections under s_orphan_lock

[1] The test program runs given number of processes, each process is
truncating a 4k file by 1 byte until it reaches 1 byte size and then the
file is extended to 4k again.

								Honza
