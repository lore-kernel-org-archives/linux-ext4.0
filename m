From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Sat, 7 Jun 2008 22:41:04 -0400
Message-ID: <20080608024104.GA30132@mit.edu>
References: <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43162 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754627AbYFHClJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jun 2008 22:41:09 -0400
Content-Disposition: inline
In-Reply-To: <20080603023955.GK23119@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current blocker for a 1.41 release is resize2fs support for
uninit_bg, and apparently on-line resizing for ext4 is currently
broken.  The ext4 resize ioctls are wired up in the latest git
repository, but it looks like there may be some breakages in the
kernel side code.  For sure it doesn't support flex_bg, and apparently
there are some problems with a simple filesystem with only the extents
feature enabled.

At this point full extents support and journal checksum support is in
the "master" branch.  The "pu" branch is currently empty except for
some staged 64-bit patches (which aren't highly critical for 1.41; as
they are cleaned up, I'll merge them in, but right now getting the
last bits of functionality for 1.41 is highest priority.)

          	     		       	    - Ted


* The 'maint' branch has these fixes since the last announcement.

Theodore Ts'o (2):
  Fix ext2fs_swap{16,32,64} for external applications on big-endian
      machines
  fsck: Fix build problem on MacOS X


* The 'master' branch has these since the last announcement
  in addition to the above.

Aneesh Kumar K.V (1):
  libext2fs: Fix build failure on powerpc in ext2fs_swap_inode_full()

Eric Sandeen (4):
  libext2fs: Teach extent.c how to split nodes
  Teach ext2fs_extent_insert() to split the current node if necessary
  libext2fs: add new function ext2fs_extent_set_bmap()
  Teach ext2fs_extent_delete() to remove an empty extent node from
      the tree

Theodore Ts'o (22):
  Wire ext2fs_block_iterate2() to use ext2fs_extent_set_bmap()
  Wire ext2fs_bmap2() to use ext2fs_extent_set_bmap()
  libext2fs: Add callback functions for _alloc_block() and
      _block_alloc_stats()
  e2fsck: Wire up callback functions for _alloc_block() and
      _block_alloc_stats()
  e2fsck: Detect unordered extents in an extent node
  f_extents2: Add new test case testing e2fsck's support for extents
  Re-enable byte-swapping functions for use by journal checksums
  Add CRC32 (big-endian) routine for use by journal checksums
  e2fsck: Add support to check journal checksums
  Fix gcc -Wall warnings in e2fsck
  Fix gcc -Wall warnings in tune2fs
  Fix gcc -Wall warnings in resize2fs
  Fix gcc -Wall warnings in libuuid
  Fix gcc -Wall warnings in libext2fs
  Update Makefile dependencies for lib/ext2fs
  e2fsck: Add better explanatory message when s_lastcheck is in the
      future
  resize2fs: Add support to use the ext4 online resize ioctl's
  Fix dependency for $(LIBSS) when an explicit dlopen() library is
      needed
  Add "#include <limits.h>" to get PATH_MAX for mke2fs and tune2fs
  e2undo: Enable missing pieces to enable I18N for this application
  Fix LIBSS dependency problem for tests/test_icount and
      lib/ss/test_ss
  Update tests to reflect undoe2fs -> e2undo rename

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
