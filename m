From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Tue, 10 Nov 2009 10:52:45 -0500
Message-ID: <E1N7t1R-0001EC-Ig@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:45628 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbZKJPwq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Nov 2009 10:52:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following regression fixes for v2.6.32.

Thanks!!

                                                        - Ted

Aneesh Kumar K.V (1):
      ext4: discard preallocation when restarting a transaction during truncate

Mingming (4):
      ext4: fix ext4_ext_direct_IO()'s return value after converting uninit extents
      ext4: skip conversion of uninit extents after direct IO if there isn't any
      ext4: code clean up for dio fallocate handling
      ext4: Fix return value of ext4_split_unwritten_extents() to fix direct I/O

Theodore Ts'o (1):
      ext4: partial revert to fix double brelse WARNING()

 fs/ext4/ext4.h    |    1 +
 fs/ext4/extents.c |   36 +++++++++++++++++++++++++-----------
 fs/ext4/inode.c   |   24 +++++++++++++++---------
 fs/ext4/namei.c   |   16 ++++------------
 4 files changed, 45 insertions(+), 32 deletions(-)
