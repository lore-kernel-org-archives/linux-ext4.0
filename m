From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext2 changes for 4.4-rc1
Date: Mon, 9 Nov 2015 14:09:44 +0100
Message-ID: <20151109130944.GE11149@quack.suse.cz>
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

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get fixes for DAX for ext2 and a minor fixup for ext4 Kconfig
description (leftover from ext3 removal).

Top of the tree is 5726b27b09cc. The full shortlog is:

Jean Delvare (1):
      ext4: Update EXT4_USE_FOR_EXT2 description

Ross Zwisler (1):
      ext2: Add locking for DAX faults

The diffstat is

 fs/ext2/ext2.h  | 11 ++++++++
 fs/ext2/file.c  | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext2/inode.c | 10 +++++++
 fs/ext2/super.c |  3 +++
 fs/ext4/Kconfig |  2 +-
 5 files changed, 105 insertions(+), 5 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
