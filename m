From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] Patches to improve/fix e2freefrag
Date: Sun,  9 Aug 2009 23:31:52 -0400
Message-ID: <1249875118-26291-1-git-send-email-tytso@mit.edu>
References: <20090727183636.GN4231@webber.adilger.int>
Cc: Andreas Dilger <adilger@sun.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46039 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbZHJDcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Aug 2009 23:32:00 -0400
In-Reply-To: <20090727183636.GN4231@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As we had discussed earlier, here are the patches to make the output of
e2freefrag either to understand.  While I was working with the program,
I found a number of bugs that caused it to behave incorrectly on file
systems with 1k block size, and to give incorrect information in some
circumstances.  These patches fix all of this bugs I was able to find.

Theodore Ts'o (6):
  e2freefrag: Clarify e2freefrag's messages
  e2freefrag: Do not print chunk-related information by default
  e2freefrag: Fix to work correctly for file systems with 1kb block
    sizes
  e2freefrag: Take into account the last free extent in the file system
  Add V=1 support when linking e2freefrag in misc/Makefile.in
  libext2fs: Treat uninitialized parts of bitmaps as unallocated

 lib/ext2fs/rw_bitmaps.c |    4 +-
 misc/Makefile.in        |    4 +-
 misc/e2freefrag.8.in    |   23 +++++------
 misc/e2freefrag.c       |   99 +++++++++++++++++++++++++++++-----------------
 tests/m_uninit/expect.1 |   48 +++++++++++-----------
 5 files changed, 100 insertions(+), 78 deletions(-)

