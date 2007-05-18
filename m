From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Online defragmentation and ext4migrate
Date: Fri, 18 May 2007 18:36:53 +0530
Message-ID: <464DA4ED.9040408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:57487 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420AbXERNHB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 09:07:01 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4ID8N4G5390384
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 23:08:23 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4IDARU8082862
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 23:10:27 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4ID6tuk020813
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 23:06:56 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Takashi san,


While doing online defragmentation do we move the blocks corresponding 
to extent index ? The reason why i am asking this is to understand the
usefulness of doing a ext4migrate followed by defrag. I understand that 
defragmentation in general will improve the performance. But with 
respect to ext4migrate we are not touching the data blocks. Instead we 
build the extent map and if that requires to have an extent index block 
then we allocate one. I am trying to understand what would be the 
performance impact of this and whether doing a defrag really improve the 
  performance.

Also looking at the version 0.4 I see that defrag ioctl only work if we 
have EXT4_EXTENTS_FL flag set. What are the plans for making defrag work 
with indirect block map inode ?


-aneesh
