From: Mingming <cmm@us.ibm.com>
Subject: Re: Preparing to push patches for the merge window
Date: Mon, 14 Sep 2009 07:24:36 -0700
Message-ID: <1252938276.4920.11.camel@mingming-laptop>
References: <E1MmDzB-000357-Po@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:40852 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZINOZB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Sep 2009 10:25:01 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n8EEFCE2027580
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2009 08:15:12 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8EEOfGW030718
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2009 08:24:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8EEOeUm032150
	for <linux-ext4@vger.kernel.org>; Mon, 14 Sep 2009 08:24:41 -0600
In-Reply-To: <E1MmDzB-000357-Po@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-09-11 at 17:48 -0400, Theodore Ts'o wrote:
> See below for a list for what I currently have in the ext4 patch queue.
> 
> Patches which are NOT yet included are:
> 
> o  Mingming's Fallocate / Direct I/O patches.
> 
> 	Mingming, it looked like you were still polishing these two
> 	patches?
> 

Yeah, the aio fsync issue is till being working on. I also have some
issue with using igrab/iput to hold the inode in cache. 

Thanks,
Mingming
> o  Eric's "limit block allocations for indirect-block files to < 2^32" patch
> 
> 	Eric, looks like you were still polishing this?
> 
> o Patches to fix crashes associated with sparse files and the
>   EXT4_IOC_MOVE_EXT ioctl which Peng Tao and Akira Fujita-san have been
>   working on.   (Looks like they are still working on trying to
>   reproduce the problem reliably, and there have been patches going back
>   and forth, but they seem to be for testing only.)
> 
> o  A port of Chris Mason's "ext3: Add locking to ext3_do_update_inode" to
>    ext4.  I'll try to look into this.
> 
> Are there other patches not listed above or below that should be
> targeted for 2.6.32?
> 
> What I may do is push what we have so far to Linus, and then we can do a
> second push for patches that aren't quite ready yet.
> 
> 					- Ted
> 
> Akira Fujita (5):
>       ext4: Fix compile warnings with MB_DEBUG
>       ext4: Fix wrong comparisons in mext_check_arguments()
>       ext4: Remove unneeded BUG_ON() in ext4_move_extents()
>       ext4: Return exchanged blocks count to user space in failure
>       ext4: Fix small typo for move_extent_per_page()
> 
> Andreas Dilger (1):
>       jbd2: round commit timer up to avoid uncommitted transaction
> 
> Andreas Schlick (1):
>       ext4: Always set dx_node's fake_dirent explicitly.
> 
> Aneesh Kumar K.V (7):
>       ext4: Fix memory leak fix when mounting an ext4 filesystem
>       ext4: Add missing unlock_new_inode() call in extent migration code
>       ext4: Allow rename to create more than EXT4_LINK_MAX subdirectories
>       ext4: Take page lock before looking at attached buffer_heads flags
>       ext4: move ext4_mb_init_group() function earlier in the mballoc.c
>       ext4: check for need init flag in ext4_mb_load_buddy
>       ext4: Clarify the locking details in mballoc
> 
> Christoph Hellwig (1):
>       ext4: fix cache flush in ext4_sync_file
> 
> Curt Wohlgemuth (1):
>       ext4: More buffer head reference leaks
> 
> Eric Sandeen (6):
>       ext4: reject too-large filesystems on 32-bit kernels
>       ext4: open-code ext4_mb_update_group_info
>       simplify some logic in ext4_mb_normalize_request
>       ext4: Add feature set check helper for mount & remount paths
>       ext4: use variables not types in sizeofs() for allocations
>       ext4: use ext4_grpblk_t more extensively
> 
> Frank Mayhar (1):
>       ext4: Make non-journal fsync work properly
> 
> H Hartley Sweeten (1):
>       jbd2: bitfields should be unsigned
> 
> Jan Kara (3):
>       jbd2: Fail to load a journal if it is too short
>       jbd2: Annotate transaction start also for jbd2_journal_restart()
>       ext4: Fix possible deadlock between ext4_truncate() and ext4_get_blocks()
> 
> Joe Perches (1):
>       ext4: Remove unnecessary semicolons in mballoc.c
> 
> Manish Katiyar (1):
>       ext4: Fix typo in ext4/Kconfig
> 
> Mingming (2):
>       ext4: Compile warning fix when EXT_DEBUG enabled
>       ext4: Show unwritten extent flag in ext4_ext_show_leaf()
> 
> Peng Tao (2):
>       ext4: fix build warning when EXT4FS_DEBUG is on
>       ext4: fix journal ref count in move_extent_par_page
> 
> Roel Kluin (1):
>       ext4: remove redundant test on unsigned
> 
> Theodore Ts'o (18):
>       ext4: Avoid null pointer dereference when decoding EROFS w/o a journal
>       ext4: Add configurable run-time mballoc debugging
>       ext4: Display the mballoc flags in mb_history in hex instead of decimal
>       ext4: Fix bugs in mballoc's stream allocation mode
>       ext4: Avoid group preallocation for closed files
>       ext4: fix extent sanity checking code with AGGRESSIVE_TEST
>       ext4: Limit number of links that can be created by ext4_link()
>       ext4: Fix spelling typo in the trace format for trace_ext4_da_writepages()
>       ext4: Restore wbc->range_start in ext4_da_writepages()
>       ext4: Add new tracepoint: trace_ext4_da_write_pages()
>       ext4: fix tracepoint format string warnings
>       ext4: Remove journal_checksum mount option and enable it by default
>       ext4: print more sysadmin-friendly message in check_block_validity()
>       ext4: Use bforget() in no journal mode for ext4_journal_{forget,revoke}()
>       ext4: Assure that metadata blocks are written during fsync in no journal mode
>       ext4: Don't update superblock write time when filesystem is read-only
>       ext4: Fix async commit mode to be safe by using a barrier
>       ext4: Fix initalization of s_flex_groups
> 
> Tobias Klauser (1):
>       ext4: Declare seq_operations and file_operations structures as const
> 
>  Documentation/filesystems/ext4.txt |    8 +-
>  fs/ext4/Kconfig                    |   11 +-
>  fs/ext4/balloc.c                   |    2 +-
>  fs/ext4/ext4.h                     |   84 ++++++--
>  fs/ext4/ext4_extents.h             |    3 +-
>  fs/ext4/ext4_jbd2.c                |    9 +-
>  fs/ext4/extents.c                  |  112 ++++++----
>  fs/ext4/fsync.c                    |    4 +-
>  fs/ext4/ialloc.c                   |    2 +-
>  fs/ext4/inode.c                    |  128 +++++++----
>  fs/ext4/ioctl.c                    |    7 +-
>  fs/ext4/mballoc.c                  |  420 ++++++++++++++++++------------------
>  fs/ext4/mballoc.h                  |   22 ++-
>  fs/ext4/migrate.c                  |    2 +-
>  fs/ext4/move_extent.c              |   47 +++--
>  fs/ext4/namei.c                    |   22 ++-
>  fs/ext4/resize.c                   |    7 +-
>  fs/ext4/super.c                    |  152 ++++++++------
>  fs/jbd2/commit.c                   |   11 +-
>  fs/jbd2/journal.c                  |    6 +
>  fs/jbd2/transaction.c              |    7 +-
>  include/linux/jbd2.h               |    2 +-
>  include/trace/events/ext4.h        |  109 +++++++---
>  include/trace/events/jbd2.h        |    2 +-
>  24 files changed, 697 insertions(+), 482 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


