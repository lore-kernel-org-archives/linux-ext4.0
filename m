From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 1 Sep 2008 16:57:27 -0400
Message-ID: <20080901205727.GH13069@mit.edu>
References: <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu> <20080710220234.GC3447@mit.edu> <20080823165127.GB18169@mit.edu> <20080828033753.GF26987@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56798 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751093AbYIAU5a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Sep 2008 16:57:30 -0400
Content-Disposition: inline
In-Reply-To: <20080828033753.GF26987@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have released e2fsprogs 1.41.1.  It has a lot of fixes to support
ext4 and extents, and anyone who wishes to experiment with the ext4
fileystem is strongly urged to upgrade to e2fsprogs 1.41.  There are
lots of fixes for ext3 filesystem users as well, of course.

The 'master' branch will be opening up with new development features
shortly.  New features that are expected for the 1.42 release include:

   * 64-bit block number support
   * Userspace tools for ext4's on-line defragmentation patches
	(not yet merged into mainline, but in the ext4 patch queue
	for a whilenow)
   * Support for FIEMAP interface (kernel patches also not yet in mainline,
	but Real Soon Now, I hope!)
   * e2scan and possibly other useful utility programs from the Lustre
	patches
   * Other good stuff which comes up for merging!

							- Ted

* The 'maint' and 'master' branches have these fixes since the last
  announcement.

Philipp Thomas (1):
  po: update de.po (from translationproject.org)

Theodore Ts'o (16):
  Fix breakage caused by commit da17e370 (missing dependency in
      Makefile)
  debian: Change symbols files to only use uptream versions numbers
  Further optimize journal placement for flex_bg filesystems
  resize2fs: Allow (non-optimal) on-line resizing for flex_bg filesystems
  tune2fs, mke2fs: Change default directory hash algorithm to half_md4
  debian: Fix postinstall scripts when the user/group is in LDAP
  tune2fs: Add support for setting the default hash algorithm for htree
  mke2fs: Allow the default hash algorithm in mke2fs.conf
  Update makefile dependency for lib/e2p/Makefile.in
  Update e2fsprogs.pot translation template
  libe2p: Fix potential core-dumping bug in iterate_on_dir()
  Only use the test_io manager if the right environment variables are set
  Fix debug flag definitions for the resize2fs man page
  Enable test_io debugging by default
  filefrag: Fix calculation of ideal number of extents
  Update release notes, changelog, etc., for e2fsprogs 1.41.1 release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
