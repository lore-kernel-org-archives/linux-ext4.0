From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Wed, 27 Jul 2011 02:38:19 +0900 (JST)
Message-ID: <20110726173822.24068.qmail@web4211.mail.ogk.yahoo.co.jp>
References: <20110725181043.GK3469@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4211.mail.ogk.yahoo.co.jp ([124.83.212.31]:37506 "HELO
	web4211.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751443Ab1GZRiY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 13:38:24 -0400
In-Reply-To: <20110725181043.GK3469@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I'm guessing the problem is you've already created a file system image
> which is 4G, and for which a large number of the blocks are not used,
> and you're trying to optimize the amount of time it takes to flash the
> image.  Is that right?

Yes, exactly.

> The way to do that is to use a program like zerofree.c (google it, or
> see attached) to make sure the non-used blocks are zero-filled, and
> then use a program like make-sparse.c (see the e2fsprogs sources, in
> the contrib directory) to only write the non-zero blocks to the flash
> device.

I see.
The flash will then contain _random_ data in the non-used blocks.
That is not a problem, right?

One more thing.
Although I have very small amount of files in my 4G image,
I see that the image has almost no zero-filled blocks.
Is that normal for ext4?
Can zerofree.c recognize them as non-used blocks?

Many thanks to those who replied.
Round
