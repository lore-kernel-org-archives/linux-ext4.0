From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix 'return 0' for error case in ext4_fill_super
Date: Thu, 18 Nov 2010 14:21:57 -0800
Message-ID: <20101118222157.GE18195@tux1.beaverton.ibm.com>
References: <1290116832-29443-1-git-send-email-joro@8bytes.org>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joerg Roedel <joro@8bytes.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:60680 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab0KRWWM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Nov 2010 17:22:12 -0500
Content-Disposition: inline
In-Reply-To: <1290116832-29443-1-git-send-email-joro@8bytes.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 18, 2010 at 10:47:12PM +0100, Joerg Roedel wrote:
> The ext4_fill_super may return with value 0 in case of an error. The
> reason is that the ret variable is used to store the return value of a
> called function and is not set back to an error value later on.
> This issue caused a NULL pointer de-ref in vfs_kern_mount on one of my
> machines when it tried to mount a partition:
> 
> 	BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
> 	IP: [<ffffffff8112e8dc>] vfs_kern_mount+0x7c/0x180
> 	PGD 218480067 PUD 225323067 PMD 0
> 	Oops: 0000 [#1] SMP
> 	last sysfs file: /sys/devices/system/cpu/cpu5/cache/index2/shared_cpu_map
> 	CPU 1
> 
> 	...
> 
> 	Process mount (pid: 3591, threadinfo ffff8802258fc000, task ffff88022586dac0)
> 	Stack:
> 	 ffff8802258fde38 0000000000000000 ffff880225e299b0 ffff880200000001
> 	 ffffffff81a230e0 ffff880225e2c818 ffff8802258fde88 ffffffff8112ea52
> 	 ffff8802258fde98 0000000000000246 ffff88022586dac0 0000000000000060
> 	Call Trace:
> 	 [<ffffffff8112ea52>] do_kern_mount+0x52/0x130
> 	 [<ffffffff811497ff>] do_mount+0x2bf/0x810
> 	 [<ffffffff810face3>] ? strndup_user+0x53/0x70
> 	 [<ffffffff81149de0>] sys_mount+0x90/0xe0
> 	 [<ffffffff81002fdb>] system_call_fastpath+0x16/0x1b
> 
> This patch fixes the issue by using the 'err' variable instead of 'ret'
> for that function-call like it is done in for all other function-calls
> in ext4_fill_super too.
> If have seen this issue on 2.6.36 too, so this patch may be -stable
> material as well.

Lukas and I have been trying to fix this bug for a couple of days now, and he
actually sent off an identical patch this morning:
http://www.spinics.net/lists/linux-ext4/msg21743.html

(I also sent off a similar cleanup of the ext3 counterpart.)

But, thanks for pointing this out! :)

--D
