From: Ted Ts'o <tytso@mit.edu>
Subject: Re: flashing large eMMC partitions with ext4
Date: Mon, 1 Aug 2011 14:57:45 -0400
Message-ID: <20110801185745.GG21388@thunk.org>
References: <CAOQ4uxh6a1qoZZs2SVxxrKfcd5q0vKkpCMDQ-X5eur3Tg07FXg@mail.gmail.com>
 <632658.72291.qm@web4207.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Goldstein Amir <amir73il@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50322 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab1HAS5v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Aug 2011 14:57:51 -0400
Content-Disposition: inline
In-Reply-To: <632658.72291.qm@web4207.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 02, 2011 at 02:43:20AM +0900, Round Robinjp wrote:
> > I meant using a newer version of resize2fs (which you do not have),
> 
> I have now corrected this and other mistakes.
> But when I mount the image after finally extending
> to 4G, the df still shows the size as 1G.
> Am I still doing something wrong?

This is nowhere near correct.  My first recommendation is to please
read the man pages so you understand what is happening; it's pretty
clear to me that you're following some other people's suggestions
without really understanding what each step does, and you're doing
some things which they were suggesting when you are creating the
small, compressed image, and what you should do after you flash the
image onto the disk.

Let me try this with a bit more more explicitly in hopes that it is
helpful.

1)  Create the file system and mount it.

    dd if=/dev/zero of=a.img bs=1G count=4
    mke2fs -t ext4 -O ^has_journal a.img
    mount -o loop a.img /mnt

2) Populate the image with your content.  (I'll leave that up to you.)

3) Unmount the file system and compress it to its minimum size.

   umount /mnt
   resize2fs -M a.img

4)  Save a.img into your source tree, or whatever.

5) For each system that you want to install this on, assuming that
	/dev/mmc is your device with the mmc:

   dd if=a.img of=/dev/mmc bs=32k
   resize2fs /dev/mmc
   tune2fs -O has_journal /dev/mmc

You're done!

Before you try this I recommend you read through each man pages for
mke2fs, resize2fs, tune2fs, and dd so you completely understand what
all of the options are, and why it works.

					- Ted
