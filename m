From: Nathan Scott <nscott@aconex.com>
Subject: Re: [RFC][PATCH] Secure Deletion and Trash-Bin Support for Ext4
Date: Thu, 07 Dec 2006 16:45:52 +1100
Message-ID: <1165470352.30459.14.camel@edge>
References: <Pine.GSO.4.53.0612041256180.15321@compserv1>
	 <20061204235042.GS33919298@melbourne.sgi.com>
	 <Pine.GSO.4.53.0612051049200.27677@compserv1>
	 <20061206091100.GA33919298@melbourne.sgi.com>
	 <20061207005619.GA12320@filer.fsl.cs.sunysb.edu>
	 <20061207014426.GL44411608@melbourne.sgi.com>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>,
	Nikolai Joukov <kolya@cs.sunysb.edu>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: David Chinner <dgc@sgi.com>
In-Reply-To: <20061207014426.GL44411608@melbourne.sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2006-12-07 at 12:44 +1100, David Chinner wrote:
> Maybe we should be using EAs for this sort of thing instead of flags
> on the inode? If we keep adding inode flags for generic features
> then we are going to force more than just XFS into inode format
> changes eventually....

You do need to be judicious in what you add, but we got up to here
(well over 10 years) with 16 bits worth of space - increasing to 32
bits is going to last a fairly long time... I wouldn't switch to a
different scheme until that point (which is also the point where the
system calls are going to have to change anyway).

cheers.

-- 
Nathan

