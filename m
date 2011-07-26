From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: flashing large eMMC partitions with ext4
Date: Tue, 26 Jul 2011 00:13:54 -0400
Message-ID: <2F7A8BEF-0AF3-4642-A8BD-CDF30AB3917F@mit.edu>
References: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp> <20110725181043.GK3469@thunk.org> <CAOQ4uxgh-T5f8e2McZQcFW3e7oBV+iDVGWBW7oXnv5oztk4z0Q@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Round Robinjp <roundrobinjp@yahoo.co.jp>,
	linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:49958 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab1GZEN7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Jul 2011 00:13:59 -0400
In-Reply-To: <CAOQ4uxgh-T5f8e2McZQcFW3e7oBV+iDVGWBW7oXnv5oztk4z0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jul 25, 2011, at 2:36 PM, Amir Goldstein wrote:

> I am going to make a 3rd guess and we will see who was closest ;-)
> My guess is that Round wan't a "short" image, just like he wrote.
> vfat image can simply be truncated, because all initial blocks are at the
> beginning of the partition.

Sure, but why did he want a "short"/truncated image?  Because it's faster
to load onto the flash device for mass production, right?

If you can do that with a specialized tool that writes the necessary blocks 
and not the ones that are all zeros, it solves his high-level need.

> One could truncate the result of an ext4 image to quite less than 4G,
> for example, if flex_bg is set to 32, all bitmaps are at the block group 0.
> copies of the super block can be discarded, since one has the copy in
> the image file.

You could do that, but it's a lot more complicated, and you still need
to write a tool that determines the first block where it is safe to truncate
away the backup superblocks.  And you have to hack mke2fs, and use
special options to make sure the flex bg size is large enough so that
all of the block group descriptors are the beginning of the disk.

It's much simpler to use a sparse image and then use a special tool
to write the file system image onto the MMC device.   The approach
you outlined can work, but it's a lot more complicated and easy 
to mess up.

-- Ted

