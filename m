From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Date: Tue, 16 Nov 2010 07:52:50 -0500
Message-ID: <20101116125249.GB31957@dhcp231-156.rdu.redhat.com>
References: <1289840723-3056-1-git-send-email-josef@redhat.com> <1289840723-3056-2-git-send-email-josef@redhat.com> <20101116111611.GA4757@quack.suse.cz> <20101116114346.GB4757@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, cmm@us.ibm.com, cluster-devel@redhat.com,
	ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756202Ab0KPMxg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Nov 2010 07:53:36 -0500
Content-Disposition: inline
In-Reply-To: <20101116114346.GB4757@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 16, 2010 at 12:43:46PM +0100, Jan Kara wrote:
> On Tue 16-11-10 12:16:11, Jan Kara wrote:
> > On Mon 15-11-10 12:05:18, Josef Bacik wrote:
> > > diff --git a/fs/open.c b/fs/open.c
> > > index 4197b9e..ab8dedf 100644
> > > --- a/fs/open.c
> > > +++ b/fs/open.c
> > > @@ -223,7 +223,7 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
> > >  		return -EINVAL;
> > >  
> > >  	/* Return error if mode is not supported */
> > > -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> > > +	if (mode && (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)))
> >   Why not just:
> > if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) ?
>   And BTW, since FALLOC_FL_PUNCH_HOLE does not change the file size, should
> not we enforce that FALLOC_FL_KEEP_SIZE is / is not set? I don't mind too
> much which way but keeping it ambiguous (ignored) in the interface usually
> proves as a bad idea in future when we want to further extend the interface...
>

Yeah I went back and forth on this.  KEEP_SIZE won't change the behavior of
PUNCH_HOLE since PUNCH_HOLE implicitly means keep the size.  I figured since its
"mode" and not "flags" it would be ok to make either way accepted, but if you
prefer PUNCH_HOLE means you have to have KEEP_SIZE set then I'm cool with that,
just let me know one way or the other.  Thanks,

Josef
