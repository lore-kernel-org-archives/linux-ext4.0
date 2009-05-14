From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ext4: Clear the unwritten buffer_head flag properly
Date: Thu, 14 May 2009 11:10:02 +0530
Message-ID: <20090514054002.GA7359@skywalker>
References: <1241692770-22547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1241692770-22547-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090512030856.GI21518@mit.edu> <20090512044627.GA6753@skywalker> <4A0B17F8.3000402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:52332 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbZENFkO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 May 2009 01:40:14 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id n4E5e9uo011313
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 11:10:09 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4E5e9aH1364208
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 11:10:09 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n4E5e8ht032639
	for <linux-ext4@vger.kernel.org>; Thu, 14 May 2009 15:40:09 +1000
Content-Disposition: inline
In-Reply-To: <4A0B17F8.3000402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2009 at 01:56:56PM -0500, Eric Sandeen wrote:
> > 
> > I think it is good. But one thing missing in the commit message is,
> > what happens if we do a write to prealloc space. Since a
> > get_block(create = 1) is now split into __get_block(create = 0 )  and
> > __get_block(create = 1). That would mean if we pass a buffer head with
> > BH_Unwritten cleared we will have
> > 
> > 
> > 1) buffer_head as BH_Unwritten cleared.
> > 
> > 2) __get_block(create = 0 ) -> Since it is prealloc space we will have
> > BH_Unwritten set .
> 
> Why do we need to set BH_Unwritten on a !create call at all?
> 
> Or maybe another way of asking is, are there any !create callers of
> get_block who -want- BH_Unwritten set?
> 
> Which is to say, should we just not be setting BH_Unwritten in get_block
> in the !create case, ever?

It should only be set in the !create case. With create == 1, we would
have already converted the uninitialized extent to initialized one and
the buffer_head should not be unwritten at all. My understanding is
unwritten flag is used to indicate the buffer_head state between a
write_begin and write_page phase with delayed allocation. ie, when we
write to fallocate space, since we have delalloc enabled, we  just
do a block lookup (get_block with create = 0). The buffer_head returned
in the above case should have unwritten set so that during writepage
we do the actual block allocation (get_block writh create = 1)
looking at the flag.


> 
> The comment:
> 
>  	/*
> +	 * The above get_blocks can cause the buffer to be
> +	 * marked unwritten. So clear the same.
> +	 */
> +	clear_buffer_unwritten(bh);
> 
> is imho not helpful; to me it says "we -just- set this, so clear it!"
> It leaves me scratching my head.
> 
> > 3) __get_block(create = 1) -> get the blocks out of prealloc space.
> > and retun with BH_Mapped set. 
> > 
> > That would imply we have BH_Unwritten and BH_Mapped set in the above
> > case which is wrong. So we need a BH_Unwritten clear between (2) and
> > (3). The patch does the same. May be we need to capture it in commit
> > message.
> 
> Better in comments, I think.  :)
> 

-aneesh
