From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Reiserfs & ext3 changes for 3.16-rc1
Date: Wed, 4 Jun 2014 22:27:58 +0200
Message-ID: <20140604202758.GC22927@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get big reiserfs cleanup from Jeff, an ext3 deadlock fix, and some small
cleanups.

Top of the tree is 166418ccefc3. The full shortlog is:

Fabian Frederick (2):
      reiserfs: remove obsolete __constant_cpu_to_le32
      fs/jbd/revoke.c: replace shift loop by ilog2

Jan Kara (1):
      ext3: Fix deadlock in data=journal mode when fs is frozen

Jeff Mahoney (30):
      reiserfs: use per-fs commit workqueues
      reiserfs: cleanup, rename key and item accessors to more friendly names
      reiserfs: cleanup, reformat comments to normal kernel style
      reiserfs: cleanup, remove nblocks argument from journal_end
      reiserfs: cleanup, remove sb argument from journal_end
      reiserfs: cleanup, remove sb argument from journal_mark_dirty
      reiserfs: cleanup, remove blocks arg from journal_join
      reiserfs: cleanup, remove unnecessary parens in dirent creation
      reiserfs: cleanup, remove leading whitespace from labels
      reiserfs: cleanup, remove unnecessary parens
      reiserfs: cleanup, make hash detection saner
      reiserfs: balance_leaf refactor, reformat balance_leaf comments
      reiserfs: balance_leaf refactor, move state variables into tree_balance
      reiserfs: balance_leaf refactor, pull out balance_leaf_insert_left
      reiserfs: balance_leaf refactor, pull out balance_leaf_paste_left
      reiserfs: balance_leaf refactor, pull out balance_leaf_insert_right
      reiserfs: balance_leaf refactor, pull out balance_leaf_paste_right
      reiserfs: balance_leaf refactor, pull out balance_leaf_new_nodes_insert
      reiserfs: balance_leaf refactor, pull out balance_leaf_new_nodes_paste
      reiserfs: balance_leaf refactor pull out balance_leaf_finish_node_insert
      reiserfs: balance_leaf refactor, pull out balance_leaf_finish_node_paste
      reiserfs: balance_leaf refactor, pull out balance_leaf{left, right, new_nodes, finish_node}
      reiserfs: balance_leaf refactor, format balance_leaf_insert_left
      reiserfs: balance_leaf refactor, format balance_leaf_paste_left
      reiserfs: balance_leaf refactor, format balance_leaf_insert_right
      reiserfs: balance_leaf refactor, format balance_leaf_paste_right
      reiserfs: balance_leaf refactor, format balance_leaf_new_nodes_paste
      reiserfs: balance_leaf refactor, format balance_leaf_finish_node
      reiserfs: balance_leaf refactor, split up balance_leaf_when_delete
      reiserfs: call truncate_setsize under tailpack mutex

The diffstat is

 fs/ext3/inode.c               |   33 +-
 fs/jbd/revoke.c               |   12 +-
 fs/reiserfs/bitmap.c          |  259 +++--
 fs/reiserfs/dir.c             |  156 +--
 fs/reiserfs/do_balan.c        | 2449 +++++++++++++++++++++++------------------
 fs/reiserfs/file.c            |   90 +-
 fs/reiserfs/fix_node.c        | 1008 ++++++++++-------
 fs/reiserfs/hashes.c          |   15 +-
 fs/reiserfs/ibalance.c        |  271 +++--
 fs/reiserfs/inode.c           | 1206 +++++++++++---------
 fs/reiserfs/ioctl.c           |   27 +-
 fs/reiserfs/item_ops.c        |  108 +-
 fs/reiserfs/journal.c         | 1339 ++++++++++++----------
 fs/reiserfs/lbalance.c        |  501 +++++----
 fs/reiserfs/namei.c           |  513 +++++----
 fs/reiserfs/objectid.c        |  101 +-
 fs/reiserfs/prints.c          |  176 +--
 fs/reiserfs/reiserfs.h        | 1921 ++++++++++++++++++++------------
 fs/reiserfs/resize.c          |   75 +-
 fs/reiserfs/stree.c           |  892 ++++++++-------
 fs/reiserfs/super.c           |  552 ++++++----
 fs/reiserfs/tail_conversion.c |  161 +--
 fs/reiserfs/xattr.c           |   70 +-
 fs/reiserfs/xattr.h           |    3 +-
 fs/reiserfs/xattr_acl.c       |   38 +-
 25 files changed, 7056 insertions(+), 4920 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
