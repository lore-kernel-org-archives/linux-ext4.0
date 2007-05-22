From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: Online defragmentation and ext4migrate
Date: Tue, 22 May 2007 17:35:09 +0900
Message-ID: <025e01c79c4c$1e1eefe0$4168010a@bsd.tnes.nec.co.jp>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp> <46517669.50804@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37585 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXEVIfV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2007 04:35:21 -0400
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.195])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4M8ZJWj026263
	for <linux-ext4@vger.kernel.org>; Tue, 22 May 2007 17:35:19 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4M8ZJv00678 for linux-ext4@vger.kernel.org; Tue, 22 May 2007 17:35:19 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4M8ZI226831 for <linux-ext4@vger.kernel.org>; Tue, 22 May 2007 17:35:18 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070522.173541.06201588 for <linux-ext4@vger.kernel.org>
	; Tue, 22 May 2007 17:35:41 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>> In my opinion, to keep the ioctl simple and small is very important
>> for ease of maintenance.  So I would rather not support indirect
>> block files in the ioctl.
>> Instead, I can add the call of the migration ioctl to my defrag tool in order
>> to defragment indirect block files.  How do you think of it?
>>
>
> That should be fine. So i will start moving the ext4migrate code as a ext4 ioctl and 
> later will send you a patch to the defrag tool that will migrate and defrag.

OK.  I am looking forward to your patch.

Cheers, Takashi
