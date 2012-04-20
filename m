From: Alex Elder <elder@dreamhost.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Thu, 19 Apr 2012 19:26:17 -0500
Message-ID: <4F90AD29.9030501@dreamhost.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/19/2012 02:20 PM, Theodore Ts'o wrote:
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

I don't like it.

I do think that the idea of being able to communicate information
like this to the filesystem is good, and we ought to be investigating
that.

But I have two initial concerns: setting this attribute at create time;
and ambiguity in interpreting what it represents.

These flags are stating that for the lifetime of the file being
created it is "hot" (or "cold").  I think very rarely will whichever
value is set be appropriate for a file's entire lifetime.

I would rather see "hotness" be a attribute of an open that did not
persist after final close.  I realize that precludes making an initial
placement decision for a likely hot (or not) file for some filesystems,
but then again, that's another reason why I have a problem with it.

The scenario I'm thinking about is that users could easily request
hot files repeatedly, and could thereby quickly exhaust all available
speedy-quick media designated to serve this purpose--and that will
be especially bad for those filesystems which base initial allocation
decisions on this.

I would prefer to see something like this communicated via fcntl().
It already passes information down to the underlying filesystem in
some cases so you avoid touching all these create interfaces.

The second problem is that "hot/cold" is a lot like "performance."
What is meant by "hot" really depends on what you want.  I think it
most closely aligns with frequent access, but someone might want
it to mean "very write-y" or "needing exceptionally low latency"
or "hammering on it from lots of concurrent threads" or "notably
good looking."  In any case, there are lots of possible hints
that a filesystem could benefit from, but if we're going to start
down that path I suggest "hot/cold" is not the right kind of
naming scheme we ought to be using.

					-Alex

>
> Theodore Ts'o (3):
>    fs: add new open flags O_HOT and O_COLD
>    fs: propagate the open_flags structure down to the low-level fs's
>      create()
>    ext4: use the O_HOT and O_COLD open flags to influence inode
>      allocation
>
>   fs/9p/vfs_inode.c           |    2 +-
>   fs/affs/affs.h              |    2 +-
>   fs/affs/namei.c             |    3 ++-
>   fs/bfs/dir.c                |    2 +-
>   fs/btrfs/inode.c            |    3 ++-
>   fs/cachefiles/namei.c       |    3 ++-
>   fs/ceph/dir.c               |    2 +-
>   fs/cifs/dir.c               |    2 +-
>   fs/coda/dir.c               |    3 ++-
>   fs/ecryptfs/inode.c         |    5 +++--
>   fs/exofs/namei.c            |    2 +-
>   fs/ext2/namei.c             |    4 +++-
>   fs/ext3/namei.c             |    5 +++--
>   fs/ext4/ext4.h              |    8 +++++++-
>   fs/ext4/ialloc.c            |   33 +++++++++++++++++++++++++++------
>   fs/ext4/migrate.c           |    2 +-
>   fs/ext4/namei.c             |   17 ++++++++++++-----
>   fs/fat/namei_msdos.c        |    2 +-
>   fs/fat/namei_vfat.c         |    2 +-
>   fs/fcntl.c                  |    5 +++--
>   fs/fuse/dir.c               |    2 +-
>   fs/gfs2/inode.c             |    3 ++-
>   fs/hfs/dir.c                |    2 +-
>   fs/hfsplus/dir.c            |    5 +++--
>   fs/hostfs/hostfs_kern.c     |    2 +-
>   fs/hugetlbfs/inode.c        |    4 +++-
>   fs/internal.h               |    6 ------
>   fs/jffs2/dir.c              |    5 +++--
>   fs/jfs/namei.c              |    2 +-
>   fs/logfs/dir.c              |    2 +-
>   fs/minix/namei.c            |    2 +-
>   fs/namei.c                  |    9 +++++----
>   fs/ncpfs/dir.c              |    5 +++--
>   fs/nfs/dir.c                |    6 ++++--
>   fs/nfsd/vfs.c               |    4 ++--
>   fs/nilfs2/namei.c           |    2 +-
>   fs/ocfs2/namei.c            |    3 ++-
>   fs/omfs/dir.c               |    2 +-
>   fs/ramfs/inode.c            |    3 ++-
>   fs/reiserfs/namei.c         |    5 +++--
>   fs/sysv/namei.c             |    4 +++-
>   fs/ubifs/dir.c              |    2 +-
>   fs/udf/namei.c              |    2 +-
>   fs/ufs/namei.c              |    2 +-
>   fs/xfs/xfs_iops.c           |    3 ++-
>   include/asm-generic/fcntl.h |    7 +++++++
>   include/linux/fs.h          |   14 ++++++++++++--
>   ipc/mqueue.c                |    2 +-
>   48 files changed, 143 insertions(+), 74 deletions(-)
>

