From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Options for migrating existing files on ext2 partitions to ext4
Date: Thu, 12 Feb 2009 13:27:34 +0530
Message-ID: <20090212075734.GA21074@skywalker>
References: <d5ca277e0902111218l1b568724l2557315d2945637a@mail.gmail.com> <20090212072334.GB3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Xiang Wang <xiangw@google.com>, linux-ext4@vger.kernel.org,
	ext4-team <ext4-team@google.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:32857 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbZBLH5u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Feb 2009 02:57:50 -0500
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id n1C7viQ1021712
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 18:57:44 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n1C7w4Y61155230
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 18:58:04 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1C7vkU7011995
	for <linux-ext4@vger.kernel.org>; Thu, 12 Feb 2009 18:57:47 +1100
Content-Disposition: inline
In-Reply-To: <20090212072334.GB3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 12, 2009 at 02:23:34AM -0500, Andreas Dilger wrote:
> On Feb 11, 2009  12:18 -0800, Xiang Wang wrote:
> 
> > Motivated by the ext4 ioctl interface for migration, we are also
> > looking into this in-place approach. But we are mostly concerned with
> > the fact that if the existing files are highly fragmented, will we
> > still get benefit from the extents? Or will we even get hurt by
> > turning the files into being extents-based?
> 
> The mballoc allocator is pretty good in conjunction with delalloc, so
> I expect you would get mostly defragmented files as you migrate.  This
> would depend on having some decent amount of free space in the filesystem
> so that it is likely that there is enough contiguous free space for some
> number of the >= average size files.
> 

We don't touch the data block during migrate. So we are not actually
doing block allocation. So if the file is fragmented it would remain so
after migrate also. But if it is not we would end up having lesser
number of meta-data information with extent format.

The plan was to hook the migrate interface with defrag so that after
migrate we run a defrag on that that would move data blocks around.

-aneesh
