From: Theodore Tso <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Sun, 15 Feb 2009 21:56:11 -0500
Message-ID: <20090216025611.GB22619@mini-me.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37199 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZBPC4f (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2009 21:56:35 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab regression and critical bug fixes for ext4.  Thanks!!

                                           - Ted

Aneesh Kumar K.V (3):
      ext4: Fix lockdep warning
      ext4: Initialize preallocation list_head's properly
      ext4: Implement range_cyclic in ext4_da_writepages instead of write_cache_pages

Dan Carpenter (1):
      ext4: Fix NULL dereference in ext4_ext_migrate()'s error handling

Jan Kara (3):
      jbd2: Fix return value of jbd2_journal_start_commit()
      Revert "ext4: wait on all pending commits in ext4_sync_fs()"
      jbd2: Avoid possible NULL dereference in jbd2_journal_begin_ordered_truncate()

Wei Yongjun (1):
      ext4: Fix to read empty directory blocks correctly in 64k

 fs/ext4/ext4.h        |    2 +-
 fs/ext4/inode.c       |   27 +++++++++++++++++++++++----
 fs/ext4/mballoc.c     |   32 +++++++++++++++++++-------------
 fs/ext4/migrate.c     |    8 +++-----
 fs/ext4/super.c       |   11 +++++++----
 fs/jbd2/journal.c     |   17 +++++++++++------
 fs/jbd2/transaction.c |   42 +++++++++++++++++++++++++++++++-----------
 fs/ocfs2/journal.h    |    6 ++++--
 include/linux/jbd2.h  |    3 ++-
 9 files changed, 101 insertions(+), 47 deletions(-)



