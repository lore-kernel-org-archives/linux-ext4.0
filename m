From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: Re: ext4: Used block count in df
Date: Mon, 11 Feb 2013 12:06:57 +0530
Message-ID: <CANBXnMmbEBgN5j2UvbYvznO9nUrXkmi4m8_xnqytPi3=zSGOPg@mail.gmail.com>
References: <CANBXnM=H0ghqzQ5aJ_O+1C_sMJ850LQ9TOHLncOYkCKVSnUrAw@mail.gmail.com>
	<5113DB2D.4000305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:48350 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3BKGhA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2013 01:37:00 -0500
In-Reply-To: <5113DB2D.4000305@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks Eric.

>> I have an observation on EXT4 filesystem. I created filesystem of size
>> 1TB, 4TB, and 7TB and then checked the output of df command.
>
> Telling us which version of e2fsprogs and which kernel would be helpful,
> but:

its 1.41.12.

> It reserves blocks for the superuser (5% by default) and also uses a lot
> of blocks up-front for filesytem metadata - inode tables, block bitmaps,
> and the like.

I also thinks so. But with this assumption, the number of 1KB blocks
used should increase as per filesystem size increase. No?

>
> But what you are seeing here is this:
>
> It also defaults to "bsd df" which does not count filesystem
> metadata when telling you about the number of blocks used.  So in theory,
> a freshly made fs should actually tell you 0 blocks used, I think.

Agree if "bsd df" assumes so.

> Looking at the dumpe2fs output for the 4t file, I see:
>
> # dumpe2fs -h 4tfile-ext4 | grep -i block
> dumpe2fs 1.41.12 (17-May-2010)
> Block count:              1073741824
> Reserved block count:     53687091
> Free blocks:              1056843748
> ...
>
> and 1073741824-1056843748 is 16898076 4k blocks, or 67592304 1k blocks
> actually used.
>
> If we ask for "minix df" by mounting with -o minixdf which is true blocks used, we get:
>
> # df 4t-ext4/
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /mnt/test2/mkfs-test/4tfile-ext4
>                      4294967296  67592304 4012626628   2% /mnt/test2/mkfs-test/4t-ext4
>
> I'd say this appears to be a slight inaccuracy in ext4_statfs, coupled with
> the strangeness of the "bsd df" reporting.  It is apparently miscalculating
> the filesystem metadata "overhead."

In your example, dumpe2fs and minix df both are reporting same value, isn't it?

I am still not able to understand why increasing the filesystem size
decreases used 1K block count :(
Am I missing some basic things here? Sorry if i am not able to catch
your point :(

Regards,
Adil

On Thu, Feb 7, 2013 at 10:19 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 2/7/13 12:39 AM, Adil Mujeeb wrote:
>> Hi,
>>
>> I have an observation on EXT4 filesystem. I created filesystem of size
>> 1TB, 4TB, and 7TB and then checked the output of df command.
>
> Telling us which version of e2fsprogs and which kernel would be helpful,
> but:
>
>> df command showed the number of 1KB blocks used. The result was:
>> 1TB: 204056
>> 4TB: 198680
>> 7TB: 181784
>
> extN makes df complicated in several ways.
>
> It reserves blocks for the superuser (5% by default) and also uses a lot
> of blocks up-front for filesytem metadata - inode tables, block bitmaps,
> and the like.
>
> But what you are seeing here is this:
>
> It also defaults to "bsd df" which does not count filesystem
> metadata when telling you about the number of blocks used.  So in theory,
> a freshly made fs should actually tell you 0 blocks used, I think.
>
> Looking at the dumpe2fs output for the 4t file, I see:
>
> # dumpe2fs -h 4tfile-ext4 | grep -i block
> dumpe2fs 1.41.12 (17-May-2010)
> Block count:              1073741824
> Reserved block count:     53687091
> Free blocks:              1056843748
> ...
>
> and 1073741824-1056843748 is 16898076 4k blocks, or 67592304 1k blocks
> actually used.
>
> If we ask for "minix df" by mounting with -o minixdf which is true blocks used, we get:
>
> # df 4t-ext4/
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /mnt/test2/mkfs-test/4tfile-ext4
>                      4294967296  67592304 4012626628   2% /mnt/test2/mkfs-test/4t-ext4
>
> I'd say this appears to be a slight inaccuracy in ext4_statfs, coupled with
> the strangeness of the "bsd df" reporting.  It is apparently miscalculating
> the filesystem metadata "overhead."
>
>> I performed the same on XFS and the result was:
>> 1TB: 32928
>> 4TB: 32928
>> 7TB: 33024
>
> XFS is straightforward; blocks used for metadata count as "used."
> Every other block is free and available.
> No fiddling around, just like with the minixdf mount option for extN.
>
> -Eric
>
>> EXT4 result shows with increasing filesystem size, the number of used
>> blocks decreased. I dont have idea about low level implementation but
>> I am curious why it is so?
>>
>> Thanks.
>>
>> Regards,
>> Adil
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
