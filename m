From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] UDF and ext2 fix for 4.16-rc1
Date: Wed, 7 Feb 2018 11:46:18 +0100
Message-ID: <20180207104618.c73pavjhkgnof2zi@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get an UDF fix and an ext2 cleanup.

Top of the tree is f463589a7cd2. The full shortlog is:

Jan Kara (1):
      udf: Sanitize nanoseconds for time stamps

Julia Lawall (1):
      ext2: drop unneeded newline

The diffstat is

 fs/ext2/super.c  | 2 +-
 fs/udf/udftime.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
