From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: When to set EXT4_FEATURE_RO_COMPAT_LARGE_FILE  ?
Date: Thu, 11 Oct 2007 22:34:13 +0530
Message-ID: <470E578D.4040308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52858 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbXJKREq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 13:04:46 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9BH4fiv032269
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 03:04:41 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BH8F0I197076
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 03:08:15 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BH4OJA026318
	for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2007 03:04:25 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Right now we do this  in ext4_do_update_inode

 if (ei->i_disksize > 0x7fffffffULL) {

.....
.....

EXT4_SET_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_LARGE_FILE);

That is if i_disksize is greater that 2**31 -1  we set the flag

But in ext4_inode the size of i_size is 32 bits

__le32  i_size;         /* Size in bytes */

That means it should be able to store ffffffffULL.

Why did we decided to enable the EXT4_FEATURE_RO_COMPAT_LARGE_FILE when we cross 2**31 -1 ?

NOTE: With EXT4_FEATURE_RO_COMPAT_LARGE_FILE we store the higer order 32 bits of i_size in i_dir_acl.


-aneesh
