From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] direct-io: always call ->end_io if non-NULL
Date: Wed, 3 Feb 2016 16:48:16 +0100
Message-ID: <20160203154816.GA2698@lst.de>
References: <1454444257-9086-1-git-send-email-hch@lst.de> <1454444257-9086-2-git-send-email-hch@lst.de> <20160203000510.GB5854@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160203000510.GB5854@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> > -	if (dio->end_io && dio->result)
> > -		dio->end_io(dio->iocb, offset, transferred, dio->private);
> > +	if (dio->end_io)
> > +		dio->end_io(dio->iocb, offset, ret, dio->private);
> 
> Could we make end_io return an int so that errors during completion can be
> stuffed into ret to be picked up by whatever's calling directio?  Something
> like this:
> 
> if (dio->end_io) {
> 	int ret2;
> 
> 	ret2 = dio->end_io(dio->iocb, offset, ret, dio->private);
> 	if (ret2 && !ret)
> 		ret = ret2;
> }
> 
> That way I can capture IO errors during the CoW remapping step and pass them to
> userland either via dio_complete()'s return value or through ki_complete.
> 
> (If ret itself is an error code then obviously we don't bother with the
> post-CoW remap.)

Should be doable, I'll respin it with that change.
