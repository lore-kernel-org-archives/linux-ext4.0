From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (May 7, 2007)
Date: Wed, 9 May 2007 10:37:40 -0700
Message-ID: <20070509173740.GQ6375@schatzie.adilger.int>
References: <4641FE96.6010603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:43341 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbXEIRhn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 May 2007 13:37:43 -0400
Content-Disposition: inline
In-Reply-To: <4641FE96.6010603@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On May 09, 2007  10:02 -0700, Avantika Mathur wrote:
> Metablock Groups:
> 
> - Mingming mentioned that in the metablock group feature, the inode 
> metadata is not moved with the rest of the metadata.  Ted will check 
> this, as he thought this had been implemented.
> 
> - Online resize does not use metablock groups, and is currently limited 
> to 2TB.
> 
> - Also need to remove sanity checks in the mount code
> 
> - Once these issues are fixed, the metablock group feature can be turned 
> on by default for ext4 filesysytems

In my recent investigation of META_BG, it appears that BOTH the kernel
and e2fsprogs do NOT handle group metadata (bitmaps, itable) outside the
group.

In the kernel ext[234]_check_descriptors() requires the bitmaps and itable
to be inside the group even though META_BG is supported for a long time.

In e2fsck/super.c check_super_block() also requires that the bitmaps and
itable be inside the group even though e2fsck has claimed META_BG for a
long time.

That means it is virtually impossible to allow the group metadata to move
under the META_BG feature.  It might be possible to predicate this change
under both 64BIT and META_BG, though this is somewhat non-standard.

Alternately, we could allow the relocation of bitmaps and itables under
BIG_BG, which is itself covers the relocation aspects and also allows
the ability to change the group size.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
