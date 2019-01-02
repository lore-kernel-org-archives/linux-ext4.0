Return-Path: <SRS0=jZge=PK=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53070 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfABRri (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Jan 2019 12:47:38 -0500
Date: Wed, 2 Jan 2019 18:47:36 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [GIT PULL] dtype handling cleanup for v4.21-rc1
Message-ID: <20190102174736.GB29127@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dtype_for_v4.21-rc1

to get a patch to provide generic functions for dtype handling and use those
for ext2. Other filesystems (ext4, btrfs, ocfs2, ...) can then merge the
cleanup patches through their trees.

I've taken the generic functions patch through my tree since Al didn't respond
and it seems non-controversial enough. But I'm sending it separately from my
standard fs fixes batch to mark something unusual is going on (which is also
why I'm sending it so late in the merge window because I forgot about this
topic branch and found out only now).

Top of the tree is 9d6e1fe4e091. The full shortlog is:

Phillip Potter (2):
      fs: common implementation of file type
      ext2: use common file type conversion

The diffstat is

 MAINTAINERS              |   1 +
 fs/Makefile              |   3 +-
 fs/ext2/dir.c            |  49 +++++++++-------------
 fs/fs_types.c            | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h       |  17 +-------
 include/linux/fs_types.h |  73 ++++++++++++++++++++++++++++++++
 6 files changed, 202 insertions(+), 46 deletions(-)
 create mode 100644 fs/fs_types.c
 create mode 100644 include/linux/fs_types.h

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
