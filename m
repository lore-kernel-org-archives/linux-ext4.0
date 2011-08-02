From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 2 Aug 2011 20:44:17 +0300
Message-ID: <CAOQ4uxiR7eVbb8_i9ZvM7X1KqaBNs1kx+nU75pTgFjbTjH+S-Q@mail.gmail.com>
References: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
	<20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <aedilger@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1HBRoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Aug 2011 13:44:19 -0400
Received: by wwe5 with SMTP id 5so13383wwe.1
        for <linux-ext4@vger.kernel.org>; Tue, 02 Aug 2011 10:44:18 -0700 (PDT)
In-Reply-To: <20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 2, 2011 at 7:07 PM, Round Robinjp <roundrobinjp@yahoo.co.jp> wrote:
> Amir
>
>> > But after extending to 4G, e2fsck makes some complain.
>> > I guess this is not expected behaviour, is it?
>> >
>>
>> it is expected when you use the current resize2fs,
>> which does not respect the flex_bg layout, so new group block bitmaps
>> are allocated beyond the 1G border and initialized.
>
> So that means I have thrown away some important part of
> the filesystem when I did truncate -s 1G, isn't it?

It's not "so important" because it contains information that can be
recovered, so fsck -fp can easily fix that.
Do you have e2fsck on your embedded system?
Can you run it on first boot?

> Will things go wrong if I flash this 1G image to my eMMC
> partition (without using Yongqiang's new 64bit resize patches)?

I think the kernel will shout at you, mark the fs with error_fs flag
and recommend that you run fsck.
This will happen when you write files to the extended 3G.

> I need to understand whether Yongqiang's patch is absolutely
> necessary for this purpose or just a good thing to have.

if you don't use it, you need to use the other method I mentioned using debugfs
or run fsck on the MMC after you flashed the short image.

>
>> if you use Yongqiang's new 64bit resize patches, the final fsck won't complain.
>> unfortunately for you, those patches have not been merged to the kernel yet,
>> so you will have to either build your own ext4 module or wait at least until
>> kernel 3.2 is released to have it in mainline.
>
> As said above.
>
>> It is actually quite simple to fix the 1G image, so it will pass fsck
>> after truncate -s 4G.
>> All it takes it setting the BLOCK_UNINIT flag in groups 8-31
>> this should be possible to do with debugfs (or write a small tool to do it).
>> if I have time, it will try it myself and post the instructions.
>
> OK, thanks in advance.
>
> Best Regards
> Round
>
