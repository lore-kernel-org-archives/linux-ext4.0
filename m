From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 26 Jul 2011 01:34:06 +0900 (JST)
Message-ID: <20110725163406.33329.qmail@web4205.mail.ogk.yahoo.co.jp>
References: <419A2628-5AF6-4B32-85B8-BE1E2B159DFA@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dilger Andreas <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4205.mail.ogk.yahoo.co.jp ([124.83.212.25]:39669 "HELO
	web4205.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752043Ab1GYQeI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jul 2011 12:34:08 -0400
In-Reply-To: <419A2628-5AF6-4B32-85B8-BE1E2B159DFA@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Many Thanks for the reply.

In both the ways you have shown, the eMMC device needs
to be zeroed in advance. But so far as I know, writing
4G bytes of zeros and writing 4G bytes of real data has
no difference. So this does not solve the problem.
Please correct me if I am wrong.
Any other options?

Thanks
Robin


--- Andreas Dilger  wrote:
> If you can wipe the MMC device to be all-zero efficiently, then you can format it quickly with "mke2fs -E lazy_itable_init,lazy_journal_init ..." and restore from a tarball.
> 
> Alternately, Lukas recently added support for QCOW2 sparse image format, and it should be possible to restore this to the device efficiently, if it is zeroed in advance. I don't know if his code skips all-zero blocks in the image, but that should be possible to add fairly easily. 
> 
> Cheers, Andreas
> 
> On 2011-07-22, at 9:49 AM, Round Robinjp <roundrobinjp@yahoo.co.jp> wrote:
> 
> > Hi
> > 
> > I have a question regarding making ext4 image for
> > large eMMC partition.
> > 
> > We have a 4G partition in our embedded device
> > in which we want to use ext4 filesystem.
> > But for that we have to create a 4G image.
> > flashing this 4G image to the eMMC takes a long
> > time. Is there any way to reduce this time?
> > 
> > For vfat, you can truncate the image leaving only
> > non zero-filled blocks which makes the image very
> > short and the time for flashing is reduced.
> > Is something similar to that possible for ext4?
> > 
> > Thanks
> > Robin
