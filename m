From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfixes for 3.2-rc4
Date: Tue, 29 Nov 2011 11:45:48 -0500
Message-ID: <E1RVQoW-0005SB-7d@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58808 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1K2Qpx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Nov 2011 11:45:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

There is a signed tag tytso-for-linus-20111129 covering this fix (which
is also cc'ed to stable@kernel.org).

Thanks!!

						- Ted

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev

Tejun Heo (1):
      ext4: fix racy use-after-free in ext4_end_io_dio()

 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
