From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Fri, 19 Jan 2007 14:19:44 +0900
Message-ID: <015201c73b89$70f521e0$4168010a@bsd.tnes.nec.co.jp>
References: <20070116210346sho@rifu.tnes.nec.co.jp> <20070116192134.GB5236@schatzie.adilger.int> <02bb01c73a29$eb846120$4168010a@bsd.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34225 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964845AbXASFT4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jan 2007 00:19:56 -0500
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.193])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0J5JsZl020935
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 14:19:54 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0J5Js723211 for linux-ext4@vger.kernel.org; Fri, 19 Jan 2007 14:19:54 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l0J5JrI09634 for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 14:19:53 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070119.141953.79602980 for <linux-ext4@vger.kernel.org>
	; Fri, 19 Jan 2007 14:19:53 +0900
To: "Andreas Dilger" <adilger@clusterfs.com>,
	"Joel Becker" <Joel.Becker@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

>> On Jan 16, 2007  21:03 +0900, sho@tnes.nec.co.jp wrote:
>>> 1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
>>>    block number of the specified file.  With this ioctl, a command
>>>    gets the specified directory's.
>>
>> Maybe I don't understand, but how is this different from the long-time
>> FIBMAP ioctl?
> 
> I can use FIBMAP instead of my new ioctl.
> You are right.  I should have used FIBMAP ioctl...

I have to get the physical block number of the specified directory.
But FIBMAP is available only for a regular file, not for a directory.
So I will use my new ioctl.

Cheers, Takashi
