From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Thu, 4 Aug 2011 00:15:41 +0900 (JST)
Message-ID: <921838.15127.qm@web4206.mail.ogk.yahoo.co.jp>
References: <20110802165757.GD2967@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Amir Goldstein <amir73il@gmail.com>,
	Dilger Andreas <aedilger@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4206.mail.ogk.yahoo.co.jp ([124.83.212.26]:28241 "HELO
	web4206.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754900Ab1HCPPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Aug 2011 11:15:43 -0400
In-Reply-To: <20110802165757.GD2967@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This is one of the reasons why I originally suggested using zero_free
> and make_sparse to write the file system image.  It's a much, much,
> MUCH simpler way of handling things, and it doesn't require resizing
> the file system image, using truncate (and making sure you truncate to
> the right size, etc.).
> 
> With the method Amir talked about, it matters whether or not the file
> system is mounted when you use resize2fs, whether you have the latest
> resize patches, etc., etc.

I am glad that I have several options in my list, and in fact
I have not yet excluded any of them. All methods have pros
and cons and I am trying to understand them.

In our environment, it is acceptable to do complicated things
at the stage of creating image. But it is strongly undesirable
to do any post processing at the time of mass production.
Although it is not impossible to add post processing, the problem
is it will require extra booting of each device at the factory.

Had it not been the case, the
"resize2fs -M a.img" + "resize2fs on the device"
would have been the ideal solution.

The reason I am trying Amir's method first is that it "may"
give me a zero-post-processing way. Also it does not require
our legacy mass production flash writer to be changed.

zero_free way is indeed simpler and does not require post
processing. The only problem is that we need to change to
a flash writer which supports writing from a sparse file.

Many thanks for taking interest.
Round
