From: Dave Chinner <david@fromorbit.com>
Subject: Re: e4defrag modifies folder's mtime.
Date: Wed, 4 Jan 2012 15:53:18 +1100
Message-ID: <20120104045318.GA17026@dastard>
References: <4F00BE34.1080006@gmail.com>
 <20120103203443.GC30502@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas Lindroth <thomas.lindroth@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:38943 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab2ADExV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jan 2012 23:53:21 -0500
Content-Disposition: inline
In-Reply-To: <20120103203443.GC30502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 03, 2012 at 03:34:43PM -0500, Ted Ts'o wrote:
> On Sun, Jan 01, 2012 at 09:12:36PM +0100, Thomas Lindroth wrote:
> > I ran e4defrag from e2fsprogs-1.42 on a file system and a lot of
> > folders had their mtime updated as a result. This confuses both my
> > backup program and myself. I guess the folder timestamps change
> > because the temporary donor file is created in the same directory as
> > the original file. XFS's defrag program put the donor files in a
> > temporary folder in the root of the file system. Maybe e4defrag
> > could do the same.
> 
> Yes, that could be done if the user running the program (which does
> not have to be root) has write access to the root directory of the
> file system.  There will certainly be cases where this will not be
> true, however.

xfs_fsr doesn't use these donor files to avoid mtime updates - it
uses invisible IO (i.e. O_NOATIME|O_NOCMTIME) to do that.

Also xfs_fsr needs root permissions because it uses the XFS
open-by-handle interfaces. Indeed, it doesn't always use tmp donor
dirs in the root directory - it only ever does that when doing an
entire fs re-organisation. If you are just defragging a single file,
it creates the tmp file in the same directory as the file being
defragged...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
