From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfix before 3.1-rc1
Date: Wed, 03 Aug 2011 20:57:40 -0400
Message-ID: <E1QomFo-0004xQ-1C@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55513 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1HDA5m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2011 20:57:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

This was an oopsie that I'd like to fix up before rc1 if possible.  Mea
culpa.

   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Please pull, thanks!!

					- Ted

Mathias Krause (1):
      ext4: use kzalloc in ext4_kzalloc()

 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
