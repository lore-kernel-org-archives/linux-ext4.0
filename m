From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Fri, 3 Aug 2007 12:22:17 -0600
Message-ID: <20070803182217.GV6142@schatzie.adilger.int>
References: <20070803040041.29456.31454.stgit@gara> <20070803040059.29456.55756.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40164 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbXHCSWS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 14:22:18 -0400
Content-Disposition: inline
In-Reply-To: <20070803040059.29456.55756.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 02, 2007  23:00 -0500, Jose R. Santos wrote:
> Eventually, a more thorough check would restrict bitmaps and inode
> tables to be located at the beginning of a flex block group range.
> Since the super block does not currently know about the number of
> groups per flex group, this will do for now.
 
As with regular block groups, it would probably be better to limit the
bitmaps and inode tables to anywhere inside the flexbg instead of the
start.  That would allow, for example, INCOMPAT_FLEXBG to be enabled
on an existing filesystem and the metadata could be moved together as
space becomes available.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
