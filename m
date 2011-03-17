From: Jan Kara <jack@suse.cz>
Subject: [PULL REQUEST] Ext3, jbd, and quota fixes for 2.6.39-rc1
Date: Thu, 17 Mar 2011 20:55:54 +0100
Message-ID: <20110317195554.GA13136@quack.suse.cz>
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

The branch contains several ext3, jbd, and quota fixes.

The full shortlog is:

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Davidlohr Bueso (1):
      quota: return -ENOMEM when memory allocation fails

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Justin P. Mattock (1):
      jbd: Remove one to many n's in a word.

Tao Ma (3):
      ext3: Adjust trim start with first_data_block.
      ext3: speed up group trim with the right free block count.
      ext3: Fix an overflow in ext3_trim_fs.

The diffstat is

 fs/ext3/balloc.c    |   21 ++++++++++++---------
 fs/ext3/namei.c     |    2 +-
 fs/ext3/super.c     |    7 +++++++
 fs/jbd/journal.c    |    2 +-
 fs/jbd2/journal.c   |    2 +-
 fs/quota/quota_v2.c |    2 +-
 6 files changed, 23 insertions(+), 13 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
