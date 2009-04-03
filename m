From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] Ext3 latency fixes
Date: Fri,  3 Apr 2009 03:01:03 -0400
Message-ID: <1238742067-30814-1-git-send-email-tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: torvalds@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36442 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZDCHBL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Apr 2009 03:01:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus, 

Please pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes

I posted these patches a while back, and with your "overwrite.c" test
case, I decided to see how they did.  The results were spectacular
enough (see below) that I've decided to request that they be included
in 2.6.30.  I've posted the critical patches below for review before,
and Jan Kara has acked them, and there have been no complaints about
them.

I've also added two patches which add replace-via-truncate and
replace-via-rename workarounds to ext3's data=writeback mode.  They
only change the behavior in the (currently non-default) data=writeback
mode.

The benchmark which I used was Linus's overwrite.c as the background
workload, and my fsync-tester as the foreground tester.  The
fsync-tester writes a megabyte to a file and then times how long it
takes to fsync that file, and then sleeps a second before repeating.

Using an unpatched 2.6.29, fsync-tester shows the following times:

fsync time: 3.4732
fsync time: 2.4338
fsync time: 5.9496
fsync time: 6.2402
fsync time: 4.3375
fsync time: 6.3283
fsync time: 3.6930
fsync time: 3.1848
fsync time: 3.3231

The final report of overwrite.c is:

       1.984 GB written in 82.75 (24 MB/s)           

With these patches applied, the fsync-tester times are:

fsync time: 1.4538
fsync time: 1.6328
fsync time: 1.4632
fsync time: 1.4550
fsync time: 0.2932
fsync time: 1.6986
fsync time: 0.3787
fsync time: 1.3380
fsync time: 1.8145
fsync time: 0.4050
fsync time: 1.3880

... and the final report of overwrite.c is:

       1.984 GB written in 93.77 (21 MB/s)           

By having the fsync-related I/O fixed to be posted using WRITE_SYNC,
instead of WRITE, it prioritizes the fsync-related I/O so that it gets
done ahead of the streaming write.  This does slow down the background
write process, but it speeds up the worst-case fsync() latency from
6.2 seconds to 1.8 seconds.  (Measurements done on a 5400 rpm laptop
drive.)

All aside from the benchmark improvements, if the writes are coming
from fsync(), they really are synchronous operations, and they should
be marked that way just from a correctness point of view.

	       		 	       	    - Ted

Theodore Ts'o (4):
      block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
      ext3: Use WRITE_SYNC for commits which are caused by fsync()
      ext3: Add replace-on-truncate hueristics for data=writeback mode
      ext3: Add replace-on-rename hueristics for data=writeback mode

 fs/buffer.c             |    5 +++--
 fs/ext3/file.c          |    4 ++++
 fs/ext3/inode.c         |    3 +++
 fs/ext3/namei.c         |    6 +++++-
 fs/jbd/commit.c         |   23 +++++++++++++++--------
 fs/jbd/transaction.c    |    2 ++
 include/linux/ext3_fs.h |    1 +
 include/linux/jbd.h     |    5 +++++
 8 files changed, 38 insertions(+), 11 deletions(-)




