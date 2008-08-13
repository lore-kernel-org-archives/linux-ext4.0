From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: BUG: Reducing the lvm partition on ext4 filesystem " ( 2.6.27-rc1
 )
Date: Wed, 13 Aug 2008 10:17:40 -0500
Message-ID: <48A2FB14.2040306@redhat.com>
References: <OF80EF388C.3D9E8928-ON652574A4.0028C9C8-652574A4.0029043A@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Rishikesh K Rajak <risrajak@in.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:59091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbYHMPSz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2008 11:18:55 -0400
In-Reply-To: <OF80EF388C.3D9E8928-ON652574A4.0028C9C8-652574A4.0029043A@in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Rishikesh K Rajak wrote:
> Hi All,
> 
> I have created the lvm partition on my machine and found there is some
> problem with reducing the size with resize2fs tool  on 2.6.27-rc1 kernel.
> 
> I am not sure this is an exact bug of ext4 filesystem or there is some
> problem with e2fsprogs/resize2fs tool.
> 
> here is the bug link which i raised :
> http://bugzilla.kernel.org/show_bug.cgi?id=11317
>

I added comments to the bug, but:

[root@e326 sbin]# mount
...
/dev/mapper/my_volg-vol01 on /mnt type ext4dev (rw)

[root@e326 sbin]# umount /mnt/tmpmount/

[root@e326 sbin]# df -h
(unfortunately current size of ext4 fs is not shown)

First you slice off the end of the block device:

[root@e326 sbin]# lvreduce -L 4G /dev/mynew_vg/vol01
  WARNING: Reducing active logical volume to 4.00 GB
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce vol01? [y/n]: y
  Reducing logical volume vol01 to 4.00 GB
  Logical volume vol01 successfully resized

(bells should be going off here!)

*then* you try to shrink the fs:

[root@e326 sbin]# ./resize2fs /dev/mynew_vg/vol01
resize2fs 1.41-WIP (17-Jun-2008)
Please run 'e2fsck -f /dev/mynew_vg/vol01' first.

and it finds that your block device is smaller than your fs:

[root@e326 sbin]# ./e2fsck -f /dev/mynew_vg/vol01
e2fsck 1.41-WIP (17-Jun-2008)
The filesystem size (according to the superblock) is 11304960 blocks
The physical size of the device is 4194304 blocks

You need to resize the fs, then resize the block device it's on.

This looks like user error to me.

-Eric
