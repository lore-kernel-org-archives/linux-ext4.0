From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: cleaned up ext4 patch series
Date: Mon, 19 Mar 2007 09:15:22 -0800
Message-ID: <1174324522.11657.14.camel@localhost.localdomain>
References: <1174319308.11636.8.camel@kleikamp.austin.ibm.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:35277 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966033AbXCSRPZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 13:15:25 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2JHFOEc010768
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 13:15:24 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2JHFOrL067416
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:15:24 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2JHFOnM022897
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 11:15:24 -0600
In-Reply-To: <1174319308.11636.8.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-03-19 at 10:48 -0500, Dave Kleikamp wrote:
> Ted,
> I have rebased the ext4 patchset on 2.6.21-rc4 and cleaned up some bad
> whitespace and sparse warnings.  The patches are here:
> http://www.kernel.org/pub/linux/kernel/people/shaggy/ext4/ext4-2007-03-19.tar.bz2
> Untarred here:
> http://www.kernel.org/pub/linux/kernel/people/shaggy/ext4/ext4-2007-03-19/
> 
> I have commented the series file with the changes I've made.  Some of
> the patches are missing signed-of-by:
> 
> # Rebased the patches to 2.6.21-rc4
> 
> # New patch to fix whitespace before applying new patches
> whitespace.patch
> 
> # Replaced truncated beginning comments
> extent-overlap-bugfix
> 

> persistent_allocation_1_ioctl_and_unitialized_extents
> 

We could mention here that this patch is going to be replaced by a new
patch to use the fallocate() operations.

> # Fixed an endian error
> persistent_allocation_2_support_for_writing_to_unitialized_extent
> 

I think Amit has an updated version of this patch in his place.

> # Note: still lots of outstanding comments from linux-ext4 list, 12/2006
> # Missing signed-off-by:
> booked-page-flag.patch
> 
> # Missing signed-off-by:
> ext4-block-reservation.patch
> 
> # fixed a bunch of endianness errors reported by sparse
> # Needs a signed-off-by from Alex, then can add shaggy's
> ext4-delayed-allocation.patch
> 
> ext4-delalloc-extents-48bit.patch
> 
> # updated to latest version
> nanosecond_timestamps.patch
> 
This nanosecond patch could be move to upstream earlier than the delayed
allocation patch (Alex is working to rewrite it at VFS level), so shall
we move it before the booked-page-flag.patch?

I wonder if we should create two branches: one branch for patches that
are well discussed and tested, which Andrew could trust and pull to mm
tree; and create another branch to store patches that are still under
discussion and likely to be rewriten based on the review feedback.


Thanks,
Mingming
