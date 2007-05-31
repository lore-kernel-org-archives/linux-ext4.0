From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: Online defragmentation
Date: Thu, 31 May 2007 13:05:06 +0900
Message-ID: <00c201c7a338$e238ae50$4168010a@bsd.tnes.nec.co.jp>
References: <465D2202.60600@linux.vnet.ibm.com> <465D2C37.9080905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:43725 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXEaEFQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 31 May 2007 00:05:16 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.161])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4V45EYc015530
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2007 13:05:14 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4V45E125010 for linux-ext4@vger.kernel.org; Thu, 31 May 2007 13:05:14 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4V45Dg19900 for <linux-ext4@vger.kernel.org>; Thu, 31 May 2007 13:05:13 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070531.130513.04603600 for <linux-ext4@vger.kernel.org>
	; Thu, 31 May 2007 13:05:13 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>> I was looking at online defrag code and found that the tmp_inode is created with 
>> tmp_inode->i_nlink equal to zero. Now i am not sure whether i understand the code 
>> correctly, but AFAIU we allocate contiguous block using this tmp_inode. That means 
>> tmp_inode have extent details corresponding to the blocks. Now we are mapping the file 
>> data found in the original inode to this new blocks. Towards the end we does a iput. In 
>> iput since we have i_nlink as zero it will go ahead and call generic_delete_inode which 
>> will cause these data blocks to be marked free (right ?)
>>
>
> Looking at the code again i guess for defragmentation it is okey. I guess what actually 
> happens is the blocks that is corresponding to the original inode get accounted under 
> tmp_inode. (it actually does a swap of blocks ) So doing a iput with i_nlink = 0 is the 
> correct approach.
>
> Correct me if i am wrong.

Your understanding is right.
The iput() is called to free the old blocks which were in the original
inode.

Cheers, Takashi 
