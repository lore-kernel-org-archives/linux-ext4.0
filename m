From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: mkfs.ext4: high default -i value undocumented
Date: Mon, 09 Mar 2009 10:56:16 -0500
Message-ID: <49B53C20.1010206@redhat.com>
References: <alpine.LSU.2.00.0903040007470.12969@fbirervta.pbzchgretzou.qr>	<49ADBB03.9070303@redhat.com> <87r616vkzw.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-ext4@vger.kernel.org,
	kzak@redhat.com
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33453 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZCIP4h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Mar 2009 11:56:37 -0400
In-Reply-To: <87r616vkzw.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Goswin von Brederlow wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
> 
>> Jan Engelhardt wrote:
>>> Hi,
>>>
>>>
>>> Creating an ext4 filesystem on a 4 GB image file (to be loop-mounted 
>>> later) gives me 256K inodes. Choosing -i 4096 instead gives 1M, which 
>>> would mean the default for -i is 16384. 
>> That's right, look in /etc/mke2fs.conf:
>>
>> [defaults]
>>         base_features =
>> sparse_super,filetype,resize_inode,dir_index,ext_attr
>>         blocksize = 4096
>>         inode_size = 256
>>         inode_ratio = 16384
>>
>>> Besides me finding 16384 a 
>>> little unreasonable (XFS offers 2M inodes by default), 
>> XFS is a totally different beast, because it dynamically allocates
>> inodes.  It doesn't really offer *anything* by default.
>>
>> Which part of a 16384-data-bytes-to-inode-count ratio do you find
>> unreasonable?  Do you find it unreasonably high, or unreasonably low?
> 
> Too high for 4G, to low for 6 TiB.

I think it's hard to make a blanket statement like that; it depends very
much on the average size of the files on the fs.

The only thing that makes it too high or too low is whether the average
file size is significantly different than 16k, really (with the caveat
that we should bias towards overprovisioning vs. underprovisioning, by
default)

-Eric

> MfG
>         Goswin

