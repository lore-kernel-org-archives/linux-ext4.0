From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Online defragmentation
Date: Wed, 30 May 2007 12:34:34 +0530
Message-ID: <465D2202.60600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:37648 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXE3Kru (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2007 06:47:50 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4UAnNlu5394626
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 20:49:23 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4UAU719078928
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 20:51:16 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4U74poH023761
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 17:04:51 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Takashi,

I was looking at online defrag code and found that the tmp_inode is 
created with tmp_inode->i_nlink equal to zero. Now i am not sure whether 
i understand the code correctly, but AFAIU we allocate contiguous block 
using this tmp_inode. That means tmp_inode have extent details 
corresponding to the blocks. Now we are mapping the file data found in 
the original inode to this new blocks. Towards the end we does a iput. 
In iput since we have i_nlink as zero it will go ahead and call 
generic_delete_inode which will cause these data blocks to be marked 
free (right ?)


I haven't tested the defrag code. This came up when i was doing the 
online migration. With large file having large number of fragmented 
blocks I was getting the below error during the iput of the temporary 
inode.

"ext4_free_blocks Freeing blocks not in datazone ...."

I was able to fix that by setting i_nlink = 1 which will cause the 
generic_forget_inode to be called


-aneesh
