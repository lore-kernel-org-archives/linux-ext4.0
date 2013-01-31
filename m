From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/9 v4] ext4: extent status tree (step2)
Date: Thu, 31 Jan 2013 13:17:48 +0800
Message-ID: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58415 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3AaFED (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jan 2013 00:04:03 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so363373pad.6
        for <linux-ext4@vger.kernel.org>; Wed, 30 Jan 2013 21:04:03 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Here's the fourth round to implement the second step of extent status
tree.  In the first step, extent status tree can track all delayed
extents, improve bigalloc, delayed allocation, and introduce lseek(2)
seek data/hole.  The first step has been applied.  In the second step,
extent status tree will try to track all extent status, and it will be
as a extent cache for extent tree.  Then we can first lookup a block
mapping from extent status tree before traversing extent tree.

The major change in this version is to rework the patch that reclaims
extent from extent status tree.  Now when the extent status tree of an
inode is accessing, this inode will be moved into the tail of the lru
list.  A counter is used to count the number of written/unwritten
extents in a extent status tree.  Meanwhile a normal shrinker is
registered to reclaim memeory when we are under a high memory pressure.
ext4_es_reclaim_extent_count() traverses the lru list to count all
cached objects.  ext4_es_shrink() tries to reclaim written/unwritten
extent from the tree.  Here we never reclaim delayed extent in the tree
because bigalloc, seek data/hole, and fiemap need it.

I do the following test to verify that the shrinker works well.  50
files that the length of file is 128m are created with 2048 extents,
and mlock(2) is used to occupy the memory as much as possible.  Then
grep(1) is used to touch all extents of every files.  I can see from the
tracepoint in ext4_es_shrink() that extents are reclaimed.

changelog:
v4 <- v3:
 - register a normal shrinker to reclaim extent from extent status tree

v3 <- v2:
 - use prune_super() to reclaim extents from extent status tree
 - stashed es_status into es_pblk
 - remove single extent cache
 - rebase against 3.8-rc4

v2 <- v1:
 - drop patches that try to improve unwritten extent conversion
 - remove EXT4_MAP_FROM_CLUSTER flag
 - add tracepoint for ext4_es_lookup_extent()
 - drop a patch, which tries to fix a warning when bigalloc and delalloc
   are enabled
 - add a shrinker to reclaim memory from extent status tree
 - rebase against 3.8-rc2

v3: http://lwn.net/Articles/533730/
v2: http://lwn.net/Articles/532446/
v1: http://lwn.net/Articles/531065/

Any comments or feedbacks are appreciated.

Regards,
						- Zheng

Zheng Liu (9):
  ext4: refine extent status tree
  ext4: remove EXT4_MAP_FROM_CLUSTER flag
  ext4: add physical block and status member into extent status tree
  ext4: adjust interfaces of extent status tree
  ext4: track all extent status in extent status tree
  ext4: lookup block mapping in extent status tree
  ext4: remove single extent cache
  ext4: adjust some functions for reclaiming extents from extent status
    tree
  ext4: reclaim extents from extent status tree

 fs/ext4/ext4.h              |  34 +--
 fs/ext4/ext4_extents.h      |   6 -
 fs/ext4/extents.c           | 256 ++++---------------
 fs/ext4/extents_status.c    | 588 ++++++++++++++++++++++++++++++++------------
 fs/ext4/extents_status.h    |  50 +++-
 fs/ext4/file.c              |  14 +-
 fs/ext4/inode.c             | 132 +++++++---
 fs/ext4/move_extent.c       |   3 -
 fs/ext4/super.c             |   8 +-
 include/trace/events/ext4.h | 178 ++++++++++++--
 10 files changed, 802 insertions(+), 467 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

