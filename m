From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.6
Date: Fri, 17 Aug 2012 10:55:48 -0400
Message-ID: <20120817145548.GA29433@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45259 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab2HQOzv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Aug 2012 10:55:51 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to 89a4e48f8479f8145eca9698f39fe188c982212f:

  ext4: fix kernel BUG on large-scale rm -rf commands (2012-08-17 09:42:17 -0400)

----------------------------------------------------------------
The following are all bug fixes and regressions.  The most notable are
the ones which cause problems for ext4 on RAID --- a performance
problem when mounting very large filesystems, and a kernel OOPS when
doing an rm -rf on large directory hierarchies on fast devices.

----------------------------------------------------------------
Theodore Ts'o (5):
      ext4: make sure the journal sb is written in ext4_clear_journal_err()
      ext4: avoid kmemcheck complaint from reading uninitialized memory
      ext4: don't call ext4_error while block group is locked
      ext4: fix long mount times on very big file systems
      ext4: fix kernel BUG on large-scale rm -rf commands

 fs/ext4/balloc.c     | 62 +++++++++++++++++++++++++++++++---------------------
 fs/ext4/bitmap.c     |  1 -
 fs/ext4/extents.c    |  1 +
 fs/ext4/super.c      |  6 +++++
 fs/jbd2/journal.c    |  3 ++-
 include/linux/jbd2.h |  1 +
 6 files changed, 47 insertions(+), 27 deletions(-)
