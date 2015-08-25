From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Running fsck of huge ext4 partition takes weeks
Date: Tue, 25 Aug 2015 13:43:46 -0600
Message-ID: <28A25D6A-DA5A-42D2-9BFE-9F6C95B51BE7@dilger.ca>
References: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34587 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbbHYTnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2015 15:43:50 -0400
Received: by pabzx8 with SMTP id zx8so43018010pab.1
        for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2015 12:43:49 -0700 (PDT)
In-Reply-To: <CAETWcfs0iLzwPmg-JY5B79rme+g0Zi2VMYoNHm+4_Pc_yRR-kQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 25, 2015, at 9:30 AM, Alexander Afonyashin <a.afonyashin@madnet-team.ru> wrote:
> 
> Hi,
> 
> Recently I had to run fsck on 47TB ext4 partition backed by hardware
> RAID6 (LSI MegaRAID SAS 2108). Right now over 2 weeks passed but fsck
> is not finished yet. It occupies 30GB RSS, almost 35GB VSS and eats
> 100% of single CPU. It detected errors (and fixed them) but doesn't
> finish yet.
> 
> Rescue disc is based on Debian 7.8.
> kernel: 4.1.4-5
> e2fsprogs: 1.42.5-1.1+deb7u1
> 
> Any suggestions?

Usually the only reason for e2fsck to run so long is because of
duplicate block pass 1b/1c.

Having some of the actual output of e2fsck would allow us to give
some useful advice.

The only thing I can offer is for you to run "strace -p <e2fsck_pid>"
and/or "ltrace -p <e2fsck_pid>" to see what it is doing.

Cheers, Andreas





