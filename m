From: Ben Greear <greearb@candelatech.com>
Subject: Re: kmemleak report in 3.9.5 related to ext4_alloc_inode
Date: Tue, 11 Jun 2013 16:24:43 -0700
Message-ID: <51B7B1BB.2090305@candelatech.com>
References: <51B76B5F.1090301@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40925 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3FKXYo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Jun 2013 19:24:44 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5BNOhpY017645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 11 Jun 2013 16:24:43 -0700
In-Reply-To: <51B76B5F.1090301@candelatech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 06/11/2013 11:24 AM, Ben Greear wrote:
> Hello!
>
> I see this kmemleak report in a slightly modified 3.9.5 kernel
> (no patches to the ext4 subsystem).
>
> Any idea if this is real and/or what a fix would be?

I now think this is bogus.  I disabled SLUB debugging and other debugging
options and now I no longer see this reported by kmemleak.

Thanks,
Ben

>
> unreferenced object 0xffff8801170bb700 (size 40):
>    comm "prelink", pid 25152, jiffies 4352882167 (age 29213.208s)
>    hex dump (first 32 bytes):
>      80 cb 94 15 01 88 ff ff d0 4f 4d 18 01 88 ff ff  .........OM.....
>      01 00 00 00 00 00 00 00 40 4d 3a 18 01 88 ff ff  ........@M:.....
>    backtrace:
>      [<ffffffff815de7bf>] kmemleak_alloc+0x73/0x98
>      [<ffffffff8118b4d4>] slab_post_alloc_hook+0x28/0x2a
>      [<ffffffff8118d9a7>] kmem_cache_alloc+0xb2/0x123
>      [<ffffffff81316919>] __debug_object_init+0x43/0x35f
>      [<ffffffff81316c62>] debug_object_init+0x14/0x16
>      [<ffffffff810b296c>] __init_work+0x27/0x29
>      [<ffffffff81241371>] ext4_alloc_inode+0x173/0x1cb
>      [<ffffffff811b0db4>] alloc_inode+0x1d/0x78
>      [<ffffffff811b0e7c>] iget_locked+0x6d/0x12f
>      [<ffffffff81229817>] ext4_iget+0x2c/0x932
>      [<ffffffff8122f485>] ext4_lookup+0xd2/0x12a
>      [<ffffffff811a3556>] lookup_real+0x2c/0x47
>      [<ffffffff811a3e0c>] __lookup_hash+0x33/0x3c
>      [<ffffffff811a5897>] walk_component+0x73/0x171
>      [<ffffffff811a6e2c>] path_lookupat+0xa7/0x304
>      [<ffffffff811a70b4>] filename_lookup+0x2b/0x82
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

