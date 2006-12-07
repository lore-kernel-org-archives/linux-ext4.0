From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 7 Dec 2006 12:44:27 +1100
Message-ID: <20061207014426.GL44411608@melbourne.sgi.com>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1> <20061206091100.GA33919298@melbourne.sgi.com> <20061207005619.GA12320@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:51154 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937940AbWLGBoz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 20:44:55 -0500
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Content-Disposition: inline
In-Reply-To: <20061207005619.GA12320@filer.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 06, 2006 at 07:56:19PM -0500, Josef Sipek wrote:
> On Wed, Dec 06, 2006 at 08:11:00PM +1100, David Chinner wrote:
> > They are defined but unused in 2.6.19, right? I can't see anywhere
> > in the 2.6.19 ext2/3/4/reiser trees that actually those flags,
> > including setting and retrieving them from disk. JFS i can see
> > sets, clears and retreives them, but not the fielsystems you
> > mention. Though I might just be blind..... ;)
> > 
> > If all we need to add to XFS is support for those flags, then XFS
> > support would be trivial to add.
> > 
> > Oh, damn. I take that back. We're almost out of flag space in the on
> > disk inode - these two flags would use the last 2 flag bits so this
> > may require an on disk inode format change in XFS. This will be
> > a little more complex than I first thought, but not impossible
> > as we already support two on-disk inode format versions.
>  
> Hrm. I was toying around with the idea of using a flag to mark inodes as
> whiteouts (similar to what BSD does) for Unionfs. I remember that Jan Blunck
> tried similar thing in his implementation of VFS unionfs mounts.
> 
> I am not entirely convinced that whiteout inode flag is the right way to do
> things, but I'm just raising this now as I wouldn't want to wait for new
> ondisk format for XFS to say that Unionfs supports XFS. (Assuming that it is
> the right approach.) ;-)

Maybe we should be using EAs for this sort of thing instead of flags
on the inode? If we keep adding inode flags for generic features
then we are going to force more than just XFS into inode format
changes eventually....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
