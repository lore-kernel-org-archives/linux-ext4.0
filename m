From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Problem with 15TB logical volume
Date: Thu, 12 Aug 2010 09:43:29 -0400
Message-ID: <4C63FA81.8060306@redhat.com>
References: <20100812091635.GC2699@asrockhome.verdurin.salon>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Adam Huffman <bloch@verdurin.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab0HLNnk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Aug 2010 09:43:40 -0400
In-Reply-To: <20100812091635.GC2699@asrockhome.verdurin.salon>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adam Huffman wrote:
> Hope it's okay to send "user problems" here.  

Sure, that's fine.

> I've made a 15TB logical volume on a 21TB RAID6 iSCSI array.
> 
> When I try to make an ext4 filesystem I see the following error:
> 
> mke4fs -E stride=32 stripe-width=384 -i 65536 -j -v \
> /dev/mapper/vg2md3000isata-homes2 
> 
> mke4fs 1.41.9 (22-Aug-2009)
> mke4fs: invalid blocks count - /dev/mapper/vg2md3000isata-homes2


You're not specifying the -E options correctly:

[root@host e2fsprogs]# misc/mke2fs.static -t ext4 -E stride=32 stripe-width=384 /mnt/test2/testdir/bigfile 
mke2fs 1.41.12 (17-May-2010)
mke2fs.static: invalid blocks count - /mnt/test2/testdir/bigfile

This works - you need comma-separated -E options:

[root@host e2fsprogs]# mke4fs -E stride=32,stripe-width=384 /mnt/test2/testdir/bigfile 
mke4fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=32 blocks, Stripe width=384 blocks
1006632960 inodes, 4026531840 blocks
...

Without the comma, mkfs thinks you are trying to mkfs a device called
"stripe-width=384" with a block count of "<devicename>"

Odd eh ;)

Perhaps echoing back the blocks count which it found to be invalid
(in this case the devicename string) would make the failure more
obvious...


> When i searched briefly yesterday, some documentation stated that the
> filesystem limit was now 16TB, and some that the limit was much higher.

Yep that should work.

-Eric
 
> The system is running Centos 5.5, e4fsprogs-1.41.9-3.el5.


