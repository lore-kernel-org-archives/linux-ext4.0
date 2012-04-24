From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bug fixes for 3.4
Date: Mon, 23 Apr 2012 22:12:52 -0400
Message-ID: <E1SMVFM-000116-KW@tytso-glaptop.cam.corp.google.com>
Cc: linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51914 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab2DXCM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Apr 2012 22:12:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The following changes since commit 57f73c2c89a5d3b2ed87201c8100d1fa989a1a65:

  ext4: fix handling of journalled quota options (2012-04-16 18:55:26 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus

for you to fetch changes up to db7e5c668e1b16061fe2d94d3cba022dd360c5d4:

  super.c: unused variable warning without CONFIG_QUOTA (2012-04-23 21:44:41 -0400)

----------------------------------------------------------------
Ext4 bug fixes for 3.4

These are two low-risk bug fixes for ext4, fixing a compile warning
and a potential deadlock.

----------------------------------------------------------------
Eldad Zack (1):
      super.c: unused variable warning without CONFIG_QUOTA

Shaohua Li (1):
      jbd2: use GFP_NOFS for blkdev_issue_flush

 fs/ext4/super.c  |    2 ++
 fs/jbd2/commit.c |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)
