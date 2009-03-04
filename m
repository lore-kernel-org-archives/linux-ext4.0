From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Tue, 03 Mar 2009 18:43:39 -0600
Message-ID: <49ADCEBB.6080904@redhat.com>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr> <49ADBB03.9070303@redhat.com> <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, kzak@redhat.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48295 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZCDAnp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Mar 2009 19:43:45 -0500
In-Reply-To: <alpine.LSU.2.00.0903040125410.12894@fbirervta.pbzchgretzou.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-03-04 00:19, Eric Sandeen wrote:
>>> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
>>> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
>>> would mean the default for -i is 16384. 
>> That's right, look in /etc/mke2fs.conf:
>>
>> [defaults]
>>        base_features =
>> sparse_super,filetype,resize_inode,dir_index,ext_attr
>>        blocksize = 4096
>>        inode_size = 256
>>        inode_ratio = 16384
> 
> Interesting - thanks for the hint.
> 
>>> Besides me finding 16384 a 
>>> little unreasonable (XFS offers 2M inodes by default), 
>> XFS is a totally different beast, because it dynamically allocates
>> inodes.  It doesn't really offer *anything* by default.
>>
>> Which part of a 16384-data-bytes-to-inode-count ratio do you find
>> unreasonable?  Do you find it unreasonably high, or unreasonably low?
> 
> I think it's a bit too high, causing the amount of usable inodes
> to be a bit too low. 

When we doubled the size of inodes by default, we halved the count.  I
also have a sneaking suspicion that it may be too low for some
scenarios, but probably ok for most.

>>> the big 
>>> point is that the mke2fs manpage (belonging to util-linux, hence Cc) 
>> not so much:
>> $ rpm -qf /usr/share/man/man8/mke2fs.8.gz
>> e2fsprogs-1.41.3-2.fc10.x86_64
> 
> Sorry, I had looked for man8/mkfs.ext2.8.gz. I am not quite sure
> what makes some developers deviate(*) from the mkfs.$name/fsck.$name
> scheme ;-)

$ rpm -qf /usr/share/man/man8/mkfs.ext2.8.gz
e2fsprogs-1.41.3-2.fc10.x86_64

:)

> (*) e2, reiser(3), dosfs
> 
>>> does not mention this 16384 default.
>>> Hope this can be addressed.
>> You could send a patch :)
> 
> parent b2ca48f40eb33bd86b8d53d4373e7fce96bced4a (v1.41.4)
> commit ca28058c4004ceaa42edeb6ba61bc2aa53d7c03d
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Mar 4 01:36:09 2009 +0100
> 
> doc: mention default for mke2fs -i

thanks :)  (up to Ted now)

-Eric
