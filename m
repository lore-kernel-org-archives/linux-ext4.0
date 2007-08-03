From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Fri, 3 Aug 2007 15:05:49 -0500
Message-ID: <20070803150549.7a83f4ef@gara>
References: <20070803040041.29456.31454.stgit@gara>
	<20070803040059.29456.55756.stgit@gara>
	<20070803182217.GV6142@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:41794 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbXHCUIQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 16:08:16 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l73K8FXB005572
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 16:08:15 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l73K8Fl5208888
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 14:08:15 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l73K8FJu032302
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 14:08:15 -0600
In-Reply-To: <20070803182217.GV6142@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 3 Aug 2007 12:22:17 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:
> On Aug 02, 2007  23:00 -0500, Jose R. Santos wrote:
> > Eventually, a more thorough check would restrict bitmaps and inode
> > tables to be located at the beginning of a flex block group range.
> > Since the super block does not currently know about the number of
> > groups per flex group, this will do for now.
> 
> As with regular block groups, it would probably be better to limit the
> bitmaps and inode tables to anywhere inside the flexbg instead of the
> start.  That would allow, for example, INCOMPAT_FLEXBG to be enabled
> on an existing filesystem and the metadata could be moved together as
> space becomes available.

This is something that would be simple to do if the ratio of block
groups per flex group known to the filesystem itself.  This implies
adding another field to the super block as reliable way to obtain this
information.  The only thing keeping me from doing so is the uncertainty
of backwards compatibility when changing the super block structure.

I agree though that one of the requirements for this feature is more
robust checking of the location of the bitmaps and inode tables within
the flex group.  Checking of the descriptor in flexbg become a little
more complicated than in regular block groups because:

1. The block and inode bitmaps should be allocated a one big chunk for
each flex group.

2. The block and inode bitmaps should be located in the first block
group and the inode tables with in the first few groups of a flex group.

3. If the full range of bitmaps in not allocated contiguously, this
means that bad blocks caused us to move a particular bitmap out and
thus the bad block list should be checked to ensure that this was the
case.

If the above conditions are not met, this could point to possible
corruption in the block descriptors.

> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 

-JRS
