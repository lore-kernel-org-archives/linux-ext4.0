From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [Ext2-devel] rfc: [patch 3/6] more e2fsprogs fixes
Date: Wed, 6 Sep 2006 04:47:32 -0600
Message-ID: <20060906104732.GP20105@schatzie.adilger.int>
References: <20060825131138.GA20278@openx1.frec.bull.fr> <20060825131840.GC20944@openx1.frec.bull.fr> <20060825235049.GP6634@schatzie.adilger.int> <20060904145941.GA9427@openx1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:32395 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1750772AbWIFKsw
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Sep 2006 06:48:52 -0400
To: Alexandre Ratchov <alexandre.ratchov@bull.net>
Content-Disposition: inline
In-Reply-To: <20060904145941.GA9427@openx1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 04, 2006  16:59 +0200, Alexandre Ratchov wrote:
> in order tu use 48bit adressing, we have to use larger block groups (because
> all group descriptors must fit in one block group).  So we'll need 16bit
> "_hi" bits for blocks_count, inodes_count and perhaps used_dirs_count. And
> this leaves no room for additional fields.
> 
> There's already a patch that makes the descriptor structure size variable
> (similarly to the inode size), see marc.theaimsgroup.com/?m=114968738307171
> Here is the updated patch set:

It was always my desire to require the use of the larger group descriptors
when using a filesystem with > 32-bit blocks.  That avoids the need to use
up the small group descriptors for the 64-bit block numbers, allowing them
to be used for other features that are still relevant for smaller filesystems
like checksums and UNINIT groups.

> linux-2.6.18-rc4:
> 
> http://www.bullopensource.org/ext4/20060904/ext4-linux-2.6.18-rc4.tar.gz
> 
> e2fsprogs-1.39:
> 
> http://www.bullopensource.org/ext4/20060904/ext4-e2fsprogs-1.39.tar.gz


Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

