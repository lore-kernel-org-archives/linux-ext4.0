From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [v1 0/4] Add project quota support for e2fsprogs
Date: Thu, 29 Oct 2015 00:49:12 -0600
Message-ID: <9526BD71-6FB5-4544-9333-504326FAD6F3@dilger.ca>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>,
	"dmonakhov@openvz.org" <dmonakhov@openvz.org>
To: Li Xi <pkuelelixi@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34985 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbbJ2GtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2015 02:49:15 -0400
Received: by pasz6 with SMTP id z6so31537462pas.2
        for <linux-ext4@vger.kernel.org>; Wed, 28 Oct 2015 23:49:14 -0700 (PDT)
In-Reply-To: <1446046933-26571-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 28, 2015, at 09:42, Li Xi <pkuelelixi@gmail.com> wrote:
> 
> The following patches adds project quota support for e2fsprogs. The
> first patch cleans up current codes to prepare for adding project
> quota support. And other patches adds project ID as well as
> project feature support for e2fsprogs.

Looks good. You can add my:

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> Li Xi (4):
>  clean up codes for adding new quota type
>  Add project quota support
>  Add project feature
>  Add inherit flags for project quota
> 
> debugfs/quota.c                 |    2 +-
> debugfs/set_fields.c            |    2 +
> e2fsck/pass1.c                  |   35 +++++++++++--
> e2fsck/quota.c                  |   28 ++++------
> e2fsck/unix.c                   |   26 +++++-----
> lib/e2p/feature.c               |    2 +
> lib/e2p/ls.c                    |   29 ++++++++---
> lib/e2p/pf.c                    |    1 +
> lib/ext2fs/ext2_fs.h            |   12 +++-
> lib/ext2fs/ext2fs.h             |    3 +-
> lib/ext2fs/swapfs.c             |    2 +
> lib/ext2fs/tst_inode_size.c     |    1 +
> lib/ext2fs/tst_super_size.c     |    3 +-
> lib/support/mkquota.c           |  105 ++++++++++++++++++++++-----------------
> lib/support/quotaio.c           |   80 ++++++++++++++++++++----------
> lib/support/quotaio.h           |   74 ++++++++++++++++++++--------
> lib/support/quotaio_tree.c      |    2 +-
> misc/chattr.c                   |    3 +-
> misc/ext4.5.in                  |    5 ++
> misc/mke2fs.c                   |   19 +++++--
> misc/tune2fs.c                  |   89 +++++++++++++++++++--------------
> tests/d_fallocate_blkmap/expect |    4 +-
> tests/f_create_symlinks/expect  |    8 ++--
> tests/m_bigjournal/expect.1     |    4 +-
> tests/m_large_file/expect.1     |    4 +-
> tests/m_quota/expect.1          |   15 +++---
> 26 files changed, 356 insertions(+), 202 deletions(-)
> 
