From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 00/11] rbtree: postorder iteration: fix, add tests, and use in various places
Date: Wed,  6 Nov 2013 17:42:29 -0800
Message-ID: <1383788572-25938-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	EXT4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	rostedt@goodmis.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

New in v2:
1: Jan Kara's fix for rbtree_postorder_for_each_entry_safe() for when gcc tries to optimize it.
2,3: test the above mentioned macro and reorder the test struct to catch anther class of errors.

Unchanged from v1:
4-11: use the postorder_for_each() in various locations.

--
Cody P Schafer (10):
  rbtree/test: move rb_node to the middle of the test struct
  rbtree/test: test rbtree_postorder_for_each_entry_safe()
  net ipset: use rbtree postorder iteration instead of opencoding
  trace/trace_stat: use rbtree postorder iteration helper instead of
    opencoding
  fs/ubifs: use rbtree postorder iteration helper instead of opencoding
  fs/ext4: use rbtree postorder iteration helper instead of opencoding
  fs/jffs2: use rbtree postorder iteration helper instead of opencoding
  fs/ext3: use rbtree postorder iteration helper instead of opencoding
  mtd/ubi: use rbtree postorder iteration helper instead of opencoding
  sh/dwarf: use rbtree postorder iteration helper instead of solution
    using repeated rb_erase()

Jan Kara (1):
  rbtree: Fix rbtree_postorder_for_each_entry_safe() iterator

 arch/sh/kernel/dwarf.c                     | 18 +++--------
 drivers/mtd/ubi/attach.c                   | 49 +++++-------------------------
 drivers/mtd/ubi/wl.c                       | 25 ++-------------
 fs/ext3/dir.c                              | 36 +++-------------------
 fs/ext4/block_validity.c                   | 33 +++-----------------
 fs/ext4/dir.c                              | 35 +++------------------
 fs/jffs2/nodelist.c                        | 28 ++---------------
 fs/jffs2/readinode.c                       | 26 ++--------------
 fs/ubifs/debug.c                           | 22 ++------------
 fs/ubifs/log.c                             | 21 ++-----------
 fs/ubifs/orphan.c                          | 21 ++-----------
 fs/ubifs/recovery.c                        | 21 ++-----------
 fs/ubifs/super.c                           | 24 +++------------
 fs/ubifs/tnc.c                             | 22 ++------------
 include/linux/rbtree.h                     | 16 +++++-----
 kernel/trace/trace_stat.c                  | 42 ++++---------------------
 lib/rbtree_test.c                          | 13 +++++++-
 net/netfilter/ipset/ip_set_hash_netiface.c | 27 +++-------------
 18 files changed, 81 insertions(+), 398 deletions(-)

-- 
1.8.4.2
