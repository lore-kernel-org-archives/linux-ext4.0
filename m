From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Thu, 28 Jul 2011 01:40:48 +0900 (JST)
Message-ID: <134141.91415.qm@web4210.mail.ogk.yahoo.co.jp>
References: <20110727012139.GB19851@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4210.mail.ogk.yahoo.co.jp ([124.83.212.30]:27640 "HELO
	web4210.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753572Ab1G0Qku convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Jul 2011 12:40:50 -0400
In-Reply-To: <20110727012139.GB19851@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > The flash will then contain _random_ data in the non-used blocks.
> > That is not a problem, right?
> 
> Nope.  So long as the previously written (random) data on the card
> doesn't contain anything security sensitive.

I understood.

> > Although I have very small amount of files in my 4G image,
> > I see that the image has almost no zero-filled blocks.
> > Is that normal for ext4?
> 
> It depends on how you created the image.

I create the image like this:

dd if=/dev/zero of=a.img bs=4096 count=1048576
mkfs.ext4 a.img
mount -t ext4 -o loop a.img /mnt
cp -a /foo/* /mnt/
umount /mnt

> > Can zerofree.c recognize them as non-used blocks?
> 
> Yes, it uses the block allocation bitmaps to understand what is used
> and non-used.

Great.

Thanks
Round
