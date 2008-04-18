From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Fri, 18 Apr 2008 14:39:35 -0400
Message-ID: <20080418183935.GA25797@mit.edu>
References: <E1IooC9-0006TJ-Q6@closure.thunk.org> <20071217171135.GB7070@thunk.org> <20080101180128.GB23047@mit.edu> <20080211044108.GA25089@mit.edu> <20080219050347.GT25098@mit.edu> <20080229142830.GB8968@mit.edu> <20080313180503.GC31653@mit.edu> <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32816 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757403AbYDRTDX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2008 15:03:23 -0400
Content-Disposition: inline
In-Reply-To: <20080407165505.GD11997@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* The 'maint' branch has these fixes since the last announcement.

Benno Schulenberg (1):
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

G=F6ran Uddeborg (1):
  po: update sv.po (from translationproject.org)

Jakub Bogusz (1):
  po: update pl.po (from translationproject.org)

Matthias Koenig (1):
  e2fsck: avoid double free of ctx->filesystem_name

Petr Pisar (1):
  po: update cs.po (from translationproject.org)

Philipp Thomas (1):
  po: update de.po (from translationproject.org)

Samuel Thibault (2):
  po: update fr.po (from translationproject.org)
  po: update fr.po (from translationproject.org)

Theodore Ts'o (4):
  Remove bashism from configure script
  libext2fs: Fix resize inode creation with non-standard
      s_first_data_block
  Fix m_no_opt regression test
  Fix non-POSIX ">&" in the Makefile for lib/ss's "make check" rule


* The 'master' branch has these since the last announcement
  in addition to the above.

Andreas Dilger (8):
  debugfs: Add support for "set_block_group <bg_num> checksum calc"
  ext2fs_set_gdt_csum(): Clean up superblock dirty flag handling
  ext2fs_set_gdt_csum(): Force the last block group to have a valid
      block bitmap
  ext2fs_set_gdt_csum(): Return an error code on errors instead of
      void
  libext2fs: Micro-optimization in inode scan code
  Split the m_lazy test case into two cases: m_lazy and m_lazy_resize
  e2fsck: Add check to enforce a valid block bitmap in last block
      group
  Add new regression test: f_uninit_last_uninit

Eric Sandeen (2):
  e2fsck: Fix extent flag validity tests in pass1 on big endian
      boxes.
  Fix a couple of implicit function declarations

Theodore Ts'o (6):
  Fix trailing whitespace in e2fsck/problem.[ch]
  dumpe2fs: Print the group checksum and the block options in a nicer
      way
  libext2fs: Make all test programs link only against the static
      library
  Add dependency rule so that static library when necessary for "make
      check"
  libext2fs: Fix big-endian bug in tst_csum.c
  New mke2fs filesystem and usage types support

----
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
