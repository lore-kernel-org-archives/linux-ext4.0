From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Where all does preallocated/extra space hide?
Date: Thu, 8 Oct 2009 17:18:52 +0530
Message-ID: <20091008114851.GA22610@skywalker.linux.vnet.ibm.com>
References: <4AC23A17.5020100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42779 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596AbZJHLte (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Oct 2009 07:49:34 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.31.245])
	by e23smtp05.au.ibm.com (8.14.3/8.13.1) with ESMTP id n98BkCcL002931
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 22:46:12 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n98Bmuwn1208402
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 22:48:56 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n98Bmu0r001420
	for <linux-ext4@vger.kernel.org>; Thu, 8 Oct 2009 22:48:56 +1100
Content-Disposition: inline
In-Reply-To: <4AC23A17.5020100@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 29, 2009 at 11:47:19AM -0500, Eric Sandeen wrote:
> I was running some of the xfstests enospc tests on ext4, and they were
> failing; in one case, manymanymany small files are made to fill up a
> 100M filesystem.  ext4 stops quite early with -ENOSPC, but after a bit,
> (or after a "sync") we get 40MB free again.  So 40% of the fs space is
> hidden somewhere in preallocation...
> 
> I tried calling out to discard group prealloc but that's only a few
> blocks.  I'll go trace through the sync paths to see what all gets
> released, but if anyone knows offhand where the rest of that space is
> hiding, please give me a shout.  :)
> 


preallocation space is discarded by default if we fail a block allocation
ext4_mb_discard_preallocations does that. What might be happening is the
extra meta data blocks that we reserve for making sure we will be able
to properly insert the new extent on block allocation.  I guess we should
force a data allocation when we fail with ENOSPC in ext4_da_writepages
We currently force a journal commit so that the we claim back the blocks
from deleted files. But we can also force block allocation for delayed
allocated inodes so that we free some of the extra meta data we reserved

-aneesh
