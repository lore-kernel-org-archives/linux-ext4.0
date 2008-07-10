From: Theodore Tso <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable) -- E2fsprogs 1.41.0 released!
Date: Thu, 10 Jul 2008 18:02:34 -0400
Message-ID: <20080710220234.GC3447@mit.edu>
References: <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51572 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbYGJWCi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 18:02:38 -0400
Content-Disposition: inline
In-Reply-To: <20080707213527.GV31490@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At long last, e2fsprogs 1.41.0 has been let loose on the world!  This
is the first stable/production version of e2fsprogs with ext4 support.

    		       	       	  	    	 - Ted

* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (1):
  blkid: Make regression test tolerate older versions of mkswap

Theodore Ts'o (13):
  debian: Add bash-static to the list of shells recommended for
      e2fsck-static
  Add a comment in INSTALL regarding --disable-tls on older systems
  mke2fs: Dumb down filesystems for GNU Hurd
  Fix incorrect definition of stripe-width in mke2fs man page
  badblocks: Use standard terminology for first/last block
  Don't use thread local storage if using diet libc
  mke2fs,tune2fs: Enable huge_file, dir_nlink, and extra_isize
      features
  resize2fs: Clean up the resize inode properly if necessary
  Update release checklist to include reminder to update translation
  Make ext2fs_check_desc() more stringent to force use of backup
      superbocks
  Update e2fsprogs.pot I18N translation template file
  Update dependencies in the Makefile for lib/ext2fs
  Update release notes, changelog, etc., for e2fsprogs 1.41 release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
