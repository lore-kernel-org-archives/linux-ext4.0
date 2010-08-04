From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] Add ioctl FITRIM.
Date: Wed, 4 Aug 2010 17:13:01 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1008041704420.2932@localhost>
References: <1280929475-12823-1-git-send-email-lczerner@redhat.com> <8762zq8lxv.fsf@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711Ab0HDPNK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 11:13:10 -0400
In-Reply-To: <8762zq8lxv.fsf@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 Aug 2010, Dmitry Monakhov wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > Adds an filesystem independent ioctl to allow implementation of file
> > system batched discard support.
> >
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ioctl.c         |   31 +++++++++++++++++++++++++++++++
> >  include/linux/fs.h |    2 ++
> >  2 files changed, 33 insertions(+), 0 deletions(-)
> >
> > diff --git a/fs/ioctl.c b/fs/ioctl.c
> > index 2d140a7..6c01c3c 100644
> > --- a/fs/ioctl.c
> > +++ b/fs/ioctl.c
> > @@ -540,6 +540,33 @@ static int ioctl_fsthaw(struct file *filp)
> >  	return thaw_super(sb);
> >  }
> >  
> > +static int ioctl_fstrim(struct file *filp, unsigned long arg)
> BTW why do we have to trim fs in one shot ?
> IMHO it is much suitable to provide start,len parameters as we 
> do in most functions(truncate, bdevdiscard, getdents).
> It allow userspace caller to implement a fancy looking progress bars.

Hi,

do you think it is really needed when even with todays SSD's it takes
just a couple of seconds ? And I suppose it will improve in future. But
generally I think we can do that..I would like to hear some more
opinions before I start looking at this.

Thanks.

-Lukas.

> > +{
> > +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> > +	unsigned int minlen;
> > +	int err;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> > +
> > +	/* If filesystem doesn't support trim feature, return. */
> > +	if (sb->s_op->trim_fs == NULL)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
> > +	if (sb->s_bdev == NULL)
> > +		return -EINVAL;
> > +
> > +	err = get_user(minlen, (unsigned int __user *) arg);
> > +	if (err)
> > +		return err;
> > +
> > +	err = sb->s_op->trim_fs(minlen, sb);
> > +	if (err)
> > +		return err;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * When you add any new common ioctls to the switches above and below
> >   * please update compat_sys_ioctl() too.
> > @@ -590,6 +617,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
> >  		error = ioctl_fsthaw(filp);
> >  		break;
> >  
> > +	case FITRIM:
> > +		error = ioctl_fstrim(filp, arg);
> > +		break;
> > +
> >  	case FS_IOC_FIEMAP:
> >  		return ioctl_fiemap(filp, arg);
> >  
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 68ca1b0..01632e4 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -315,6 +315,7 @@ struct inodes_stat_t {
> >  #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
> >  #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
> >  #define FITHAW		_IOWR('X', 120, int)	/* Thaw */
> > +#define FITRIM		_IOWR('X', 121, int)	/* Trim */
> >  
> >  #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
> >  #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
> > @@ -1580,6 +1581,7 @@ struct super_operations {
> >  	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
> >  #endif
> >  	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
> > +	int (*trim_fs) (unsigned int, struct super_block *);
> >  };
> >  
> >  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
