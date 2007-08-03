From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: What is fragment in ext3/4 ?
Date: Fri, 3 Aug 2007 16:28:59 -0600
Message-ID: <20070803222859.GX6142@schatzie.adilger.int>
References: <46B1A9F9.3050901@gmail.com> <20070803000228.GO6142@schatzie.adilger.int> <46B35260.9000900@redhat.com> <46B355D6.8000007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Coly Li <colyli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:42200 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235AbXHCW3D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 18:29:03 -0400
Content-Disposition: inline
In-Reply-To: <46B355D6.8000007@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 04, 2007  00:20 +0800, Coly Li wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Eric Sandeen wrote:
> > There's a fair amount of code around this never-implemented concept;
> > should it be removed?  :)
> 
> I agree with this idea. It seems we will never implement it in future,
> once "fragment" packed into inode.

Yes, this should all be removed.  In fact, the "fragment" fields are
being reassigned in the upstream e2fsprogs, so there is no chance to
implement it in the future either.  If we ever want to have fragments
like this, the plan was to add them as EAs in the inode (no point to
make an external EA block to hold a block of data).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
