From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Wed, 13 Dec 2006 18:24:28 -0700
Message-ID: <20061214012428.GA11548@schatzie.adilger.int>
References: <20060913164202.GA14838@openx1.frec.bull.fr> <1158171071.6072.10.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>,
	linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53889 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbWLNBYb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 20:24:31 -0500
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Content-Disposition: inline
In-Reply-To: <1158171071.6072.10.camel@lade.trondhjem.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sep 13, 2006  14:11 -0400, Trond Myklebust wrote:
> On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
> > here is a small patch that adds the "change attribute" for ext3
> > file-systems;
> > 
> > the change attribute is a simple counter that is reset to zero on
> > inode creation and that is incremented every time the inode data is
> > modified (similarly to the "ctime" time-stamp).
> 
> I would really have preferred a full-blown 64-bit counter as per
> RFC3530, but I suppose we could always combine this change attribute
> with the high word from ctime in order to make up the NFSv4 change
> attribute. That should keep us safe until someone develops a ramdisk
> with < 1 nsecond access time.

Trond, can you please elaborate on the need for a 64-bit version counter
for NFSv4?  We have been looking at something similar, but ctime+nsec is
not really sufficient as it is possible that the inode ctime can go
backward if the clock is reset.

What kind of requirements does NFSv4 place on the version?  Monotonic is
probably a good bet.  Does it need to be global for the filesystem, or
is a per-inode version sufficient?  What functionality of NFSv4 needs
the version?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
