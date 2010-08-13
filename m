From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 update for 2.6.36
Date: Fri, 13 Aug 2010 17:09:42 -0400
Message-ID: <E1Ok1VW-0003Hx-QA@tytso-glaptop>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54749 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab0HMVJr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Aug 2010 17:09:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

No other late-breaking bug reports/regressions have turned up, and since
I want to get this fixed before -rc1 gets released, please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

I fixed the compile warning basically as you suggested, but with a
better name and with the comments moved to the inline function where
they would make more sense.

Thanks,

						- Ted

Theodore Ts'o (1):
      ext4: clean up compiler warning in start_this_handle()

 fs/jbd2/transaction.c |   46 +++++++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 19 deletions(-)
