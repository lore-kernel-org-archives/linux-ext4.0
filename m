From: Jan Kara <jack@suse.cz>
Subject: [PULL] Trivial ext2 & ext3 fix for 2.6.35-rc4
Date: Fri, 25 Jun 2010 01:24:17 +0200
Message-ID: <20100624232417.GG3345@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

  to get to two trivial one-liners:

Jan Kara (1):
      ext2: update ctime when changing the file's permission by setfacl

Miao Xie (1):
      ext3: update ctime when changing the file's permission by setfacl

The diffstat is

 fs/ext2/acl.c |    1 +
 fs/ext3/acl.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
