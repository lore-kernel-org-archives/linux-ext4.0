From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: flashing large eMMC partitions with ext4
Date: Fri, 22 Jul 2011 10:35:20 -0600
Message-ID: <419A2628-5AF6-4B32-85B8-BE1E2B159DFA@gmail.com>
References: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61587 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1GVQe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Jul 2011 12:34:57 -0400
Received: by pzk37 with SMTP id 37so3832500pzk.1
        for <linux-ext4@vger.kernel.org>; Fri, 22 Jul 2011 09:34:56 -0700 (PDT)
In-Reply-To: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If you can wipe the MMC device to be all-zero efficiently, then you can format it quickly with "mke2fs -E lazy_itable_init,lazy_journal_init ..." and restore from a tarball.

Alternately, Lukas recently added support for QCOW2 sparse image format, and it should be possible to restore this to the device efficiently, if it is zeroed in advance. I don't know if his code skips all-zero blocks in the image, but that should be possible to add fairly easily. 

Cheers, Andreas

On 2011-07-22, at 9:49 AM, Round Robinjp <roundrobinjp@yahoo.co.jp> wrote:

> Hi
> 
> I have a question regarding making ext4 image for
> large eMMC partition.
> 
> We have a 4G partition in our embedded device
> in which we want to use ext4 filesystem.
> But for that we have to create a 4G image.
> flashing this 4G image to the eMMC takes a long
> time. Is there any way to reduce this time?
> 
> For vfat, you can truncate the image leaving only
> non zero-filled blocks which makes the image very
> short and the time for flashing is reduced.
> Is something similar to that possible for ext4?
> 
> Thanks
> Robin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
