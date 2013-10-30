From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] ext4: Spot-check block group sub-table locations
Date: Wed, 30 Oct 2013 10:33:49 -0700
Message-ID: <20131030173349.GA8208@birch.djwong.org>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
 <20130928001404.25857.43349.stgit@birch.djwong.org>
 <20130929064400.GB10285@gmail.com>
 <20131009220824.GM6860@birch.djwong.org>
 <20131030164507.GC13343@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50758 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3J3Rdy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Oct 2013 13:33:54 -0400
Content-Disposition: inline
In-Reply-To: <20131030164507.GC13343@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 30, 2013 at 12:45:07PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 09, 2013 at 03:08:24PM -0700, Darrick J. Wong wrote:
> > > FWIW, I notice that in ext4_check_descriptors() we also check the
> > > location of bitmap.  So maybe we could use ext4_is_sane_bgdata_location
> > > in that function.
> > 
> > That could be done, but all we'd be doing is trading this:
> > 
> > 	block_bitmap = ext4_block_bitmap(sb, gdp);
> > 	if (block_bitmap < first_block || block_bitmap > last_block) {
> > 
> > for this slightly slower code:
> > 
> > 	if (ext4_is_sane_bgdata_location(sb, gdp,
> > 					 ext4_block_bitmap(sb, gdb))) {
> > 
> > I don't know if that's worth the code churn or not.  It's an easy change, but I
> > don't think it adds much.  Ted -- if you want me to make the change I'll do it,
> > but if you're content to leave the patch as it is, then so am I.
> 
> The question I have is if we are checking to make sure all of the
> block and inode bitmaps are sane at mount time, how much is it worth
> it to check to make sure that they are sane each time we need to load
> the bitmap?  This is especially true since for ext4 file systems with
> flex_bg, the only real check we can do is to is whether the block
> number is out of range, which will almost certainly cause a device
> error.

Probably not worth much, but I thought it was cheap compared to making and
bouncing an IO.  Also, if the check fails, we can mark the bg offline and let
fsck sort out the mess.  The regular error path doesn't do this... though we
could change that too.  

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
