From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 6/6] Updated series file
Date: Thu, 14 Jun 2007 21:29:26 +0530
Message-ID: <1181836766.15456.2.camel@garfield>
References: <1181835073.7779.9.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-kKh6Bm70qvS8esbZE3QF"
Cc: Mingming Cao <cmm@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Jean noel Cordenner <jean-noel.cordenner@bull.net>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:52883 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXFNP7T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jun 2007 11:59:19 -0400
In-Reply-To: <1181835073.7779.9.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-kKh6Bm70qvS8esbZE3QF
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The updated series file.


--=-kKh6Bm70qvS8esbZE3QF
Content-Disposition: attachment; filename=series
Content-Type: text/plain; name=series; charset=UTF-8
Content-Transfer-Encoding: 7bit

# Rebased the patches to 2.6.22-rc4

# Add mount option to turn off extents
ext4_noextent_mount_opt.patch

# Mounted ext4dev fs with extents by default for testing purpose,
# for Ext4 product release, extents mount option
# will be turn on only if the fs has EXTENTS feature on
ext4_extents_on_by_default.patch

# Propagate inode flags
ext4-propagate_flags.patch

# Add extent sanity checks
ext4-extent-sanity-checks.patch

# Bug fix:set 64bit JBD2 feature on >32bit ext4 fs
ext4_set_jbd2_64bit_feature.patch

# Fix: Rename CONFIG_JBD_DEBUG to CONFIG_JBD2_DEBUG
jbd2_config_jbd2_debug_fix.patch

# Export jbd2-debug via debugfs
ext4_CONFIG_JBD2_DEBUG.patch
jbd2_move_jbd2_debug_to_debugfs.patch

# fallocate() syscall patches and ext4 fallocate() implementation
# Missing manpages
ext4-fallocate-1-syscall_i386_amd64_ppc
ext4-fallocate-2-syscall_s390
ext4-fallocate-3-syscall_ia64
ext4-fallocate-5-ext4_support
ext4-fallocate-6-uninit_write_support

# Nanosecond timestamp support
ext4-nanosecond-patch

# inode verion patch series
# inode versioning is needed for NFSv4

# vfs changes, 64 bit inode->i_version
64-bit-i_version.patch
# reserve hi 32 bit inode version on ext4 on-disk inode
i_version_hi.patch
# ext4 inode version read/store
ext4_i_version_hi_2.patch
# ext4 inode version update
i_version_update_ext4.patch
# add a noversion mount option to disable inode version updates
ext4_no_version.patch
# VFS-level updates of inode version.
i_version_update_vfs.patch

# New patch to expand inode i_extra_isize to support features
# in high part of inode (>128 bytes)
ext4_expand_inode_extra_isize.patch

# Export jbd stats through procfs
# Shall this move to debugfs?
jbd-stats-through-procfs

# Remove 32000 subdirs limit. 
ext4_remove_subdirs_limit.patch

##############################################################
# Unstable patches
# Note: still lots of outstanding comments from linux-ext4 list, 12/2006
# Missing signed-off-by:
booked-page-flag.patch

# Reserve blocks for delalloc
ext4-block-reservation.patch

# Delayed allocation support for data=writeback mode
# Needs support for ordered mode and pagesize!= fs block size
ext4-delayed-allocation.patch

# 48 bit block number support in delalloc
ext4-delalloc-extents-48bit.patch

# Add mount option to turn off delayed allocation
ext4_nodelalloc_mount_opt.patch

--=-kKh6Bm70qvS8esbZE3QF--
