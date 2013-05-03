From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext3/jbd fixes for 3.10-rc1
Date: Fri, 3 May 2013 11:50:06 +0200
Message-ID: <20130503095006.GA13470@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get a couple of ext3/jbd fixes.

Top of the tree is fb1c2d8. The full shortlog is:

Jan Kara (3):
      ext3: fix data=journal fast mount/umount hang
      jbd: don't wait (forever) for stale tid caused by wraparound
      Merge branch 'for_next' into for_linus

Zheng Liu (2):
      jbd: use kmem_cache_zalloc instead of kmem_cache_alloc/memset
      jbd: use kmem_cache_zalloc for allocating journal head

The diffstat is

 fs/ext3/inode.c      |    3 ++-
 fs/jbd/journal.c     |   19 ++++++++++++++-----
 fs/jbd/transaction.c |    1 -
 include/linux/jbd.h  |    2 +-
 4 files changed, 17 insertions(+), 8 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
