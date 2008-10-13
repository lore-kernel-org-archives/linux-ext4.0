From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 13 Oct 2008 00:09:27 -0400
Message-ID: <20081013040927.GK12662@mit.edu>
References: <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu> <20080710220234.GC3447@mit.edu> <20080823165127.GB18169@mit.edu> <20080828033753.GF26987@mit.edu> <20080901205727.GH13069@mit.edu> <20081002134139.GB25164@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60630 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbYJMEJa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 00:09:30 -0400
Content-Disposition: inline
In-Reply-To: <20081002134139.GB25164@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've just released e2fsprogs 1.41.3 to fix a few more bug fixes, and
to smooth the transition from ext4dev to ext4, which will occur in
2.6.28.  Distributions that are contemplating releasing e2fsprogs
1.41.x are strongly recommended to use e2fsprogs 1.41.3.

* The 'maint' and 'master' branches have these fixes since the last
  announcement:

Eric Sandeen (4):
  e2fsprogs: fix blkid detection of ext4dev as ext4
  unix_io: check for read-only devices when opening R/W
  resize2fs: check for bogus new_size
  e2fsck: exit from preenhalt if IO errors were encountered

Theodore Ts'o (8):
  Update Makefile depend information for crc16.o
  Fix parallel build problem with util/subst
  debugfs: Fix ncheck when printing pathnames for multiple hardlinks
      in a directory
  libblkid: Fix file descriptor leak when checking for a module
  e2fsck: Print the correct inode number for uninit-bg related
      problem reports
  e2fsck: Offer to clear the test_fs flag if ext4 is available
  Update e2fsprogs translation template file
  Update release notes, changelog, etc., for e2fsprogs 1.41.3 release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
