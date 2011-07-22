From: Round Robinjp <roundrobinjp@yahoo.co.jp>
Subject: flashing large eMMC partitions with ext4
Date: Sat, 23 Jul 2011 00:49:28 +0900 (JST)
Message-ID: <20110722154936.30251.qmail@web4208.mail.ogk.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web4208.mail.ogk.yahoo.co.jp ([124.83.212.28]:20828 "HELO
	web4208.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751340Ab1GVP4S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Jul 2011 11:56:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

I have a question regarding making ext4 image for
large eMMC partition.
 
We have a 4G partition in our embedded device
in which we want to use ext4 filesystem.
But for that we have to create a 4G image.
flashing this 4G image to the eMMC takes a long
time. Is there any way to reduce this time?

For vfat, you can truncate the image leaving only
non zero-filled blocks which makes the image very
short and the time for flashing is reduced.
Is something similar to that possible for ext4?

Thanks
Robin
