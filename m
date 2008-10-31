From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 fixes
Date: Fri, 31 Oct 2008 00:11:08 -0400
Message-ID: <E1KvlLo-0000tO-6m@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43526 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbYJaELK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 00:11:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This fixes some regressions that have been reported.

						- Ted


Eric Sandeen (2):
      merge ext4_claim_free_blocks & ext4_has_free_blocks
      delay capable() check in ext4_has_free_blocks()

Hidehiro Kawai (2):
      ext3: fix a bug accessing freed memory in ext3_abort
      ext4: fix a bug accessing freed memory in ext4_abort

Theodore Ts'o (1):
      jbd2: Call the commit callback before the transaction could get dropped

 fs/ext3/super.c  |   10 +++++--
 fs/ext4/balloc.c |   77 +++++++++++++++++++-----------------------------------
 fs/ext4/ext4.h   |    3 +-
 fs/ext4/super.c  |   11 +++++---
 fs/jbd2/commit.c |    8 +++---
 5 files changed, 46 insertions(+), 63 deletions(-)
