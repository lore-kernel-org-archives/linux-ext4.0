From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Fri, 20 Apr 2012 12:12:32 +0300
Message-ID: <4F912880.70708@panasas.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:60019 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2DTJMo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 20 Apr 2012 05:12:44 -0400
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/19/2012 10:20 PM, Theodore Ts'o wrote:

> As I had brought up during one of the lightning talks at the Linux
> Storage and Filesystem workshop, I am interested in introducing two new
> open flags, O_HOT and O_COLD.  These flags are passed down to the
> individual file system's inode operations' create function, and the file
> system can use these flags as a hint regarding whether the file is
> likely to be accessed frequently or not.
> 
> In the future I plan to do further work on how ext4 would use these
> flags, but I want to first get the ability to pass these flags plumbed
> into the VFS layer and the code points for O_HOT and O_COLD reserved.
> 
> 
> Theodore Ts'o (3):
>   fs: add new open flags O_HOT and O_COLD
>   fs: propagate the open_flags structure down to the low-level fs's
>     create()
>   ext4: use the O_HOT and O_COLD open flags to influence inode
>     allocation
> 


I would expect that the first, and most important patch to this
set would be the man page which would define the new API. 
What do you mean by cold/normal/hot? what is expected if supported?
how can we know if supported? ....

I presume you mean 3 levels (not even 2 bits) of what T10 called
"read-frequency" or is that "write-frequency", or some other metrics
you defined?

Well in the patchset you supplied it means closer to outer-edge.
What ever that means? so in the case of ext4 on SSD or DM/MD or
loop or thin provisioned LUN. How do I stop it. The code is already
there in Kernel and the application is setting that flag at create,
how do I make the FS not do that stupid, for me, thing?

I wish you'd be transparent, call it O_OUTER_DISK and be honest
about it. The "undefined API" never ever worked in the past,
why would it work now?

And Yes an fctrl is a much better match, and with delayed allocation
that should not matter, right?

And one last thing. We would like to see numbers. Please show us where/how
it matters. Are there down sides?. If it's so good we'd like to implement
it too.

Thanks
Boaz

>  fs/9p/vfs_inode.c           |    2 +-
>  fs/affs/affs.h              |    2 +-
>  fs/affs/namei.c             |    3 ++-
>  fs/bfs/dir.c                |    2 +-
>  fs/btrfs/inode.c            |    3 ++-
>  fs/cachefiles/namei.c       |    3 ++-
>  fs/ceph/dir.c               |    2 +-
>  fs/cifs/dir.c               |    2 +-
>  fs/coda/dir.c               |    3 ++-
>  fs/ecryptfs/inode.c         |    5 +++--
>  fs/exofs/namei.c            |    2 +-
>  fs/ext2/namei.c             |    4 +++-
>  fs/ext3/namei.c             |    5 +++--
>  fs/ext4/ext4.h              |    8 +++++++-
>  fs/ext4/ialloc.c            |   33 +++++++++++++++++++++++++++------
>  fs/ext4/migrate.c           |    2 +-
>  fs/ext4/namei.c             |   17 ++++++++++++-----
>  fs/fat/namei_msdos.c        |    2 +-
>  fs/fat/namei_vfat.c         |    2 +-
>  fs/fcntl.c                  |    5 +++--
>  fs/fuse/dir.c               |    2 +-
>  fs/gfs2/inode.c             |    3 ++-
>  fs/hfs/dir.c                |    2 +-
>  fs/hfsplus/dir.c            |    5 +++--
>  fs/hostfs/hostfs_kern.c     |    2 +-
>  fs/hugetlbfs/inode.c        |    4 +++-
>  fs/internal.h               |    6 ------
>  fs/jffs2/dir.c              |    5 +++--
>  fs/jfs/namei.c              |    2 +-
>  fs/logfs/dir.c              |    2 +-
>  fs/minix/namei.c            |    2 +-
>  fs/namei.c                  |    9 +++++----
>  fs/ncpfs/dir.c              |    5 +++--
>  fs/nfs/dir.c                |    6 ++++--
>  fs/nfsd/vfs.c               |    4 ++--
>  fs/nilfs2/namei.c           |    2 +-
>  fs/ocfs2/namei.c            |    3 ++-
>  fs/omfs/dir.c               |    2 +-
>  fs/ramfs/inode.c            |    3 ++-
>  fs/reiserfs/namei.c         |    5 +++--
>  fs/sysv/namei.c             |    4 +++-
>  fs/ubifs/dir.c              |    2 +-
>  fs/udf/namei.c              |    2 +-
>  fs/ufs/namei.c              |    2 +-
>  fs/xfs/xfs_iops.c           |    3 ++-
>  include/asm-generic/fcntl.h |    7 +++++++
>  include/linux/fs.h          |   14 ++++++++++++--
>  ipc/mqueue.c                |    2 +-
>  48 files changed, 143 insertions(+), 74 deletions(-)
> 


