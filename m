From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 updates for 3.10-rc2
Date: Tue, 14 May 2013 12:09:02 -0400
Message-ID: <nsxsj1po869.fsf@lambda.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48345 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab3ENQJH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 May 2013 12:09:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 0d606e2c9fccdd4e67febf1e2da500e1bfe9e045:

  ext4: fix type-widening bug in inode table readahead code (2013-04-23 08:59:35 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to e2555fde4159467fb579e6ae3c0a8fc33015d0f5:

  jbd,jbd2: fix oops in jbd2_journal_put_journal_head() (2013-05-13 09:45:01 -0400)

----------------------------------------------------------------
Fixed regressions (two stability regressions and a performance
regression) introduced during the 3.10-rc1 merge window.  Also
included is a bug fix relating to allocating blocks after resizing an
ext3 file system when using the ext4 file system driver.

----------------------------------------------------------------
Jan Kara (1):
      jbd,jbd2: fix oops in jbd2_journal_put_journal_head()

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Theodore Ts'o (1):
      ext4: revert "ext4: use io_end for multiple bios"

Yan, Zheng (1):
      ext4: fix fio regression

 fs/ext4/ext4.h               |   8 +--
 fs/ext4/extents.c            |   9 ++--
 fs/ext4/extents_status.c     |  17 ++++--
 fs/ext4/extents_status.h     |   3 +-
 fs/ext4/file.c               |   4 +-
 fs/ext4/inode.c              |  85 ++++++++++++++----------------
 fs/ext4/mballoc.c            |   6 ++-
 fs/ext4/page-io.c            | 121 ++++++++++++++++---------------------------
 include/linux/journal-head.h |   8 ++-
 include/trace/events/ext4.h  |   4 +-
 10 files changed, 119 insertions(+), 146 deletions(-)
