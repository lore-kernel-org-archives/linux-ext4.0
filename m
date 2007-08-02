From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 1/4] e2fsprogs: Add undo I/O manager
Date: Thu, 2 Aug 2007 15:37:28 -0600
Message-ID: <20070802213728.GH6142@schatzie.adilger.int>
References: <11859824513552-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <f2c3823cb66c7a30436b1f2163cbe3bba791a115.1185981319.git.aneesh.kumar@linux.vnet.ibm.com> <20070801225247.GC5692@schatzie.adilger.int> <46B22340.5020709@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:38879 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXHBVhj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Aug 2007 17:37:39 -0400
Content-Disposition: inline
In-Reply-To: <46B22340.5020709@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 03, 2007  00:02 +0530, Aneesh Kumar K.V wrote:
> Andreas Dilger wrote:
> >Is this the mtime and UUID of the new filesystem or the old one?  It
> >should be the UUID and mtime of the new filesystem, so that the
> >undo file can be verified against the current superblock.  This poses
> >a bit of a problem, because that information isn't saved until after
> >the mke2fs run is finished.
> >
> >One possibility is to overwrite this information at the end of mke2fs
> >after the new UUID and mtime are written?
> 
> This can be done by writing the file system identity during the the 
> io_channel_close.
> How about this patch on top of the last series. I will merge this into the 
> patcheset

I thought about this also, but in fact for most uses of the undo manager
we want to save the information at the start instead of the end, so it
is possible to undo e.g. a partial e2fsck that crashes before it finishes.
Only with mke2fs (and, I guess tune2fs -U) does the UUID change at the
end.

Also, can you check if mke2fs does any non-iomanager output?  I think
there is code to "zap" the old superblock at the start and old RAID info
at the end of the block device, and I'm not sure if this uses the normal
IO manager or not.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
