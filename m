From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext3 & udf fixes for 3.7-rc1
Date: Thu, 4 Oct 2012 14:34:29 +0200
Message-ID: <20121004123429.GE4641@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

Shortlog pretty much says it all. Interesting bits are UDF support for
direct IO and ext3 fix for a long standing oops in data=journal mode.

Top of the tree is 09e05d4. The full shortlog is:

Eric Sandeen (1):
      ext3: don't clear orphan list on ro mount with errors

Ian Abbott (1):
      UDF: Add support for O_DIRECT

Jan Kara (2):
      Merge branch 'fast_track' into for_next
      jbd: Fix assertion failure in commit code due to lacking transaction credits

Namjae Jeon (1):
      udf: add writepages support for udf

Sachin Kamat (2):
      reiserfs: Make reiserfs_xattr_handlers static
      ext3: Replace 0 with NULL for pointer in super.c file

The diffstat is

 arch/um/os-Linux/time.c |    2 +-
 fs/ext3/super.c         |    8 +++--
 fs/jbd/commit.c         |   45 +++++++++++++++++++++++++--------
 fs/jbd/transaction.c    |   64 ++++++++++++++++++++++++++++++++--------------
 fs/reiserfs/xattr.c     |    2 +-
 fs/udf/file.c           |    9 ++++++
 fs/udf/inode.c          |   59 +++++++++++++++++++++++++++++++-----------
 7 files changed, 137 insertions(+), 52 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
