From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET RFC] sched, jbd2: mark sleeps on journal->j_checkpoint_mutex as iowait
Date: Fri, 28 Oct 2016 12:58:08 -0400
Message-ID: <1477673892-28940-1-git-send-email-tj@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com, mingbo@fb.com
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, axboe@kernel.dk,
        tytso@mit.edu, jack@suse.com, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

When there's heavy metadata operation traffic on ext4, the journal
gets filled soon and majority of filesystem users end up blocking on
journal->j_checkpoint_mutex with a stacktrace similar to the
following.

 [<ffffffff8c32e758>] __jbd2_log_wait_for_space+0xb8/0x1d0
 [<ffffffff8c3285f6>] add_transaction_credits+0x286/0x2a0
 [<ffffffff8c32876c>] start_this_handle+0x10c/0x400
 [<ffffffff8c328c5b>] jbd2__journal_start+0xdb/0x1e0
 [<ffffffff8c30ee5d>] __ext4_journal_start_sb+0x6d/0x120
 [<ffffffff8c2d713e>] __ext4_new_inode+0x64e/0x1330
 [<ffffffff8c2e9bf0>] ext4_create+0xc0/0x1c0
 [<ffffffff8c2570fd>] path_openat+0x124d/0x1380
 [<ffffffff8c258501>] do_filp_open+0x91/0x100
 [<ffffffff8c2462d0>] do_sys_open+0x130/0x220
 [<ffffffff8c2463de>] SyS_open+0x1e/0x20
 [<ffffffff8c7ec5b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
 [<ffffffffffffffff>] 0xffffffffffffffff

Because the sleeps on the mutex aren't accounted as iowait, the system
doesn't show the usual signs of being bogged down by IOs - both iowait
and /proc/stat:procs_blocked stay misleadingly low.  While propagation
of iowait through locking constructs is far from being strict, heavy
contention on j_checkpoint_mutex is easy to trigger, obviously iowait
and getting it right can help users in tracking down the issue quite a
bit.

Due to the way io_schedule() is implemented, it currently is hairy to
add an io variant to an existing interface - the schedule() call
itself, which is usually buried deep, should be replaced with
io_schedule().  As we already have current->in_iowait to mark the task
as sleeping for iowait, this can be made easy by breaking up
io_schedule() into multiple steps so that the preparation and marking
can be done before calling an existing interafce and the actual iowait
accounting can be done from inside the scheduler.

What do you think?

This patch contains the following four patches.

 0001-sched-move-IO-scheduling-accounting-from-io_schedule.patch
 0002-sched-separate-out-io_schedule_prepare-and-io_schedu.patch
 0003-mutex-add-mutex_lock_io.patch
 0004-jbd2-use-mutex_lock_io-for-journal-j_checkpoint_mute.patch

0001-0002 implement io_schedule_prepare/finish().
0003 implements mutex_lock_io() using io_schedule_prepare/finish().
0004 uses mutex_lock_io() on journal->j_checkpoint_mutex.

This patchset is also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-mutex_lock_io

Thanks, diffstat follows.

 fs/jbd2/commit.c       |    2 -
 fs/jbd2/journal.c      |   14 ++++++-------
 include/linux/mutex.h  |    4 +++
 include/linux/sched.h  |    8 ++-----
 kernel/locking/mutex.c |   24 ++++++++++++++++++++++
 kernel/sched/core.c    |   52 +++++++++++++++++++++++++++++++++++++------------
 6 files changed, 79 insertions(+), 25 deletions(-)

--
tejun
