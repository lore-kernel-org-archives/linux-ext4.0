From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 7 Dec 2006 13:49:44 +1100
Message-ID: <20061207024944.GM44411608@melbourne.sgi.com>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1> <20061206091100.GA33919298@melbourne.sgi.com> <20061207005619.GA12320@filer.fsl.cs.sunysb.edu> <20061207014426.GL44411608@melbourne.sgi.com> <20061207023530.GA17244@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:53263 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967774AbWLGCuT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 21:50:19 -0500
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Content-Disposition: inline
In-Reply-To: <20061207023530.GA17244@filer.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 06, 2006 at 09:35:30PM -0500, Josef Sipek wrote:
> On Thu, Dec 07, 2006 at 12:44:27PM +1100, David Chinner wrote:
> > Maybe we should be using EAs for this sort of thing instead of flags
> > on the inode? If we keep adding inode flags for generic features
> > then we are going to force more than just XFS into inode format
> > changes eventually....
> 
> Aren't EAs slow? Maybe not on XFS but on other filesystems...

Only when they don't fit in the inode itself and extra
disk seeks are needed to retrieve them.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
