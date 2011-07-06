From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/23] New spin of the bigalloc patches
Date: Wed,  6 Jul 2011 12:35:43 -0400
Message-ID: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33460 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This version of the bigalloc patch set has a bunch of fixes so that
delayed allocation and i_blocks/quota works correctly, which was the
major set of failures that we had been seeing.  There is still are a few
warnings triggering in ext4_da_reserve_space():

EXT4-fs (sdb2): ext4_da_update_reserve_space: ino 13, used 1 with only 0 reserved data

caused by fsstress, but this should be much more stable.  Thanks to
Aditya Kali for his yeoman work to fix this problem.

The next branch in e2fsprogs branch also has a number of bigalloc fixes.
E2fsck should now be able to properly check bigalloc file systems, and
repair many of the more common bigalloc file system corruption issues.

       	       	   	       		     	    - Ted

Aditya Kali (2):
  ext4: Fix bigalloc quota accounting and i_blocks value
  ext4: add some tracepoints in ext4/extents.c

Theodore Ts'o (21):
  ext4: read-only support for bigalloc file systems
  ext4: enforce bigalloc restrictions (e.g., no online resizing, etc.)
  ext4: convert instances of EXT4_BLOCKS_PER_GROUP to
    EXT4_CLUSTERS_PER_GROUP
  ext4: factor out block group accounting into functions
  ext4: split out ext4_free_blocks_after_init()
  ext4: bigalloc changes to block bitmap initialization functions
  ext4: convert block group-relative offsets to use clusters
  ext4: teach mballoc preallocation code about bigalloc clusters
  ext4: teach ext4_free_blocks() about bigalloc and clusters
  ext4: teach ext4_ext_map_blocks() about the bigalloc feature
  ext4: teach ext4_ext_truncate() about the bigalloc feature
  ext4: convert s_{dirty,free}blocks_counter to
    s_{dirty,free}clusters_counter
  ext4: convert the free_blocks field in s_flex_groups to be
    free_clusters
  ext4: teach ext4_statfs() to deal with clusters if bigalloc is
    enabled
  ext4: tune mballoc's default group prealloc size for bigalloc file
    systems
  ext4: enable mounting bigalloc as read/write
  ext4: Rename ext4_free_blks_{count,set}() to refer to clusters
  ext4: rename ext4_count_free_blocks() to ext4_count_free_clusters()
  ext4: rename ext4_free_blocks_after_init() to
    ext4_free_clusters_after_init()
  ext4: rename ext4_claim_free_blocks() to ext4_claim_free_clusters()
  ext4: rename ext4_has_free_blocks() to ext4_has_free_clusters()

 fs/ext4/balloc.c            |  345 +++++++++++++++----------
 fs/ext4/ext4.h              |   94 +++++--
 fs/ext4/ext4_extents.h      |    2 +
 fs/ext4/extents.c           |  607 ++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/ialloc.c            |   73 +++---
 fs/ext4/indirect.c          |    7 +
 fs/ext4/inode.c             |   87 +++++--
 fs/ext4/ioctl.c             |   33 ++-
 fs/ext4/mballoc.c           |  290 +++++++++++++--------
 fs/ext4/mballoc.h           |    9 +-
 fs/ext4/resize.c            |   10 +-
 fs/ext4/super.c             |  151 ++++++++---
 include/trace/events/ext4.h |  415 ++++++++++++++++++++++++++++-
 13 files changed, 1677 insertions(+), 446 deletions(-)

-- 
1.7.4.1.22.gec8e1.dirty

