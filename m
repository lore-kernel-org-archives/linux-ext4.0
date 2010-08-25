From: andreas@rid-net.de
Subject: defragmentation of boot related files
Date: Wed, 25 Aug 2010 14:00:03 +0200
Message-ID: <4C7505C3.1070509@rid-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:48243 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0HYMAT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Aug 2010 08:00:19 -0400
Received: from [10.0.0.108] (p5DD4A4C4.dip.t-dialin.net [93.212.164.196])
	by post.strato.de (klopstock mo39) (RZmta 23.5)
	with (DHE-RSA-AES128-SHA encrypted) ESMTP id q04c44m7PBrbgB
	for <linux-ext4@vger.kernel.org>;
	Wed, 25 Aug 2010 14:00:17 +0200 (MEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

I try to find ways to reduce the start time of programs or the whole 
operating system. The idea to increase disk performance is to gather all 
related files on disk physically close together. Unlike the last patches 
from Kazuya Mio for "relevant file defragmentation" files used by system 
boot are mostly not in the same directory.

First i look at the EXT4_IOC_MOVE_EXT call.
To reduce the amount of disk seeks i want to move the extents from 
several files into a single donor file. To do so i increment the 
move_extent.donor_start by the size of each file. But i got an error.

The error is caused by the lines in the kernel source 
fs/ext4/move_extent.c:998
998	/* Start offset should be same */
999	if (orig_start != donor_start) {
1000		ext4_debug("ext4 move extent: orig and donor's start "
1001		     "offset are not same [ino:orig %lu, donor %lu]\n",
1002                 orig_inode->i_ino, donor_inode->i_ino);
1003            return -EINVAL;
1004    }

Is there a reason why the offset of the original file and the donor file 
must be the same?

As i can see the patch for relevant file defragmentation in e4defrag 
supports only directories. May it be possible to select any desired file?

What would you suggest as the best way to put files physically together?

If I could help, tell me. :)

Regards,

andy
