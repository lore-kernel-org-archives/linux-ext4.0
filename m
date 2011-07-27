From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 27 Jul 2011 11:16:39 -0600
Message-ID: <5605A19B-0478-486F-9D95-5ADFA14F2140@gmail.com>
References: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0 (iPhone Mail 8L1)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47537 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1G0RQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Jul 2011 13:16:49 -0400
Received: by pzk37 with SMTP id 37so3016841pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 27 Jul 2011 10:16:49 -0700 (PDT)
In-Reply-To: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I still think that using resize2fs and removing/adding the journal provides the clearest way to create a small image. The only drawback is that this needs some post-processing steps after the image is written, so it may not be suitable for some workflows. 

Cheers, Andreas

On 2011-07-27, at 10:40 AM, Round Robinjp <roundrobinjp@yahoo.co.jp> wrote:

>>> The flash will then contain _random_ data in the non-used blocks.
>>> That is not a problem, right?
>> 
>> Nope.  So long as the previously written (random) data on the card
>> doesn't contain anything security sensitive.
> 
> I understood.
> 
>>> Although I have very small amount of files in my 4G image,
>>> I see that the image has almost no zero-filled blocks.
>>> Is that normal for ext4?
>> 
>> It depends on how you created the image.
> 
> I create the image like this:
> 
> dd if=/dev/zero of=a.img bs=4096 count=1048576
> mkfs.ext4 a.img
> mount -t ext4 -o loop a.img /mnt
> cp -a /foo/* /mnt/
> umount /mnt
> 
>>> Can zerofree.c recognize them as non-used blocks?
>> 
>> Yes, it uses the block allocation bitmaps to understand what is used
>> and non-used.
> 
> Great.
> 
> Thanks
> Round
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
