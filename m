From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ext3 lockdep warning in 2.6.25-rc6
Date: Sun, 23 Mar 2008 12:06:27 +0100
Message-ID: <1206270388.6437.90.camel@lappy>
References: <200803222234.m2MMYRJo005108@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Erez Zadok <ezk@cs.sunysb.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393AbYCWLHV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Mar 2008 07:07:21 -0400
In-Reply-To: <200803222234.m2MMYRJo005108@agora.fsl.cs.sunysb.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-03-22 at 18:34 -0400, Erez Zadok wrote:
> In message <1206207527.6437.83.camel@lappy>, Peter Zijlstra writes:
> > On Sat, 2008-03-22 at 10:37 -0400, Erez Zadok wrote:
> > > I was building a kernel using "make -j 4" inside a unionfs, mounted on top
> > > of ext3.  The kernel is vanilla 2.6.25-rc6 plus unionfs patches.  At some
> > > point I forced a cache flush using "echo 3 > /proc/sys/vm/drop_caches" and I
> > > got the lockdep warning below.  Note that unionfs doesn't appear to be
> > > involved in this lockdep warning at all, so I suspect this is probably an
> > > issue between jbd and ext3 directly.
> > 
> > Known issue, drop_caches isn't production quality.
> 
> Is this a general problem with drop_caches, or its interaction with
> ext3/jbd?  If I get a similar lockdep warning with other file systems,
> should I bother to report this to the respective f/s maintainers?

Its a generic problem with drop_caches. If you look in the lkml archives
you'll find similar reports against XFS and others.

Some time ago Andrew outlined a fix for it, but so far that hasn't
happened:  http://lkml.org/lkml/2007/2/23/46



