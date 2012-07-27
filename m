From: Lukas Czerner <lczerner@redhat.com>
Subject: Add invalidatepage_range address space operation
Date: Fri, 27 Jul 2012 10:00:59 +0200
Message-ID: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-mmc-owner@vger.kernel.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This set of patches are aimed to allow truncate_inode_pages_range() handle
ranges which are not aligned at the end of the page. Currently it will
hit BUG_ON() when the end of the range is not aligned. Punch hole feature
however can benefit from this ability saving file systems some work not
forcing them to implement their own invalidate code to handle unaligned
ranges.

In order for this to work we need however new address space operation
invalidatepage_range which should be able to handle page invalidation with
offset and length specified.

patch 01:	Implements the new invalidatepage_range address space
		operation in the mm layer
patch 02 - 05:	Wire the new invalidatepage_range aop to the ext4, xfs and
		ocfs2 file system (which are currently the only file
		systems supporting punch hole) and implement this
		functionality for jbd2 as well.
patch 06:	Change truncate_inode_pages_range() to handle unaligned
		ranges.
patch 07 - 15:	Ext4 specific changes which take benefit from the
		previous truncate_inode_pages_range() change. Not all
		are realated specifically to this change, but all are
		related to the punch hole feature.

Thanks!
-Lukas


[PATCH 01/15] mm: add invalidatepage_range address space operation
[PATCH 02/15] jbd2: implement jbd2_journal_invalidatepage_range
[PATCH 03/15] ext4: implement invalidatepage_range aop
[PATCH 04/15] xfs: implement invalidatepage_range aop
[PATCH 05/15] ocfs2: implement invalidatepage_range aop
[PATCH 06/15] mm: teach truncate_inode_pages_range() to handle non
[PATCH 07/15] ext4: Take i_mutex before punching hole
[PATCH 08/15] Revert "ext4: remove no longer used functions in
[PATCH 09/15] Revert "ext4: fix fsx truncate failure"
[PATCH 10/15] ext4: use ext4_zero_partial_blocks in punch_hole
[PATCH 11/15] ext4: remove unused discard_partial_page_buffers
[PATCH 12/15] ext4: remove unused code from ext4_remove_blocks()
[PATCH 13/15] ext4: update ext4_ext_remove_space trace point
[PATCH 14/15] ext4: make punch hole code path work with bigalloc
[PATCH 15/15] ext4: Allow punch hole with bigalloc enabled


fs/buffer.c                 |   23 +++-
fs/ext4/ext4.h              |   14 +-
fs/ext4/extents.c           |  215 +++++++++++-------------------
fs/ext4/indirect.c          |   13 +--
fs/ext4/inode.c             |  316 +++++++++++++++++++------------------------
fs/jbd2/journal.c           |    1 +
fs/jbd2/transaction.c       |   20 +++-
fs/ocfs2/aops.c             |    7 +-
fs/xfs/xfs_aops.c           |   14 +-
fs/xfs/xfs_trace.h          |   41 ++++++-
include/linux/buffer_head.h |    2 +
include/linux/fs.h          |    2 +
include/linux/jbd2.h        |    2 +
include/linux/mm.h          |    2 +
include/trace/events/ext4.h |   55 +++++---
mm/truncate.c               |  107 +++++++++++-----
16 files changed, 437 insertions(+), 397 deletions(-)


