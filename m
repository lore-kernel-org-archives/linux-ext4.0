From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] ext4 bugfixes/cleanups
Date: Sat, 02 Aug 2008 21:47:52 -0400
Message-ID: <E1KPShM-0007Ks-M0@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:47556 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180AbYHCBrz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Aug 2008 21:47:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This patch series contains a number of bug fixes that have been
discovered by primarily by benchmarkers and people who have been trying
out ext4.  A few cleanups have been included as well.

Thanks!!

                                                - Ted

Aneesh Kumar K.V (5):
      ext4: Fix data corruption when writing to prealloc area
      ext4: Improve error handling in mballoc
      ext4: Convert the usage of NR_CPUS to nr_cpu_ids.
      ext4: Don't allow lg prealloc list to be grow large.
      ext4: Cleanup the block reservation code path

Eric Sandeen (4):
      ext4: sync up block and inode bitmap reading functions
      ext4: lock block groups when initializing
      ext4: fix ext4_da_write_begin error path
      ext4: remove write-only variables from ext4_ordered_write_end

Hidehiro Kawai (2):
      ext4: don't read inode block if the buffer has a write error
      jbd2: don't abort if flushing file data failed

Li Zefan (1):
      ext4: improve ext4_fill_flex_info() a bit

Theodore Ts'o (6):
      ext4: Allow read/only mounts with corrupted block group checksums
      ext4: Fix ext4_ext_journal_restart()
      ext4: Fix lack of credits BUG() when deleting a badly fragmented inode
      ext4: don't assume extents can't cross block groups when truncating
      ext4: Cleanup whitespace and other miscellaneous style issues
      ext4: unexport jbd2_journal_update_superblock

