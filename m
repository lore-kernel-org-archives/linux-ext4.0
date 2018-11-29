Return-Path: <SRS0=G5ay=OI=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726651AbeK2Stc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 29 Nov 2018 13:49:32 -0500
Date: Thu, 29 Nov 2018 08:45:04 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] ext2 and udf fixes for v4.20-rc5
Message-ID: <20181129074504.GA31087@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git fixes_for_v4.20-rc5

to get three small ext2 and udf fixes.

Top of the tree is 2aad26fa0a3d. The full shortlog is:

Jan Kara (1):
      udf: Allow mounting volumes with incorrect identification strings

Pan Bian (1):
      ext2: fix potential use after free

xingaopeng (1):
      ext2: initialize opts.s_mount_opt as zero before using it

The diffstat is

 fs/ext2/super.c  |  1 +
 fs/ext2/xattr.c  |  2 +-
 fs/udf/super.c   | 16 ++++++++++------
 fs/udf/unicode.c | 14 +++++++++++---
 4 files changed, 23 insertions(+), 10 deletions(-)

							Thanks
								Honza


-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
