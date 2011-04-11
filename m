From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 2.6.39-rc3
Date: Mon, 11 Apr 2011 09:03:09 -0400
Message-ID: <E1Q9Glp-0000bw-N4@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33872 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1DKNDO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2011 09:03:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to get the following ext4 bug/regression fixes for the 2.6.39.

Thanks!!

                                        - Ted

Curt Wohlgemuth (1):
      ext4: sync the directory inode in ext4_sync_parent()

Jan Kara (1):
      ext4: remove unnecessary [cm]time update of quota file

Kazuya Mio (1):
      ext4: Allow indirect-block file to grow the file size to max file size

Tao Ma (2):
      ext4: fix a double free in ext4_register_li_request
      ext4: init timer earlier to avoid a kernel panic in __save_error_info

Theodore Ts'o (1):
      ext4: fix data corruption regression by reverting commit 6de9843dab3f

Yongqiang Yang (2):
      ext4: fix credits computing for indirect mapped files
      ext4: allow an active handle to be started when freezing

Zhang Huan (1):
      jbd2: fix potential memory leak on transaction commit

Zhu Yanhai (1):
      jbd2: move bdget out of critical section

 fs/ext4/ext4_jbd2.h |    4 +-
 fs/ext4/fsync.c     |   17 +++++++++--
 fs/ext4/inode.c     |   35 ++++++++++++++++--------
 fs/ext4/super.c     |   74 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/jbd2/commit.c    |    4 ++-
 fs/jbd2/journal.c   |    3 +-
 6 files changed, 102 insertions(+), 35 deletions(-)
