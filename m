From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Tue, 19 Feb 2008 00:03:47 -0500
Message-ID: <20080219050347.GT25098@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50284 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1749667AbYBSFDt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 00:03:49 -0500
Content-Disposition: inline
In-Reply-To: <20080211044108.GA25089@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Christophe GRENIER (1):
  Add portability checks to support DJGPP

Eric Sandeen (1):
  print "mostly-printable" xattr strings in debugfs

Theodore Ts'o (9):
  Update Czech, Dutch, Polish, Sweedish, and Vietnamese translations
  libuuid: use fcntl locking instead of lockf
  uuidd: Fix pid file so it has the correct pid number
  configure.in: Don't use the dc command unless it is required
  Make fsck ignore mounted filesystems if given the -M option
  Update to latest samba tdb library before LGPLv3 change
  debugfs: Add new superblock fields to the set_super_value command
  Add support for setting RAID stride and strip-width via mke2fs and
      tune2fs
  libe2p: Make list_super2() print the RAID stride and stripe-width


* The 'master' branch has these since the last announcement
  in addition to the above.

Theodore Ts'o (1):
  libext2: Add BLOCK_FLAG_READ_ONLY flag to ext2fs_block_iterate2()

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
