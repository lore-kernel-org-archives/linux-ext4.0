From: Andreas Dilger <adilger@sun.com>
Subject: Re: Understanding mballoc
Date: Mon, 3 Dec 2007 12:29:37 -0700
Message-ID: <20071203192937.GK3604@webber.adilger.int>
References: <20071203181237.GD7222@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <bzzz@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:51867 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbXLCT3j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 14:29:39 -0500
Content-Disposition: inline
In-Reply-To: <20071203181237.GD7222@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 03, 2007  23:42 +0530, Aneesh Kumar K.V wrote:
> This is my attempt at understanding multi block allocator. I have
> few questions marked as FIXME below. Can you help answering them.
> Most of this data is already in the patch queue as commit message.
> I have updated some details regarding preallocation. Once we
> understand the details i will update the patch queue commit message.

Some comments below, Alex can answer more authoritatively.

> If we are not able to find blocks in the inode prealloc space and if we have
> the group allocation flag set then we look at the locality group prealloc
> space. These are per CPU prealloc list repreasented as
> 
> ext4_sb_info.s_locality_groups[smp_processor_id()]
> 
> /* FIXME!! 
> After getting the locality group related to the current CPU we could be
> scheduled out and scheduled in on different CPU. So why are we putting the
> locality group per cpu ?
> */

I think just to avoid contention between CPUs.  It is possible to get
scheduled at this point it is definitely unlikely.  There does appear
to still be proper locking for the locality group, so at worst we get
contention between 2 CPUs for the preallocation instead of all of them.

> /* FIXME: 
> We need to explain the normalization of the request length.
> What are the conditions we are checking the request length
> against. Why are group request always requested at 512 blocks ?

Probably no particular reason for 512 blocks = 2MB, other than some
decent number of smaller requests can fit in there before looking
for another one.

One note for normalization - regarding recent benchmarks that show
e2fsck performance improvement for clustering of indirect blocks it
would also seem that allocating index blocks in the same preallocation
group could provide a similar improvement for mballoc+extents.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
