From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Wed, 17 Jan 2007 14:20:43 -0800
Message-ID: <45AEA13B.6070606@us.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:50574 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbXAQWUs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Jan 2007 17:20:48 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0HMJMte025367
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 17:19:22 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0HMKjVn525062
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 15:20:45 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0HMKjtQ025841
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jan 2007 15:20:45 -0700
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Amit K. Arora wrote:

> Outstanding Issues:
> ------------------
> (1) The final interface is yet to be decided. We have the option of
> chosing from one of these:
> 	a> modifying posix_fallocate() in glibc
> 	b> using fcntl
> 	c> using ftruncate, or
> 	d> using the ioctl interface.
> 
>   If we go with ioctl interface, we need to chose the return
> value from the ioctl. We should either return "0" for success and
> errno for failure, or we should be returning number of bytes
> preallocated.
> 

Now I am more prefer just return 0 for success. Returning the number of 
bytes preallocated back to userspace might be helpful in the case when 
the specified window contains blocks already being allocated, but this 
should not be a common case.

> (2) Also, we need to decide on what should happen in case of a
> partial success scenario. i.e. after few blocks get preallocated, we hit
> some error - say ENOSPC. Should the call just return the number of bytes
> preallocated, or should it "undo" the partial preallocation and then
> exit with error code ?
> 
I think we should try to avoid this partial preallocation at the first 
place. Probably checking the number of free blocks before calling 
ext4_ext_get_blocks() and returns -ENOSPC if there isn't enough free 
blocks to allocate. Otherwise, if it still hits ENOSPC error, I think it 
doesn't hurt to leave the partial preallocated blocks there.

Cheers,
Mingming
