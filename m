From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 00/19] V2 Bigalloc patches
Date: Tue,  3 May 2011 18:24:30 -0400
Message-ID: <1304461490-11056-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:58103 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1ECWYx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 May 2011 18:24:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is the revised bigalloc patches.  This version survives xfstests
with the -o block_validity mount option.  I've attached the e2fsprogs
patches needed so that we can create an bigalloc filesystem.  This is
**not** the final version of the e2fsprogs changes.  Those are currently
in process of being developed.

This is primarily because some folks at the file system summit wanted to
see the in-progress patches.

This patch set is based off of the current ext4 "master" branch.  (There
is a bigalloc branch on the ext4 tree which also contains these
commits.)  These patches **will** conflict with the punch patches from
Allison and Mingming, so this patch set will definitely be changing
after I pull in the punch patches into the ext4 tree.

							- Ted

Theodore Ts'o (19):
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
  ext4: convert s_freeblocks_counter to s_freeclusters_counter
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

 fs/ext4/balloc.c  |  302 ++++++++++++++++++++++++++++++++---------------------
 fs/ext4/ext4.h    |   64 ++++++++---
 fs/ext4/extents.c |  241 +++++++++++++++++++++++++++++++++++++-----
 fs/ext4/ialloc.c  |   72 ++++++-------
 fs/ext4/inode.c   |   19 +++-
 fs/ext4/ioctl.c   |   33 +++++-
 fs/ext4/mballoc.c |  256 ++++++++++++++++++++++++++++-----------------
 fs/ext4/mballoc.h |    9 +-
 fs/ext4/resize.c  |   10 +-
 fs/ext4/super.c   |  139 ++++++++++++++++++-------
 10 files changed, 792 insertions(+), 353 deletions(-)

-- 
1.7.3.1

