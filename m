From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext4_inode difference between e2fsprogs and ext4
Date: Thu, 11 Oct 2007 14:30:48 +0530
Message-ID: <470DE640.3040101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:57970 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXJKJBk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 05:01:40 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9B91Pss013263
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 19:01:25 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9B94vhf244044
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 19:04:57 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9B916sA009441
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 19:01:07 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

in e2fsprogs we have

union { 
                struct {
                        __u16   l_i_blocks_hi;
                        __u16   i_pad1;
                        __u16   l_i_uid_high;   /* these 2 fields    */
                        __u16   l_i_gid_high;   /* were reserved2[0] */
                        __u32   l_i_reserved2;
                } linux2;



In ext4 we have

  union { 
                struct {
                        __le16  l_i_reserved1;  /* Obsoleted fragment number/size which are removed in ext4 */
                        __le16  l_i_file_acl_high;
                        __le16  l_i_uid_high;   /* these 2 fields */
                        __le16  l_i_gid_high;   /* were reserved2[0] */
                        __u32   l_i_reserved2;
                } linux2;


Last week we were discussing about taking that l_i_reserved1 and using that for making file_acl 64 bit and using the
lower l_i_reserved2 for 64 bit dir_acl. 

Now where will i put l_i_blocks_hi ?

-aneesh
