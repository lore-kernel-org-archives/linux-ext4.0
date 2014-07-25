From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Fri, 25 Jul 2014 12:33:29 +0800
Message-ID: <53D1DE19.9000503@fnarfbargle.com>
References: <53CBA75B.2030102@fnarfbargle.com> <53CC66DA.2080804@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:60510 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGYEde (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 00:33:34 -0400
Received: from srv
	([10.8.0.1] helo=srv.home ident=heh6312)
	by ns3.fnarfbargle.com with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1XAXCE-0006PR-8i
	for linux-ext4@vger.kernel.org; Fri, 25 Jul 2014 14:33:30 +1000
Received: from bkmac.home ([192.168.2.87])
	by srv.home with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1XAXCD-0001di-6K
	for linux-ext4@vger.kernel.org; Fri, 25 Jul 2014 12:33:29 +0800
In-Reply-To: <53CC66DA.2080804@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 21/07/14 09:03, Brad Campbell wrote:
> On 20/07/14 19:26, Brad Campbell wrote:
>> G'day all,
>>
>> Machine was running 3.13.5. x86_64.
>>
>> I had a 12 device (2TB) RAID-6 formatted ext4. I added 2 drives to its
>> underlying md and restriped it (no issues). After the restripe I
>> attempted an online resize using ext2progs 1.42.5 (Debian stable). This
>> failed with a message about the size not fitting into 32 bits so I
>> compiled 1.42.11 and tried again.
>
>
> More info:
> I discovered the debug flags, so this is resize2fs -f 255 /dev/md0
>
> last_start just keeps incrementing for as long as I care to leave it run.
>
> fs has 4007207 inodes, 1957 groups required.
> fs requires 4374122900 data blocks.
> With 1957 group(s), we have 63820826 blocks available.

Ping? Working filesystem that locks up resize2fs 1.42.11 and 
consequently fails to fill the entire device. Passes fsck cleanly but 
will not resize either online or off.

Is there any other data I can provide or pointers on how I might 
un-break things?

Regards,
Brad
