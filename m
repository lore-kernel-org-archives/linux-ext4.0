From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/6] mke2fs: set block_validity as a default mount option
Date: Mon, 25 Aug 2014 08:52:18 -0700
Message-ID: <20140825155218.GA22645@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042630.2441.34661.stgit@birch.djwong.org>
 <20140824224721.GG6236@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaHYPw0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2014 11:52:26 -0400
Content-Disposition: inline
In-Reply-To: <20140824224721.GG6236@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 24, 2014 at 06:47:21PM -0400, Theodore Ts'o wrote:
> On Fri, Aug 08, 2014 at 09:26:30PM -0700, Darrick J. Wong wrote:
> > The block_validity mount option spot-checks block allocations against
> > a bitmap of known group metadata blocks.  This helps us to prevent
> > self-inflicted catastrophic failures such as trying to "share"
> > critical metadata (think bitmaps) with file data, which usually
> > results in filesystem destruction.
> > 
> > In order to test the overhead of the mount option, I re-used the speed
> > tests in the metadata checksum testing script.  In short, the program
> > creates what looks like 15 copies of a kernel source tree, except that
> > it uses fallocate to strip out the overhead of writing the file data
> > so that we can focus on metadata overhead.  On a 64G RAM disk, the
> > overhead was generally about 0.9% and at most 1.6%.  On a 160G USB
> > disk, the overhead was about 0.8% and peaked at 1.2%.
> 
> I was doing a spot check of the additional memory impact of
> block_validity mount option, and it's for a 20T file system, assuming
> the basic flex_bg size of 16 block groups, it's a bit over 400k of
> kernel memory.  That's not a *huge* amount of memory, but it could
> potentially be noticeable on a bookshelf NAS server.
> 
> However, I could imagine that for a system with say, two dozen 10T
> drives (which aren't that far off in the future) in a tray, that's
> around 4 megabytes of memory, which starts being non-trivial.
> 
> That being said, I suspect for most users, it's not that big of a deal
> --- so maybe this is something we should just simply enable by default
> in the kernel, let those folks who want to disable specify a
> noblock_validity mount option.

Should there be a noblock_validity default mount option?

I suppose I can simply send in a one-liner making b_v the kernel default and
see if anyone screams....

> The other thing to consider is that for big raid arrays, maybe we
> should use a larger flex_bg size.  The main reason for keeping the
> size small is to minimize the seek time between the inode table and a
> block in the flex_bg.  But for raid devices, we could probably afford
> to increase flex_bg size, which would decrease the numer of system
> zones that the block validity code would need to track.

One could make the default flexbg size = 16 * stride_width / stripe_width as a
start.

--D
> 
>       	       	     	      	   	      - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
