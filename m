From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Frequent ext4 oopses with 4.4.0 on Intel NUC6i3SYB
Date: Mon, 3 Oct 2016 23:18:55 -0400
Message-ID: <20161004031855.thdifhchkxgjjl4e@thunk.org>
References: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Johannes Bauer <dfnsonfsduifb@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56646 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751636AbcJDDTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 3 Oct 2016 23:19:14 -0400
Content-Disposition: inline
In-Reply-To: <fcb653b9-cd9e-5cec-1036-4b4c9e1d3e7b@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 03, 2016 at 12:52:20PM +0200, Johannes Bauer wrote:
> Shows also a stacktrace with the same call path, also running on a
> (different) Intel NUC, also running a 4.4.0 kernel. This pastebin is
> nowhere referenced however, so I'm unsure who found it and where exactly
> it was posted. Since the offending process in the unknown guy or girl's
> pastebin was dd, however, I believe that he or she tried to deliberately
> reproduce the problem.

Have you tried using a 4.4.23 kernel?  There are a large number of bug
fixes in the kernel betweeb 4.4.0 and 4.4.23.

The last time I've done a stable kernel test run was against 4.4.17,
and it passed clean:

FSTESTIMG: gce-xfstests/xfstests-201608132226
FSTESTVER: e2fsprogs	v1.43.1-22-g25c4a20 (Wed, 8 Jun 2016 18:11:27 -0400)
FSTESTVER: fio		fio-2.6-8-ge6989e1 (Thu, 4 Feb 2016 12:09:48 -0700)
FSTESTVER: quota		81aca5c (Tue, 12 Jul 2016 16:15:45 +0200)
FSTESTVER: xfsprogs	v4.5.0 (Tue, 15 Mar 2016 15:25:56 +1100)
FSTESTVER: xfstests-bld	75f1eb0 (Sat, 13 Aug 2016 22:18:57 -0400)
FSTESTVER: xfstests	linux-v3.8-1149-g4e58a5b (Mon, 8 Aug 2016 10:50:34 -0400)
FSTESTVER: kernel	4.4.17 #4 SMP Mon Aug 15 23:55:25 EDT 2016 x86_64
FSTESTCFG: "all"
FSTESTSET: "-g auto"
FSTESTEXC: "ext4/022"
FSTESTOPT: "aex"
MNTOPTS: ""
CPUS: "2"
MEM: "7477.49"
MEM: 7680 MB (Max capacity)
BEGIN TEST 4k: Ext4 4k block Tue Aug 16 00:05:28 EDT 2016
Passed all 224 tests

						- Ted

P.S.   Fixes between 4.4.0 and 4.4.17:

% git log --oneline v4.4..v4.4.17 -- fs/ext4 fs/jbd2
26015f0 ext4: verify extent header depth
8b8de1c ext4: silence UBSAN in ext4_mb_init()
12aa7d9 ext4: address UBSAN warning in mb_find_order_for_block()
b2601bb ext4: fix oops on corrupted filesystem
b2044c3 ext4: clean up error handling when orphan list is corrupted
c5ce389 ext4: fix hang when processing corrupted orphaned inode list
fa5613b ext4: iterate over buffer heads correctly in move_extent_per_page()
2122834 ext4: fix races of writeback with punch hole and zero range
1f7b7e9 ext4: fix races between buffered IO and collapse / insert range
e096ade ext4: move unlocked dio protection from ext4_alloc_file_blocks()
0b680de ext4: fix races between page faults and hole punching
c745297 ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()
ee8516a ext4: ignore quota mount options if the quota feature is enabled
321299a ext4: add lockdep annotations for i_data_sem
93272be jbd2: fix FS corruption possibility in jbd2_journal_destroy() on umount path
7c3d142 ext4: fix bh->b_state corruption
bbfe21c ext4: don't read blocks from disk after extents being swapped
600d41f ext4: fix potential integer overflow
33f48f8 ext4: fix scheduling in atomic on group checksum failure
b80b70e ext4 crypto: add missing locking for keyring_key access

Fixes between 4.4.17 and 4.4.23:

% git log --oneline v4.4.17..v4.4.23 -- fs/ext4 fs/jbd2
bf63b9d fscrypto: require write access to mount to set encryption policy
8d693a2 fscrypto: add authorization check for setting encryption policy
d8aafd0 ext4: use __GFP_NOFAIL in ext4_free_blocks()
1d12bad ext4: avoid modifying checksum fields directly during checksum verification
77ae14d ext4: avoid deadlock when expanding inode size
a79f1f7 ext4: properly align shifted xattrs when expanding inodes
e6abdbf ext4: fix xattr shifting when expanding inodes part 2
f2c06c7 ext4: fix xattr shifting when expanding inodes
dfa0a22 ext4: validate that metadata blocks do not overlap superblock
564e0f8 jbd2: make journal y2038 safe
3a22cf0 ext4: fix reference counting bug on block allocation error
db82c74 ext4: short-cut orphan cleanup on error
f8d4d52 ext4: validate s_reserved_gdt_blocks on mount
175f36c ext4: don't call ext4_should_journal_data() on the journal inode
5a7f477 ext4: fix deadlock during page writeback
9e38db2 ext4: check for extents that wrap around

And note that not all fixes get backported.  Sometimes a patch is too
large or too complex to backport.  Or sometimes we forget to tag a
patch for a stable kernel backport that really should have been
backported.  So trying to see if you can replicate the problem using
the latest 4.8 kernel would also be a good thing to try.

Finally, the oops was inside the memory allocator, so it's possible
the problem was caused by a corrupted freelist, which could have been
caused by a wild pointer dereference in any part of the kernel, not
necessarily ext4.  Which is another reason to go to the latest 4.4.x
kernel or to try the 4.8 kernel.  The bug in some other part of the
subsystem may have since been fixed.
