From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH-v5 0/5] add support for a lazytime mount option
Date: Fri, 28 Nov 2014 09:55:19 +0100
Message-ID: <CA+icZUUaXTVKczXHaxJbVgRpd9FaN+csraOsgaqoV72Dc=+OLw@mail.gmail.com>
References: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1417154411-5367-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 28, 2014 at 7:00 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> This is an updated version of what had originally been an
> ext4-specific patch which significantly improves performance by lazily
> writing timestamp updates (and in particular, mtime updates) to disk.
> The in-memory timestamps are always correct, but they are only written
> to disk when required for correctness.
>
> This provides a huge performance boost for ext4 due to how it handles
> journalling, but it's valuable for all file systems running on flash
> storage or drive-managed SMR disks by reducing the metadata write
> load.  So upon request, I've moved the functionality to the VFS layer.
> Once the /sbin/mount program adds support for MS_LAZYTIME, all file
> systems should be able to benefit from this optimization.
>
> There is still an ext4-specific optimization, which may be applicable
> for other file systems which store more than one inode in a block, but
> it will require file system specific code.  It is purely optional,
> however.
>
> Please note the changes to update_time() and the new write_time() inode
> operations functions, which impact btrfs and xfs.  The changes are
> fairly simple, but I would appreciate confirmation from the btrfs and
> xfs teams that I got things right.   Thanks!!
>

Some questions... on how to test this...

[ Base ]
Is this patchset on top of ext4-next (ext4.git#dev)? Might someone
test on top of Linux v3.18-rc6 with pulled in ext4.git#dev2?

[ Userland ]
Do I need an updated userland (/sbin/mount)? IOW, adding "lazytime" to
my ext4-line(s) in /etc/fstab is enough?

[ Benchmarks ]
Do you have numbers - how big/fast is the benefit? On a desktop machine?

Thanks in advance.

- Sedat -

> Changes since -v4:
>    - Fix ext4 optimization so it does not need to increment (and more
>      problematically, decrement) the inode reference count
>    - Per Christoph's suggestion, drop support for btrfs and xfs for now,
>      issues with how btrfs and xfs handle dirty inode tracking.  We can add
>      btrfs and xfs support back later or at the end of this series if we
>      want to revisit this decision.
>    - Miscellaneous cleanups
>
> Changes since -v3:
>    - inodes with I_DIRTY_TIME set are placed on a new bdi list,
>         b_dirty_time.  This allows filesystem-level syncs to more
>         easily iterate over those inodes that need to have their
>         timestamps written to disk.
>    - dirty timestamps will be written out asynchronously on the final
>         iput, instead of when the inode gets evicted.
>    - separate the definition of the new function
>         find_active_inode_nowait() to a separate patch
>    - create separate flag masks: I_DIRTY_WB and I_DIRTY_INODE, which
>        indicate whether the inode needs to be on the write back lists,
>        or whether the inode itself is dirty, while I_DIRTY means any one
>        of the inode dirty flags are set.  This simplifies the fs
>        writeback logic which needs to test for different combinations of
>        the inode dirty flags in different places.
>
> Changes since -v2:
>    - If update_time() updates i_version, it will not use lazytime (i..e,
>        the inode will be marked dirty so the change will be persisted on to
>        disk sooner rather than later).  Yes, this eliminates the
>        benefits of lazytime if the user is experting the file system via
>        NFSv4.  Sad, but NFS's requirements seem to mandate this.
>    - Fix time wrapping bug 49 days after the system boots (on a system
>         with a 32-bit jiffies).   Use get_monotonic_boottime() instead.
>    - Clean up type warning in include/tracing/ext4.h
>    - Added explicit parenthesis for stylistic reasons
>    - Added an is_readonly() inode operations method so btrfs doesn't
>        have to duplicate code in update_time().
>
> Changes since -v1:
>    - Added explanatory comments in update_time() regarding i_ts_dirty_days
>    - Fix type used for days_since_boot
>    - Improve SMP scalability in update_time and ext4_update_other_inodes_time
>    - Added tracepoints to help test and characterize how often and under
>          what circumstances inodes have their timestamps lazily updated
>
> Theodore Ts'o (5):
>   vfs: add support for a lazytime mount option
>   vfs: don't let the dirty time inodes get more than a day stale
>   vfs: add lazytime tracepoints for better debugging
>   vfs: add find_inode_nowait() function
>   ext4: add optimization for the lazytime mount option
>
>  fs/ext4/inode.c             |  66 +++++++++++++++++++++++--
>  fs/ext4/super.c             |   9 ++++
>  fs/fs-writeback.c           |  66 ++++++++++++++++++++++---
>  fs/inode.c                  | 116 +++++++++++++++++++++++++++++++++++++++++---
>  fs/libfs.c                  |   2 +-
>  fs/logfs/readwrite.c        |   2 +-
>  fs/nfsd/vfs.c               |   2 +-
>  fs/pipe.c                   |   2 +-
>  fs/proc_namespace.c         |   1 +
>  fs/sync.c                   |   8 +++
>  fs/ufs/truncate.c           |   2 +-
>  include/linux/backing-dev.h |   1 +
>  include/linux/fs.h          |  17 ++++++-
>  include/trace/events/ext4.h |  30 ++++++++++++
>  include/trace/events/fs.h   |  56 +++++++++++++++++++++
>  include/uapi/linux/fs.h     |   1 +
>  mm/backing-dev.c            |  10 +++-
>  17 files changed, 367 insertions(+), 24 deletions(-)
>  create mode 100644 include/trace/events/fs.h
>
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
