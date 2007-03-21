From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [Patch 0/2] Persistent preallocation in ext4 (using fallocate inode op)
Date: Wed, 21 Mar 2007 17:49:51 +0530
Message-ID: <20070321121951.GB27273@amitarora.in.ibm.com>
References: <1174319308.11636.8.camel@kleikamp.austin.ibm.com> <1174324522.11657.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:48044 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbXCUMTt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Mar 2007 08:19:49 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2LCJmX0015150
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 08:19:48 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2LCJmqT049182
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 06:19:48 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2LCJluf031438
	for <linux-ext4@vger.kernel.org>; Wed, 21 Mar 2007 06:19:48 -0600
Content-Disposition: inline
In-Reply-To: <1174324522.11657.14.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 19, 2007 at 09:15:22AM -0800, Mingming Cao wrote:
> On Mon, 2007-03-19 at 10:48 -0500, Dave Kleikamp wrote:
> > persistent_allocation_1_ioctl_and_unitialized_extents
> 
> We could mention here that this patch is going to be replaced by a new
> patch to use the fallocate() operations.
> 
> > # Fixed an endian error
> > persistent_allocation_2_support_for_writing_to_unitialized_extent
> 
> I think Amit has an updated version of this patch in his place.

Hi Mingming,

Here are the new patches which use new fallocate inode interface. I have
made following changes to the previous patchset:

1. Removed ioctl portion of the code from the preallocation patch.
2. Added ext4_fallocate() to support the new fallocate inode operation,
which will be called from the sys_fallocate() system call code.
3. Fixed the endian error which you observed in the "write support for
uninitialized extents" patch.

--
Regards,
Amit Arora
