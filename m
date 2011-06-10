From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [BUG] ext4 timestamps corruption
Date: Fri, 10 Jun 2011 17:27:40 +0900
Message-ID: <4DF1D57C.3030107@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:37911 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1FJIiG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 04:38:06 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id p5A8c4qo013722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jun 2011 17:38:05 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Officially, ext4 can handle its timestamps until 2514
with 32bit entries plus EPOCH_BIT (2bits).
But when timestamps values use 32+ bit
(e.g. 2038-01-19 9:14:08 0x0000000080000000),
we can get corrupted values.
Because sign bit is overwritten by transferring value
between kernel space and user space.

This can be happened with kernel 3.0.0-rc2 (Also older kernel)
on x86_64.

# This issue is already on Bugzilla,
  does anybody know this current status?
https://bugzilla.kernel.org/show_bug.cgi?id=23732

Reproduce steps are as follows:
# System time is set to UTC.

# mount -t ext4 /dev/sda8 /mnt/mp1

# touch -t 203801190314.08 /mnt/mp1/FILE

# umount /mnt/mp1
# mount -t ext4 /dev/sda8 /mnt/mp1

# stat /mnt/mp1/FILE
  File: `/mnt/mp1/FILE'
  Size: 0         	Blocks: 0          IO Block: 4096   regular empty file
Device: 808h/2056d	Inode: 12          Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 1901-12-13 20:45:52.000000000 +0000       <-----
Modify: 1901-12-13 20:45:52.000000000 +0000       <-----
Change: 2011-06-10 03:57:39.595385951 +0100
 Birth: -

Regards,
Akira Fujita

