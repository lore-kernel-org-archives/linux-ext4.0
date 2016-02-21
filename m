From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Sun, 21 Feb 2016 17:28:26 +1100
Message-ID: <20160221062826.GB14668@dastard>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
 <20160218220232.GA4262@dastard>
 <20160219131829.GA30166@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24603 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbcBUUpd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Feb 2016 15:45:33 -0500
Content-Disposition: inline
In-Reply-To: <20160219131829.GA30166@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 02:18:29PM +0100, Jan Kara wrote:
> On Fri 19-02-16 09:02:32, Dave Chinner wrote:
> > Won't that now call ext4_put_io_end() ->
> > ext4_convert_unwritten_extents() with an uninitialised offset and
> > size?
> > 
> > i.e. I don't think this prevents warnings, and may make things
> > worse when real errors occur....
> 
> Yeah, if IO error occurs while writing to unwritten extent we need to just
> destroy the IO end without doing the extent conversion (since we don't know
> how much got written). Attached patch should fix the issue - full xfstests
> run is in progress but a quick check using generic/299 has passed.
> 
> How do we merge this? It depends on the changes in Dave's tree so do we
> merge it via that? I have other ext4 changes pending in this area so Ted
> would then have to pull some branch from Dave's tree. Guys?

The xfs-dio-fix-4.6 branch in the XFS tree is stable, so feel free
to pull it into other trees. However, it might be better for me to
append this patch to that branch once it is revewed and tested to
keep them all together in a stable branch. It can still be pulled
into other trees if needed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
