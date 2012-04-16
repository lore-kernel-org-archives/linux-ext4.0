From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 00/32] e2fsprogs: make e2fsprogs support inline data
Date: Mon, 16 Apr 2012 08:08:21 -0700
Message-ID: <729213E5-B7EB-493E-A92B-0BA56FC3BD7E@dilger.ca>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37186 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2DPPFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 11:05:12 -0400
Received: by dake40 with SMTP id e40so7033410dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 08:05:11 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-04-16, at 4:39 AM, Zheng Liu wrote:
> Here is v2 for making e2fsprogs support inline data.  Now debugfs
> supports inline data in read-write mode.  Meanwhile e2fsck has
> been improved to support inline data feature.
> 
> v1->v2:
> * [mke2fs] automatically set EXT_ATTR feature when INLINE_DATA is set
> * [debugfs] supports read-write mode

As with the previous patch series, there is a need to show some
benchmark data that indicates how much improvement this feature
provides.  Some examples would include percentage of directories
stored inline (e.g. in a typical distro installation), performance
improvement (e.g. cold-cache filesystem traversal).  It is likely
that these improvements will be more visible with bigalloc enabled
for a large cluster size (e.g. space savings).

Without a clear indication of performance improvement, the patch
cannot be included due to added complexity and unclear benefits.

> In mke2fs, EXT4_FEATURE_INCOMPAT_INLINE_DATA is set to 0x2000 to
> consist with kernel.  When making a new ext4 file system with
> INLINE_DATA feature, mke2fs will check whether EXT_ATTR is set or
> not.  If it is not set, mke2fs will mark it automatically because
> INLINE_DATA depends on it.
> 
> In debugfs, it can support inline data in read-write mode.  Now
> there is two problems that need to be solved.  No matter whether
> the size of data is fit into inline data or not, 'write' command
> writes the data into disk blocks rather than inode itself.  'mkdir'
> command will expand dir to a new disk block when inode->i_block
> has full because Tao found a performance regression when a huge
> number of dirs are added and removed in EA space.  It causes that
> the code in kernel might be changed.  So now 'mkdir' cmd doesn't
> add a new dir entry in EA space.
> 
> TODO list:
> * [mke2fs] initialize ROOT dir with inline data flag
> * [mke2fs] initialize LOST+FOUND dir with inline data flag

Note that it does not make sense to store lost+found inline.  It
is purposely created with multiple leaf blocks so that blocks
do not need to be allocated during e2fsck runs.  Probably the
same is true for root - it will almost certainly immediately
be moved out of the inode due to file creations.

Cheers, Andreas

> * [debugfs] 'write' cmd writes the data into inode itself
> * [debugfs] 'mkdir' cmd add dir entry into EA space
> 
> Regards,
> Zheng
> 
> libext2fs: add EXT4_FEATURE_INCOMPAT_INLINE_DATA flag
> mke2fs: make it support inline data feature
> libext2fs: add inline_data feature
> mke2fs: add inline_data feature in mke2fs's manpage
> libext2fs: add ext2fs_find_entry_ext_attr function
> libext2fs: add EXT4_INLINE_DATA_FL flag for inode
> libext2fs: add data structures for inline data feature
> libext2fs: add inline_data file
> debugfs: make ncheck cmd support inline data
> debugfs: make chroot and cd cmd support inline data
> debugfs: make ls cmd support inline data
> debugfs: make stat cmd support inline data
> debufs: make blocks cmd support inline data
> debugfs: make filefrag cmd support inline data
> debugfs: make link cmd support inline data
> debugfs: make unlink cmd support inline data
> debugfs: make mkdir cmd support inline data
> debugfs: make rmdir cmd support inline data
> debugfs: make rm and kill_file cmd support inline data
> debugfs: make pwd cmd support inline data
> debugfs: make expand_dir cmd support inline data
> debugfs: make lsdel cmd support inline data
> debugfs: make undel cmd support inline data
> debugfs: make dump and cat cmd support inline data
> debugfs: make rdump cmd support inline data
> debugfs: make dirsearch cmd support inline data
> debugfs: make bma cmd support inline data
> e2fsck: add three problem descriptions in pass1
> e2fsck: check incorrect inline data flag
> e2fsck: make pass1 support inline data
> libext2fs: add read/write inline data functions
> e2fsck: check inline data in pass2
> 
> debugfs/debugfs.c          |   25 ++-
> debugfs/dump.c             |   38 +++-
> debugfs/filefrag.c         |   30 ++-
> debugfs/htree.c            |    6 +
> debugfs/ls.c               |    8 +-
> debugfs/lsdel.c            |   19 +-
> debugfs/ncheck.c           |    8 +-
> e2fsck/pass1.c             |   70 ++++-
> e2fsck/pass1b.c            |    5 +-
> e2fsck/pass2.c             |   50 +++-
> e2fsck/problem.c           |   15 +
> e2fsck/problem.h           |    9 +
> lib/e2p/feature.c          |    2 +
> lib/ext2fs/Makefile.in     |    5 +
> lib/ext2fs/Makefile.pq     |    1 +
> lib/ext2fs/bmap.c          |   16 +
> lib/ext2fs/dblist_dir.c    |    8 +-
> lib/ext2fs/dirblock.c      |   62 ++++
> lib/ext2fs/expanddir.c     |    8 +-
> lib/ext2fs/ext2_ext_attr.h |    4 +
> lib/ext2fs/ext2_fs.h       |    9 +
> lib/ext2fs/ext2fs.h        |   69 ++++-
> lib/ext2fs/ext_attr.c      |   26 ++
> lib/ext2fs/get_pathname.c  |    7 +-
> lib/ext2fs/inline_data.c   |  715 ++++++++++++++++++++++++++++++++++++++++++++
> lib/ext2fs/link.c          |    9 +-
> lib/ext2fs/lookup.c        |    6 +-
> lib/ext2fs/mkdir.c         |    4 +
> lib/ext2fs/unlink.c        |    9 +-
> misc/mke2fs.8.in           |    3 +
> misc/mke2fs.c              |   10 +-
> 31 files changed, 1197 insertions(+), 59 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





