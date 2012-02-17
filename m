From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 2/2] misc: Add fuse2fs, a FUSE server for e2fsprogs
Date: Fri, 17 Feb 2012 10:51:28 -0800
Message-ID: <20120217185128.GC15164@tux1.beaverton.ibm.com>
References: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com> <20120107085534.4325.32519.stgit@elm3c44.beaverton.ibm.com> <20120217151840.GE19606@thunk.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60126 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2BQSv7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 13:51:59 -0500
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 17 Feb 2012 13:51:57 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 141F56E8058
	for <linux-ext4@vger.kernel.org>; Fri, 17 Feb 2012 13:51:32 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1HIpW9B260104
	for <linux-ext4@vger.kernel.org>; Fri, 17 Feb 2012 13:51:32 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1HIpUHB011552
	for <linux-ext4@vger.kernel.org>; Fri, 17 Feb 2012 16:51:31 -0200
Content-Disposition: inline
In-Reply-To: <20120217151840.GE19606@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 17, 2012 at 10:18:40AM -0500, Ted Ts'o wrote:
> On Sat, Jan 07, 2012 at 12:55:35AM -0800, Darrick J. Wong wrote:
> > This is the initial implementation of a FUSE server based on e2fsprogs.  The
> > point of this program is to enable ext4 to run on any OS that FUSE supports
> > (and doesn't already have a native driver), such as MacOS X, BSDs, and Windows.
> > The code requires FUSE API v28, which is available in Linux fuse and osxfuse
> > releases that are available as of January 2012.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> So my system supports up to FUSE API v26 (this is an Ubuntu 10.04
> system; the same should be true for RHEL 5 and RHEL 6 as I understand
> things, since fuse 2.7 and 2.8 both stayed at the same API level).
> Nothing blew up when I built fuse2fs with this version of fuse, and
> when I mounted it, it (mostly) seemed to work --- except it corrupted
> some files randomly, and ultimately corrupted the file system itself.
> 
> I don't know yet whether this is due to the FUSE API mismatch, or some
> bugs in fuse2fs, but either way, this is scary, especially since all
> of the failures were silent until the data and file system corruption
> happened.
> 
> Do you know why the code requires FUSE API v28, and not FUSE API v26,
> and is there an explicit way (either at run time or at compile time)
> to determine if there is an API mismatch?

Hrmm... it worked fine on my Ubuntu 10.04 system... :/

The reason that I specified v28 is that osxfuse advertises v28 support, and it
didn't seem to break on Linux, at least not for me.  There's nothing about v28
that mandates its use over v26.  I think the API detection is keyed off the
#define FUSE_USE_VERSION 28 at the beginning of e2fuse.c; if you try to build
against an old version it'll fail.  I'm not whether or not the wire protocol
actually checks the version, though there seem to be the appropriate fields in
the packet structs.

If you send me more data on the corruption I can try to figure out if it's some
sort of API mismatch, or e2fsprogs bugs, or e2fuse bugs.  Regrettably, it /is/
easier to corrupt something with e2fuse than it ought to be.

--D
> 
> I'm going to hold off on including this patch for now, for the obvious
> reasons....
> 
> Thanks,
> 
> 						- Ted
> 

