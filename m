From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: use directio end_io error status to finish
 unwritten aio dio correctly
Date: Fri, 19 Feb 2016 10:15:48 -0500
Message-ID: <20160219151548.GB3014@thunk.org>
References: <20160218054557.GH6338@birch.djwong.org>
 <20160218060148.GA10571@infradead.org>
 <20160218220232.GA4262@dastard>
 <20160219131829.GA30166@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56698 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbcBSPP6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 10:15:58 -0500
Content-Disposition: inline
In-Reply-To: <20160219131829.GA30166@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 19, 2016 at 02:18:29PM +0100, Jan Kara wrote:
> Yeah, if IO error occurs while writing to unwritten extent we need to just
> destroy the IO end without doing the extent conversion (since we don't know
> how much got written). Attached patch should fix the issue - full xfstests
> run is in progress but a quick check using generic/299 has passed.
> 
> How do we merge this? It depends on the changes in Dave's tree so do we
> merge it via that? I have other ext4 changes pending in this area so Ted
> would then have to pull some branch from Dave's tree. Guys?

I've been asking Darrick this on the weekly ext4 teleconference for a
while.  If DIO changes can be put this on a separate git branch, we
can merge it that way.  Worse case, the DIO fix can go in during the
next merge window, and then the ext4 fixup can go in post rc2.  After
all, we've been living this for a while...

					- Ted
