From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] ext3: Add FITRIM handle for ext3
Date: Tue, 23 Nov 2010 11:32:46 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011231126380.3139@dhcp-lab-213.englab.brq.redhat.com>
References: <1290425358-16253-1-git-send-email-lczerner@redhat.com> <1290425358-16253-2-git-send-email-lczerner@redhat.com> <20101122174220.GC5012@quack.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0KWKcx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 05:32:53 -0500
In-Reply-To: <20101122174220.GC5012@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 22 Nov 2010, Jan Kara wrote:

> On Mon 22-11-10 12:29:18, Lukas Czerner wrote:
> > It takes fstrim_range structure as an argument. fstrim_range is definec in
> > the include/linux/fs.h.
> > 
> > After the FITRIM is done, the number of actually discarded Bytes is stored
> > in fstrim_range.len to give the user better insight on how much storage
> > space has been really released for wear-leveling.
>   Umm, why do we have to do this when FITRIM is already handled in
> fs/ioctl.c? I'd expect us to just provide .trim_fs ioctl, no?

Hi,

see upstream commits:
93bb41f4f8b89ac8b4d0a734bc59634cb0a29a89
e681c047e47c0abe67bf95857f23814372793cb0

unfortunately people was not happy with generic ioctl interface for that
purpose, there were concerned that it is no common enough to be included
in core vfs and there is no need for new super operation since each
filesystem can easily setup its own ioctl handling.

When I say people I need to clarify that it was mainly Christoph Hellwig
who had objections against the former implementation and I must say that
he had a point.

-Lukas


> 
> 									Honza
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/ext3/ioctl.c |   22 ++++++++++++++++++++++
> >  1 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
> > index 8897481..fc080dd 100644
> > --- a/fs/ext3/ioctl.c
> > +++ b/fs/ext3/ioctl.c
> > @@ -276,7 +276,29 @@ group_add_out:
> >  		mnt_drop_write(filp->f_path.mnt);
> >  		return err;
> >  	}
> > +	case FITRIM: {
> >  
> > +		struct super_block *sb = inode->i_sb;
> > +		struct fstrim_range range;
> > +		int ret = 0;
> > +
> > +		if (!capable(CAP_SYS_ADMIN))
> > +			return -EPERM;
> > +
> > +		if (copy_from_user(&range, (struct fstrim_range *)arg,
> > +				   sizeof(range)))
> > +			return -EFAULT;
> > +
> > +		ret = ext3_trim_fs(sb, &range);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		if (copy_to_user((struct fstrim_range *)arg, &range,
> > +				 sizeof(range)))
> > +			return -EFAULT;
> > +
> > +		return 0;
> > +	}
> >  
> >  	default:
> >  		return -ENOTTY;
> > -- 
> > 1.7.2.3
> > 
> 

-- 
