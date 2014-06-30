From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.16
Date: Sun, 29 Jun 2014 20:11:59 -0400
Message-ID: <20140630001159.GA25311@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35899 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF3AMB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Jun 2014 20:12:01 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable

for you to fetch changes up to a93cd4cf86466caa49cfe64607bea7f0bde3f916:

  ext4: Fix hole punching for files with indirect blocks (2014-06-26 12:30:54 -0400)

----------------------------------------------------------------
Fix a regression when trying to compile ext4 on older versions gcc.

Fix a number of miscellaneous bugs for punch hole as well as a
long-standing potential double buffer head release when failing a
block allocation for an indirect-mapped file.

----------------------------------------------------------------
Jan Kara (3):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix block zeroing when punching holes in indirect block files
      ext4: Fix hole punching for files with indirect blocks

Namjae Jeon (1):
      ext4: decrement free clusters/inodes counters when block group declared bad

T Makphaibulchoke (1):
      fs/mbcache: replace __builtin_log2() with ilog2()

 fs/ext4/balloc.c   | 16 ++++++++++++++++
 fs/ext4/ialloc.c   | 23 +++++++++++++++++++++++
 fs/ext4/indirect.c | 24 +++++++++++++++++++-----
 fs/ext4/mballoc.c  |  8 ++++++++
 fs/mbcache.c       |  3 ++-
 5 files changed, 68 insertions(+), 6 deletions(-)
