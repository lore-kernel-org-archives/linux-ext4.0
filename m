From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] ext2, ext3, and quota fixes
Date: Mon, 12 Apr 2010 21:22:12 +0200
Message-ID: <20100412192212.GN3404@quack.suse.cz>
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

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get a few fixes:

Andrew Perepechko (1):
      quota: Fix possible dq_flags corruption

Dmitry Monakhov (2):
      ext2: symlink must be handled via filesystem specific operation
      ext3: symlink must be handled via filesystem specific operation

Jan Kara (1):
      quota: Hide warnings about writes to the filesystem before quota was turned on

The diffstat is

 fs/ext2/symlink.c |    2 ++
 fs/ext3/symlink.c |    2 ++
 fs/quota/dquot.c  |   18 ++++++++++++------
 3 files changed, 16 insertions(+), 6 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
