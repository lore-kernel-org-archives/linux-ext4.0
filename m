From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: fiemap bugs on sparse files.
Date: Wed, 23 Feb 2011 17:34:41 +0800
Message-ID: <AANLkTikTet_Gw2kCQ8+j-qYVJgUc0dxKQ=kE295gcJR7@mail.gmail.com>
References: <1298409435-sup-2565@think>
	<AANLkTikMhTM6c1=ihMj0XOZD0VYVLoHOeoGV4_7qvN=b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f179.google.com ([209.85.215.179]:32929 "EHLO
	mail-ey0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049Ab1BWJen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 04:34:43 -0500
Received: by eyg5 with SMTP id 5so1236794eyg.10
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 01:34:41 -0800 (PST)
In-Reply-To: <AANLkTikMhTM6c1=ihMj0XOZD0VYVLoHOeoGV4_7qvN=b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 23, 2011 at 4:59 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> On Wed, Feb 23, 2011 at 5:18 AM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> [ resend, sorry if this is a dup ]
>>
>> Hi everyone,
>>
>> We've had reports on btrfs that cp is giving us files full of zeros
>> instead of actually copying them. =A0It was tracked down to a bug wi=
th
>> the btrfs fiemap implementation where it was returning holes for
>> delalloc ranges.
>>
>> Newer versions of cp are trusting fiemap to tell it where the holes
>> are, which does seem like a pretty neat trick.
>>
>> I decided to give xfs and ext4 a shot with a few tests cases too, xf=
s
>> passed with all the ones btrfs was getting wrong, and ext4 got the b=
asic
>> delalloc case right.
>>
>> # mkfs.ext4 /dev/xxx
>> # mount /dev/xxx /mnt
>> # dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1
>> # fiemap-test foo
>> ext: =A0 0 logical: [ =A0 =A0 =A0 0.. =A0 =A0 255] phys: =A0 =A0 =A0=
 =A00.. =A0 =A0 255 flags: 0x007 tot: 256
>>
>> Horray! =A0But once we throw a hole in, things go bad:
>>
>> # mkfs.ext4 /dev/xxx
>> # mount /dev/xxx /mnt
>> # dd if=3D/dev/zero of=3D/mnt/foo bs=3D1M count=3D1 seek=3D1
>> # fiemap-test foo
>> < no output >
> Actually, there is no extent in extent tree now, so
> ext4_ext_walk_space() will pass ext4_ext_fiemap_cb() a variable of
> struct ext4_ext_cache with the requested length. But in
> ext4_ext_fiemap_cb() just the paging contains start block is got
> via find_get_page(), if find_get_page() return null,
> ext4_ext_fiemap_cb() =A0thinks the whole request range is empty and i=
t
> returns request range.
>
> In 1st case, find_get_page() will succeed.
>
> It seems that we should get no. of pages in page cache if
> find_get_page() fails, and correct the range to be returned.
We can call find_get_pages() with nr_pages=3D1 instead. And we can regu=
late
the range with page->index if it is not the the paging contains start b=
lock.


>
> Right?
>
> If right I will send a patch.
>
>>
>> We've got a delalloc extent after the hole and ext4 fiemap didn't fi=
nd
>> it. =A0If I run sync to kick the delalloc out:
>>
>> # sync
>> # fiemap-test foo
>> ext: =A0 0 logical: [ =A0 =A0 256.. =A0 =A0 511] phys: =A0 =A034048.=
=2E =A0 34303 flags: 0x001 tot: 256
>
> Now, there is a extent in extent tree at least. and
> ext4_ext_walk_space() will regulate the request range to be passed to
> ext4_ext_fiemap_cb().
>>
>> fiemap-test is sitting in my /usr/local/bin, and I have no idea how =
it
>> got there. =A0It's full of pretty comments so I know it isn't mine, =
but
>> you can grab it here:
>>
>> http://oss.oracle.com/~mason/fiemap-test.c
>>
>> xfsqa has a fiemap program too.
>>
>> -chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
