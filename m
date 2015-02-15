From: grantksupport@operamail.com
Subject: gdisk-created Bios Boot Partition created with NO fs,
 reports fs TYPE=ext4.  Bug/why?
Date: Sun, 15 Feb 2015 10:38:56 -0800
Message-ID: <1424025536.1061731.227795501.40064DE9@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60778 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbbBOSi5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Feb 2015 13:38:57 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id 277F52075E
	for <linux-ext4@vger.kernel.org>; Sun, 15 Feb 2015 13:38:56 -0500 (EST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I'm not entirely sure this is the right list for this question, but it IS ext4 'involved'.  So ...

I create a GPT Bios Boot Partition on a clean disk

	sgdisk -z /dev/sdc
	sgdisk -o /dev/sdc
	sgdisk -n 1:2048:+1M    -t 1:ef02  -c 1:"BIOS Boot"           /dev/sdc

IIUC, at this point, the partition should exist with NO filesystem.

But, if I check with blkid

	blkid /dev/sdc1
		/dev/sdc1: LABEL="RAID_BOOT" UUID="8a828baa-f315-4456-88d2-ff14849eb705" TYPE="ext4" PARTLABEL="BIOS Boot" PARTUUID="2b3b10b1-a458-481e-872c-bada7d244b13" 

Note that it IDs the filesystem type as

	TYPE="ext4"

Why?

Bios Boot Partition should have NO filesystem.

Is blkid correct?  Is there, or isn't there a fs on that partition?

if there isn't, what's causint the 'false' report?

If there IS, how do I make sure there isn't?

grant

