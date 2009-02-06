From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 06 Feb 2009 17:43:21 -0500
Message-ID: <498CBD09.4020301@redhat.com>
References: <p06240517c5b14e12f7d1@[10.1.5.33]> <498CB68C.5030409@redhat.com> <p06240530c5b26b5a174c@[10.1.5.33]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: "J.D. Bakker" <jdb@lartmaker.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35482 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbZBFWp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 17:45:26 -0500
In-Reply-To: <p06240530c5b26b5a174c@[10.1.5.33]>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

J.D. Bakker wrote:
> At 17:15 -0500 06-02-2009, Ric Wheeler wrote:
>> J.D. Bakker wrote:
>>> Hi,
>>>
>>> My 4TB ext4 RAID-6 has just become damaged for the second time in 
>>> two months. While I do have backups for most of my data, it would be 
>>> good to know if there is a recovery procedure or a way to avoid 
>>> these crashes. The symptoms are massive group descriptor corruption, 
>>> similar to what was mentioned in 
>>> http://thread.gmane.org/gmane.comp.file-systems.ext4/10844 and 
>>> http://article.gmane.org/gmane.comp.file-systems.ext4/11195 .
>> What kind of RAID 6 device are you using? Is it MD raid or some 
>> vendor array?
>
> md, as shown in the linked config and dmesg.
>
>>> http://lartmaker.nl/ext4/kernel-config.txt
>>> http://lartmaker.nl/ext4/dmesg.txt
>>> http://lartmaker.nl/ext4/lspci.txt
>>> http://lartmaker.nl/ext4/proc-mdstat.txt
>>> http://lartmaker.nl/ext4/proc-partitions.txt
>
> JDB.

RAID6 is not that new, but it is newer than MD raid5. Does RAID5/6 
handle the write barriers correctly these days? I think that barriers 
are enabled only for RAID1 which means that your disks might be holding 
up lots of volatile data that will go "poof" if you power off or reboot.

You can "fix" this by disabling the write cache on your drives, but you 
will have a performance hit (at least for S-ATA drives).

Ric

