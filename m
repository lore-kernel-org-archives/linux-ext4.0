From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH V2] mke2fs: account for physical as well as logical sector
 size
Date: Tue, 09 Feb 2010 16:23:30 -0600
Message-ID: <4B71E062.9000203@redhat.com>
References: <4B7090B7.4060708@redhat.com> <4B70914B.3000102@redhat.com> <20100209222155.GB739@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab0BIWXg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Feb 2010 17:23:36 -0500
In-Reply-To: <20100209222155.GB739@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tytso@mit.edu wrote:
> On Mon, Feb 08, 2010 at 04:33:47PM -0600, Eric Sandeen wrote:
>> Some devices, notably 4k sector drives, may have a 512 logical
>> sector size, mapped onto a 4k physical sector size.
>>
>> When mke2fs is ratcheting down the blocksize for small filesystems,
>> or when a blocksize is specified on the commandline, we should not
>> willingly go below the physical sector size of the device.
>>
>> When a blocksize is specified, we -must- not go below
>> the logical sector size of the device.
>>
>> Add a new library function, ext2fs_get_device_phys_sectsize()
>> to get the physical sector size if possible, and adjust the
>> logic in mke2fs to enforce the above rules.
> 
> Was this something you think is worth trying to slip into 1.41.10?
> 
> Just checking... my default is to defer this unless you think its
> especially important.
> 
> 						- Ted


I'm inclined to defer it.  I can get it in as a patch if we need to.

I'd meant to send it earlier but well, you know ... ;)

Thanks,
-Eric
