From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ext4 writepages is making tiny bios?
Date: Thu, 3 Sep 2009 12:42:09 -0400
Message-ID: <20090903164209.GA28384@infradead.org>
References: <20090901184450.GB7885@think> <20090901205744.GE6996@mit.edu> <20090901212740.GA9930@infradead.org> <20090903055201.GA7146@discord.disaster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbZICQmM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Sep 2009 12:42:12 -0400
Content-Disposition: inline
In-Reply-To: <20090903055201.GA7146@discord.disaster>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 03, 2009 at 03:52:01PM +1000, Dave Chinner wrote:
> > XFS did the mistake of trusting the VM, while everyone more or less
> > overrode it.  Removing all those checks and writing out much larger
> > data fixes it with a relatively small patch:
> > 
> > 	http://verein.lst.de/~hch/xfs/xfs-writeback-scaling
> 
> Careful:
> 
> -	tloff = min(tlast, startpage->index + 64);
> +	tloff = min(tlast, startpage->index + 8192);
> 
> That will cause 64k page machines to try to write back 512MB at a
> time. This will re-introduce similar to the behaviour in sles9 where
> writeback would only terminate at the end of an extent (because the
> mapping end wasn't capped like above).

Pretty good point, any applies to all the different things we discussed
recently.  Ted, should be maybe introduce a max_writeback_mb instead of
the max_writeback_pages in the VM, too?

