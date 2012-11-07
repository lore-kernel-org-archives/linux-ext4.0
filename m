From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [PATCH] xfs: add hot tracking support.
Date: Wed, 7 Nov 2012 16:38:23 +0800
Message-ID: <CAEH94LjKg78Fm=xROhHsrZkSMUFhJMWeec1b87e8jLh9cMzMGw@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<20121016000405.GA2864@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57649 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2KGIiZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 03:38:25 -0500
In-Reply-To: <20121016000405.GA2864@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

HI, Dave,

I guess that you should add some hot tracking stuff in some
xfs_show_xxx function, right?

On Tue, Oct 16, 2012 at 8:04 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Connect up the VFS hot tracking support so XFS filesystems can make
> use of it.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |    1 +
>  fs/xfs/xfs_super.c |    9 +++++++++
>  2 files changed, 10 insertions(+)
>
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index a631ca3..d5e7277 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -215,6 +215,7 @@ typedef struct xfs_mount {
>  #define XFS_MOUNT_WSYNC                (1ULL << 0)     /* for nfs - all metadata ops
>                                                    must be synchronous except
>                                                    for space allocations */
> +#define XFS_MOUNT_HOTTRACK     (1ULL << 1)     /* hot inode tracking */
>  #define XFS_MOUNT_WAS_CLEAN    (1ULL << 3)
>  #define XFS_MOUNT_FS_SHUTDOWN  (1ULL << 4)     /* atomic stop of all filesystem
>                                                    operations, typically for
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 56c2537..17786ff 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -61,6 +61,7 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  #include <linux/parser.h>
> +#include <linux/hot_tracking.h>
>
>  static const struct super_operations xfs_super_operations;
>  static kmem_zone_t *xfs_ioend_zone;
> @@ -114,6 +115,7 @@ mempool_t *xfs_ioend_pool;
>  #define MNTOPT_NODELAYLOG  "nodelaylog"        /* Delayed logging disabled */
>  #define MNTOPT_DISCARD    "discard"    /* Discard unused blocks */
>  #define MNTOPT_NODISCARD   "nodiscard" /* Do not discard unused blocks */
> +#define MNTOPT_HOTTRACK        "hot_track"     /* hot inode tracking */
>
>  /*
>   * Table driven mount option parser.
> @@ -371,6 +373,8 @@ xfs_parseargs(
>                         mp->m_flags |= XFS_MOUNT_DISCARD;
>                 } else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
>                         mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +               } else if (!strcmp(this_char, MNTOPT_HOTTRACK)) {
> +                       mp->m_flags |= XFS_MOUNT_HOTTRACK;
>                 } else if (!strcmp(this_char, "ihashsize")) {
>                         xfs_warn(mp,
>         "ihashsize no longer used, option is deprecated.");
> @@ -1040,6 +1044,9 @@ xfs_fs_put_super(
>  {
>         struct xfs_mount        *mp = XFS_M(sb);
>
> +       if (mp->m_flags & XFS_MOUNT_HOTTRACK)
> +               hot_track_exit(sb);
> +
>         xfs_filestream_unmount(mp);
>         xfs_unmountfs(mp);
>
> @@ -1470,6 +1477,8 @@ xfs_fs_fill_super(
>                 error = ENOMEM;
>                 goto out_unmount;
>         }
> +       if (mp->m_flags & XFS_MOUNT_HOTTRACK)
> +               hot_track_init(sb);
>
>         return 0;
>



-- 
Regards,

Zhi Yong Wu
