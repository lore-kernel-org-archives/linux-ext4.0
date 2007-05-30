From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Online defragmentation
Date: Wed, 30 May 2007 13:18:07 +0530
Message-ID: <465D2C37.9080905@linux.vnet.ibm.com>
References: <465D2202.60600@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Takashi Sato <sho@tnes.nec.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44498 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXE3Hsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 May 2007 03:48:46 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l4U89LS5186630
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 18:09:21 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.250.237])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4U7pxeV158832
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 17:52:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4U7mIKp013576
	for <linux-ext4@vger.kernel.org>; Wed, 30 May 2007 17:48:21 +1000
In-Reply-To: <465D2202.60600@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Aneesh Kumar K.V wrote:
> Hi Takashi,
> 
> I was looking at online defrag code and found that the tmp_inode is 
> created with tmp_inode->i_nlink equal to zero. Now i am not sure whether 
> i understand the code correctly, but AFAIU we allocate contiguous block 
> using this tmp_inode. That means tmp_inode have extent details 
> corresponding to the blocks. Now we are mapping the file data found in 
> the original inode to this new blocks. Towards the end we does a iput. 
> In iput since we have i_nlink as zero it will go ahead and call 
> generic_delete_inode which will cause these data blocks to be marked 
> free (right ?)
> 

Looking at the code again i guess for defragmentation it is okey. I 
guess what actually happens is the blocks that is corresponding to the 
original inode get accounted under tmp_inode. (it actually does a swap 
of blocks ) So doing a iput with i_nlink = 0 is the correct approach.

Correct me if i am wrong.

Sorry for the noise.

-aneesh
