From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Date: Mon, 8 Nov 2010 21:05:09 -0500
Message-ID: <20101109020509.GB27816@dhcp231-156.rdu.redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com> <1289248327-16308-2-git-send-email-josef@redhat.com> <20101109012254.GE2715@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	joel.becker@oracle.com, cmm@us.ibm.com, cluster-devel@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387Ab0KICFg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Nov 2010 21:05:36 -0500
Content-Disposition: inline
In-Reply-To: <20101109012254.GE2715@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 09, 2010 at 12:22:54PM +1100, Dave Chinner wrote:
> On Mon, Nov 08, 2010 at 03:32:03PM -0500, Josef Bacik wrote:
> > This patch simply allows XFS to handle the hole punching flag in fallocate
> > properly.  I've tested this with a little program that does a bunch of random
> > hole punching with FL_KEEP_SIZE and without it to make sure it does the right
> > thing.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_iops.c |   12 +++++++++---
> >  1 files changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> > index 96107ef..99df347 100644
> > --- a/fs/xfs/linux-2.6/xfs_iops.c
> > +++ b/fs/xfs/linux-2.6/xfs_iops.c
> > @@ -516,6 +516,7 @@ xfs_vn_fallocate(
> >  	loff_t		new_size = 0;
> >  	xfs_flock64_t	bf;
> >  	xfs_inode_t	*ip = XFS_I(inode);
> > +	int		cmd = XFS_IOC_RESVSP;
> >  
> >  	/* preallocation on directories not yet supported */
> >  	error = -ENODEV;
> > @@ -528,17 +529,22 @@ xfs_vn_fallocate(
> >  
> >  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> >  
> > +	if (mode & FALLOC_FL_PUNCH_HOLE)
> > +		cmd = XFS_IOC_UNRESVSP;
> > +
> >  	/* check the new inode size is valid before allocating */
> >  	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
> >  	    offset + len > i_size_read(inode)) {
> > -		new_size = offset + len;
> > +		if (cmd == XFS_IOC_UNRESVSP)
> > +			new_size = offset;
> > +		else
> > +			new_size = offset + len;
> 
> What semantic is FALLOC_FL_KEEP_SIZE supposed to convey during a
> hole punch? Doesn't this just turn the hole punch operation into
> a truncate? If so, what's the point of punching the hole when you
> can just call ftruncate() to get the same result?
>

Well your UNRESVSP can do the same thing as a ftruncate so I figured it was ok
to just go ahead and use it rather than add complexity, especially since I don't
understand this crazy fs of yours ;).
 
> I'd suggest that FALLOC_FL_PUNCH_HOLE should, by definition, not
> change the file size, and have no option to be able to change it.
> This needs to be defined and documented - can you include a man
> page update in this series that defines the expected behaviour
> of FALLOC_FL_PUNCH_HOLE?

Oh I see you mean don't allow hole punch to change the size at all.  I was
thinking of doing this originally, but like I said above I figured that there
was no harm in doing the equivalent of an ftruncate.  But you are right, theres
no sense in duplicating functionality, I'll change it to keep PUNCH_HOLE from
changin the size.  Now I just need to figure out where that man page is...

Josef
