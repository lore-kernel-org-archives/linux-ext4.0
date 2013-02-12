From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: Re: ext4: Used block count in df
Date: Tue, 12 Feb 2013 11:44:41 +0530
Message-ID: <CANBXnMkKA7qjMoO-yEGhbyKYQMRzvVA+GExg_KGCWPEHNVnyDQ@mail.gmail.com>
References: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com>
	<5113DB2D.4000305@redhat.com>
	<CANBXnMmbEBgN5j2UvbYvznO9nUrXkmi4m8_xnqytPi3=zSGOPg@mail.gmail.com>
	<51192B14.4030301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:53785 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3BLGOn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2013 01:14:43 -0500
In-Reply-To: <51192B14.4030301@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> My only point is, default ext4 statfs behavior is quite complicated, and it
> looks like you have found a bug related to the calculation of metadata overhead.

I see.
Where should I report this issue to get it confirm by developers?

> It should only be a reporting issue, and should not cause any runtime issues.

OK, I understand.

Thanks,
Adil

On Mon, Feb 11, 2013 at 11:02 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/11/13 12:36 AM, Adil Mujeeb wrote:
>> Thanks Eric.
>>
>>>> I have an observation on EXT4 filesystem. I created filesystem of size
>>>> 1TB, 4TB, and 7TB and then checked the output of df command.
>>>
>>> Telling us which version of e2fsprogs and which kernel would be helpful,
>>> but:
>>
>> its 1.41.12.
>>
>>> It reserves blocks for the superuser (5% by default) and also uses a lot
>>> of blocks up-front for filesytem metadata - inode tables, block bitmaps,
>>> and the like.
>>
>> I also thinks so. But with this assumption, the number of 1KB blocks
>> used should increase as per filesystem size increase. No?
>>
>>>
>>> But what you are seeing here is this:
>>>
>>> It also defaults to "bsd df" which does not count filesystem
>>> metadata when telling you about the number of blocks used.  So in theory,
>>> a freshly made fs should actually tell you 0 blocks used, I think.
>>
>> Agree if "bsd df" assumes so.
>>
>>> Looking at the dumpe2fs output for the 4t file, I see:
>>>
>>> # dumpe2fs -h 4tfile-ext4 | grep -i block
>>> dumpe2fs 1.41.12 (17-May-2010)
>>> Block count:              1073741824
>>> Reserved block count:     53687091
>>> Free blocks:              1056843748
>>> ...
>>>
>>> and 1073741824-1056843748 is 16898076 4k blocks, or 67592304 1k blocks
>>> actually used.
>>>
>>> If we ask for "minix df" by mounting with -o minixdf which is true blocks used, we get:
>>>
>>> # df 4t-ext4/
>>> Filesystem           1K-blocks      Used Available Use% Mounted on
>>> /mnt/test2/mkfs-test/4tfile-ext4
>>>                      4294967296  67592304 4012626628   2% /mnt/test2/mkfs-test/4t-ext4
>>>
>>> I'd say this appears to be a slight inaccuracy in ext4_statfs, coupled with
>>> the strangeness of the "bsd df" reporting.  It is apparently miscalculating
>>> the filesystem metadata "overhead."
>>
>> In your example, dumpe2fs and minix df both are reporting same value, isn't it?
>>
>> I am still not able to understand why increasing the filesystem size
>> decreases used 1K block count :(
>> Am I missing some basic things here? Sorry if i am not able to catch
>> your point :(
>
> My only point is, default ext4 statfs behavior is quite complicated, and it
> looks like you have found a bug related to the calculation of metadata overhead.
>
> It should only be a reporting issue, and should not cause any runtime issues.
>
> Thanks,
> -Eric
>
>> Regards,
>> Adil
>
>
