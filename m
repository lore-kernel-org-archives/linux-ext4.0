From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 6 Dec 2006 19:56:19 -0500
Message-ID: <20061207005619.GA12320@filer.fsl.cs.sunysb.edu>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1> <20061206091100.GA33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48107 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937871AbWLGA43 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Dec 2006 19:56:29 -0500
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061206091100.GA33919298@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 06, 2006 at 08:11:00PM +1100, David Chinner wrote:
> They are defined but unused in 2.6.19, right? I can't see anywhere
> in the 2.6.19 ext2/3/4/reiser trees that actually those flags,
> including setting and retrieving them from disk. JFS i can see
> sets, clears and retreives them, but not the fielsystems you
> mention. Though I might just be blind..... ;)
> 
> If all we need to add to XFS is support for those flags, then XFS
> support would be trivial to add.
> 
> Oh, damn. I take that back. We're almost out of flag space in the on
> disk inode - these two flags would use the last 2 flag bits so this
> may require an on disk inode format change in XFS. This will be
> a little more complex than I first thought, but not impossible
> as we already support two on-disk inode format versions.
 
Hrm. I was toying around with the idea of using a flag to mark inodes as
whiteouts (similar to what BSD does) for Unionfs. I remember that Jan Blunck
tried similar thing in his implementation of VFS unionfs mounts.

I am not entirely convinced that whiteout inode flag is the right way to do
things, but I'm just raising this now as I wouldn't want to wait for new
ondisk format for XFS to say that Unionfs supports XFS. (Assuming that it is
the right approach.) ;-)
 
Josef "Jeff" Sipek.

-- 
I already backed up the box once, I can do it again!
