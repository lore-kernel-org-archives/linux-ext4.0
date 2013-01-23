From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 00/10 v3] ext4: extent status tree (step2)
Date: Wed, 23 Jan 2013 20:03:50 +0800
Message-ID: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

Here is my third try to implement the second step of extent status tree.
The first step has been applied into upstream kernel.  In the second
step, extent status tree will track all extent status, and it will be as
a extent cache for extent tree.  Thus, we can first try to lookup a
block mapping in this tree before accessing extent tree.  Meanwhile we
add nr_cached_objects() and free_cached_objects() callback functions to
try to reclaim extents from the extent status tree under a heavy memory
pressure because fragmented extent tree causes that extent status tree
costs too much memory.

This patch series is also sent to linux-fsdevel mailing list because
we want to change prune_super() function so that we could avoid to
reclaim too many cached objects.

changelog:
v3 <- v2:
 - use prune_super() to reclaim extents from extent status tree
 - stashed es_status into es_pblk
 - remove single extent cache
 - rebase against 3.8-rc4

v2 <- v1:
 - drop patches that try to improve unwritten extent conversion
 - remove EXT4_MAP_FROM_CLUSTER flag
 - add tracepoint for ext4_es_lookup_extent()
 - drop a patch, which tries to fix a warning when bigalloc and delalloc are
   enabled
 - add a shrinker to reclaim memory from extent status tree
 - rebase against 3.8-rc2

v2: http://lwn.net/Articles/532446/
v1: http://lwn.net/Articles/531065/

Any comments or feedbacks are welcome.

Regards,
						- Zheng

Theodore Ts'o (1):
  fs: allow for fs-specific objects to be pruned as part of pruning
    inodes

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

 fs/ext4/ext4.h              |  33 +--
 fs/ext4/ext4_extents.h      |   6 -
 fs/ext4/extents.c           | 256 ++++----------------
 fs/ext4/extents_status.c    | 554 ++++++++++++++++++++++++++++++++------------
 fs/ext4/extents_status.h    |  50 +++-
 fs/ext4/file.c              |  14 +-
 fs/ext4/inode.c             | 138 ++++++++---
 fs/ext4/move_extent.c       |   3 -
 fs/ext4/super.c             |  20 +-
 fs/super.c                  |  22 +-
 include/trace/events/ext4.h | 158 ++++++++++---
 11 files changed, 783 insertions(+), 471 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

