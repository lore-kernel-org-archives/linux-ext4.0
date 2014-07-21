From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Online resize issue with 3.13.5 & 3.15.6
Date: Mon, 21 Jul 2014 09:03:22 +0800
Message-ID: <53CC66DA.2080804@fnarfbargle.com>
References: <53CBA75B.2030102@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns3.fnarfbargle.com ([103.4.17.7]:53010 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaGUBDY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2014 21:03:24 -0400
Received: from srv
	([10.8.0.1] helo=srv.home ident=heh16448)
	by ns3.fnarfbargle.com with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1X920B-0004rw-Q0
	for linux-ext4@vger.kernel.org; Mon, 21 Jul 2014 11:02:51 +1000
Received: from bkmac.home ([192.168.2.87])
	by srv.home with esmtp (Exim 4.80)
	(envelope-from <lists2009@fnarfbargle.com>)
	id 1X920g-0004HB-75
	for linux-ext4@vger.kernel.org; Mon, 21 Jul 2014 09:03:22 +0800
In-Reply-To: <53CBA75B.2030102@fnarfbargle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 20/07/14 19:26, Brad Campbell wrote:
> G'day all,
>
> Machine was running 3.13.5. x86_64.
>
> I had a 12 device (2TB) RAID-6 formatted ext4. I added 2 drives to its
> underlying md and restriped it (no issues). After the restripe I
> attempted an online resize using ext2progs 1.42.5 (Debian stable). This
> failed with a message about the size not fitting into 32 bits so I
> compiled 1.42.11 and tried again.


More info:
I discovered the debug flags, so this is resize2fs -f 255 /dev/md0

last_start just keeps incrementing for as long as I care to leave it run.

fs has 4007207 inodes, 1957 groups required.
fs requires 4374122900 data blocks.
With 1957 group(s), we have 63820826 blocks available.
Added 131540 extra group(s), blks_needed 4374122900, data_blocks 
62023030, last_start 4356599580
Added 131595 extra group(s), blks_needed 4374122900, data_blocks 
73483100, last_start 5781212288
Added 131246 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781244926
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781277564
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781310202
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781342840
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781375478
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781408116
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781440754
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781473392
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781506030
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781538668
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781571306
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781603944
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781636582
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781669220
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781701858
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781734496
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781767134
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781799772
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781832410
Added 131072 extra group(s), blks_needed 4374122900, data_blocks 
79184732, last_start 5781865048

