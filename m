From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Mon, 22 Feb 2016 09:19:14 +0100
Message-ID: <20160222081914.GD7791@quack.suse.cz>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
 <20160218220232.GA4262@dastard>
 <20160219131829.GA30166@quack.suse.cz>
 <20160221062826.GB14668@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbcBVISw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Feb 2016 03:18:52 -0500
Content-Disposition: inline
In-Reply-To: <20160221062826.GB14668@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 21-02-16 17:28:26, Dave Chinner wrote:
> On Fri, Feb 19, 2016 at 02:18:29PM +0100, Jan Kara wrote:
> > On Fri 19-02-16 09:02:32, Dave Chinner wrote:
> > > Won't that now call ext4_put_io_end() ->
> > > ext4_convert_unwritten_extents() with an uninitialised offset and
> > > size?
> > > 
> > > i.e. I don't think this prevents warnings, and may make things
> > > worse when real errors occur....
> > 
> > Yeah, if IO error occurs while writing to unwritten extent we need to just
> > destroy the IO end without doing the extent conversion (since we don't know
> > how much got written). Attached patch should fix the issue - full xfstests
> > run is in progress but a quick check using generic/299 has passed.
> > 
> > How do we merge this? It depends on the changes in Dave's tree so do we
> > merge it via that? I have other ext4 changes pending in this area so Ted
> > would then have to pull some branch from Dave's tree. Guys?
> 
> The xfs-dio-fix-4.6 branch in the XFS tree is stable, so feel free
> to pull it into other trees. However, it might be better for me to
> append this patch to that branch once it is revewed and tested to
> keep them all together in a stable branch. It can still be pulled
> into other trees if needed...

Full xfstests run completed for me fine with the patch so it should be
good to go in your tree in that regard. So additional review would be fine
though. Darrick, can you have a look?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
