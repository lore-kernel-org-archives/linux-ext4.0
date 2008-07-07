From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Mon, 7 Jul 2008 17:35:27 -0400
Message-ID: <20080707213527.GV31490@mit.edu>
References: <20080320202243.GO13719@mit.edu> <20080402000626.GB302@mit.edu> <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:38443 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757216AbYGGVfa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Jul 2008 17:35:30 -0400
Content-Disposition: inline
In-Reply-To: <20080617120511.GC12448@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've just released e2fsprogs 1.41-WIP-0707, which should be considered
a release candidate release.  So please test it!!  It is available in
the usual places.  The "master" head of the git repository, at
sourceforge or at ftp.kernel.org (as soon as gets pushed out to the
mirrors, in /pub/linux/kernel/people/tytso/e2fsprogs-interim).

							- Ted

* The 'maint' branch has these fixes since the last announcement.

Theodore Ts'o (4):
  libblkid: Fix marginal C code in probe_lvm2()
  mke2fs, tune2fs, resize2fs: Use floating point to calculate
      percentages
  Clarify the debugfs man page regarding the default superblock
  Update release notes, changelog, and other files for v1.40.11
      release


* The 'master' branch has these since the last announcement
  in addition to the above.

Benno Schulenberg (2):
  po: update es.po (from translationproject.org)
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

David Planella Molas (1):
  po: update ca.po (from translationproject.org)

Eric Sandeen (5):
  Add e2undo files to the RPM specfile template
  blkid: fix swap tests (again)
  blkid: use list_for_each_safe in garbage collection
  Clean up some trivial build warnings
  e2fsck: Fix i_size checking for large extent-based files

Iustin Pop (1):
  badblocks: fix a bug in the read throttling

Jakub Bogusz (1):
  po: update pl.po (from translationproject.org)

Petr Pisar (1):
  po: update cs.po (from translationproject.org)

Philipp Thomas (1):
  po: update de.po (from translationproject.org)

Ricardo M. Correia (1):
  Add ZFS test image to blkid test suite

Samuel Thibault (1):
  po: update fr.po (from translationproject.org)

Theodore Ts'o (19):
  Update release notes for debian experimental package
  Update e2fsprogs.pot and POTFILES.in
  Add a reference to e2fsck.conf(5) to the e2fsck man page
  Fix "make check" in e2fsck subdirectory to use the in-tree com_err
      library
  blkid: Fix cc portability problem in probe_lvm2()
  debian: parse /etc/adduser.conf file manually
  libext2fs: Don't include ss/ss.h except when debugging
  blkid: Make sure a device returned by blkid_find_dev_with_tag
      exists
  blkid: Eliminate stale entries that duplicate a verified device
  badblocks: Fix crash when lots of -t patterns given
  mke2fs: Use a fs_type of 'journal' when creating an external
      journal
  mke2fs: Print a better error msg when ext2fs_get_device_size()
      returns EFBIG
  Treat build.static as an ingored file in the source directory
  debian: Add dbg packages which contain the stripped out debuging
      symbols
  debian: Create debian release tarball to obey new WIP naming
      convention
  libext2fs: Fix FLEX_BG offset used by ext2fs_allocate_group_table
  debian: Update debian policy compliance to 3.8.0.0
  Add build.static to util/subset.exclude as well.
  Update release notes for e2fsprogs 1.41-WIP-0707 release.

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
