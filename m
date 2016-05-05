From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v5 1/2] dax: Don't touch i_dio_count in dax_do_io()
Date: Thu, 5 May 2016 17:48:12 +0200
Message-ID: <20160505154812.GA2090@quack2.suse.cz>
References: <1461947276-25988-1-git-send-email-Waiman.Long@hpe.com>
 <1461947276-25988-2-git-send-email-Waiman.Long@hpe.com>
 <20160505141637.GJ1970@quack2.suse.cz>
 <20160505142748.GA10157@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Waiman Long <Waiman.Long@hpe.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	Scott J Norton <scott.norton@hpe.com>,
	Douglas Hatch <doug.hatch@hpe.com>,
	Toshimitsu Kani <toshi.kani@hpe.com>, dbueso@suse.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbcEEPsR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2016 11:48:17 -0400
Content-Disposition: inline
In-Reply-To: <20160505142748.GA10157@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 05-05-16 07:27:48, Christoph Hellwig wrote:
> On Thu, May 05, 2016 at 04:16:37PM +0200, Jan Kara wrote:
> > We cannot easily do this currently - the reason is that in several places we
> > wait for i_dio_count to drop to 0 (look for inode_dio_wait()) while
> > holding i_mutex to wait for all outstanding DIO / DAX IO. You'd break this
> > logic with this patch.
> > 
> > If we indeed put all writes under i_mutex, this problem would go away but
> > as Dave explains in his email, we consciously do as much IO as we can
> > without i_mutex to allow reasonable scalability of multiple writers into
> > the same file.
> 
> So the above should be fine for xfs, but you're telling me that ext4
> is doing DAX I/O without any inode lock at all?  In that case it's
> indeed not going to work.

By default ext4 uses i_mutex to serialize both direct (and thus dax) reads
and writes. However with dioread_nolock mount option, we use only i_data_sem
(ext4 local rwsem) for direct reads and overwrites. That is enough to
guarantee ext4 metadata consistency and gives you better scalability but
you lose write vs read and write vs write atomicity (essentially you get
the same behavior as for XFS direct IO).

> > The downside of that is that overwrites and writes vs reads are not atomic
> > wrt each other as POSIX requires. It has been that way for direct IO in XFS
> > case for a long time, with DAX this non-conforming behavior is proliferating
> > more. I agree that's not ideal but serializing all writes on a file is
> > rather harsh for persistent memory as well...
> 
> For non-O_DIRECT I/O it's simply required..

Well, we already break write vs read atomicity for buffered IO for all
filesystems except XFS which has its special locking. So that's not a new
thing. I agree that also breaking write vs write atomicity for 'normal' IO
is a new thing, in a way more serious as the corrupted result ends up being
stored on disk, and some applications may be broken by that. So we should
fix that.

I was hoping that Davidlohr would come up with a more scalable
range-locking implementation than my original RB-tree based one and we
could use that but that seems to be taking longer than I originally
expected...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
