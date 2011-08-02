From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 3 Aug 2011 01:07:08 +0900 (JST)
Message-ID: <20110802160715.3069.qmail@web4212.mail.ogk.yahoo.co.jp>
References: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Andreas Dilger <aedilger@gmail.com>, Ted Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Goldstein Amir <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4212.mail.ogk.yahoo.co.jp ([124.83.212.32]:23928 "HELO
	web4212.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754365Ab1HBQHU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Aug 2011 12:07:20 -0400
In-Reply-To: <CAOQ4uxiFaEvC0WpZH_bVp-Thhv0TMADNabd2pcr9pENfufDLoA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Amir

> > But after extending to 4G, e2fsck makes some complain.
> > I guess this is not expected behaviour, is it?
> >
> 
> it is expected when you use the current resize2fs,
> which does not respect the flex_bg layout, so new group block bitmaps
> are allocated beyond the 1G border and initialized.

So that means I have thrown away some important part of
the filesystem when I did truncate -s 1G, isn't it?
Will things go wrong if I flash this 1G image to my eMMC
partition (without using Yongqiang's new 64bit resize patches)?
I need to understand whether Yongqiang's patch is absolutely
necessary for this purpose or just a good thing to have.

> if you use Yongqiang's new 64bit resize patches, the final fsck won't complain.
> unfortunately for you, those patches have not been merged to the kernel yet,
> so you will have to either build your own ext4 module or wait at least until
> kernel 3.2 is released to have it in mainline.

As said above.

> It is actually quite simple to fix the 1G image, so it will pass fsck
> after truncate -s 4G.
> All it takes it setting the BLOCK_UNINIT flag in groups 8-31
> this should be possible to do with debugfs (or write a small tool to do it).
> if I have time, it will try it myself and post the instructions.

OK, thanks in advance.

Best Regards
Round
