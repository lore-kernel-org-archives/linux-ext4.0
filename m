From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC] Insure direct IO writes do not use the page cache
Date: Thu, 30 Jul 2009 16:36:11 +0530
Message-ID: <20090730110611.GA27453@skywalker>
References: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37051 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZG3LGY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Jul 2009 07:06:24 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp08.au.ibm.com (8.14.3/8.13.1) with ESMTP id n6VGtCaW003097
	for <linux-ext4@vger.kernel.org>; Sat, 1 Aug 2009 02:55:12 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n6UB6Njv512222
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2009 21:06:23 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6UB6NdT027470
	for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2009 21:06:23 +1000
Content-Disposition: inline
In-Reply-To: <6601abe90907281728h22be79fenc68a16b578e28a91@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 28, 2009 at 05:28:05PM -0700, Curt Wohlgemuth wrote:
> This insures that direct IO writes to fallocate'd file space do not use the
> page cache.
> 
> 
>       Signed-off-by: Curt Wohlgemuth <curtw@google.com>
> 
> ---
> 
> I implemented Aneesh's ideas for this solution, but have some questions.
> 
> I've verified that the page cache isn't  used, regardless of whether
> FALLOC_FL_KEEP_SIZE is used in the fallocate() call or not.
> 
> The changes:
>    - New inode state flag to indicate that a DIO write is ongoing
> 
>    - ext4_ext_convert_to_initialized() will mark any new extent it creates
>      as uninitialized, if this new EXT4_STATE_DIO_WRITE flag is set.

That will have issues with a parallel get_block due to writepages. ext4_da_writepages
will end up calling get_block on uninit extent without holding inode->i_mutex. So
you can have a direct_IO -> get_block and a writepages -> get_block going together
now if we mark extent as uninit based on a inode flag we will have to fix the
writepages call path also. Instead of inode flag you may want to track the extent
(you can look at the patch from Chris Mason implementing data=guarded for ext3. Chris
Mason's patch track buffer_head what you want is to track extent. And convert the
extent to init using end_io call back. 


> 
>    - ext4_direct_IO() will set this flag for any write.
> 
>      It now calls blockdev_direct_IO_own_locking() to do the I/O.
> 
>      After return from blockdev_direct_IO_own_locking() it clears the flag
>      and calls a new routine to mark all extents containing the returned
>      blocks as initialized.
> 
> I'm a bit uncertain about the use of DIO_OWN_LOCKING; I looked at the XFS
> code to see if it acquired any other locks while using this flag, but didn't
> see any.  Suggestions/corrections welcome.

-aneesh
