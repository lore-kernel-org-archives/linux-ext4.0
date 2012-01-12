From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] xfs: Protect xfs_file_aio_write() with
 sb_start_write - sb_end_write
Date: Thu, 12 Jan 2012 22:36:56 +0100
Message-ID: <20120112213656.GF8778@quack.suse.cz>
References: <1326331253-6497-1-git-send-email-jack@suse.cz>
 <1326331253-6497-5-git-send-email-jack@suse.cz>
 <20120112212941.GI23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>,
	Alex Elder <elder@kernel.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755375Ab2ALVg7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Jan 2012 16:36:59 -0500
Content-Disposition: inline
In-Reply-To: <20120112212941.GI23916@ZenIV.linux.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 12-01-12 21:29:41, Al Viro wrote:
> On Thu, Jan 12, 2012 at 02:20:53AM +0100, Jan Kara wrote:
> > Replace racy xfs_wait_for_freeze() check with reliable sb_start_write()
> > - sb_end_write() locking. Due to lock ranking dictated by the page fault
> > code we have to call sb_start_write() after we acquire ilock.
> > 
> > CC: Ben Myers <bpm@sgi.com>
> > CC: Alex Elder <elder@kernel.org>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_file.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 753ed9b..c5f879b 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
> >  		*iolock = XFS_IOLOCK_SHARED;
> >  	}
> >  
> > +	sb_start_write(inode->i_sb);
> >  	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
> >  	ret = generic_file_direct_write(iocb, iovp,
> >  			&nr_segs, pos, &iocb->ki_pos, count, ocount);
> > +	sb_end_write(inode->i_sb);
> 
> What lock ordering do you have in mind?  Explicit description in fs/super.c,
> please...
  Good point. Will add explanatory comment. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
