From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH 0/8][RESEND] drop lock/unlock super
Date: Thu, 30 Aug 2012 16:55:49 +0200
Message-ID: <503F7EF5.1030409@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Boaz Harrosh <bharrosh@panasas.com>, bhalevy@tonian.com,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger.kernel@dilger.ca, Theodore Ts'o <tytso@mit.edu>,
	hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
	Al Viro <viro@ZenIV.linux.org.uk>, hch@infradead.org,
	dushistov@mail.ru, osd-dev@open-osd.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60937 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2H3PCb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2012 11:02:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I resend the patch series to remove the deprecated calls lock_super and 
unlock_super. I let you decide what to do. At the moment I received 
positive feedback for ext3/4 and exofs from fs maintainers. I hope 
someone can say "yes" for the others. Al, in case it's ok, can you apply 
them in the vfs tree for 3.7? Actually in the Ted's tree there is 
already the patch for ext4, but however I'm re-sending it because I 
don't want to break a tree.
Thanks.

Marco Stornelli (8):
   exofs: drop lock/unlock super
   ext3: drop lock/unlock super
   ext4: drop lock/unlock super
   fat: drop lock/unlock super
   hpfs: drop lock/unlock super
   sysv: drop lock/unlock super
   ufs: drop lock/unlock super
   vfs: drop lock/unlock super

  fs/exofs/super.c     |    4 ----
  fs/ext3/super.c      |    6 ------
  fs/ext4/super.c      |   11 +----------
  fs/fat/dir.c         |    4 ++--
  fs/fat/fat.h         |    1 +
  fs/fat/inode.c       |    9 +++++----
  fs/fat/namei_msdos.c |   26 +++++++++++++-------------
  fs/fat/namei_vfat.c  |   30 +++++++++++++++---------------
  fs/hpfs/super.c      |    3 ---
  fs/super.c           |   23 -----------------------
  fs/sysv/balloc.c     |   18 +++++++++---------
  fs/sysv/ialloc.c     |   14 +++++++-------
  fs/sysv/inode.c      |    4 ++--
  fs/sysv/super.c      |    1 +
  fs/sysv/sysv.h       |    1 +
  fs/ufs/balloc.c      |   30 +++++++++++++++---------------
  fs/ufs/ialloc.c      |   16 ++++++++--------
  fs/ufs/super.c       |   21 +++++++++++----------
  fs/ufs/ufs.h         |    1 +
  include/linux/fs.h   |    1 -
  20 files changed, 92 insertions(+), 132 deletions(-)

-- 
1.7.3.4
---

