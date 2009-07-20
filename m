From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: filefrag abort
Date: Mon, 20 Jul 2009 17:16:12 -0500
Message-ID: <4A64ECAC.2000900@redhat.com>
References: <4A64E650.6020603@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZGTWQP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 18:16:15 -0400
In-Reply-To: <4A64E650.6020603@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ron Johnson wrote:
> Hi,
> 
> (Is this OT?  http://sourceforge.net/forum/forum.php?forum_id=7052 
> doesn't show much activity...)
> 
> Debian Sid, e2fsprogs 1.41.8-1
> Home-rolled 64-bit 2.6.30 with 32-bit userland
> 
> Is this ioctl32() error caused by a "disconnect" between kernel and 
> userland?
> 
> Thanks
> 
> $ df -T /
> Filesystem    Type   1K-blocks      Used Available Use% Mounted on
> /dev/sdb2     ext3    34606072   8585632  24262528  27% /
> 
> # filefrag -v /bin/cp
> Filesystem type is: ef53
> Filesystem cylinder groups is approximately 265
> File size of /bin/cp is 92476 (23 blocks, blocksize 4096)
>   ext logical physical expected length flags
> Calling get_bmap for block 0
> Aborted
> 
> [92747.137445] ioctl32(filefrag:17217): Unknown cmd fd(3) 
> cmd(c020660b){t:'f';sz:32} arg(ffca4c38) on /bin/cp

It's a bug, I sent a patch...

http://marc.info/?l=linux-ext4&m=124768937928420&w=2

-Eric
