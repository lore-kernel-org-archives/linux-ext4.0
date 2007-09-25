From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 16:21:29 +0530
Message-ID: <46F8E831.1060305@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <46F8D0DA.7090500@linux.vnet.ibm.com> <20070925100101.GC6143@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:52470 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXIYKw1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 06:52:27 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PAq4P6022521
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 20:52:04 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PAtZVD257524
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 20:55:36 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PAoVU2026769
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 20:50:31 +1000
In-Reply-To: <20070925100101.GC6143@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Sep 25, 2007  14:41 +0530, Aneesh Kumar K.V wrote:
>> The patches are on top of patch queue. I haven't touched
>> the uid and gid of ext4_inode. Do you think i should
>> change that too ?
> 
> You can add a Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> to those patches.  As I suspected there were a number of bugs hiding
> in there.  I would also change the uid and gid fields, even if we
> don't suspect any problems now.
> 

the primary reason for me not looking at uid gid and file_acl fields are

a) we can mount with option nouid32 and that will look at only the low 16 
   bits
b) same is true with the gid fields

c) Also i_file_acl. If the creater os is HURD we look at only the low 32 bits.


That means all the pace where we access these fields we have conditional access
That makes it less error prone. 

with the changes the code will some what as below 

         if(!(test_opt (inode->i_sb, NO_UID32))) {
-               inode->i_uid |= le16_to_cpu(raw_inode->i_uid_high) << 16;
-               inode->i_gid |= le16_to_cpu(raw_inode->i_gid_high) << 16;
+               inode->i_uid = ext4_get_i_uid(raw_inode);
+               inode->i_gid = ext4_get_i_gid(raw_inode);
+       } else {
+               inode->i_uid = ext4_get_i_uid_low(raw_inode);
+               inode->i_gid = ext4_get_i_gid_low(raw_inode);
        }


-aneesh
