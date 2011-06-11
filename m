From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [BUG] ext4 timestamps corruption
Date: Sat, 11 Jun 2011 10:48:44 -0600
Message-ID: <3BB3CFE7-BD50-4123-A1C8-D3FDAAD184DA@gmail.com>
References: <4DF1D57C.3030107@rs.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Tso , ext4 development" <tytso@mit.edu>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:49456 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab1FKSEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Jun 2011 14:04:51 -0400
In-Reply-To: <4DF1D57C.3030107@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-10, at 2:27 AM, Akira Fujita <a-fujita@rs.jp.nec.com> wrote:
> 
> Officially, ext4 can handle its timestamps until 2514
> with 32bit entries plus EPOCH_BIT (2bits).
> But when timestamps values use 32+ bit
> (e.g. 2038-01-19 9:14:08 0x0000000080000000),
> we can get corrupted values.
> Because sign bit is overwritten by transferring value
> between kernel space and user space.
> 
> This can be happened with kernel 3.0.0-rc2 (Also older kernel)
> on x86_64.
> 
> # This issue is already on Bugzilla,
>  does anybody know this current status?
> https://bugzilla.kernel.org/show_bug.cgi?id=23732

I can't find any discussion about this bug in the list archives, but it is definitely a real problem.

At first glance, it appears that the correct solution is to shift the high
bits in the extra time by only 31 bits.

As stated in the posting, it makes sense to keep the range -2^31 - +2^33
for maximum usability. I don't think there is any value to store more
negative times.

To be honest I also don't think there is any value to even keeping negative
timestamps (before 1970) since this is about storing file creation or
modification times and I don't think any files with real creation dates
before 1970 are used anywhere.

Either way I expect the time range to be sufficient, once the bug is fixed.

> Reproduce steps are as follows:
> # System time is set to UTC.
> 
> # mount -t ext4 /dev/sda8 /mnt/mp1
> 
> # touch -t 203801190314.08 /mnt/mp1/FILE
> 
> # umount /mnt/mp1
> # mount -t ext4 /dev/sda8 /mnt/mp1
> 
> # stat /mnt/mp1/FILE
>  File: `/mnt/mp1/FILE'
>  Size: 0             Blocks: 0          IO Block: 4096   regular empty file
> Device: 808h/2056d    Inode: 12          Links: 1
> Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 1901-12-13 20:45:52.000000000 +0000       <-----
> Modify: 1901-12-13 20:45:52.000000000 +0000       <-----
> Change: 2011-06-10 03:57:39.595385951 +0100
> Birth: -

Hmm, interesting, I wonder how stat is expecting to get the "Birth" time from
the kernel?  We have the crtime in ext4 inodes, so we could be returning it. 

Cheers, Andreas