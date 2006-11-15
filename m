From: "Takashi Sato" <sho@tnes.nec.co.jp>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 15 Nov 2006 18:54:03 +0900
Message-ID: <016301c7089b$fe322240$4168010a@bsd.tnes.nec.co.jp>
References: <20061027162326sho@rifu.tnes.nec.co.jp> <m3lkn2ryno.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	"Jan Kara" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51405 "EHLO
	tyo201.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S966725AbWKOJyP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Nov 2006 04:54:15 -0500
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kAF9sEdE016656
	for <linux-ext4@vger.kernel.org>; Wed, 15 Nov 2006 18:54:14 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kAF9sDG10127 for linux-ext4@vger.kernel.org; Wed, 15 Nov 2006 18:54:13 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kAF9sDa20935 for <linux-ext4@vger.kernel.org>; Wed, 15 Nov 2006 18:54:13 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061115.185914.92102608 for <linux-ext4@vger.kernel.org>
	; Wed, 15 Nov 2006 18:59:15 +0900
To: "Alex Tomas" <alex@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Alex,

Thank you for your information.
I have sent the patches of the defragmentation for a extent-based
file on ext3 using your patches of the multi-block allocation.
I'm happy if you have a time to review my patches.
"[RFC][PATCH 0/3] Extent base online defrag"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116307062907075&w=2

And I'd like to start considering the defragmentation for ext4.
Do you have a plan to update your patches for ext4?

> I've been reworking mballoc with few new features:
> 
> 1) in-core preallocation
>   like existing  reservation, but can preallocate few pieces for a file
> 
> 2) locality groups
>   to maintain groups of related files and flush them together.
>   say, two users are unpacking kernel. with delayed allocation
>   we've got bunch of files from the both in cache. then we flush
>   first set (few MBs) of files from one user, then from another.
>   this way write I/Os will be large enough to achieve good
>   throughput and files are still quite localized to be used later
>   at good read rate.
> 
> 3) scalable reservation
>   required for delayed allocation to avoid -ENOSPC at flush time.
>   current version uses per-sb spinlock.
> 
> probably we could add something for defragmentation?

Cheers, Takashi
