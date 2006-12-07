From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Wed, 6 Dec 2006 21:35:30 -0500
Message-ID: <20061207023530.GA17244@filer.fsl.cs.sunysb.edu>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1> <20061204235042.GS33919298@melbourne.sgi.com> <Pine.GSO.4.53.0612051049200.27677@compserv1> <20061206091100.GA33919298@melbourne.sgi.com> <20061207005619.GA12320@filer.fsl.cs.sunysb.edu> <20061207014426.GL44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061207014426.GL44411608@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 07, 2006 at 12:44:27PM +1100, David Chinner wrote:
> Maybe we should be using EAs for this sort of thing instead of flags
> on the inode? If we keep adding inode flags for generic features
> then we are going to force more than just XFS into inode format
> changes eventually....

Aren't EAs slow? Maybe not on XFS but on other filesystems...

Josef "Jeff" Sipek.

-- 
Linux, n.:
  Generous programmers from around the world all join forces to help
  you shoot yourself in the foot for free. 
