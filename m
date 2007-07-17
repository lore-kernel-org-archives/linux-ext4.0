From: Mingming Cao <cmm@us.ibm.com>
Subject: ext4 patch queue updated
Date: Tue, 17 Jul 2007 13:44:41 -0700
Message-ID: <1184705081.3820.10.camel@localhost.localdomain>
References: <1183275416.4010.125.camel@localhost.localdomain>
	 <20070710163027.1bf7e94e.akpm@linux-foundation.org>
	 <1184633395.3836.24.camel@localhost.localdomain>
	 <1184666370.7063.13.camel@garfield.linsyssoft.com>
	 <1184699323.3820.3.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37984 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbXGQUoj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jul 2007 16:44:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6HKic2w030930
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 16:44:38 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6HKid2t389012
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 16:44:39 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6HKiclg024198
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jul 2007 16:44:39 -0400
In-Reply-To: <1184699323.3820.3.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

The ext4 patch queue has been updated with updates to address latest
review comments.  http://repo.or.cz/w/ext4-patch-queue.git

The series is being reordered: the patches still has outstanding
comments are moved to the end of the series. Per our discussion on
Monday, tThose patches are ready for submission are

# Rebased the patches to 2.6.22

# fallocate() syscall patches and ext4 fallocate() implementation
# Missing manpages
#ext4-fallocate-1-man-page
ext4-fallocate-2-syscall_i386_amd64_ppc
ext4-fallocate-3-ext4_support
ext4-fallocate-4-uninit_write_support
ext4-fallocate-5-new-ondisk-format

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
jbd2_move_jbd2_debug_to_debugfs.patch

# Nanosecond timestamp support
ext4-nanosecond-patch
ext4_negative_timestamp_handle_fix.patch

# New patch to expand inode i_extra_isize to support features
# in high part of inode (>128 bytes)
ext4_expand_inode_extra_isize.patch

# Remove 32000 subdirs limit. 
ext4_remove_subdirs_limit.patch

# Various Cleanups
ext4-zero_user_page.patch
is_power_of_2-ext4-superc.patch
ext4-remove-extra-is_rdonly-check.patch
ext4_extent_compilation_fixes.patch
ext4_extent_macros_cleanup.patch

#JBD->JBD2 naming cleanups
