From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 3 Aug 2011 11:40:09 +0300
Message-ID: <CAOQ4uxjaAmJ6acCBNUtKW2th-+k8vXfdX7gsb-W_sFvj10-rXg@mail.gmail.com>
References: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
	<20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <aedilger@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36889 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1HCIkK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 04:40:10 -0400
Received: by wwe5 with SMTP id 5so593783wwe.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 Aug 2011 01:40:09 -0700 (PDT)
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
> Will things go wrong if I flash this 1G image to my eMMC
> partition (without using Yongqiang's new 64bit resize patches)?
> I need to understand whether Yongqiang's patch is absolutely
> necessary for this purpose or just a good thing to have.
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

You are welcome ;-)
https://raw.github.com/amir73il/e2fsprogs-snapshots/next4-stable/contrib/uninit_bg.c


so after resize2fs to 4G, you need to umount the image and run:

amir@qalab:~$ gcc -o uninit_bg -lext2fs uninit_bg.c
amir@qalab:~$ uninit_bg -f a.img 8
uninit_bg: uninitializing filesystem a.img groups [8..31]
uninit_bg: found 514 used blocks in group 8!
uninit_bg: found super block backup in group 9!
uninit_bg: found 579 used blocks in group 9!
uninit_bg: found 514 used blocks in group 10!
uninit_bg: found 514 used blocks in group 11!
uninit_bg: found 514 used blocks in group 12!
uninit_bg: found 514 used blocks in group 13!
uninit_bg: found 514 used blocks in group 14!
uninit_bg: found 514 used blocks in group 15!
uninit_bg: found 514 used blocks in group 16!
uninit_bg: found 514 used blocks in group 17!
uninit_bg: found 514 used blocks in group 18!
uninit_bg: found 514 used blocks in group 19!
uninit_bg: found 514 used blocks in group 20!
uninit_bg: found 514 used blocks in group 21!
uninit_bg: found 514 used blocks in group 22!
uninit_bg: found 514 used blocks in group 23!
uninit_bg: found 514 used blocks in group 24!
uninit_bg: found super block backup in group 25!
uninit_bg: found 579 used blocks in group 25!
uninit_bg: found 514 used blocks in group 26!
uninit_bg: found super block backup in group 27!
uninit_bg: found 579 used blocks in group 27!
uninit_bg: found 514 used blocks in group 28!
uninit_bg: found 514 used blocks in group 29!
uninit_bg: found 514 used blocks in group 30!
uninit_bg: found 514 used blocks in group 31!

now you have an fs you can truncate to 1G.
fsck will complain about one small thing.
the complian is not relevant for your use case,
because you don't intent to resize that fs again
and the last group is full if you are using round size like 4G.

amir@qalab:~$ truncate -s 1G a.img
amir@qalab:~$ truncate -s 4G a.img
amir@qalab:~$ e2fsck -nf a.img
e2fsck 1.41.14 (22-Dec-2010)
Last group block bitmap uninitialized.  Fix? no

Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
a.img: 2204/262144 files (0.3% non-contiguous), 86720/1048576 blocks



Amir.
