From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 regression fix
Date: Thu, 23 Dec 2010 17:44:53 -0500
Message-ID: <E1PVtu1-0005vZ-Ay@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60852 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0LWWoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Dec 2010 17:44:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git linus-hot-fix

To get the following regression fix (which was introduced in
2.6.37-rc1).

Thanks,

						- Ted

Theodore Ts'o (1):
      ext4: fix on-line resizing regression

 fs/ext4/resize.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
