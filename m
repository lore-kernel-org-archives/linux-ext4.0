From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] ext2, udf, reiserfs fixes for 4.13-rc1
Date: Thu, 13 Jul 2017 18:18:16 +0200
Message-ID: <20170713161816.GH5884@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752517AbdGMQST (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 13 Jul 2017 12:18:19 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get several ext2, udf, and reiserfs fixes.

Top of the tree is 4d9bcaddacf2. The full shortlog is:

Ernesto A. Fernández (1):
      ext2: Fix memory leak when truncate races ext2_get_blocks

Jan Kara (6):
      udf: Remove unused UDF_DEFAULT_BLOCKSIZE
      udf: Fix races with i_size changes during readpage
      udf: Use i_size_read() in udf_adinicb_writepage()
      udf: Fix deadlock between writeback and udf_setsize()
      udf: Use time64_to_tm for timestamp conversion
      udf: Convert udf_disk_stamp_to_time() to use mktime64()

Jeff Mahoney (2):
      reiserfs: don't preallocate blocks for extended attributes
      reiserfs: fix race in prealloc discard

The diffstat is

 fs/ext2/inode.c      |  1 +
 fs/reiserfs/bitmap.c | 14 ++++++--
 fs/udf/file.c        | 12 +++++--
 fs/udf/inode.c       |  4 +--
 fs/udf/super.c       |  2 --
 fs/udf/udftime.c     | 98 +++++++---------------------------------------------
 6 files changed, 36 insertions(+), 95 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
