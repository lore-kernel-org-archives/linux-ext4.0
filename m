From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 16/14] libext2fs: require the inline data xattr on all
 inline data files
Date: Thu, 23 Jul 2015 14:12:21 -0700
Message-ID: <20150723211221.GD10037@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150605013856.GA7063@birch.djwong.org>
 <20150611001530.GK24181@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28393 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbbGWVMY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Jul 2015 17:12:24 -0400
Content-Disposition: inline
In-Reply-To: <20150611001530.GK24181@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 10, 2015 at 08:15:30PM -0400, Theodore Ts'o wrote:
> On Thu, Jun 04, 2015 at 06:38:56PM -0700, Darrick J. Wong wrote:
> > Turns out that the kernel requires the inline data xattr to exist for
> > all inline data files, even if the inline data size is zero.
> > Therefore, never delete the xattr key, and teach e2fsck always to look
> > for it.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> It seems reasonable to have e2fsck look for this case, but I wonder if
> it might be better to fix it by changing the kernel and e2fsck and
> libext2fs's punch function to clear the inline data flag when it
> removes the inline data xattr, and to do so if the xattr data size is
> zero.

It would be much cleaner to do so, however... I tried doing this and found that
existing kernels expect to be able to maintain a pointer to the value area(!)
and barf when they don't find an xattr, even if it's empty.  I suspect the
proper fix is to remove the shortcut and use the xattr fetch functions (since
the rest of the inline data code uses them) and maybe do the 'system.data' name
compression (and feature flag...) at the same time.

That is to say, if we bother changing anything at all.  There's nothing
seriously wrong with the (weird) way it is now, and this patch exists to codify
that weird way into e2fsprogs so future programmers won't screw up the hidden
requirement about the xattr existence.

<shrug>

--D

> 
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
