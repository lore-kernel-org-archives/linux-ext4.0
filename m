From: drgreenthumb <thisisadrgreenthumb@gmail.com>
Subject: Re: [PATCH] e2fsprogs: Apple Darwin, fix case of device with not 512
 bytes block size
Date: Mon, 20 Mar 2017 23:31:36 +0300
Message-ID: <7c41c86c-a1da-483a-dcd1-f53dc6fe20a8@gmail.com>
References: <20170319192926.GA3509@localhost.localdomain>
 <20170319204503.kedk2x35xvceqocj@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:32890 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932158AbdCTU01 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Mar 2017 16:26:27 -0400
Received: by mail-lf0-f66.google.com with SMTP id r36so11422978lfi.0
        for <linux-ext4@vger.kernel.org>; Mon, 20 Mar 2017 13:26:25 -0700 (PDT)
In-Reply-To: <20170319204503.kedk2x35xvceqocj@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/19/2017 11:45 PM, Theodore Ts'o wrote:
> Thanks for the patch.  Can you tell me how far back support for
> DKIOCGETBLOCKSIZE goes?  i.e., is it worth adding a fallback if
> DKIOCGETBLOCKSIZE is not available?  I suppose in the worst case we
> can fall back to using a binary search to find size of the device.

I checked that DKIOCGETBLOCKSIZE and DKIOCGETBLOCKCOUNT are both
available in file xnu/bsd/sys/disk.h from version 10.1 to 10.12.

> Also, could I perhaps ask you to take a look at
> lib/ext2fs/getsectsize.c while you are at it?  Does Mac OS X have
> support for DIOCGSECTORSIZE, and how does this related to
> DKIOCGETBLOCKSIZE?  Do you know what Mac OS X's alignment restrictions
> are for Direct I/O?

There is no definition of DIOCGSECTORSIZE for Mac OS X.
Seems like, it exist only for FreeBSD.
Not sure about alignment restriction for Direct I/O,
but for for Intel based Mac's the 4k page size will have place.

> Many thanks for helping me improve Apple Darwin support for e2fsprogs!  :-)
>
>      	    		   	   - Ted
>
> On Sun, Mar 19, 2017 at 10:29:26PM +0300, Fedor Uporov wrote:
>> Signed-off-by: Fedor Uporov <thisisadrgreenthumb@gmail.com>
>> ---
>>  lib/blkid/getsize.c  | 11 +++++++----
>>  lib/ext2fs/getsize.c |  9 ++++++---
>>  2 files changed, 13 insertions(+), 7 deletions(-)
>>
>> diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
>> index 8e8eb4c..3d26338 100644
>> --- a/lib/blkid/getsize.c
>> +++ b/lib/blkid/getsize.c
>> @@ -78,12 +78,15 @@ blkid_loff_t blkid_get_dev_size(int fd)
>>  	unsigned long long size64;
>>  	blkid_loff_t high, low;
>>
>> -#ifdef DKIOCGETBLOCKCOUNT	/* For Apple Darwin */
>> -	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0) {
>> +#if defined DKIOCGETBLOCKCOUNT && defined DKIOCGETBLOCKSIZE	/* For Apple Darwin */
>> +	unsigned int size;
>> +
>> +	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0 &&
>> +	    ioctl(fd, DKIOCGETBLOCKSIZE, &size) >= 0) {
>>  		if (sizeof(blkid_loff_t) < sizeof(unsigned long long) &&
>> -		    (size64 << 9) > 0xFFFFFFFF)
>> +		    (size64 * size) > 0xFFFFFFFF)
>>  			return 0; /* EFBIG */
>> -		return (blkid_loff_t)size64 << 9;
>> +		return (blkid_loff_t)size64 * size;
>>  	}
>>  #endif
>>
>> diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
>> index 89c33d4..68480c6 100644
>> --- a/lib/ext2fs/getsize.c
>> +++ b/lib/ext2fs/getsize.c
>> @@ -151,9 +151,12 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
>>  	if (fd < 0)
>>  		return errno;
>>
>> -#ifdef DKIOCGETBLOCKCOUNT	/* For Apple Darwin */
>> -	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0) {
>> -		*retblocks = size64 / (blocksize / 512);
>> +#if defined DKIOCGETBLOCKCOUNT && defined DKIOCGETBLOCKSIZE	/* For Apple Darwin */
>> +	unsigned int size;
>> +
>> +	if (ioctl(fd, DKIOCGETBLOCKCOUNT, &size64) >= 0 &&
>> +	    ioctl(fd, DKIOCGETBLOCKSIZE, &size) >= 0) {
>> +		*retblocks = size64 * size / blocksize;
>>  		goto out;
>>  	}
>>  #endif
>> --
>> 2.1.4
>>
