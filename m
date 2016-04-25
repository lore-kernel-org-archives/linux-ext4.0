From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: refuse O_DIRECT opens for mode where DIO doesn't
 work
Date: Tue, 26 Apr 2016 09:49:46 +1000
Message-ID: <20160425234946.GB26977@dastard>
References: <1461472078-20104-1-git-send-email-tytso@mit.edu>
 <877ffmhvzt.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dmitry Monakhov <dmonlist@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13148 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbcDYXtu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2016 19:49:50 -0400
Content-Disposition: inline
In-Reply-To: <877ffmhvzt.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 25, 2016 at 12:35:02PM +0300, Dmitry Monakhov wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > Certain ext4 modes (encryption, data=journal, inline data) cause
> > Direct I/O to be a no-op.  Instead of making DIO fail silently, make
> > the open with the O_DIRECT flag fail with EINVAL.
> >
> > This will avoid surprises to application programs, and also signal to
> > xfstests not to try O_DIRECT tests for file system modes where it
> > doesn't work (and could result in test failures).
> >
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> > ---
> >  fs/ext4/file.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> > index fa2208b..4113676 100644
> > --- a/fs/ext4/file.c
> > +++ b/fs/ext4/file.c
> > @@ -372,7 +372,12 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
> >  			return -EACCES;
> >  		if (ext4_encryption_info(inode) == NULL)
> >  			return -ENOKEY;
> > +		if (filp->f_flags & O_DIRECT)
> > +			return -EINVAL;
> >  	}
> > +	if ((ext4_should_journal_data(inode) || ext4_has_inline_data(inode)) &&
> > +	    (filp->f_flags & O_DIRECT))
> Hmm...
> __ext4_new_inode set EXT4_STATE_MAY_INLINE_DATA for each inode if
> ext4_has_feature_inline_data(sb) is true.
> So this may result in complain from user who want inline data
> optimization for small files, but also want O_DIRECT to works.
> IMHO it is reasonable to convert inline inodes to regular ones if user
> open it for WRITE with O_DIRECT

Why not just transparently fall back to buffered IO if direct IO
cannot be done? Saves people from wondering why applications fail
on one ext4 filesystem and not another....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
