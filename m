From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: ext3 sequential read performance (~20%) degrade
Date: Thu, 14 Sep 2006 16:36:12 -0700
Message-ID: <1158276972.24991.10.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:20109 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932130AbWINXcn
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Sep 2006 19:32:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8ENWhep008618
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 19:32:43 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8ENWgK4225046
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 17:32:42 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8ENWgdm024949
	for <linux-ext4@vger.kernel.org>; Thu, 14 Sep 2006 17:32:42 -0600
To: akpm@osdl.org, sct@redhat.com
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Andrew,

I have been working on tracking down ~20% performance degrade for
sequential read performance for ext3. 

Finally narrowed it down to get_blocks() support. If I force
ext3_get_blocks_handle() to always return 1 block - I get better
IO rate. I did all the usual stuff, tracked down requests, traced
blocksizes, looked at readahead code, looked at mpage_readpages()
etc.. I still can't figure out how to explain the degrade..

Any suggestions on how to track it down.

Thanks,
Badari

# cat iotest
mount /dev/sdb2 /mnt/tmp
time dd if=/mnt/tmp/testfile of=/dev/null bs=4k count=1048576
umount /mnt/tmp

2.6.18-rc6: (multiblock):

# ./iotest
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB) copied, 75.2654 seconds, 57.1 MB/s

real    1m15.282s
user    0m0.248s
sys     0m4.292s

2.6.18-rc6 (force single block in ext3_get_blocks_handle():

# ./iotest
./iotest
1048576+0 records in
1048576+0 records out
4294967296 bytes (4.3 GB) copied, 62.9472 seconds, 68.2 MB/s

real    1m2.976s
user    0m0.268s
sys     0m4.280s


