From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag
 (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Sun, 07 Mar 2010 23:43:58 -0600
Message-ID: <4B948E9E.2030703@redhat.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab0CHFoM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Mar 2010 00:44:12 -0500
In-Reply-To: <4B94367E.9080506@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeff Garzik wrote:
> On 03/07/2010 03:32 PM, Christian Borntraeger wrote:
>> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
>> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
>> case. It seems that struct move_extent is compat save, only types
>> with fixed widths are used:
>> {
>>          __u32 reserved;         /* should be zero */
>>          __u32 donor_fd;         /* donor file descriptor */
>>          __u64 orig_start;       /* logical start offset in block for
>> orig */
>>          __u64 donor_start;      /* logical start offset in block for
>> donor */
>>          __u64 len;              /* block length to be moved */
>>          __u64 moved_len;        /* moved block length */
>> };
>>
>> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
>>
>> Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
>> CCed: Akira Fujita<a-fujita@rs.jp.nec.com>
> 
> I'm curious, what is the overall deployment status of ext4 defragging? I
> actually worked on this problem years ago[1], and am hopeful that I will
> see defragging in a Linux distribution sometime in my lifetime!  ;-)

on ext4 you mean, I guess - you could use XFS if defragging is a high priority,
see xfs_fsr(8)

> Looking at Fedora rawhide, I do not see anything resembling e4defrag in
> any of the RPM packages like e2fsprogs.

I had it for a while, but with the various problems and general uneasiness
with the code so far, I took it back out lest people lose data to it.

-Eric

> Thanks to everyone working on this,
> 
>     Jeff
> 
> 
> 
> 
> [1] http://linux.yyz.us/misc/ext2meta.c

