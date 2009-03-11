From: Nick Dokos <nicholas.dokos@hp.com>
Subject: e2fsprogs w/64-bit patches: make check gets one failure
Date: Wed, 11 Mar 2009 14:53:32 -0400
Message-ID: <12304.1236797612@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:28618 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZCKSxf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Mar 2009 14:53:35 -0400
Received: from smtp1.fc.hp.com (smtp.fc.hp.com [15.15.136.127])
	by g4t0016.houston.hp.com (Postfix) with ESMTP id 9A9371420D
	for <linux-ext4@vger.kernel.org>; Wed, 11 Mar 2009 18:53:33 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I followed the workflow that Ted described in the following message:

   http://marc.info/?l=linux-ext4&m=123367642710241&w=2

with the patch series from git://github.com/tytso/e2fsprogs-64bit.git

With all the patches in the series file applied, make check gives
me the following error:

...
f_h_reindex: reindex HTREE Directory with different hash seed: failed
...
100 tests succeeded	1 tests failed
make[1]: *** [check] Error 1
make[1]: Leaving directory `/home/nick/src/e2fsprogs/standard/build/tests'
make: *** [check-recursive] Error 1


I bisected the series and found that the culprit seems to be

  0024-Miscellaneous-e2fsck-related-64-bit-fixes.patch

Unfortunately, a bunch of later patches don't apply cleanly without
this one, so the most complete series file that does not get the
error is the following - uncommenting 0024 gives the error:

# BASE 1.41.4
libext2fs__add_64-bit_support_to_the_undo_manager
add_ext2_off64_t_type
add_new_blk64_t_handling_functions
use_blk64_t_for_blocks_in_struct_ext2_file
add_64-bit_dirblock_interface
add_64-bit_alloc_stats_interface
add_64-bit_alloc_interface
add_64-bit_ext_attr_interface
add_64-bit_closefs_interface
use_new_ext2fs_super_and_bgd_loc2_call_in_libext2fs
add_64-bit_openfs_interface
add_ext2fs_div64_ceil
add_64-bit_mkjournal.c_interface
64-bit_mke2fs_cleanup
Initial-design-for-64-bit-bitmaps.patch 
0002-Squash-warnings.patch
0003-Add-64-bit-bitops.patch
0004-Implement-64-bit-bitarray-bmap-ops.patch
0005-Convert-libext2fs-to-64-bit-bitmap-interface.patch
0006-Convert-mke2fs-to-new-bitmap-interface.patch
0007-Convert-e2fsck-to-new-bitmap-interface.patch
0008-Turn-on-new-bitmaps-in-e2fsck-and-mke2fs.patch
0009-Add-progress-bar-for-allocating-block-tables-takes.patch
0010-signed-int-blk64_t-to-fix-bugs-at-2-31-2-32-blo.patch
0011-Fix-overflow-in-calculation-of-total-file-system-blo.patch
0012-Add-ext2fs_block_iterate3-from-Ted.patch
0013-Support-48-bit-file-acl-blocks.patch
0014-super-s_-_blocks_count-ext2fs_-_blocks_count.patch
0015-Convert-to-inode-block-bitmap-table-loc-loc_set.patch
0016-ext2fs_block_alloc_stats-ext2fs_block_alloc_stats.patch
0017-Convert-to-64-bit-IO.patch
0019-Allow-cancellation-during-group-descriptor-checks.patch
0020-More-progress-meters-more-more.patch
0021-Minor-compiler-warning-fixes.patch
0022-ext2fs_get_device_size-ext2fs_get_device_size2.patch
0023-Add-64bit-option-to-known-incompatible-file-system-o.patch
#0024-Miscellaneous-e2fsck-related-64-bit-fixes.patch
0025-Fix-bug-handling-very-small-final-block-groups-intr.patch
0026-Fix-bug-in-selecting-fs-type-resulting-in-1K-blocks.patch
0027-Add-missing-free_blocks_hi-field-to-debugfs-table.patch
Add-e2p-64bit-blocks-support
0028-super-s_-_blocks_count-ext2fs_-_blocks_count-e.patch
0029-Get-e2fsprogs-ext4_group_desc-in-sync-with-the-kerne.patch
0030-New-accessor-functions-for-block-group-descriptor-va.patch
0042-Create-64-bit-dblist-functions.patch

Let me know if more information is needed.

Thanks,
Nick

Version info (on a Fedora 10 substrate):
Linux 2.6.29-rc7 #1 SMP Wed Mar 11 12:20:10 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
e2fsck/e2fsck -V
e2fsck 1.41.4 (27-Jan-2009)
	Using EXT2FS Library version 1.41.4, 27-Jan-2009
misc/mke2fs -V
mke2fs 1.41.4 (27-Jan-2009)
	Using EXT2FS Library version 1.41.4
