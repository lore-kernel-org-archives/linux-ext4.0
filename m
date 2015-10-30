From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Fwd: [v1 0/4] Add project quota support for e2fsprogs
Date: Fri, 30 Oct 2015 11:42:28 +0800
Message-ID: <CAP9B-Qn1F2KpxC-TFore9XZCfY5goo=fOYa7Le79kckxj-5UPw@mail.gmail.com>
References: <1446046933-26571-1-git-send-email-lixi@ddn.com>
	<CAP9B-Q=EU6L0mgL+s5RGMg5PsW6o+0hMDcQmp-QF=PisAcz1pA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35091 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbbJ3Dma (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Oct 2015 23:42:30 -0400
Received: by lfbn126 with SMTP id n126so27421482lfb.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2015 20:42:28 -0700 (PDT)
In-Reply-To: <CAP9B-Q=EU6L0mgL+s5RGMg5PsW6o+0hMDcQmp-QF=PisAcz1pA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

re-cc to linux-ext4 due to plain/text policy.

---------- Forwarded message ----------
From: Shilong Wang <wangshilong1991@gmail.com>
Date: Fri, Oct 30, 2015 at 11:16 AM
Subject: Re: [v1 0/4] Add project quota support for e2fsprogs
To: Li Xi <pkuelelixi@gmail.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
adilger@dilger.ca, Jan Kara <jack@suse.cz>, viro@zeniv.linux.org.uk,
hch@infradead.org, Dmitry Monakhov <dmonakhov@openvz.org>


2015-10-28 23:42 GMT+08:00 Li Xi <pkuelelixi@gmail.com>:
>
> The following patches adds project quota support for e2fsprogs. The
> first patch cleans up current codes to prepare for adding project
> quota support. And other patches adds project ID as well as
> project feature support for e2fsprogs.
>
> Li Xi (4):
>   clean up codes for adding new quota type
>   Add project quota support
>   Add project feature
>   Add inherit flags for project quota
>
>  debugfs/quota.c                 |    2 +-
>  debugfs/set_fields.c            |    2 +
>  e2fsck/pass1.c                  |   35 +++++++++++--
>  e2fsck/quota.c                  |   28 ++++------
>  e2fsck/unix.c                   |   26 +++++-----
>  lib/e2p/feature.c               |    2 +
>  lib/e2p/ls.c                    |   29 ++++++++---
>  lib/e2p/pf.c                    |    1 +
>  lib/ext2fs/ext2_fs.h            |   12 +++-
>  lib/ext2fs/ext2fs.h             |    3 +-
>  lib/ext2fs/swapfs.c             |    2 +
>  lib/ext2fs/tst_inode_size.c     |    1 +
>  lib/ext2fs/tst_super_size.c     |    3 +-
>  lib/support/mkquota.c           |  105 ++++++++++++++++++++++-----------------
>  lib/support/quotaio.c           |   80 ++++++++++++++++++++----------
>  lib/support/quotaio.h           |   74 ++++++++++++++++++++--------
>  lib/support/quotaio_tree.c      |    2 +-
>  misc/chattr.c                   |    3 +-
>  misc/ext4.5.in                  |    5 ++
>  misc/mke2fs.c                   |   19 +++++--
>  misc/tune2fs.c                  |   89 +++++++++++++++++++--------------
>  tests/d_fallocate_blkmap/expect |    4 +-
>  tests/f_create_symlinks/expect  |    8 ++--
>  tests/m_bigjournal/expect.1     |    4 +-
>  tests/m_large_file/expect.1     |    4 +-
>  tests/m_quota/expect.1          |   15 +++---
>  26 files changed, 356 insertions(+), 202 deletions(-)


BTW, here is a drafted xfstests to verify kernel work, to run it you need.

git clone https://github.com/wangshilong/{quota-tools, xfstests,
e2fsprogs} && git checkout project

and run xfstests with following commands:

[root@vm7-2 xfstests-dev]# ./check ext4/050 ext4/106 ext4/107 ext4/108
ext4/196 ext4/244 ext4/299 ext4/400 ext4/401

....
....

Ran: ext4/050 ext4/106 ext4/107 ext4/108 ext4/196 ext4/244 ext4/299
ext4/400 ext4/401

Passed all 9 tests



>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
