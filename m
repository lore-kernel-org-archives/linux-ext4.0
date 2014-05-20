From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v3] Improve orphan list scaling
Date: Tue, 20 May 2014 14:45:47 +0200
Message-ID: <1400589949-25595-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaETMp4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 08:45:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  here is another version of my patches to improve orphan list scaling by
reducing amount of work done under global s_orphan_mutex. Since previous
version I've fixed some bugs (thanks Thavatchai!), retested with updated
xfstests to verify the problem Ted has spotted is fixed, and rerun the
performance tests because the bugs had a non-trivial impact on the
functionality.

To stress orphan list operations I run my artifical test program.  The test
program runs given number of processes, each process is truncating a 4k file
by 1 byte until it reaches 1 byte size and then the file is extended to 4k
again.

The average times for 10 runs for the test program to run on my 48-way box
with ext4 on ramdisk are:
	Vanilla				Patched
Procs	Avg		Stddev		Avg			Stddev
 1	  2.769200	0.056194	2.750000 (-0.6%)	0.054772
 2	  5.756500	0.313268	5.669000 (-1.5%)	0.587528
 4	 11.852500	0.130221	8.311000 (-29.9%)	0.257544
10	 33.590900	0.394888	20.162000 (-40%)	0.189832
20	 71.035400	0.320914	55.854000 (-21.4%)	0.478815
40	236.671100	2.856885	174.543000 (-26.3%)	0.974547

In the lockstat reports, s_orphan_mutex has been #1 in both cases however
the patches significanly reduced the contention. For 10 threads the numbers
look like:

         con-bounces contentions waittime-min waittime-max waittime-total
Orig         7089335     7089335         9.07   3504220.69  1473754546.28
Patched      2547868     2547868         9.18      8218.64   547550185.12

         waittime-avg acq-bounces acquisitions holdtime-min holdtime-max
Orig           207.88    14487647     16381236         0.16       211.62
Patched        214.91     7994533      8191236         0.16       203.81

         holdtime-total holdtime-avg
Orig        79738146.84         4.87
Patched     30660307.81         3.74

We can see the number of acquisitions dropped to a half (we now check
whether inode already is / is not part of the orphan list before acquiring
s_orphan_mutex). The average hold time is somewhat smaller as well and given
that the patched kernel doesn't have those 50% of short lived aquisitions
just for checking whether the inode is part of the orphan list, we can see
that the patched kernel really does significanly less work with s_orphan_lock
held.

Changes since v2:
* Fixed bug in ext4_orphan_del() leading to orphan list corruption - thanks
  to Thavatchai for pointing that out.
* Fixed bug in ext4_orphan_del() that could lead to using freed inodes

Changes since v1:
* Fixed up various bugs in error handling pointed out by Thavatchai and
  some others as well
* Somewhat reduced critical sections under s_orphan_lock

								Honza
