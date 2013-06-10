From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC PATCH 0/4] ext4/jbd2: several possible mainline fixes
Date: Mon, 10 Jun 2013 15:31:59 -0400
Message-ID: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:43151 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3FJTcS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Jun 2013 15:32:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been trying to diagnose a problem where ext4 can't be reliably
used under preempt-rt kernels.  While I've not solved that yet, I
have found two things that look to me to be possible issues that
could also impact mainline (and two cosmetic fixes), so I'm sending
them here to see if they make sense to others who are more familiar
with filesystem code than I am.  At the moment, I can't see why the
issues I've identified here couldn't happen on mainline/non-RT.
The series attached here was build/boot tested on v3.10-rc5.

[ -- stop reading here if you don't care about how ext4 fails on RT -- ]

With respect to the RT problem, it looks like I'm seeing a stall
in jbd2_journal_commit_transaction() in the jbd2 thread, and then
everything else piles up behind that.   The stall looks like this:

[ 1593.701664] jbd2/sda1-8     D ffff880223c758c0  4832  1214      2 0x00000000
[ 1593.701668]  ffff88021ff97b10 0000000000000046 ffff88021ff97ac0 ffffffff8106e8f1
[ 1593.701669]  ffff880223c75500 ffff88021ff97fd8 ffff88021ff97fd8 ffff88021ff97fd8
[ 1593.701670]  ffffffff81c16440 ffff880223c75500 ffff88021ff97ae0 ffff880223c75500
[ 1593.701671] Call Trace:
[ 1593.701673]  [<ffffffff8106e8f1>] ? get_parent_ip+0x11/0x50
[ 1593.701674]  [<ffffffff810e9560>] ? __lock_page+0x70/0x70
[ 1593.701676]  [<ffffffff8172dc34>] schedule+0x24/0x70
[ 1593.701677]  [<ffffffff8172dd0a>] io_schedule+0x8a/0xd0
[ 1593.701678]  [<ffffffff810e9569>] sleep_on_page+0x9/0x10
[ 1593.701679]  [<ffffffff8172cba8>] __wait_on_bit+0x58/0x90
[ 1593.701680]  [<ffffffff810e9ca9>] ? find_get_pages_tag+0x109/0x190
[ 1593.701681]  [<ffffffff810e9688>] wait_on_page_bit+0x78/0x80
[ 1593.701682]  [<ffffffff810603d0>] ? autoremove_wake_function+0x40/0x40
[ 1593.701684]  [<ffffffff810e9a39>] filemap_fdatawait_range+0xf9/0x190
[ 1593.701685]  [<ffffffff812c4451>] ? submit_bio+0x71/0xe0
[ 1593.701686]  [<ffffffff8106e8f1>] ? get_parent_ip+0x11/0x50
[ 1593.701687]  [<ffffffff8103f125>] ? unpin_current_cpu+0x15/0x80
[ 1593.701689]  [<ffffffff810e9aef>] filemap_fdatawait+0x1f/0x30
[ 1593.701691]  [<ffffffff81220c34>] jbd2_journal_commit_transaction+0xb14/0x1c20
[ 1593.701692]  [<ffffffff81226b91>] kjournald2+0xc1/0x270

Using jbd_debug() it seems that I end up with jbd2_log_do_checkpoint
and jbd2_journal_commit_transaction running into each other.  In one of
my attached patches, I show they overlap to the point of interrupting
each others jbd_debug messages.  Maybe that doesn't matter?  Here is a
typical debug trace with time stamps:

[  695.229129] (fs/jbd2/journal.c, 495): __jbd2_log_start_commit: JBD2: requesting commit 42331/42330
[  695.229141] (fs/jbd2/journal.c, 203): kjournald2: kjournald2 wakes
[  695.229145] (fs/jbd2/journal.c, 211): kjournald2: woke because of timeout
[  695.229147] (fs/jbd2/journal.c, 155): kjournald2: commit_sequence=42330, commit_request=42331
[  695.229150] (fs/jbd2/journal.c, 158): kjournald2: OK, requests differ
[  695.229158] (fs/jbd2/commit.c, 372): jbd2_journal_commit_transaction: JBD2: starting commit of transaction 42331
[  695.229164] (fs/jbd2/journal.c, 495): __jbd2_log_start_commit: JBD2: requesting commit 42331/42330
[  695.243653] (fs/jbd2/journal.c, 495): __jbd2_log_start_commit: JBD2: requesting commit 42331/42330
[  695.247738] (fs/jbd2/checkpoint.c, 345): jbd2_log_do_checkpoint: Start checkpoint
[  695.247749] (fs/jbd2/checkpoint.c, 354): jbd2_log_do_checkpoint: cleanup_journal_tail returned 1
[  695.248917] (fs/jbd2/journal.c, 648): jbd2_log_wait_commit: JBD2: want 42331, j_commit_sequence=42330
[  695.265162] (fs/jbd2/revoke.c, 566): jbd2_journal_write_revoke_records: Wrote 10 revoke records
        <filesystem now dead for writes>

Notice that we never got the expected message:

  "jbd2_journal_commit_transaction: JBD2: commit 42331 complete"

Stuck waiting/spinning somewhere in jbd2_journal_commit_transaction.
As near as I can tell, it never got to phase 3 of commit_transaction.

Since jbd2_journal_commit_transaction is such a large function,
I'm tempted to break it up some, just to ease my debugging (compare
0x1c20 to the smaller numbers around it).  Perhaps there would be
interest in such kinds of patches for mainline?

Thanks,
Paul.
---

Paul Gortmaker (4):
  jbd2/journal_commit_transaction: relocate state lock to incorporate
    all users
  jbd2/log_wait_for_space: drop checkpoint mutex when waiting
  jbd2: fix duplicate debug label for phase 2
  jbd/jbd2: relocate bit_spinlock header to jbd_common

 fs/jbd2/checkpoint.c       | 7 +++++++
 fs/jbd2/commit.c           | 7 ++++---
 include/linux/jbd.h        | 1 -
 include/linux/jbd2.h       | 1 -
 include/linux/jbd_common.h | 2 ++
 5 files changed, 13 insertions(+), 5 deletions(-)

-- 
1.8.1.2

