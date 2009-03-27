From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 16:24:28 -0400
Message-ID: <1238185471-31152-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45715 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597AbZC0UYf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The following patches have been posted as providing at least some
partial improvement to the ext3 latency problem that has been
discussed on the 2.6.29 mongo-LKML-thread-that-would-not-die.

I plan to push this to Linus during the 2.6.29 merge window if there
are no huge objections.  It is by no means a complete solution, but it
should at least help the situation somewhat.

It is also available via git:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes

Comments?

						- Ted

Jan Kara (1):
      ext3: Avoid starting a transaction in writepage when not necessary

Theodore Ts'o (2):
      block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
      ext3: Use WRITE_SYNC for commits which are caused by fsync()




