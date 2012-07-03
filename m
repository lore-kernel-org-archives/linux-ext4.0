From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 5/5] XFS: prjquota and grpqouta now may coexist
Date: Tue, 03 Jul 2012 23:14:22 +0400
Message-ID: <87a9zgy7w1.fsf@dmbot.sw.ru>
References: <1340269733-25922-1-git-send-email-dmonakhov@openvz.org> <1340269733-25922-6-git-send-email-dmonakhov@openvz.org> <20120622023612.GG10673@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51584 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2GCTO2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jul 2012 15:14:28 -0400
In-Reply-To: <20120622023612.GG10673@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Jun 2012 12:36:12 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Jun 21, 2012 at 01:08:53PM +0400, Dmitry Monakhov wrote:
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  fs/xfs/xfs_super.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 0d9de41..f408a27 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -538,14 +538,14 @@ xfs_showargs(
> >  	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
> >  		seq_puts(m, "," MNTOPT_UQUOTANOENF);
> >  
> > -	/* Either project or group quotas can be active, not both */
> > -
> >  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
> >  		if (mp->m_qflags & XFS_OQUOTA_ENFD)
> >  			seq_puts(m, "," MNTOPT_PRJQUOTA);
> >  		else
> >  			seq_puts(m, "," MNTOPT_PQUOTANOENF);
> > -	} else if (mp->m_qflags & XFS_GQUOTA_ACCT) {
> > +	}
> > +
> > +	if (mp->m_qflags & XFS_GQUOTA_ACCT) {
> >  		if (mp->m_qflags & XFS_OQUOTA_ENFD)
> >  			seq_puts(m, "," MNTOPT_GRPQUOTA);
> >  		else
> 
> Why can they co-exist now? XFS does not use the VFS quota
> code, and you've made no other changes to XFS so I can't see how you
> can make that assertion. There's a current patchset under review
> that allows XFS to have co-existing group and project quotas - it's
> complex, changes the on-disk format and requires userspace tool
> support (e.g. mkfs, repair, xfs_db, etc).
> 
> So I can't see how this works with XFS at all...
Yes, you right, let's just drop that patch at all.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
