From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/4] Backports of jbd2 commits to jbd
Date: Thu, 1 Aug 2013 15:01:04 -0400
Message-ID: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The following commits exist in jbd2, and the backport to jbd is
relatively straightforward.  In doing so we make the debug enable
interface consistent between jbd and jbd2.

For testing, I've booted up a machine with ext3 fs, done some basic
operations (update a git tree, build a kernel) and also ensured that
enabling debug via the new /sys/module/jbd/parameters/ entry works.
Testing was on a baseline of v3.10-rc1-39-g741ddbc.

Paul.
---

Paul Gortmaker (4):
  jbd: use module parameters instead of debugfs for jbd_debug
  jbd: relocate assert after state lock in journal_commit_transaction()
  jbd: drop checkpoint mutex when waiting in __log_wait_for_space()
  jbd: use a single printk for jbd_debug()

 fs/jbd/Kconfig      |  6 ++---
 fs/jbd/checkpoint.c |  8 +++++++
 fs/jbd/commit.c     |  2 +-
 fs/jbd/journal.c    | 67 +++++++++++++++++++++--------------------------------
 include/linux/jbd.h | 20 +++++++---------
 5 files changed, 46 insertions(+), 57 deletions(-)

-- 
1.8.1.2
