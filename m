From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] FS bugfixes for 3.17-rc2
Date: Thu, 21 Aug 2014 00:32:33 +0200
Message-ID: <20140820223233.GA6477@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get udf, isofs, and ext3 bug fix.

Top of the tree is e6d8fb340f20. The full shortlog is:

Chao Yu (1):
      udf: avoid unneeded up_write when fail to add entry in ->symlink

Chin-Tsung Cheng (1):
      ext3: Count internal journal as bsddf overhead in ext3_statfs

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

The diffstat is

 fs/ext3/super.c  |  5 +++--
 fs/isofs/inode.c | 15 ++++++++-------
 fs/isofs/isofs.h | 23 +++++++++++++++++++----
 fs/isofs/rock.c  | 39 ++++++++++++++++++++++++++++-----------
 fs/udf/namei.c   |  3 ++-
 5 files changed, 60 insertions(+), 25 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
