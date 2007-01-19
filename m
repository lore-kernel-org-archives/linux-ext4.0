From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC][PATCH 0/3] ext4 online defrag (ver 0.2)
Date: Fri, 19 Jan 2007 21:00:44 +0900
Message-ID: <024c01c73bc1$75a31f20$4168010a@bsd.tnes.nec.co.jp>
References: <20070116210346sho@rifu.tnes.nec.co.jp> <20070116192134.GB5236@schatzie.adilger.int> <02bb01c73a29$eb846120$4168010a@bsd.tnes.nec.co.jp> <015201c73b89$70f521e0$4168010a@bsd.tnes.nec.co.jp> <20070119113351.GM5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: "Joel Becker" <Joel.Becker@oracle.com>,
	<linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:34096 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965077AbXASMAu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jan 2007 07:00:50 -0500
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0JC0nOE020463
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 21:00:49 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0JC0nB24676 for linux-ext4@vger.kernel.org; Fri, 19 Jan 2007 21:00:49 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l0JC0mj25844 for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 21:00:48 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070119.210048.21902616 for <linux-ext4@vger.kernel.org>
	; Fri, 19 Jan 2007 21:00:48 +0900
To: "Andreas Dilger" <adilger@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Thank you for your comment.

>> >>>1. Add new ioctl(EXT4_IOC_DEFRAG) which returns the first physical
>> >>>   block number of the specified file.  With this ioctl, a command
>> >>>   gets the specified directory's.
>> >>
>> >>Maybe I don't understand, but how is this different from the long-time
>> >>FIBMAP ioctl?
>> >
>> >I can use FIBMAP instead of my new ioctl.
>> >You are right.  I should have used FIBMAP ioctl...
>>
>> I have to get the physical block number of the specified directory.
>> But FIBMAP is available only for a regular file, not for a directory.
>> So I will use my new ioctl.
>
> Though it might make sense to implement FIBMAP for a directory, to keep
> it consistent and allow user-space tools like "filefrag" to work on
> directories also.

It sounds good.
I think it will be useful for other tools which use FIBMAP.
So I will consider the implementation of FIBMAP for a directory.

Cheers, Takashi
