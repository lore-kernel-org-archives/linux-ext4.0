From: "J.D. Bakker" <jdb@lartmaker.nl>
Subject: Re: Recovering a damaged ext4 fs - revisited.
Date: Fri, 6 Feb 2009 23:34:36 +0100
Message-ID: <p06240530c5b26b5a174c@[10.1.5.33]>
References: <p06240517c5b14e12f7d1@[10.1.5.33]>
 <498CB68C.5030409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Cc: linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.lartmaker.nl ([69.93.127.100]:40776 "EHLO www.lartmaker.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZBFWek (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Feb 2009 17:34:40 -0500
In-Reply-To: <498CB68C.5030409@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At 17:15 -0500 06-02-2009, Ric Wheeler wrote:
>J.D. Bakker wrote:
>>Hi,
>>
>>My 4TB ext4 RAID-6 has just become damaged for the second time in 
>>two months. While I do have backups for most of my data, it would 
>>be good to know if there is a recovery procedure or a way to avoid 
>>these crashes. The symptoms are massive group descriptor 
>>corruption, similar to what was mentioned in 
>>http://thread.gmane.org/gmane.comp.file-systems.ext4/10844 and 
>>http://article.gmane.org/gmane.comp.file-systems.ext4/11195 .
>What kind of RAID 6 device are you using? Is it MD raid or some vendor array?

md, as shown in the linked config and dmesg.

>>http://lartmaker.nl/ext4/kernel-config.txt
>>http://lartmaker.nl/ext4/dmesg.txt
>>http://lartmaker.nl/ext4/lspci.txt
>>http://lartmaker.nl/ext4/proc-mdstat.txt
>>http://lartmaker.nl/ext4/proc-partitions.txt

JDB.
-- 
LART. 250 MIPS under one Watt. Free hardware design files.
http://www.lartmaker.nl/
