From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2 0/6] misc jbd2 fixes and cleanups
Date: Tue, 11 Jun 2013 18:44:24 -0400
Message-ID: <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:47992 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3FKWpL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 18:45:11 -0400
In-Reply-To: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a series of commits that came about while researching a problem
on a preempt-rt kernel.  The RT problem seems tied to the function
jbd2_journal_commit_transaction, hence the common theme/location in
this series.

That said, it turns out that there is nothing in these commits that is
specific to RT, so they were reviewed with the aim to mainline them
(and also continue to research the RT problem...)

Once these have been placed in a non-rebased branch with fixed commit
IDs, I'll submit ext3/jbd versions of the same where appropriate.

Testing has involved ensuring jbd_debug still works (with the newly
documented non-debugfs module param) and also with a largely parallel
yocto build running concurrently with a large "rm -rf" (i.e. the test
that has been problematic on 3.4.x/3.6.x preempt-rt kernels).

Thanks,
Paul.

---

Changes since v1:
  --assert after state lock is now a standalone/separate commit
  --add jbd2-only va_args patch for jbd_debug in manner suggested by Ted
  --fix log_wait_for_space patch to avoid extra mutex lock/unlock
  --add new patch to fix stale data/dependency in jbd2/Kconfig


The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git jbd2-fixes

for you to fetch changes up to 26a48f70423cc58f5fbaf1d8fcd703e8bd455aef:

  jbd2: remove debug dependency on debug_fs; update help text (2013-06-11 17:58:42 -0400)

----------------------------------------------------------------
Paul Gortmaker (6):
      jbd2/journal_commit_transaction: relocate assert after state lock
      jbd2/log_wait_for_space: drop checkpoint mutex when waiting
      jbd2: fix duplicate debug label for phase 2
      jbd/jbd2: relocate bit_spinlock header to jbd_common
      jbd2: make jbd_debug that won't split printk statements
      jbd2: remove debug dependency on debug_fs; update help text

 fs/jbd2/Kconfig            |  6 +++---
 fs/jbd2/checkpoint.c       |  8 ++++++++
 fs/jbd2/commit.c           |  6 +++---
 fs/jbd2/journal.c          | 17 +++++++++++++++++
 include/linux/jbd.h        |  1 -
 include/linux/jbd2.h       | 15 +++++----------
 include/linux/jbd_common.h |  2 ++
 7 files changed, 38 insertions(+), 17 deletions(-)
