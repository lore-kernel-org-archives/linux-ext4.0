From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Open bugs found by fuzzing as of 2016-07-30
Date: Sat, 30 Jul 2016 15:04:43 +0200
Message-ID: <579CA5EB.1070707@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47209 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbcG3NEs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jul 2016 09:04:48 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u6UD4l7k004644
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jul 2016 13:04:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id u6UD4lsQ004232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jul 2016 13:04:47 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id u6UD4jUM001438
	for <linux-ext4@vger.kernel.org>; Sat, 30 Jul 2016 13:04:46 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

It's been two weeks since I posted the first list of bugs found using
AFL: https://www.spinics.net/lists/linux-ext4/msg53022.html

With a bunch of ext4 patches going into 4.8 we're down from 15 to 6
with current linus/master:

1. general protection fault: 0000 [#1] KASAN
http://139.162.151.198/f/ext4/57be666646a37e9821d52bc64846a3b3b785ee7a

2. kernel BUG at fs/buffer.c:3061!
http://139.162.151.198/f/ext4/7df880da89c82579c15ca8bc786a3467ca9c47f7

3. kernel BUG at fs/ext4/inode.c:3738!
http://139.162.151.198/f/ext4/5bdefda69f39b2f2c56d9b67d5b7d9e2cc8dfd5f
(discussion: https://www.spinics.net/lists/linux-ext4/msg53032.html)

4. kernel BUG at fs/ext4/mballoc.c:3191!
http://139.162.151.198/f/ext4/34284738d67f0405325b2c43211c56020b9d0211

5. kernel BUG at fs/jbd2/commit.c:825!
http://139.162.151.198/f/ext4/3143febf7925bd1ea398bd1a775551133bd69ffd

6. WARNING: CPU: 0 PID: 58 at fs/ext4/ext4.h:2748 
ext4_block_bitmap_csum_set+0x358/0x600
http://139.162.151.198/f/ext4/9628c19aff0bbaaae4149a03486305c7f6cd7523


Vegard
