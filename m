From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 26 Jul 2011 09:39:58 +0800
Message-ID: <CAGBYx2Y_rOwid5HBa_qTFRxsgW_2ukMjzEUrLt6cCDMpG0WDQg@mail.gmail.com>
References: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
	<20110725181043.GK3469@thunk.org>
	<CAOQ4uxgh-T5f8e2McZQcFW3e7oBV+iDVGWBW7oXnv5oztk4z0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Round Robinjp <roundrobinjp@yahoo.co.jp>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56498 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1GZBj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 21:39:59 -0400
Received: by pzk37 with SMTP id 37so9450004pzk.1
        for <linux-ext4@vger.kernel.org>; Mon, 25 Jul 2011 18:39:58 -0700 (PDT)
In-Reply-To: <CAOQ4uxgh-T5f8e2McZQcFW3e7oBV+iDVGWBW7oXnv5oztk4z0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 26, 2011 at 2:36 AM, Amir Goldstein <amir73il@gmail.com> wr=
ote:
> On Mon, Jul 25, 2011 at 9:10 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Sat, Jul 23, 2011 at 12:49:28AM +0900, Round Robinjp wrote:
>>> Hi
>>>
>>> I have a question regarding making ext4 image for
>>> large eMMC partition.
>>>
>>> We have a 4G partition in our embedded device
>>> in which we want to use ext4 filesystem.
>>> But for that we have to create a 4G image.
>>> flashing this 4G image to the eMMC takes a long
>>> time. Is there any way to reduce this time?
>>>
>>> For vfat, you can truncate the image leaving only
>>> non zero-filled blocks which makes the image very
>>> short and the time for flashing is reduced.
>>> Is something similar to that possible for ext4?
>>
>> OK, so it's not obvious what problem you are trying to ask here.
>>
>> It sounds like Andreas was trying to help you solve the problem of
>> minimizing the number of blocks written by mke2fs.
>>
>> I'm guessing the problem is you've already created a file system ima=
ge
>> which is 4G, and for which a large number of the blocks are not used=
,
>> and you're trying to optimize the amount of time it takes to flash t=
he
>> image. =A0Is that right?
>>
>
> I am going to make a 3rd guess and we will see who was closest ;-)
> My guess is that Round wan't a "short" image, just like he wrote.
> vfat image can simply be truncated, because all initial blocks are at=
 the
> beginning of the partition.
>
> One could truncate the result of an ext4 image to quite less than 4G,
> for example, if flex_bg is set to 32, all bitmaps are at the block gr=
oup 0.
> copies of the super block can be discarded, since one has the copy in
> the image file.
>
> The only important piece of information, not in the beginning of the =
partition
> is the super block of the journal, which is usually in the middle of =
the fs,
> so one needs do some tricks to allocate the journal from group 0.
> Is there a mke2fs option to do that?
Now the fs is clean, so we can delete journal.  After the image is
flashed to the eMMC, we can add journal again.  I think tune2fs can
add and delete journal.  Am I rgiht?

Yongqiang.
>
> All-in-all, I think it should be easy to prepare a 4G image that coul=
d
> be truncated
> to one group (128M).
>
> Amir.
>
>> The way to do that is to use a program like zerofree.c (google it, o=
r
>> see attached) to make sure the non-used blocks are zero-filled, and
>> then use a program like make-sparse.c (see the e2fsprogs sources, in
>> the contrib directory) to only write the non-zero blocks to the flas=
h
>> device.
>>
>> Regards,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
