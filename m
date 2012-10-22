From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.7
Date: Mon, 22 Oct 2012 18:19:59 -0400
Message-ID: <20121022221959.GA16531@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56896 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254Ab2JVWUC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2012 18:20:02 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following changes since commit c278531d39f3158bfee93dc67da0b77e09776de2:

  ext4: fix ext4_flush_completed_IO wait semantics (2012-10-05 11:31:55 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to 5de35e8d5c02d271c20e18337e01bc20e6ef472e:

  ext4: Avoid underflow in ext4_trim_fs() (2012-10-22 18:01:19 -0400)

----------------------------------------------------------------
Various bug fixes for ext4.  The most serious of them fixes a security
bug (CVE-2012-4508) which leads to stale data exposure when we have
fallocate racing against writes to files undergoing delayed
allocation.  We also have two fixes for the metadata checksum feature,
the most serious of which can cause the superblock to have a invalid
checksum after a power failure.

----------------------------------------------------------------
Dmitry Monakhov (2):
      ext4: serialize fallocate with ext4_convert_unwritten_extents
      ext4: race-condition protection for ext4_convert_unwritten_extents_endio

Lukas Czerner (2):
      ext4: fix undefined bit shift result in ext4_fill_flex_info
      ext4: Avoid underflow in ext4_trim_fs()

Tao Ma (1):
      ext4: Checksum the block bitmap properly with bigalloc enabled

Theodore Ts'o (1):
      ext4: fix metadata checksum calculation for the superblock

 fs/ext4/balloc.c    |  8 +++----
 fs/ext4/bitmap.c    |  6 ++++--
 fs/ext4/ext4.h      |  7 +++----
 fs/ext4/ext4_jbd2.c |  8 ++-----
 fs/ext4/extents.c   | 60 +++++++++++++++++++++++++++++++++++++++++++----------
 fs/ext4/ialloc.c    |  4 +---
 fs/ext4/mballoc.c   | 14 ++++++-------
 fs/ext4/resize.c    |  3 +--
 fs/ext4/super.c     |  9 ++++----
 9 files changed, 74 insertions(+), 45 deletions(-)
