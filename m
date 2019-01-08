Return-Path: <SRS0=tdqe=PQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59296 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727001AbfAHKFC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Jan 2019 05:05:02 -0500
Date: Tue, 8 Jan 2019 11:05:00 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [GIT PULL] dtype handling cleanup for v4.21-rc1
Message-ID: <20190108100500.GA15801@quack2.suse.cz>
References: <20190102174736.GB29127@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190102174736.GB29127@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Linus,

On Wed 02-01-19 18:47:36, Jan Kara wrote:
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dtype_for_v4.21-rc1
> 
> to get a patch to provide generic functions for dtype handling and use those
> for ext2. Other filesystems (ext4, btrfs, ocfs2, ...) can then merge the
> cleanup patches through their trees.

I didn't get any reply WRT this pull request and you didn't pull yet. I
guess you just wanted to have a deeper look and didn't get to it yet? Or do
you have some problem with the patches?

								Honza

> 
> I've taken the generic functions patch through my tree since Al didn't respond
> and it seems non-controversial enough. But I'm sending it separately from my
> standard fs fixes batch to mark something unusual is going on (which is also
> why I'm sending it so late in the merge window because I forgot about this
> topic branch and found out only now).
> 
> Top of the tree is 9d6e1fe4e091. The full shortlog is:
> 
> Phillip Potter (2):
>       fs: common implementation of file type
>       ext2: use common file type conversion
> 
> The diffstat is
> 
>  MAINTAINERS              |   1 +
>  fs/Makefile              |   3 +-
>  fs/ext2/dir.c            |  49 +++++++++-------------
>  fs/fs_types.c            | 105 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h       |  17 +-------
>  include/linux/fs_types.h |  73 ++++++++++++++++++++++++++++++++
>  6 files changed, 202 insertions(+), 46 deletions(-)
>  create mode 100644 fs/fs_types.c
>  create mode 100644 include/linux/fs_types.h
> 
> 							Thanks
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
