Return-Path: <SRS0=ufRS=NJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729229AbeJ2T36 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 29 Oct 2018 15:29:58 -0400
Date: Mon, 29 Oct 2018 11:41:50 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] ext2 and udf changes for v4.20-rc1
Message-ID: <20181029104150.GD5988@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git filesystems_for_v4.20-rc1

to get small ext2 cleanups and couple of udf fixes.

Top of the tree is 2aad26fa0a3d. The full shortlog is:

Chengguang Xu (2):
      ext2: cache NULL when both default_acl and acl are NULL
      ext2: remove redundant building macro check

Colin Ian King (1):
      udf: remove unused variables group_start and nr_groups

Jan Kara (4):
      udf: Prevent write-unsupported filesystem to be remounted read-write
      udf: Fix crash during mount
      udf: Drop freed bitmap / table support
      udf: Drop pack pragma from udf_sb.h

The diffstat is

 fs/ext2/acl.c   |   4 ++
 fs/ext2/ext2.h  |   4 --
 fs/ext2/super.c |   5 +-
 fs/udf/balloc.c |  30 +-----------
 fs/udf/super.c  | 139 +++++++++++++++++++++++++++++++-------------------------
 fs/udf/udf_sb.h |  10 +---
 6 files changed, 85 insertions(+), 107 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
