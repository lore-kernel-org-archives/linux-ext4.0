From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH RFC v2 1/6] fs: vfs ioctls for managing project id
Date: Wed, 11 Mar 2015 03:00:59 -0400
Message-ID: <3403886C-8932-4CB0-8B1D-F468A5B199BA@dilger.ca>
References: <20150310171133.23081.49616.stgit@buzz> <20150310172205.23081.67263.stgit@buzz>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andy Lutomirski <luto@amacapital.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Li Xi <pkuelelixi@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150310172205.23081.67263.stgit@buzz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

How do your patches relate to the project quota patches from Li Xi?

Cheers, Andreas

> On Mar 10, 2015, at 13:22, Konstantin Khlebnikov <khlebnikov@yandex-team.ru> wrote:
> 
> This patch adds generic vfs interface for project id and
> related super-block methods.
> 
> Two new ioctls:
> int ioctl(fd, FS_IOC_GETPROJECT, unsigned *project);
> int ioctl(fd, FS_IOC_SETPROJECT, unsigned *project);
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
> Documentation/filesystems/Locking |    4 +++
> Documentation/filesystems/vfs.txt |    8 +++++
> fs/compat_ioctl.c                 |    2 +
> fs/ioctl.c                        |   58 +++++++++++++++++++++++++++++++++++++
> include/linux/fs.h                |    2 +
> include/uapi/linux/fs.h           |    3 ++
> 6 files changed, 77 insertions(+)
> 
> diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
> index f91926f2f482..7a01e2b606d0 100644
> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -126,6 +126,8 @@ prototypes:
>    ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
>    ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
>    int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
> +    kprojid_t (*get_project) (struct inode *);
> +    int (*set_project) (struct inode *, kprojid_t);
> 
> locking rules:
>    All may block [not true, see below]
> @@ -147,6 +149,8 @@ show_options:        no        (namespace_sem)
> quota_read:        no        (see below)
> quota_write:        no        (see below)
> bdev_try_to_free_page:    no        (see below)
> +get_project        no
> +set_project        no        (i_mutex)
> 
> ->statfs() has s_umount (shared) when called by ustat(2) (native or
> compat), but that's an accident of bad API; s_umount is used to pin
> diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> index 966b22829f3b..aeff3c54021b 100644
> --- a/Documentation/filesystems/vfs.txt
> +++ b/Documentation/filesystems/vfs.txt
> @@ -230,6 +230,8 @@ struct super_operations {
>         ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
>    int (*nr_cached_objects)(struct super_block *);
>    void (*free_cached_objects)(struct super_block *, int);
> +    kprojid_t (*get_project)(struct inode *);
> +    int (*set_project)(struct inode *, kprojid_t);
> };
> 
> All methods are called without any locks being held, unless otherwise
> @@ -319,6 +321,12 @@ or bottom half).
>    implementations will cause holdoff problems due to large scan batch
>    sizes.
> 
> +  get_project: called by the ioctl and quota code to get project id of an inode.
> +    Method should return INVALID_PROJID if feature isn't supported.
> +
> +  set_project: called by the ioctl to set project id for an inode.
> +    This is called with i_mutex held.
> +
> Whoever sets up the inode is responsible for filling in the "i_op" field. This
> is a pointer to a "struct inode_operations" which describes the methods that
> can be performed on individual inodes.
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index afec6450450f..9a24e4038377 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -889,6 +889,8 @@ COMPATIBLE_IOCTL(FIOASYNC)
> COMPATIBLE_IOCTL(FIONBIO)
> COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
> COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
> +COMPATIBLE_IOCTL(FS_IOC_GETPROJECT)
> +COMPATIBLE_IOCTL(FS_IOC_SETPROJECT)
> /* 0x00 */
> COMPATIBLE_IOCTL(FIBMAP)
> COMPATIBLE_IOCTL(FIGETBSZ)
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 5d01d2638ca5..d351576d95c8 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -9,6 +9,7 @@
> #include <linux/capability.h>
> #include <linux/file.h>
> #include <linux/fs.h>
> +#include <linux/mount.h>
> #include <linux/security.h>
> #include <linux/export.h>
> #include <linux/uaccess.h>
> @@ -545,6 +546,57 @@ static int ioctl_fsthaw(struct file *filp)
>    return thaw_super(sb);
> }
> 
> +static int ioctl_getproject(struct file *filp, projid_t __user *argp)
> +{
> +    struct user_namespace *ns = current_user_ns();
> +    struct inode *inode = file_inode(filp);
> +    struct super_block *sb = inode->i_sb;
> +    kprojid_t kprojid;
> +    projid_t projid;
> +
> +    if (!sb->s_op->get_project)
> +        return -EOPNOTSUPP;
> +    kprojid = sb->s_op->get_project(inode);
> +    if (!projid_valid(kprojid))
> +        return -EOPNOTSUPP;
> +    projid = from_kprojid(ns, kprojid);
> +    if (projid == (projid_t)-1)
> +        return -EACCES;
> +    return put_user(projid, argp);
> +}
> +
> +static int ioctl_setproject(struct file *filp, projid_t __user *argp)
> +{
> +    struct user_namespace *ns = current_user_ns();
> +    struct inode *inode = file_inode(filp);
> +    struct super_block *sb = inode->i_sb;
> +    kprojid_t kprojid;
> +    projid_t projid;
> +    int ret;
> +
> +    if (!sb->s_op->set_project)
> +        return -EOPNOTSUPP;
> +    if (ns != &init_user_ns)
> +        return -EPERM;
> +    ret = get_user(projid, argp);
> +    if (ret)
> +        return ret;
> +    kprojid = make_kprojid(ns, projid);
> +    if (!projid_valid(kprojid))
> +        return -EACCES;
> +    ret = mnt_want_write_file(filp);
> +    if (ret)
> +        return ret;
> +    mutex_lock(&inode->i_mutex);
> +    if (inode_owner_or_capable(inode))
> +        ret = sb->s_op->set_project(inode, kprojid);
> +    else
> +        ret = -EPERM;
> +    mutex_unlock(&inode->i_mutex);
> +    mnt_drop_write_file(filp);
> +    return ret;
> +}
> +
> /*
>  * When you add any new common ioctls to the switches above and below
>  * please update compat_sys_ioctl() too.
> @@ -597,6 +649,12 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>    case FS_IOC_FIEMAP:
>        return ioctl_fiemap(filp, arg);
> 
> +    case FS_IOC_GETPROJECT:
> +        return ioctl_getproject(filp, argp);
> +
> +    case FS_IOC_SETPROJECT:
> +        return ioctl_setproject(filp, argp);
> +
>    case FIGETBSZ:
>        return put_user(inode->i_sb->s_blocksize, argp);
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b4d71b5e1ff2..42156801739e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1655,6 +1655,8 @@ struct super_operations {
>                  struct shrink_control *);
>    long (*free_cached_objects)(struct super_block *,
>                    struct shrink_control *);
> +    kprojid_t (*get_project)(struct inode *);
> +    int (*set_project)(struct inode *, kprojid_t);
> };
> 
> /*
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 9b964a5920af..144426326e15 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -170,6 +170,9 @@ struct inodes_stat_t {
> #define FS_IOC32_GETVERSION        _IOR('v', 1, int)
> #define FS_IOC32_SETVERSION        _IOW('v', 2, int)
> 
> +#define FS_IOC_GETPROJECT        _IOR('f', 20, unsigned)
> +#define FS_IOC_SETPROJECT        _IOW('f', 21, unsigned)
> +
> /*
>  * Inode flags (FS_IOC_GETFLAGS / FS_IOC_SETFLAGS)
>  */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
