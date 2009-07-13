From: Eric Sandeen <sandeen@redhat.com>
Subject: using dm-zero to test large filesystems w/o all those pesky disks
Date: Mon, 13 Jul 2009 11:45:55 -0500
Message-ID: <4A5B64C3.2010102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41081 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZGMQp5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 12:45:57 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6DGjvbn005110
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 12:45:57 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6DGjvxW022258
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 12:45:57 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6DGjtDI010092
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jul 2009 12:45:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From Documentation/device-mapper/zero.txt in the kernel:

> To create a sparse device, start by creating a dm-zero device that's the
> desired size of the sparse device. For this example, we'll assume a 10TB
> sparse device.
> 
> TEN_TERABYTES=`expr 10 \* 1024 \* 1024 \* 1024 \* 2`   # 10 TB in sectors
> echo "0 $TEN_TERABYTES zero" | dmsetup create zero1
> 
> Then create a snapshot of the zero device, using any available block-device as
> the COW device. The size of the COW device will determine the amount of real
> space available to the sparse device. For this example, we'll assume /dev/sdb1
> is an available 10GB partition.
> 
> echo "0 $TEN_TERABYTES snapshot /dev/mapper/zero1 /dev/sdb1 p 128" | \
>    dmsetup create sparse1
> 
> This will create a 10TB sparse device called /dev/mapper/sparse1 that has
> 10GB of actual storage space available. If more than 10GB of data is written
> to this device, it will start returning I/O errors.

It should be quite possible to use this sort of thing for large ext4
filesystem testing.

Further tricks could be done to mark certain regions of the filesystem
as full, and then place dm error targets under those regions, so that if
any IO happens in this region it will return an error; this could maybe
help catch wraparounds & overflows...

-Eric
