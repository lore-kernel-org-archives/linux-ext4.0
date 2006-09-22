From: Andreas Dilger <adilger@clusterfs.com>
Subject: ext4 compat flag assignments
Date: Fri, 22 Sep 2006 02:15:20 -0700
Message-ID: <20060922091520.GC6335@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:24556 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751108AbWIVJPX
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Sep 2006 05:15:23 -0400
To: Theodore Ts'o <tytso@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ted,
there are several COMPAT flag assignments that have been proposed in
the past:

- EXT4_FEATURE_INCOMPAT_64BIT (0x0080!) - support for 64-bit block count
  fields in the superblock (s_blocks_count_hi, s_free_blocks_count_hi),
  large group descriptors (s_desc_size), extents with high 16 bits
  (ee_start_hi, ei_leaf_hi), inode ACL (i_file_acl_hi).  May also grow
  to encompass the previously proposed BIG_BG.

- EXT4_FEATURE_RO_COMPAT_HUGE_FILE (0x0008) - change i_blocks to be
  in units of s_blocksize units instead of 512-byte sectors, use
  l_i_frag and l_i_fsize as i_blocks_hi (could also be part of 64BIT).
  Also uses EXT4_HUGE_FILE_FL 0x40000 for i_flags.

- EXT4_FEATURE_RO_COMPAT_GDT_CSUM (0x0010?) - store a crc16 checksum in
  the group descriptor (s_uuid[16] | __u32 group | ext3_group_desc
  (excluding gd_checksum itself)).  This allows the kernel to more safely
  manage UNINIT groups.  Incomplete patch, e2fsck support mostly done.

- EXT4_FEATURE_RO_COMPAT_DIR_NLINK (0x0020?) - allow directories to have
  > 65000 subdirectories (i_nlinks) by setting i_nlinks = 1 for such
  directories.  RO_COMPAT protects old filesystems from unlinking such
  directories incorrectly and losing all files therein.  Needs RO_COMPAT
  flag handling, needs e2fsck support, but very heavily tested.

- EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE (0x0040?) - add s_min_extra_isize and
  s_want_extra_isize fields to superblock, which allow specifying
  the minimum and desired i_extra_isize fields in large inodes
  (for nsec+epoch timestamps, potential other uses).  Needs RO_COMPAT
  flag handling, needs e2fsck support, patch complete, little testing.


I'm not sure about the state of HUGE_FILE (it might be useful for ext[23]
to allow larger sparse files, but also fits quite well with INCOMPAT_64BIT),
but the others are definitely useful independent from INCOMPAT_64BIT.
There are patches in various states of completion for all of the features.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

