From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Quota, fsnotify, and ext2 changes for 4.10-rc1
Date: Mon, 19 Dec 2016 10:34:42 +0100
Message-ID: <20161219093442.GD17598@quack2.suse.cz>
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

to get changes to locking of some quota operations from dedicated quota mutex
to s_umount semaphore, a fsnotify fix and a simple ext2 fix.

Top of the tree is 5716863e0f82. The full shortlog is:

Darrick J. Wong (1):
      ext2: reject inodes with negative size

Jan Kara (8):
      fs: Provide function to get superblock with exclusive s_umount
      quota: Hold s_umount in exclusive mode when enabling / disabling quotas
      quota: Use s_umount protection for quota operations
      ocfs2: Protect periodic quota syncing with s_umount semaphore
      quota: Remove dqonoff_mutex from dquot_scan_active()
      ocfs2: Use s_umount for quota recovery protection
      quota: Remove dqonoff_mutex
      fsnotify: Fix possible use-after-free in inode iteration on umount

The diffstat is

 fs/ext2/inode.c         |   4 ++
 fs/notify/inode_mark.c  |  45 ++++------------
 fs/ocfs2/quota_global.c |  10 +++-
 fs/ocfs2/quota_local.c  |  11 ++--
 fs/ocfs2/super.c        |   1 -
 fs/quota/dquot.c        | 134 +++++++++++++++++-------------------------------
 fs/quota/quota.c        |  22 +++++---
 fs/super.c              |  81 +++++++++++++++++++++--------
 include/linux/fs.h      |   2 +
 include/linux/quota.h   |   1 -
 10 files changed, 151 insertions(+), 160 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
