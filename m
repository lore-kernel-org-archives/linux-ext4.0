From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] misc: Add fuse2fs, a FUSE server for e2fsprogs
Date: Fri, 17 Feb 2012 10:18:40 -0500
Message-ID: <20120217151840.GE19606@thunk.org>
References: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
 <20120107085534.4325.32519.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39658 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab2BQPSp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 10:18:45 -0500
Content-Disposition: inline
In-Reply-To: <20120107085534.4325.32519.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 07, 2012 at 12:55:35AM -0800, Darrick J. Wong wrote:
> This is the initial implementation of a FUSE server based on e2fsprogs.  The
> point of this program is to enable ext4 to run on any OS that FUSE supports
> (and doesn't already have a native driver), such as MacOS X, BSDs, and Windows.
> The code requires FUSE API v28, which is available in Linux fuse and osxfuse
> releases that are available as of January 2012.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

So my system supports up to FUSE API v26 (this is an Ubuntu 10.04
system; the same should be true for RHEL 5 and RHEL 6 as I understand
things, since fuse 2.7 and 2.8 both stayed at the same API level).
Nothing blew up when I built fuse2fs with this version of fuse, and
when I mounted it, it (mostly) seemed to work --- except it corrupted
some files randomly, and ultimately corrupted the file system itself.

I don't know yet whether this is due to the FUSE API mismatch, or some
bugs in fuse2fs, but either way, this is scary, especially since all
of the failures were silent until the data and file system corruption
happened.

Do you know why the code requires FUSE API v28, and not FUSE API v26,
and is there an explicit way (either at run time or at compile time)
to determine if there is an API mismatch?

I'm going to hold off on including this patch for now, for the obvious
reasons....

Thanks,

						- Ted
