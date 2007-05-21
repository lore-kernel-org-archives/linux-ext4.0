From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: Online defragmentation and ext4migrate
Date: Mon, 21 May 2007 19:25:37 +0900
Message-ID: <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp>
References: <464DA4ED.9040408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:64568 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760619AbXEUK3u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 06:29:50 -0400
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4LATm3F021026
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 19:29:48 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.160])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4LAPiUR024039
	for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 19:25:44 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4LAPhe29190 for linux-ext4@vger.kernel.org; Mon, 21 May 2007 19:25:43 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4LAPhL14066 for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 19:25:43 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070521.192604.46802192 for <linux-ext4@vger.kernel.org>
	; Mon, 21 May 2007 19:26:04 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Aneesh san,

> While doing online defragmentation do we move the blocks corresponding to extent index ? 
> The reason why i am asking this is to understand the
> usefulness of doing a ext4migrate followed by defrag. I understand that defragmentation 
> in general will improve the performance. But with respect to ext4migrate we are not 
> touching the data blocks. Instead we build the extent map and if that requires to have 
> an extent index block then we allocate one. I am trying to understand what would be the 
> performance impact of this and whether doing a defrag really improve the performance.

I think converting a file to extents has the benefit for the performance of
block searching. If we want to improve also the performance of  reading
file data, we have to run the defrag after that.

> Also looking at the version 0.4 I see that defrag ioctl only work if we have 
> EXT4_EXTENTS_FL flag set. What are the plans for making defrag work with indirect block 
> map inode ?

Unfortunately, my defrag doesn't support an indirect block file.
But we can reduce fragments in the file with the defrag just after
ext4migrate.

In my opinion, to keep the ioctl simple and small is very important
for ease of maintenance.  So I would rather not support indirect
block files in the ioctl.
Instead, I can add the call of the migration ioctl to my defrag tool in order
to defragment indirect block files.  How do you think of it?

Cheers, Takashi 
