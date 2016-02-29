From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Mon, 29 Feb 2016 18:03:05 +1100
Message-ID: <20160229070305.GE30721@dastard>
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
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:47727 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbcB2HDI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Feb 2016 02:03:08 -0500
Content-Disposition: inline
In-Reply-To: <20160219131829.GA30166@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 02:18:29PM +0100, Jan Kara wrote:
> How do we merge this? It depends on the changes in Dave's tree so do we
> merge it via that? I have other ext4 changes pending in this area so Ted
> would then have to pull some branch from Dave's tree. Guys?
...
> Subject: [PATCH] ext4: Fix data exposure after failed AIO DIO

Now committed and pushed to the xfs-dio-fixes-4.6 branch, and merged
back into the XFS for-next branch so it will be picked up by
linux-next builds.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
