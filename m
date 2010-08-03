From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 0/3] *** SUBJECT HERE ***
Date: Tue,  3 Aug 2010 12:01:52 -0400
Message-ID: <1280851315-9167-1-git-send-email-tytso@mit.edu>
Cc: John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47588 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab0HCSgY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Aug 2010 14:36:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The first patch in this patch series hasn't changed since when I had
last posted it, but I'm including it again for the benefit of the folks
on ocfs2-dev.

Thanks to some work done by Eric Whitney, when he accidentally ran the
command "mkfs.ext4 -t xfs", and created a ext4 file system without a
journal, it appears that main scalability bottleneck for ext4 is in the
jbd2 layer.  In fact, his testing on a 48-core system shows that on some
workloads, ext4 is roughly comparable with XFS!

The lockstat results indicate that the main bottlenecks are in the
j_state_lock and t_handle_lock, especially in start_this_handle() in
fs/jbd2/transaction.c.  A previous patch, which removed an unneeded
grabbing of j_state_lock jbd2_journal_stop() relieved pressure on that
lock and was noted to make a significant difference for dbench on a
kernel with CONFIG_PREEMPT_RT enabled, as well as on a 48-core AMD
system from HP.   This patch is already in 2.6.35, and the benchmark
results can be found here: http://free.linux.hp.com/~enw/ext4/2.6.34/

This patch series removes all exclusive spinlocks when starting and
stopping jbd2 handles, which should improve things even more.  Since
OCFS2 uses the jbd2 layer, and the second patch in this patch series
touches ocfs2 a wee bit, I'd appreciate it if you could take a look and
let me know what you think.  Hopefully, this should also improve OCFS2's
scalability.

Best regards,

     					- Ted

Theodore Ts'o (3):
  jbd2: Use atomic variables to avoid taking t_handle_lock in
    jbd2_journal_stop
  jbd2: Change j_state_lock to be a rwlock_t
  jbd2: Remove t_handle_lock from start_this_handle()

 fs/ext4/inode.c       |    4 +-
 fs/ext4/super.c       |    4 +-
 fs/jbd2/checkpoint.c  |   18 +++---
 fs/jbd2/commit.c      |   42 +++++++-------
 fs/jbd2/journal.c     |   94 +++++++++++++++----------------
 fs/jbd2/transaction.c |  149 ++++++++++++++++++++++++++++---------------------
 fs/ocfs2/journal.c    |    4 +-
 include/linux/jbd2.h  |   12 ++--
 8 files changed, 174 insertions(+), 153 deletions(-)

