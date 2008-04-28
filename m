From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Sun, 27 Apr 2008 22:53:02 -0400
Message-ID: <20080428025302.GC30840@mit.edu>
References: <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43299 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761485AbYD1CxE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Apr 2008 22:53:04 -0400
Content-Disposition: inline
In-Reply-To: <20080421162726.GF9700@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've cut a release of e2fsprogs 1.41-WIP-0427, as a tarball, just so
that people have something outside of git that they can play with.

I made a lot of changes to the undo manager before finally merging it,
including rename undoe2fs to e2undo, and speeding it up substantially.
It is now roughly 4 times faster than before when we force the
creation of an undo file while running mke2fs on a filesystem with a
journal file enabled.

We still have some cleanup work to do, which is being kept up to date here;

http://ext4.wiki.kernel.org/index.php/E2fsprogs_features_and_patches

							- Ted

* The 'maint' branch has these fixes since the last announcement.

Makoto Dei (1):
  fsck does not accept 'j' with German locale

Manish Katiyar (1):
  Fix "make docs" rule in Makefile for doc folder.

Theodore Ts'o (6):
  blkid: Keep cached filesystem information on EACCES and ENOENT
      errors
  libext2fs.texinfo: Fix @deftypefun definitions so they are all on
      one line
  Update texinfo.tex file newer version from the FSF
  mke2fs: Don't allow the combination of the meta_bg and resize_inode
      features
  Update release notes and debian changelog for 1.40.9 release
  debian: The doc-base section should be Programming, not
      Apps/Programming


* The 'master' branch has these since the last announcement
  in addition to the above.

Aneesh Kumar K.V (6):
  libext2fs: Add undo I/O manager
  Add e2undo command
  mke2fs: Add support for the undo I/O manager.
  tune2fs: Support for large inode migration.
  Fix the resize inode test case
  Add test cases for undoe2fs: u_undoe2fs_mke2fs and
      u_undoe2fs_tune2fs

Theodore Ts'o (15):
  libext2fs: Initialize s_min_extra_isize and s_wanted_extra_isize
  libe2p: Print the s_min_extra_isize and s_wanted_extra_isize fields
  ext2fs_set_gdt_csum: Remove bogus setting of ITABLE_ZEROED
  ext2fs_set_gdt_csum: Remove setting of BLOCK_UNINIT
  e2fsck: Fix pass5 handling of meta_bg and uninit_bg combination
  Add comments documenting ext2fs_[reserve_]super_and_bgd_loc()
  Remove LAZY_BG feature
  Transfer responsibility of setting the *_UNINIT flags to libext2fs
  mke2fs/libext2fs: Fix lazy inode table initialization
  ext2fs_open_inode_scan: Handle an non-zero bg_itable_used in block
      group 0
  Basic flexible block group support
  mke2fs: New bitmap and inode table allocation for FLEX_BG
  mke2fs: Make argument to the extended option lazy_itable_init
      optional
  ext2fs_add_journal_inode: Optimize writing the journal data blocks
  Update version.h and README for 1.41-WIP-0427 release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
