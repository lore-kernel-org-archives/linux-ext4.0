From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Tue, 12 May 2009 10:16:27 +0530
Message-ID: <20090512044627.GA6753@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60047 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZELEqu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 00:46:50 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp08.au.ibm.com (8.13.1/8.13.1) with ESMTP id n4C4h8dr030657
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:43:08 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4C4kmSN1355808
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:46:50 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4C4klQX016680
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 14:46:48 +1000
Content-Disposition: inline
In-Reply-To: <20090512030856.GI21518@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 11, 2009 at 11:08:56PM -0400, Theodore Tso wrote:
> On Thu, May 07, 2009 at 04:09:29PM +0530, Aneesh Kumar K.V wrote:
> > ext4_get_blocks_wrap does a block lookup requesting to
> > allocate new blocks. A lookup of blocks in prealloc area
> > result in setting the unwritten flag in buffer_head. So
> > a write to an unwritten extent will cause the buffer_head
> > to have unwritten and mapped flag set. Clear hte unwritten
> > buffer_head flag before requesting to allocate blocks.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> I've rewritten the commit changelog to this, which I believe more
> accurately describes the patch.  Comments, please?
> 
> ext4: Clear the unwritten buffer_head flag after the extent is initialized
> 
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> The BH_Unwritten flag indicates that the buffer is allocated on disk
> but has not been written; that is, the disk was part of a persistent
> preallocation area.  That flag should only be set when a get_blocks()
> function is looking up a inode's logical to physical block mapping.
> 
> When ext4_get_blocks_wrap() is called with create=1, the uninitialized
> extent is converted into an initialized one, so the BH_Unwritten flag
> is no longer appropriate.  Hence, we need to make sure the
> BH_Unwritten is not left set, to avoid the ensuing confusion and
> hilarty.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 

I think it is good. But one thing missing in the commit message is,
what happens if we do a write to prealloc space. Since a
get_block(create = 1) is now split into __get_block(create = 0 )  and
__get_block(create = 1). That would mean if we pass a buffer head with
BH_Unwritten cleared we will have


1) buffer_head as BH_Unwritten cleared.

2) __get_block(create = 0 ) -> Since it is prealloc space we will have
BH_Unwritten set .

3) __get_block(create = 1) -> get the blocks out of prealloc space.
and retun with BH_Mapped set. 

That would imply we have BH_Unwritten and BH_Mapped set in the above
case which is wrong. So we need a BH_Unwritten clear between (2) and
(3). The patch does the same. May be we need to capture it in commit
message.

-aneesh



