From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 0/3] jbd2 scalability patches
Date: Wed,  4 Aug 2010 12:39:14 -0400
Message-ID: <1280939957-3277-1-git-send-email-tytso@mit.edu>
Cc: John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46666 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505Ab0HDQjS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 12:39:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This version fixes three bugs in the 2nd patch of this series that
caused kernel BUG when the system was under race.  We weren't accounting
with t_oustanding_credits correctly, and there were race conditions
caused by the fact the I had overlooked the fact that
__jbd2_log_wait_for_space() and jbd2_get_transaction() requires
j_state_lock to be write locked.

Theodore Ts'o (3):
  jbd2: Use atomic variables to avoid taking t_handle_lock in
    jbd2_journal_stop
  jbd2: Change j_state_lock to be a rwlock_t
  jbd2: Remove t_handle_lock from start_this_handle()

 fs/ext4/inode.c       |    4 +-
 fs/ext4/super.c       |    4 +-
 fs/jbd2/checkpoint.c  |   18 +++---
 fs/jbd2/commit.c      |   42 ++++++------
 fs/jbd2/journal.c     |   94 +++++++++++++--------------
 fs/jbd2/transaction.c |  172 ++++++++++++++++++++++++++++---------------------
 fs/ocfs2/journal.c    |    4 +-
 include/linux/jbd2.h  |   12 ++--
 8 files changed, 188 insertions(+), 162 deletions(-)

