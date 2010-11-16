From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 16 Nov 2010 07:53:46 -0500
Message-ID: <20101116125345.GC31957@dhcp231-156.rdu.redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-2-git-send-email-josef@redhat.com> <20101116111611.GA4757@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
	ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334Ab0KPMyc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 07:54:32 -0500
Content-Disposition: inline
In-Reply-To: <20101116111611.GA4757@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 12:16:11PM +0100, Jan Kara wrote:
> On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> > diff --git a/fs/open.c b/fs/open.c
> > index 4197b9e..ab8dedf 100644
> > --- a/fs/open.c
> > +++ b/fs/open.c
> > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> >  		return -EINVAL;
> >  
> >  	/* Return error if mode is not supported */
> > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
>   Why not just:
> if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?
>

Good point, thank you.
 
> > diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> > index 3c15510..851cba2 100644
> > --- a/include/linux/falloc.h
> > +++ b/include/linux/falloc.h
> > @@ -2,6 +2,7 @@
> >  #define _FALLOC_H_
> >  
> >  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
> > +#define FALLOC_FL_PUNCH_HOLE	0X02 /* de-allocates range */
>                                  ^ use lowercase 'x' please...
>

Argh bitten by caps-lock again.  Thanks I'll fix this up,

Josef 
