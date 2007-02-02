From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Fw: [BUG -mm] ext3_orphan_add() accessing corrupted list on a corrupted ext3fs
Date: Thu, 1 Feb 2007 18:19:38 -0700
Message-ID: <20070202011938.GC5717@schatzie.adilger.int>
References: <20070201010836.31a63ef2.akpm@osdl.org> <20070201102534.GF5404@schatzie.adilger.int> <m3odod4wju.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Fengguang Wu <fengguang.wu@gmail.com>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:46236 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423058AbXBBB0o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Feb 2007 20:26:44 -0500
Content-Disposition: inline
In-Reply-To: <m3odod4wju.fsf@bzzz.home.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 01, 2007  20:28 +0300, Alex Tomas wrote:
> >>>>> Andreas Dilger (AD) writes:
>  AD> I don't have a comment on the actual bug here, but this is another case
>  AD> where it would be nice to have multi-mount protection built into ext3...
>  AD> When I last proposed this it was refused on the grounds that an external
>  AD> HA manager should be doing this job but I don't think that is realistic.
> 
> can we use JBD-like approach? export some inode and MMP/whatever
> would 'ping' 1st block of the inode.

I'd be happy enough to implement the engine for this in a generic kernel
layer instead of being ext3-specific.  That said, ext3 also has the
ability to mark the filesystem incompatible to older kernels that do not
support the MMP protocol, so this avoids the requirement that both
kernels are up-to-date in order to not corrupt shared images.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
