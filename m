From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Thu, 06 Nov 2008 18:06:16 -0500
Message-ID: <E1KyDvc-0007hT-I6@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46228 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751175AbYKFXGS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 18:06:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab some bug fixes and regressions for ext4.  Thanks!!

                                                - Ted

Aneesh Kumar K.V (2):
      ext4: fix missing ext4_unlock_group in error path
      ext4: Convert to host order before using the values.

Sami Liedes (1):
      jbd2: deregister proc on failure in jbd2_journal_init_inode

Theodore Ts'o (4):
      jbd: don't give up looking for space so easily in __log_wait_for_space
      jbd2: don't give up looking for space so easily in __jbd2_log_wait_for_space
      ext4: wait on all pending commits in ext4_sync_fs()
      ext4: calculate journal credits correctly

 fs/ext4/inode.c      |    5 +++--
 fs/ext4/mballoc.c    |    1 +
 fs/ext4/super.c      |   24 ++++++++++--------------
 fs/jbd/checkpoint.c  |   31 ++++++++++++++++++++++++-------
 fs/jbd2/checkpoint.c |   32 +++++++++++++++++++++++++-------
 fs/jbd2/journal.c    |    2 ++
 6 files changed, 65 insertions(+), 30 deletions(-)
