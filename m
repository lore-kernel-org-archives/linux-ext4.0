From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Errors with 1024 block size
Date: Tue, 18 Nov 2008 16:54:20 +0530
Message-ID: <20081118112420.GB9345@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:50582 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYKRLYj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Nov 2008 06:24:39 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAIBNnqW016554
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:23:49 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAIBOoUd4677816
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:24:50 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAIBOaDD024830
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:24:37 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

With block size 1024 on x86 i am getting different errors listed below
I can't reproduce them always.



[root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71
ls: /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/l71: Stale NFS file handle
[root@llm19 tmp]# ls -al /mnt/tmp/f/p369/d3/d6/d39/db2/dee/d10f/d3f/
total 411
drwxrwxrwx 3 689933 root    1024 Nov 18 05:59 .
drwxrwxrwx 3   8391 root    1024 Nov 18 05:59 ..
drwxrwxrwx 2 root   root    1024 Nov 18 05:33 d83
-rw-rw-rw- 1 root   root       0 Nov 18 05:06 fb4
-rw-rw-rw- 1 root   root 3350138 Nov 18 05:33 fb9
?--------- ? ?      ?          ?            ? l71
lrwxrwxrwx 1 root   root     509 Nov 18 05:23 ld9 -> xxxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxxx/xxxxxxxx
[root@llm19 tmp]# 

dmesg gives:

EXT4-fs error (device sdb1): ext4_free_inode: bit already cleared for inode 168449


Some other message i got before. But i didn't capture the info fully 

a) "Deleting nonexistent file ..." warning in ext4_unlink

b) "Empty directory has too many links..." in ext4_rmdir

