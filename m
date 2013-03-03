From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.9
Date: Sat, 02 Mar 2013 22:17:02 -0500
Message-ID: <nsx1ubxw4sx.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50990 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab3CCDRH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 22:17:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 8e919d13048cd5acaadb2b15b48acbfb8832d3c2:

  ext4: fix extent status tree regression for file systems > 512GB (2013-02-27 14:54:37 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 9b2ff35753c0512bc8c6adae9e9c87cbeee86f82:

  ext4: enable quotas before orphan cleanup (2013-03-02 18:22:38 -0500)

----------------------------------------------------------------
Various bug fixes for ext4.  The most important is a fix for the new
extent cache's slab shrinker which can cause significant, user-visible
pauses when the system is under memory pressure.

----------------------------------------------------------------
Dmitry Monakhov (1):
      jbd2: fix ERR_PTR dereference in jbd2__journal_start

Jan Kara (2):
      ext4: don't allow quota mount options when quota feature enabled
      ext4: enable quotas before orphan cleanup

Lukas Czerner (1):
      ext4: convert number of blocks to clusters properly

Theodore Ts'o (2):
      ext4: optimize ext4_es_shrink()
      ext4: use percpu counter for extent cache count

Wei Yongjun (1):
      ext4: fix possible memory leak in ext4_remount()

Zheng Liu (1):
      ext4: fix a warning from sparse check for ext4_dir_llseek

 fs/ext4/balloc.c            |  2 +-
 fs/ext4/dir.c               |  2 +-
 fs/ext4/ext4.h              |  1 +
 fs/ext4/extents_status.c    | 39 +++++++++++++--------------------------
 fs/ext4/mballoc.c           |  8 ++++----
 fs/ext4/resize.c            |  6 +++---
 fs/ext4/super.c             | 61 +++++++++++++++++++++++++++++++++++++++++++------------------
 fs/jbd2/transaction.c       |  2 +-
 include/trace/events/ext4.h | 40 ++++++++++++----------------------------
 9 files changed, 79 insertions(+), 82 deletions(-)
