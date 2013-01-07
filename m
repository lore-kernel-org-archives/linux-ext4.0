From: Theodore Ts'o <tytso@mit.edu>
Subject: [GIT PULL] ext4 regression fixes for 3.8
Date: Mon, 07 Jan 2013 11:42:47 -0500
Message-ID: <nsx38ydt054.fsf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42201 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3AGQmt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Jan 2013 11:42:49 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to fef0ebdb229bedce888b63923e2a1ba4e6c6a84c:

  ext4: remove duplicate call to ext4_bread() in ext4_init_new_dir() (2013-01-06 23:40:25 -0500)

----------------------------------------------------------------
Bug fixes, including two regressions introduced in v3.8.  The most
serious of these regressions is a buffer cache leak.

----------------------------------------------------------------
Guo Chao (2):
      ext4: release buffer in failed path in dx_probe()
      ext4: remove duplicate call to ext4_bread() in ext4_init_new_dir()

Valerie Aurora (1):
      ext4: fix configuration dependencies for ext4 ACLs and security labels

 fs/ext4/Kconfig | 2 ++
 fs/ext4/namei.c | 3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)
