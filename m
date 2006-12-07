From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 7 Dec 2006 00:35:25 -0500
Message-ID: <20061207053525.GA23020@filer.fsl.cs.sunysb.edu>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1> <20061206091100.GA33919298@melbourne.sgi.com> <20061207005619.GA12320@filer.fsl.cs.sunysb.edu> <20061207014426.GL44411608@melbourne.sgi.com> <20061207023530.GA17244@filer.fsl.cs.sunysb.edu> <20061207024944.GM44411608@melbourne.sgi.com> <1165461298.2817.10.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55424 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968820AbWLGFff (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2006 00:35:35 -0500
To: Nicholas Miell <nmiell@comcast.net>
Content-Disposition: inline
In-Reply-To: <1165461298.2817.10.camel@entropy>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 06, 2006 at 07:14:58PM -0800, Nicholas Miell wrote:
> On Thu, 2006-12-07 at 13:49 +1100, David Chinner wrote:
> > On Wed, Dec 06, 2006 at 09:35:30PM -0500, Josef Sipek wrote:
> > > On Thu, Dec 07, 2006 at 12:44:27PM +1100, David Chinner wrote:
> > > > Maybe we should be using EAs for this sort of thing instead of flags
> > > > on the inode? If we keep adding inode flags for generic features
> > > > then we are going to force more than just XFS into inode format
> > > > changes eventually....
> > > 
> > > Aren't EAs slow? Maybe not on XFS but on other filesystems...
> > 
> > Only when they don't fit in the inode itself and extra
> > disk seeks are needed to retrieve them.
> > 
> > Cheers,
> > 
> > Dave.
> 
> Also keep in mind that the EA doesn't actually have to have a physical
> representation on disk (or, rather, it does, but it doesn't need to be
> the same representation used by EAs in the user namespace).
> 
> This means that if one of those slow EA filesystems still has room for
> flags in the inode, it can synthesize the EA on demand.
 
Interesting point. Filesystems such as XFS would be unaffected (at least
with attr v1, not sure how attr2 does things in XFS wrt EAs.)

Another question is, suppose that filesystem x is one of the slow EA
filesystems, exposing this whiteout inode flag as EA would require fs x to
be compiled with EA support. As a matter of fact, it would require all the
filesystems to have EA support. Sure, overall it is less work for me, but I
am more interested in doing the Right Thing(tm) - which may be something
completely different from EA or inode flag (e.g., what Ted Tso suggested at
OLS - effectively a metadata-only ondisk format for unionfs.)
 
> This is even preferable to ioctls for the interface to new filesystem
> metadata -- if a backup or archive program knows how to store EAs, it
> will be able to save and restore any new exotic metadata without any
> extra effort.

Agreed.

Josef "Jeff" Sipek.

-- 
UNIX is user-friendly ... it's just selective about who it's friends are
