From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [GIT PULL] ext4 update
Date: Tue, 29 Apr 2008 22:45:18 -0400
Message-ID: <E1Jr2Jq-0007F2-Ox@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40357 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbYD3Cpe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Apr 2008 22:45:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

These are all cleanups and bug fixes for 2.6.26.

Thanks,

						- Ted

Akinobu Mita (3):
      ext4: use ext4_group_first_block_no()
      ext4: use ext4_get_group_desc()
      ext4: check ext4_journal_get_write_access() errors

Andi Kleen (1):
      Convert ext4 to use unlocked_ioctl

Aneesh Kumar K.V (15):
      ext4: Fix fallocate error path
      ext4: Enable extent format for symlinks.
      arm: Export empty_zero_page for ZERO_PAGE usage in modules.
      m68k: Export empty_zero_page for ZERO_PAGE usage in modules.
      sparc: Export symbols for ZERO_PAGE usage in modules.
      ext4: ENOSPC error handling for writing to an uninitialized extent
      ext4: zero out small extents when writing to prealloc area.
      ext4: Fix race between migration and mmap write
      ext4: Fix fallocate to update the file size in each transaction
      ext4: make ext4_ext_get_blocks always return <= max_blocks
      ext4: Return unwritten buffer head when trying to read from prealloc space.
      ext4: Cache the correct extent length for uninit extents
      ext4:  Convert list_for_each_rcu() to list_for_each_entry_rcu()
      ext4: Don't do GFP_NOFS allocations after taking ext4_lock_group
      ext4: mark inode dirty after initializing the extent tree

Christoph Hellwig (1):
      ext4: move headers out of include/linux

Duane Griffin (4):
      jbd2: tidy up revoke cache initialisation and destruction
      jbd2: eliminate duplicated code in revocation table init/destroy functions
      jbd2: replace potentially false assertion with if block
      jbd2: only create debugfs and stats entries if init is successful

Eric Sandeen (1):
      ext4: reduce mballoc stack usage with noinline_for_stack

Harvey Harrison (2):
      ext4: replace remaining __FUNCTION__ occurrences
      jdb2: replace remaining __FUNCTION__ occurrences

Hisashi Hifumi (1):
      ext4: fdatasync should skip metadata writeout when overwriting

Jan Kara (2):
      ext4: Fix update of mtime and ctime on rename
      ext4: Fix hang on umount with quotas when journal is aborted

Joe Perches (1):
      ext4: remove duplicate include of ext4_fs_i.h header file

Josef Bacik (6):
      jbd2: fix the way the b_modified flag is cleared
      jbd2: fix possible journal overflow issues
      ext4:  check return of ext4_orphan_get properly
      ext4: fix mount option parsing
      ext4: fix wrong gfp type under transaction
      ext4: don't use ext4_error in ext4_check_descriptors

Marcin Slusarz (2):
      ext4: le*_add_cpu conversion
      ext4: convert byte order of constant instead of variable

Mingming Cao (3):
      ext4: remove extra define of ext4_new_blocks_old from mballoc.c
      ext4: make ext4_xattr_list() static
      ext4: Move mballoc headers/structures to a seperate header file mballoc.h

Randy Dunlap (1):
      jbd2: fix kernel-doc notation

Roel Kluin (3):
      ext3: fix test ext_generic_write_end() copied return value
      ext4: fix test ext_generic_write_end() copied return value
      ext4: fix hot spins in mballoc after err_freebuddy and err_freemeta

Solofo Ramangalahy (2):
      ext4: update ctime and mtime for truncate with extents.
      ext4: cleanup for compiling mballoc with verification and debugging #defines



