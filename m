From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 22 Feb 2008 20:37:28 +0530
Message-ID: <20080222150728.GA6629@skywalker>
References: <1203691158-6788-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203691158-6788-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1203691158-6788-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:60809 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752701AbYBVPHc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 10:07:32 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1MF7UG9018414
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 20:37:30 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MF7Tpb1147006
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 20:37:29 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1MF7Tgi030665
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:07:29 GMT
Content-Disposition: inline
In-Reply-To: <1203691158-6788-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Test results for the patch.

mmaptest simply maps a range and write to it.
The length of the extent indicate whether it is initialized or not.

There is no space in the file system for another block.
So the uninitialized extent have to be converted to initialized extent.

root@qemu-image:/ext4# /root/mmaptest testfile 0 100
mmaping 0 to 100
[kvaneesh@llm59 linux-2.6.25-rc2]$ ~/ext4migrate --display /home/kvaneesh/test-images/ext3.img  testfile
extent: block=0-3 len=4 start=1153 start_hi=0
extent: block=4-32807 len=32804 start=1157 start_hi=0

root@qemu-image:/ext4# dd if=/root/a.c of=testfile  seek=6 bs=4096 conv=notrunc
[kvaneesh@llm59 linux-2.6.25-rc2]$ ~/ext4migrate --display /home/kvaneesh/test-images/ext3.img  testfile
extent: block=0-3 len=4 start=1153 start_hi=0
extent: block=4-32791 len=32788 start=1157 start_hi=0
extent: block=24-24 len=1 start=1177 start_hi=0
extent: block=25-32807 len=32783 start=1178 start_hi=0

root@qemu-image:/ext4# dd if=/root/a.c of=testfile  seek=8 bs=4096 conv=notrunc
[kvaneesh@llm59 linux-2.6.25-rc2]$ ~/ext4migrate --display /home/kvaneesh/test-images/ext3.img  testfile
extent: block=0-3 len=4 start=1153 start_hi=0
extent: block=4-32791 len=32788 start=1157 start_hi=0
extent: block=24-24 len=1 start=1177 start_hi=0
extent: block=25-39 len=15 start=1178 start_hi=0

root@qemu-image:/ext4# /root/mmaptest testfile 4096 5000
mmaping 4096 to 5000
[kvaneesh@llm59 linux-2.6.25-rc2]$ ~/ext4migrate --display /home/kvaneesh/test-images/ext3.img  testfile
extent: block=0-3 len=4 start=1153 start_hi=0
extent: block=4-23 len=20 start=1157 start_hi=0
extent: block=24-24 len=1 start=1177 start_hi=0
extent: block=25-39 len=15 start=1178 start_hi=0
