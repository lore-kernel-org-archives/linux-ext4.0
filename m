From: Dave Chinner <david@fromorbit.com>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Thu, 26 May 2016 12:20:20 +1000
Message-ID: <20160526022020.GG26977@dastard>
References: <57448A5D.4050805@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Gernot Hillier <gernot.hillier@siemens.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14346 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbcEZCUY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 May 2016 22:20:24 -0400
Content-Disposition: inline
In-Reply-To: <57448A5D.4050805@siemens.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 24, 2016 at 07:07:41PM +0200, Gernot Hillier wrote:
> Hi there!
> 
> We experience strange delays with kernel 4.1.18 during dpkg package
> installation on an ext4 filesystem after switching from Ubuntu 14.04 to
> 16.04. We can reproduce the issue with kernel 4.6. Installation of the
> same package takes 2s with ext3 and 31s with ext4 on the same partition.
> 
> Hardware is an Intel-based server with Supermicro X8DTH board and
> Seagate ST973451SS disks connected to an LSI SAS2008 controller (PCI
> 0x1000:0x0072, mpt2sas driver).
> 
> We could track this down to the introduction of fallocate() in recent
> dpkg versions and derived the following synthetic test case. First
> sync_file_range() call takes ~5ms, 2nd call ~15ms.
> 
> 	fd = open("test1.txt", 0xc1);
> 	ret = fallocate(fd, 0, 0, 20);
> 	ret = write(fd, "hallo", 6);
> 	ret = sync_file_range(fd, 0, 0, 2);
> 	ret = close(fd);
> 
> 	fd = open("test2.txt", 0xc1);
> 	ret = fallocate(fd, 0, 0, 20);
> 	ret = write(fd, "hallo", 6);
> 	ret = sync_file_range(fd, 0, 0, 2);
> 	ret = close(fd);

Stupid question: why is dpkg using fallocate() for such small ranges
like that? I can't think of a more inefficient way to do small IO -
using delayed allocation is far more optimal from a layout,
overhead, latency and IO perspective than the above forced
allocation pseudo-synchronous write behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
