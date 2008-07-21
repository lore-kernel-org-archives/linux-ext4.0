From: Theodore Tso <tytso@mit.edu>
Subject: Re: e2fsprogs and blocks outside i_size
Date: Mon, 21 Jul 2008 08:34:00 -0400
Message-ID: <20080721123400.GA28839@mit.edu>
References: <20080718121130.GB23898@skywalker> <20080718123706.GE11221@mit.edu> <20080721050825.GE3370@webber.adilger.int> <20080721055918.GA8788@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48356 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750728AbYGUMeH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 08:34:07 -0400
Content-Disposition: inline
In-Reply-To: <20080721055918.GA8788@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 21, 2008 at 11:29:18AM +0530, Aneesh Kumar K.V wrote:
> 
> That is fine for extents marked uninit. But when we zero out we zero out
> the full extent. So that means a write of few bytes can result in blocks
> being zeroed out outside i_size.  My question was how e2fsck can handle
> this. Because the extent will no more be marked as uninit and  there
> would be blocks outside i_size all carrying zero. 
> 

Wel, as I said originally, we have four choices, only two of which are
tenable:

1) Don't change i_size and leave e2fsck confused about whether i_size
is confused or not; the next time e2fsck runs it can either fix it and
change i_size, confusing applications that depend on i_size, or not
fix it and in the case of a corrupted i_size, leave valid data
inaccessible or do the hack to which Andreas reacted, "Yuck", and
which Annesh quoted and I assume agree.  (i.e., checking the data
blocks to see if they are non-zero, and electing to to risk confusing
the application in the case where they are non-zero).  This is the
current case.

2) Change i_size and always confuse applications that depend on i_size
carrying some semantic meaning.

3) Don't aggressively zero-out (as it presents us with these two
untenable options) and try to explit the extent instead.  If the block
application fails, return ENOSPC.

4) #3, except if the block allocation fails, try to steal a block that
had been previously preallocated for some other logical block in that
inode.


Are there any other choices?  I think #3 and #4 are the only options
and #3 is certainly the simplest to implement, but it could lead to
confusing results since the filesystem would be returning ENOSPC even
though 'df' reports that space is available --- and some applications
preallocate in order to guarantee no write failures.

#4 is more complex, but it means that file might be more fragmented at
the end, which would be bad for applications that depend on
fallocate() to provide a more contiugous file.  (Although fallocate
never guaranteed perfect layout, just that it might provide a better
one.)  It also means that at the end, a file write might end up
failing anyway, since we ended up stealing a block that was meant for
use as a data bock.

The one other thing I would note is that at least for non-root users,
the reserved blocks will help save us most of the time, except for
when users explicitly set the reserved blocks down to zero.  But maybe
this is one place where we just document that reserved blocks serve
yet another purpose, which is to get us out of this mess, and that
applications which depend on preallocated writes not failing need to
either (a) not use insane write patterns, or (b) not run as root and
to save a modest number of reserved blocks for this situation (or
otherwise leave some "slack space" in the filesystem.)

							- Ted

