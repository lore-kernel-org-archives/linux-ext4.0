From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes for 3.1-rc5
Date: Wed, 31 Aug 2011 13:46:43 -0400
Message-ID: <E1Qyos7-0001in-99@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59848 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab1HaRqr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 13:46:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

	git://github.com/tytso/ext4.git for_linus-20110831 # 8c0bec2151a

to get the following bug fix.  It address a lockdep warning which a lot
of people have been complaining about.

Thanks,

						- Ted


Jiaying Zhang (1):
      ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining

 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |    3 ---
 fs/ext4/page-io.c |   18 +++++++++++++++++-
 3 files changed, 18 insertions(+), 4 deletions(-)
