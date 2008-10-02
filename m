From: Theodore Tso <tytso@mit.edu>
Subject: Re: What's in e2fsprogs.git (stable)
Date: Thu, 2 Oct 2008 09:41:39 -0400
Message-ID: <20081002134139.GB25164@mit.edu>
References: <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu> <20080710220234.GC3447@mit.edu> <20080823165127.GB18169@mit.edu> <20080828033753.GF26987@mit.edu> <20080901205727.GH13069@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:52252 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753730AbYJBNll (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 09:41:41 -0400
Content-Disposition: inline
In-Reply-To: <20080901205727.GH13069@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have released e2fsprogs 1.41.2.  It has a number of fixes over
1.41.1.  Distributions that are contemplating releasing e2fsprogs
1.41.x are strongly recommended to use e2fsprogs 1.41.2.  At the very
least, commit 52771ab5 should be cherry-picked, as it fixes a
regression from e2fsprogs 1.40.7 which stops "e2fsck -b 32768 /dev/XXX"
from working.

						- Ted

* The 'maint' and 'master' branch have these fixes since the last annou=
ncement.

Arif E. Nugroho (1):
  po: update id.po (from translationproject.org)

Benno Schulenberg (1):
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

G=F6ran Uddeborg (1):
  po: update sv.po (from translationproject.org)

Jakub Bogusz (1):
  po: update pl.po (from translationproject.org)

Manish Katiyar (4):
  debugfs: Fix memory leak in do_ncheck()'s error path
  badblocks: Display time and percentage complete in verbose mode.
  resize2fs: Fix potential memory corruption in
      ext2fs_progress_init()
  debugfs: Make the usage messsage of logdump consistent with man
      page

Matthias Andree (2):
  Print size of resulting .tar.gz file.
  Unbreak build if directory renamed from e2fsprogs.

Petr Pisar (1):
  po: update cs.po (from translationproject.org)

Philipp Thomas (1):
  po: update de.po (from translationproject.org)

Samuel Thibault (1):
  po: update fr.po (from translationproject.org)

Theodore Ts'o (29):
  Fix e2fsprogs-libs build failure due to 'subs' target
  badblocks: Open the device with O_LARGEFILE
  libext2fs: Remove unused ext2fs_find_{first,ext}_bit_set()
  libext2fs: Compile ext2fs_swab64() for all platforms
  Update debian/changefile for 1.41.1-2 debian release
  Fix pkg-config files: use Requires.private and fix the include
      directory
  Fix bold font specifer in mke2fs.8 man page
  Improve ELF shared library handling
  Fix e2initrd_helper, blkid, and fsck from linking with unneeded
      libraries
  debian: Fix dependencies field in the udeb packages
  debian: Reorder rules to build udebs to avoid Lintian warning
  Add more historical information into the debian/*.symbols files
  Update debian/changefile for 1.41.1-3 debian release
  e2fsck: Don't print the PO header when printing problems with
      PROMPT_NULL
  Install with relative symlinks if $(root_libdir) =3D=3D $(libdir)
  Fix various spelling mistakes in various man pages
  libext2fs.texinfo: Add documentation for the file I/O functions
  e2fsck: Fix e2fsck automatic blocksize detetion
  debugfs: Add the ability to specify the hash seed to the "hash"
      command
  Fix compiling under diet libc
  debian: Use dietlibc when possible for building e2fsck.static
  libcom_err: Use sem_post/sem_init to prevent race conditions
  debugfs: Fix ncheck to print all pathnames for the inodes
  badblocks: Fix progress output for "badblocks -sw /dev/XXX"
  Fix spelling mistake in e2fsck man page
  libcom_err: Fix file descriptor leak after an exec
  mke2fs.8: Add an explanation of how the -t and -O options interact
  libcom_err: Add missing type declarations to clean up -Wall
      warnings
  Update release notes, changelog, etc., for e2fsprogs 1.41.2 release

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
