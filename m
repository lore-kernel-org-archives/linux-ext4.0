From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 27 Jul 2011 21:05:57 +0300
Message-ID: <CAOQ4uxhVNporfaNJrR7Zt++4tVZjJiuUhKRkNB+CzFzTeFmzGw@mail.gmail.com>
References: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
	<5605A19B-0478-486F-9D95-5ADFA14F2140@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Round Robinjp <roundrobinjp@yahoo.co.jp>,
	"Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56327 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab1G0SF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jul 2011 14:05:58 -0400
Received: by wyg8 with SMTP id 8so1182273wyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 27 Jul 2011 11:05:57 -0700 (PDT)
In-Reply-To: <5605A19B-0478-486F-9D95-5ADFA14F2140@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 27, 2011 at 8:16 PM, Andreas Dilger <aedilger@gmail.com> wr=
ote:
> I still think that using resize2fs and removing/adding the journal pr=
ovides the clearest way to create a small image. The only drawback is t=
hat this needs some post-processing steps after the image is written, s=
o it may not be suitable for some workflows.
>

I must say this is a fun game to play :-)

I think it can be done without post processing.
If you know the estimated disk usage of the initial fs, say 1G:
1. mkfs a 1G ext4 fs with no journal, flex_bg=3D32, resize=3D4G
2. mount it and cp -a /foo/* /mnt/
3. use new online resize to resize fs to 4G (maintaining flex_bg layout=
)
4. add journal to mounted fs (.journal file should be allocated with go=
al 0??)

if my calculations are correct, the only blocks written beyond the 1G m=
ark
are the super block backup copies, so truncating the resulting image to=
 1G
won't do any damage - even fsck shouldn't complain.

I have a task in my queue to test Yongqiangs new resize patches
(not the series that was just merged - the next series).
When I get to it I will try to play this game and let you guys know if
it worked.

Amir.

> Cheers, Andreas
>
> On 2011-07-27, at 10:40 AM, Round Robinjp <roundrobinjp@yahoo.co.jp> =
wrote:
>
>>>> The flash will then contain _random_ data in the non-used blocks.
>>>> That is not a problem, right?
>>>
>>> Nope. =A0So long as the previously written (random) data on the car=
d
>>> doesn't contain anything security sensitive.
>>
>> I understood.
>>
>>>> Although I have very small amount of files in my 4G image,
>>>> I see that the image has almost no zero-filled blocks.
>>>> Is that normal for ext4?
>>>
>>> It depends on how you created the image.
>>
>> I create the image like this:
>>
>> dd if=3D/dev/zero of=3Da.img bs=3D4096 count=3D1048576
>> mkfs.ext4 a.img
>> mount -t ext4 -o loop a.img /mnt
>> cp -a /foo/* /mnt/
>> umount /mnt
>>
>>>> Can zerofree.c recognize them as non-used blocks?
>>>
>>> Yes, it uses the block allocation bitmaps to understand what is use=
d
>>> and non-used.
>>
>> Great.
>>
>> Thanks
>> Round
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
