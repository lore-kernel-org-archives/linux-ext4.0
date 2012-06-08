From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.5-rc2
Date: Fri, 08 Jun 2012 14:13:19 -0400
Message-ID: <E1Sd3gV-00080R-1E@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:48578 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400Ab2FHSNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2012 14:13:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to b22b1f178f6799278d3178d894f37facb2085765:

  ext4: don't set i_flags in EXT4_IOC_SETFLAGS (2012-06-07 19:04:19 -0400)

----------------------------------------------------------------
ext4 bug fixes for 3.5-rc2

This update contains two bug fixes, both destined for the stable tree.
Perhaps the most important is one which fixes ext4 when used with file
systems originally formatted for use with ext3, but then later
converted to take advantage of ext4.

----------------------------------------------------------------
Tao Ma (1):
      ext4: don't set i_flags in EXT4_IOC_SETFLAGS

Theodore Ts'o (1):
      ext4: fix the free blocks calculation for ext3 file systems w/ uninit_bg

 fs/ext4/balloc.c | 8 ++++----
 fs/ext4/ioctl.c  | 1 -
 2 files changed, 4 insertions(+), 5 deletions(-)
