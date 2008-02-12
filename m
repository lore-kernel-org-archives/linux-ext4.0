From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: EXT4_FEATURE_RO_COMPAT_DIR_NLINK and the directory size.
Date: Tue, 12 Feb 2008 18:06:32 +0530
Message-ID: <20080212123632.GA16634@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48158 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYBLMgf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 07:36:35 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1CCaW9R001934
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 18:06:32 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1CCaWRm594066
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 18:06:32 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1CCaWp5010762
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 12:36:32 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Steps:
[root]# more /root/largedir 
i=65000
mkdir /mnt/tmp/test/
cd /mnt/tmp/test/
while [ $i -gt 0 ]
do 
        mkdir $i
        i=$(expr $i - 1)
done

# /root/largedir
# cd /mnt/tmp/test
# rm -rf *
# cd ..
# ls -al 
drwxr-xr-x  1 root root 1380352 Feb 12 07:15 test
# e2fsck -fv /dev/sda7
# ls -al 
drwxr-xr-x  2 root root 1380352 Feb 12 07:15 test


So e2fsck fix the link count. But the size is not updated. If i try to
run the script again, i get 

EXT4-fs error (device sda7): ext4_find_entry: reading directory #187681
offset 0
attempt to access beyond end of device
sda7: rw=32, want=17582522464, limit=19551042
attempt to access beyond end of device
sda7: rw=32, want=32620150800, limit=19551042
attempt to access beyond end of device
sda7: rw=32, want=32620150800, limit=19551042



Also after running fsstress fsck fails with zero size directory on
powerpc. I am finding directories with 

i_links_count == 1
i_blocks == 0

I missed to check whether the l_i_blocks_hi was having some value.

-aneesh
