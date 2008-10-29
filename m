From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Date: Wed, 29 Oct 2008 16:27:07 +1100
Message-ID: <20081029052707.GH4985@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed> <20081029040014.GB17624@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	linux-ext4@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:57187 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbYJ2F1M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Oct 2008 01:27:12 -0400
Content-Disposition: inline
In-Reply-To: <20081029040014.GB17624@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 29, 2008 at 05:00:14AM +0100, Nick Piggin wrote:
> On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> > FWIW, the core issue here is that we've got to do the
> > filemap_fdatawait() call in the ->fsync method because ->fsync
> > gets called before we've waited for the data I/O to complete.
> > XFS updates inode state on I/O completion, so we *must* wait
> > for data I/O to complete before logging the inode changes. I
> > think btrfs has the same problem....
> 
> Interesting. Does that mean you can do without the final filemap_fdatawait?

We could, yes.

> Can you do the first fdatawait without i_mutex held?

I don't see why not - I/O completion is only touching the XFS inode.
XFS has it's own inode locks for I/O and inode exclusion, and the
mapping tree lock protects the tree walk that the fdatawait is
doing...

> There was some talk IIRC about moving all this logic into the filesystem
> to provide more flexibility here. If there is still enough interest,
> we should get that moving...

It would simplify some of the code in XFS, that's for sure ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
