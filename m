From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 06 Dec 2006 19:14:58 -0800
Message-ID: <1165461298.2817.10.camel@entropy>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
	 <20061204235042.GS33919298@melbourne.sgi.com>
	 <Pine.GSO.4.53.0612051049200.27677@compserv1>
	 <20061206091100.GA33919298@melbourne.sgi.com>
	 <20061207005619.GA12320@filer.fsl.cs.sunysb.edu>
	 <20061207014426.GL44411608@melbourne.sgi.com>
	 <20061207023530.GA17244@filer.fsl.cs.sunysb.edu>
	 <20061207024944.GM44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061207024944.GM44411608@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2006-12-07 at 13:49 +1100, David Chinner wrote:
> On Wed, Dec 06, 2006 at 09:35:30PM -0500, Josef Sipek wrote:
> > On Thu, Dec 07, 2006 at 12:44:27PM +1100, David Chinner wrote:
> > > Maybe we should be using EAs for this sort of thing instead of flags
> > > on the inode? If we keep adding inode flags for generic features
> > > then we are going to force more than just XFS into inode format
> > > changes eventually....
> > 
> > Aren't EAs slow? Maybe not on XFS but on other filesystems...
> 
> Only when they don't fit in the inode itself and extra
> disk seeks are needed to retrieve them.
> 
> Cheers,
> 
> Dave.

Also keep in mind that the EA doesn't actually have to have a physical
representation on disk (or, rather, it does, but it doesn't need to be
the same representation used by EAs in the user namespace).

This means that if one of those slow EA filesystems still has room for
flags in the inode, it can synthesize the EA on demand.

This is even preferable to ioctls for the interface to new filesystem
metadata -- if a backup or archive program knows how to store EAs, it
will be able to save and restore any new exotic metadata without any
extra effort.

-- 
Nicholas Miell <nmiell@comcast.net>

