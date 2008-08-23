From: Theodore Tso <tytso@mit.edu>
Subject: What's in e2fsprogs.git (stable)
Date: Sat, 23 Aug 2008 12:51:27 -0400
Message-ID: <20080823165127.GB18169@mit.edu>
References: <20080407165505.GD11997@mit.edu> <20080418183935.GA25797@mit.edu> <20080421162726.GF9700@mit.edu> <20080428025302.GC30840@mit.edu> <20080524234904.GC5970@mit.edu> <20080603023955.GK23119@mit.edu> <20080608024104.GA30132@mit.edu> <20080617120511.GC12448@mit.edu> <20080707213527.GV31490@mit.edu> <20080710220234.GC3447@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:60476 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbYHWQv3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Aug 2008 12:51:29 -0400
Content-Disposition: inline
In-Reply-To: <20080710220234.GC3447@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm about to do an e2fsprogs 1.41.1 release, and so I've just pushed
out a debian unstable release for some guinea pig testing, especially
since there have been quite a large number of bug fixes since
e2fsprogs 1.41.0.

If there is anything bug fixes or other changes that you think should
especially be included in e2fsprogs 1.41.1, please let me know.

My expectation is after 1.41.1 release, 'master' will fork off from
'maint', as we start adding new features such as 64-bit block number
support.

	    	      	      	     	    - Ted

* The 'maint' and 'master' branches have these fixes since the last
	announcement.

Aneesh Kumar K.V (1):
  e2fsprogs: Fix tst_extents output on bigendian machine.

Benno Schulenberg (9):
  e2undo, tune2fs: Report the correct name for the undo program.
  badblocks: Insert a missing "\n" in the usage string.
  partinfo: Print clearer error messages.
  tune2fs: Delete a stray word from a comment.
  po: update nl.po (from translationproject.org)
  mke2fs: Fix several typos in the man page.
  blkid: On the man page, show option arguments in the descriptions.
  libblkid: On the man page, replace empty references with an existing =
one.
  po: update nl.po (from translationproject.org)

Clytie Siddall (1):
  po: update vi.po (from translationproject.org)

=46rederic Bohe (1):
  Fix inode table allocation with flexbg

G=F6ran Uddeborg (1):
  po: update sv.po (from translationproject.org)

Li Zefan (1):
  Fix a typo in lib/e2p/Makefile.in

Manish Katiyar (7):
  libext2fs: fix potential memory leak in ext2fs_initialize()
  libext2fs: Add stricter/earlier tests for blocksize in ext2fs_open()
  ext2fs_read_inode: Check the validity of the inode number earlier
  libext2fs : Fix typo in function names in libext2fs.texinfo
  libext2fs : Fix memory leaks in ext2fs_extent_open()
  ext2ed: Remove masix support
  libext2fs: Fix memory leak in ext2fs_initialize().

Petr Pisar (2):
  po: update cs.po (from translationproject.org)
  po: update cs.po (from translationproject.org)

Philipp Thomas (2):
  po: update de.po (from translationproject.org)
  po: update de.po (from translationproject.org)

Theodore Ts'o (62):
  blkid: Add new option -L which pretty-prints the device list
  Fix Solaris shell script portability issues
  e2fsck: Change kmem_cache_t to lkmem_cache_t for Solaris
  Only use __builtin_expect if __GNUC__ > 3
  Use K&R style comments instead of C99 comments for portability
  Remove vararg macro which causes portability problems from ext3_exten=
t.h
  Remove gcc-specific varargs macro in extent.c
  Define _XOPEN_SOURCE to 600 consistently for Solaris C99 support
  Flush stdio buffers before calling setbuf()
  e2fsck: Set LD_LIBRARY_PATH before running "make check" programs
  e2undo: Don't use __FUNCTION__ for portability reasons
  badblocks: If nanosleep() does not exist, try using usleep() instead
  libext2fs: Don't check the group checksum when !GDT_CSUM
  libblkid: Make sure we never reference a null dev->bid_type
  Add debian changelog for 1.41.0-2 release
  debian: Update section and priority of -dbg packages to match overrid=
e file
  Don't assume that /bin/true is always in /bin
  blkid: Fix portability issue if TIOCGSIZE and TIOCGWINSZ are present
  Disable %.sh -> % GNU make rule in the top-level Makefile
  Add an tune2fs.static target in misc/Makefile.in
  debian: Fix FTBFS problem on mips
  debian: Update changelog for 1.40.0-3 release
  debian: Fix minor typo in uuid-runtime's package description
  debian: wrap copyright files to avoid "line too long" lintian warning=
s
  Add more intelligent handling of the mke2fs.conf installation process
  po: update nl.po (from translationproject.org)
  po: update pl.po (from translationproject.org)
  po: update fr.po (from translationproject.org)
  Fix missing space typo's in partinfo and resize2fs
  Fix cross compilation issues in e2fsck/gen_crc32table
  mke2fs: Fix enforcement of no features for revision 0 filesystems
  partinfo: Fix usage message
  mke2fs/tune2fs: Fix max journal size in message to be consistent/corr=
ect
  tune2fs: Improve the error messages for tune2fs -I
  debugfs: Fix htree command so it works with extent-based directories
  blkid: Fix probing logic so we find renamed devices
  e2fsck: Fix check to see if an extent-based file is fragmented
  e2fsck: Fix signed/unsigned error in fragcheck report for indirect bl=
ocks
  e2fsck: Fix ind/dind/tind statistics and add extent depth statistics
  libext2fs: Initialize unset inode timestamps when writing a new inode
  e2fsck: Fix max size calculation for extent files
  e2fsck: fix spurious complaints about i_size caused by preallocated b=
locks
  resize2fs: Fix double bumping of directory in-use counts
  libext2fs: Fix reading bitmaps from e2image files
  Fix ext2fs_extent_set_bmap() when setting a block before the first ex=
tent
  ext2fs_extent_set_bmap(): fix bug when replacing a single block exten=
t
  ext2fs_extent_set_bmap(): Avoid creating extra extents for resize2fs
  ext2fs_block_iterate2(): Support changing interior nodes of an extent=
 tree
  libext2fs: Add support for uninit_bg feature to allocation functions
  resize2fs: Fix support for filesystems with the uninit_bg feature
  resize2fs: supply block allocator for extents function
  po: Add Indonesian translation from the Translation Project
  resize2fs: Make sure we close out the progress bar in pass #4
  libext2fs: Replace use of sprintf with strcpy/strcat to help SILO
  configure.in: use AC_MSG_{RESULT,WARN,ERROR} instead of echo
  libuuid: Windows portability fixes
  configure.in: Respect LDFLAGS environment variable if passed into con=
figure
  libblkid: Fix potential crash if blkid cache is out of date when prob=
ing
  libblkid: Enhance support for MacOS's hfs, hfsplus, and hfsx filesyst=
ems
  e2fsck: Portability fix: Use WORDS_BIGENDIAN instead of __LITTLE_ENDI=
AN
  mke2fs: Issue a warning if the mke2fs.conf file wasn't updated
  Interim update of the debian/changelog and the release notes

------
URL's for the e2fsprogs repository:
	git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
	http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
