From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: fsck errors with fsstress
Date: Tue, 15 Apr 2008 12:17:33 +0530
Message-ID: <20080415064733.GA8099@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:39004 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYDOGs1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Apr 2008 02:48:27 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m3F6lkvA006523
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 16:47:46 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3F6mG6O1196106
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 16:48:16 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3F6mImD009559
	for <linux-ext4@vger.kernel.org>; Tue, 15 Apr 2008 16:48:19 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On x86_64 after fsstress with fallocate is run with 

fsstress -c -n1000 -p1000 -d /mnt/tmp/fsstress -f dwrite=0

e2fsprogs from next branch with HEAD at v1.40.8-163-g60dc00b

/usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sda5
e2fsck 1.40.8 (13-Mar-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 401326 has an invalid extent
	(logical block 76, physical block 2441549, invalid len 711)
Clear? no

Inode 401326, i_blocks is 1112, should be 0.  Fix? no

Inode 475743 has an invalid extent
	(logical block 226, physical block 2441673, invalid len 245)
Clear? no

Inode 475743, i_blocks is 328, should be 0.  Fix? no

Inode 603723 has an invalid extent
	(logical block 34, physical block 2441671, invalid len 316)
Clear? no

Inode 603723, i_blocks is 456, should be 0.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(118168--118173) -(174537--174541) -(371445--371462) -(592857--592859) -937329 -(961360--961363) -(968529--968547) -(1238135--1238143) -(1285426--1285432) -(1415800--1415801) -(1576655--1576681) -(2075764--2075776) -(2364415--2364420) -(2368402--2368410) -(2432102--2432111) -2432247 -(2433343--2433346) -(2435405--2435432) -(2441075--2441105) -(2441265--2441289) -(2441348--2441353) -2441549 -2441671 -2441673
Fix? no


/dev/sda5: ********** WARNING: Filesystem still has errors **********
