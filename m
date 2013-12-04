From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 01/28] libext2fs: support modifying arbitrary extended
 attributes
Date: Wed, 4 Dec 2013 14:55:31 -0800
Message-ID: <20131204225531.GA10150@birch.djwong.org>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
 <1386072715-9869-2-git-send-email-wenqing.lz@taobao.com>
 <20131203195457.GD9535@birch.djwong.org>
 <20131204145343.GC17008@thunk.org>
 <20131204203028.GT9535@birch.djwong.org>
 <20131204224314.GD19914@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	Zheng Liu <wenqing.lz@taobao.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab3LDWzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Dec 2013 17:55:42 -0500
Content-Disposition: inline
In-Reply-To: <20131204224314.GD19914@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 04, 2013 at 05:43:14PM -0500, Theodore Ts'o wrote:
> On Wed, Dec 04, 2013 at 12:30:28PM -0800, Darrick J. Wong wrote:
> > It doesn't include all of them.  At the moment there are 83 of them(!) which I
> > haven't figured out how to release in a reviewable manner.  Roughly speaking,
> > the patches can be grouped:
> > 
> >  1. The unapplied patches from the October submission (fuse2fs, 64bit
> >     conversion, xattr editing part 1, metadata checksumming tests)
> >  2. The xattr-editing patches
> >  3. Fixes for uninit extent handling
> >  4. Patches to test and turn on block_validity
> >  5. A bunch of coverity fixes
> >  6. Fixes for bugs I found by running xfstests atop fuse2fs
> >  7. Fixes for that thing about block_uninit groups that Akira Fujita and I were
> >     discussing
> >  8. Fixes for 1k block filesystems with meta_bg
> >  9. Patches to prevent too-high lblk mapping
> > 
> > I could collapse all the post-October fuse2fs and xattr-editing patches into
> > the original submissions, but that seems like it would be harder for people to
> > review the new changes.
> 
> Can you send at least some of the fixes independent of patches that
> have API/ABI or functionality impacts, or are dependent on patches
> that will require more careful review?
> 
> In particular, if there are any fixes that might lead to data loss or
> be significant in some way (potential security issues, etc.) sending
> them independently, preferably against the maint branch, would be a
> good idea, so we can get that into a 1.42.x maintenance release.

Shouldn't be too hard, all I have to do is shove the fuse2fs/xattr/64bit-conv
patches towards the end. :)

--D
> 
> Thanks,
> 
> 					- Ted
