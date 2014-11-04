From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/6] RFC: (partially) endian-annotate e2fsprogs
Date: Tue, 4 Nov 2014 15:27:40 -0800
Message-ID: <20141104232740.GB10043@birch.djwong.org>
References: <54497296.8000708@redhat.com>
 <20141104163407.GA30614@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46586 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaKDX1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Nov 2014 18:27:51 -0500
Content-Disposition: inline
In-Reply-To: <20141104163407.GA30614@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 04, 2014 at 11:34:07AM -0500, Theodore Ts'o wrote:
> On Thu, Oct 23, 2014 at 04:26:46PM -0500, Eric Sandeen wrote:
> > This is really only partial, and in the end didn't spot any
> > actual problems.  And things are a bit odd and tricky, because
> > some structures (superblocks, inodes, etc) are swapped in-place
> > in the same structure (so they can't be easily annotated - 
> > if we wish to, we should define separate on-disk and in-memory
> > structures).
> > 
> > Further, i_block in the inode is sometimes swapped on read, and
> > sometimes not (!), depending on whether it's indirect blocks,
> > extents, or inline data.  So that's still messy too.
> > 
> > So this is really just kind of an RFC; I did it on a whim, and
> > things aren't yet totally sparse-check clean, but figured I'd send
> > it out and see what people think, whether it's worth merging,
> > or working on cleaning up the above issues to make it all tidier.
> > 
> > (sparse is pretty good at looking for casts in and out of blk64_t
> > too, though I haven't looked much at those.)
> 
> I've applied all of these patches, thanks.  I'm not sure how much we
> can clean up some of the rest of the bits without breaking the library
> ABI, and we're not all that sparse-clean to start, so I think it's
> worth merging now.  We can always do more clean ups (both with sparse,
> or gcc-wall, clang, etc.) as people have time.

Uh... it breaks my ppc64/arm64 cross builds, though moving the __CHECKER__ and
typedef bits out of that horrible three-way #if fixes it.  Will send patch.

--D

> 
> Thanks!!
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
