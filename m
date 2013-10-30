From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Spot-check block group sub-table locations
Date: Wed, 30 Oct 2013 12:45:07 -0400
Message-ID: <20131030164507.GC13343@thunk.org>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
 <20130928001404.25857.43349.stgit@birch.djwong.org>
 <20130929064400.GB10285@gmail.com>
 <20131009220824.GM6860@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52493 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3J3Qu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:50:59 -0400
Content-Disposition: inline
In-Reply-To: <20131009220824.GM6860@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 09, 2013 at 03:08:24PM -0700, Darrick J. Wong wrote:
> > FWIW, I notice that in ext4_check_descriptors() we also check the
> > location of bitmap.  So maybe we could use ext4_is_sane_bgdata_location
> > in that function.
> 
> That could be done, but all we'd be doing is trading this:
> 
> 	block_bitmap = ext4_block_bitmap(sb, gdp);
> 	if (block_bitmap < first_block || block_bitmap > last_block) {
> 
> for this slightly slower code:
> 
> 	if (ext4_is_sane_bgdata_location(sb, gdp,
> 					 ext4_block_bitmap(sb, gdb))) {
> 
> I don't know if that's worth the code churn or not.  It's an easy change, but I
> don't think it adds much.  Ted -- if you want me to make the change I'll do it,
> but if you're content to leave the patch as it is, then so am I.

The question I have is if we are checking to make sure all of the
block and inode bitmaps are sane at mount time, how much is it worth
it to check to make sure that they are sane each time we need to load
the bitmap?  This is especially true since for ext4 file systems with
flex_bg, the only real check we can do is to is whether the block
number is out of range, which will almost certainly cause a device
error.

						- Ted
