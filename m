From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: i_size error with the latest patchqueue
Date: Thu, 31 Jul 2008 21:40:59 +0530
Message-ID: <20080731161058.GA20838@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:40026 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbYGaQLJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 Jul 2008 12:11:09 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6VGB6qs006580
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 21:41:06 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6VGB6om1855604
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 21:41:06 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6VGB5jc028377
	for <linux-ext4@vger.kernel.org>; Thu, 31 Jul 2008 21:41:06 +0530
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

I haven't yet looked at whether it is kernel or e2fsck bug.
But I am having this with the latest patch queue when running
fsstress. The fsstress have falloc added as a supported operation.
So it is mostly to do with fallocate. Architecture is x86.

The tests performed are

               chown 3/39 write op
               creat 4/39 write op
               dread 4/39  
           fdatasync 1/39 write op
               fsync 1/39 write op
            getdents 1/39  
                link 1/39 write op
               mkdir 2/39 write op
               mknod 2/39 write op
                read 1/39  
            readlink 1/39  
              rename 2/39 write op
               rmdir 1/39 write op
                stat 1/39  
             symlink 2/39 write op
                sync 1/39  
            truncate 2/39 write op
              unlink 1/39 write op
               write 4/39 write op
           fallocate 4/39 write op

seed = 1218256896


/usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sdb1
e2fsck 1.41.0 (10-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 10093, i_size is 974599, should be 999424.  Fix? no

Inode 22481, i_size is 363927, should be 909312.  Fix? no

Inode 28621, i_size is 143236, should be 159744.  Fix? no

Inode 28635, i_size is 1203683, should be 1830912.  Fix? no

Inode 42764, i_size is 2328377, should be 2691072.  Fix? no

Inode 54630, i_size is 204182, should be 331776.  Fix? no

Inode 60249, i_size is 0, should be 700416.  Fix? no

Inode 67588, i_size is 1621922, should be 1810432.  Fix? no

Inode 71084, i_size is 0, should be 184320.  Fix? no

Inode 78764, i_size is 0, should be 151552.  Fix? no

Inode 92569, i_size is 651967, should be 806912.  Fix? no


-aneesh
