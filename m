From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Wed, 27 Aug 2008 23:37:53 -0400
Message-ID: <20080828033753.GF26987@mit.edu>
References: <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu> <20080710220234.GC3447@mit.edu> <20080823165127.GB18169@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49905 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753703AbYH1Dh4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 23:37:56 -0400
Content-Disposition: inline
In-Reply-To: <20080823165127.GB18169@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' and 'master' branches have these fixes since the last
	announcement.

Andreas Dilger (8):
  e2fsck_write_bitmaps() optimization
  Document the extent and huge file flags in the chattr.1.in man page
  Fix miscellaneous compile warnings
  e2fsck: Change comments in problem array to match what is printed
  libext2fs: grow dblist more aggressively
  allow integrating the "make rpm" command into a build system
  add debugfs command to print known features
  fix e2fsck error message for bad htree depth

Manish Katiyar (2):
  debugfs: Close the file handle and return in case of errors
  debugfs: Print the progname instead of argv[0] in error message

Theodore Ts'o (29):
  libblkid: Fix false detection of DFSee created filesystems.
  libblkid: Strengthen the JFS probe routine
  debian: Add debian/watch file
  Fix mke2fs man page to escape all minus signs
  debian: Remove e2fsck-static.lintian-overrides
  debian: add libuuid1.lintian-overrides
  debian: Add uuid-runtime.lintian-overrides
  Remove trailing space from the description of the r_move_itable
      test
  libext2fs: Fix namespace leakage of crc16 functions
  libe2p: Fix namespace leakage of os_tab
  libblkid: Fix namespace leakage of unicode_16be_to_utf8
  debian: Add dpkg-gensymbols support to track ABI changes to the
      libraries
  Add support for with empty directory blocks in 64k blocksize
      filesystems
  libblkid: Optimize devicemapper support
  Remove use of devmapper library by the blkid library
  libblkid: Unexport the private symbol blkid_devdirs
  libblkid: Give a priority bonus to "leaf" devicemapper devices
  ext2fs_mkjournal(): Don't allocate an extra block to the journal
  Create the journal in the middle of the filesystem
  ext2fs_block_iterate2: Add BLOCK_FLAG_APPEND support for
      extent-based files
  If the filesystem supports extents create an extent-based journal
      inode
  ext2fs_block_iterate2: Fix memory leak on error paths
  libext2fs: Fix ext2fs_bmap() to work with extents and BMAP_ALLOC
  debugfs: Use extents when writing a file if the filesystem supports
      them
  Build lib/ext2fs/ext2_err.h early to avoid parallel build problems
  Update @-expansion script for the I18N translation template
  Improve future compatibility for the 64-bit I/O channel functions
  Remove trailing whitespace for the entire source tree
  Update e2fsprogs.pot translation template file

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
