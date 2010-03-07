From: Jeff Garzik <jeff@garzik.org>
Subject: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT)
 in 32bit compat mode)
Date: Sun, 07 Mar 2010 18:27:58 -0500
Message-ID: <4B94367E.9080506@garzik.org>
References: <201003072132.10579.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.210.174]:33728 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0CGXwE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Mar 2010 18:52:04 -0500
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/07/2010 03:32 PM, Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:
> {
>          __u32 reserved;         /* should be zero */
>          __u32 donor_fd;         /* donor file descriptor */
>          __u64 orig_start;       /* logical start offset in block for orig */
>          __u64 donor_start;      /* logical start offset in block for donor */
>          __u64 len;              /* block length to be moved */
>          __u64 moved_len;        /* moved block length */
> };
>
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
>
> Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
> CCed: Akira Fujita<a-fujita@rs.jp.nec.com>

I'm curious, what is the overall deployment status of ext4 defragging? 
I actually worked on this problem years ago[1], and am hopeful that I 
will see defragging in a Linux distribution sometime in my lifetime!  ;-)

Looking at Fedora rawhide, I do not see anything resembling e4defrag in 
any of the RPM packages like e2fsprogs.

Thanks to everyone working on this,

	Jeff




[1] http://linux.yyz.us/misc/ext2meta.c

