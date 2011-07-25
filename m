From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: flashing large eMMC partitions with ext4
Date: Mon, 25 Jul 2011 10:55:40 -0600
Message-ID: <3E2C70BF-3A77-42C8-A451-E4F9A655E309@dilger.ca>
References: <20110725163406.33329.qmail@web4205.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Round Robinjp <roundrobinjp@yahoo.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:17061 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYQzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jul 2011 12:55:42 -0400
In-Reply-To: <20110725163406.33329.qmail@web4205.mail.ogk.yahoo.co.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-25, at 10:34 AM, Round Robinjp wrote:
> Many Thanks for the reply.
> 
> In both the ways you have shown, the eMMC device needs
> to be zeroed in advance. But so far as I know, writing
> 4G bytes of zeros and writing 4G bytes of real data has
> no difference. So this does not solve the problem.
> Please correct me if I am wrong.

I was hoping that MMC had some sort of "TRIM" or "UNMAP" command.  It might also be possible to use/modify the QCOW2 tools so that they don't _save_ zero blocks in the image file, but write them out at restore time?

Alternately, with the "lazy_itable_init" option if you have a new enough kernel (maybe 2.6.38 or 2.6.39?), it will zero the inode table blocks for you.

> Any other options?
> 
> Thanks
> Robin
> 
> 
> --- Andreas Dilger  wrote:
>> If you can wipe the MMC device to be all-zero efficiently, then you can format it quickly with "mke2fs -E lazy_itable_init,lazy_journal_init ..." and restore from a tarball.
>> 
>> Alternately, Lukas recently added support for QCOW2 sparse image format, and it should be possible to restore this to the device efficiently, if it is zeroed in advance. I don't know if his code skips all-zero blocks in the image, but that should be possible to add fairly easily. 
>> 
>> Cheers, Andreas
>> 
>> On 2011-07-22, at 9:49 AM, Round Robinjp <roundrobinjp@yahoo.co.jp> wrote:
>> 
>>> Hi
>>> 
>>> I have a question regarding making ext4 image for
>>> large eMMC partition.
>>> 
>>> We have a 4G partition in our embedded device
>>> in which we want to use ext4 filesystem.
>>> But for that we have to create a 4G image.
>>> flashing this 4G image to the eMMC takes a long
>>> time. Is there any way to reduce this time?
>>> 
>>> For vfat, you can truncate the image leaving only
>>> non zero-filled blocks which makes the image very
>>> short and the time for flashing is reduced.
>>> Is something similar to that possible for ext4?
>>> 
>>> Thanks
>>> Robin


Cheers, Andreas





