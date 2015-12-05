From: The Ghost <the-ghost@inbox.ru>
Subject: Does ext4 write anything during reading with relatime?
Date: Sat, 05 Dec 2015 14:03:14 +0300
Message-ID: <5662C472.2050902@inbox.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.181.147]:54717 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbbLELFQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Dec 2015 06:05:16 -0500
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 89356193DC85
	for <linux-ext4@vger.kernel.org>; Sat,  5 Dec 2015 14:03:19 +0300 (MSK)
Received: from ip-95-220-88-90.bb.netbynet.ru ([95.220.88.90]:39636 helo=[192.168.1.9])
	by smtp32.i.mail.ru with esmtpa (envelope-from <the-ghost@inbox.ru>)
	id 1a5AcX-00089v-2J
	for linux-ext4@vger.kernel.org; Sat, 05 Dec 2015 14:03:17 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mounted read-only, naturally, reading from an ext4 filesystem does 
not cause any write operations. But if I mount it read-write and try to 
read from it, then apparently some write operations are issued, because 
my "write-mostly" drive in a RAID1 array spins up. Now, I understand 
that apparently the mount operation itself does write something, and I 
do mount it with a "relatime" option, but I'm just reading stuff over 
and over again - it shouldn't be caused by atime updating. Also, a bug 
with "write-mostly" finally got fixed, and I'm using a fixed kernel 
(latest 3.16 from Debian Jessie-backports).

I just want someone to explain what's happening or direct me towards 
some information about that, because I just want to understand. :) And I 
don't know any means to find out myself... if there are any, those would 
require much better understanding of filesystems than I have...


-- 
The Ghost
