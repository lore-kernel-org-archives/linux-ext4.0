From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: flashing large eMMC partitions with ext4
Date: Mon, 25 Jul 2011 22:07:19 -0600
Message-ID: <9DA89371-1C7C-4FA8-B3B5-33BA673E9F12@dilger.ca>
References: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp> <20110725181043.GK3469@thunk.org> <CAOQ4uxgh-T5f8e2McZQcFW3e7oBV+iDVGWBW7oXnv5oztk4z0Q@mail.gmail.com> <CAGBYx2Y_rOwid5HBa_qTFRxsgW_2ukMjzEUrLt6cCDMpG0WDQg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Amir Goldstein <amir73il@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
	Round Robinjp <roundrobinjp@yahoo.co.jp>,
	linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:30480 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1GZEHW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 00:07:22 -0400
In-Reply-To: <CAGBYx2Y_rOwid5HBa_qTFRxsgW_2ukMjzEUrLt6cCDMpG0WDQg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-25, at 7:39 PM, Yongqiang Yang wrote:
> On Mon, Jul 25, 2011 at 9:10 PM, Ted Ts'o <tytso@mit.edu> wrote:
>> On Sat, Jul 23, 2011 at 12:49:28AM +0900, Round Robinjp wrote:
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
>> 
>> I'm guessing the problem is you've already created a file system image
>> which is 4G, and for which a large number of the blocks are not used,
>> and you're trying to optimize the amount of time it takes to flash the
>> image.  Is that right?
> 
> Now the fs is clean, so we can delete journal.  After the image is
> flashed to the eMMC, we can add journal again.  I think tune2fs can
> add and delete journal.  Am I rgiht?

Yes, "tune2fs -O ^has_journal {dev}" will remove the journal (if clean).
That will save 32MB of space in your image.

Then, use "resize2fs -M {dev}" to shrink the image as small as possible,
and then after restoring the image, run "resize2fs {dev}" to grow the
image to fill the device again and "tune2fs -j {dev}" will add it again
with the default size.

Cheers, Andreas





