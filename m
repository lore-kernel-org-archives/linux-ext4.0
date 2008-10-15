From: Nick Piggin <npiggin@suse.de>
Subject: Re: minix/ext2 + rd problem
Date: Wed, 15 Oct 2008 06:16:44 +0200
Message-ID: <20081015041644.GA24613@wotan.suse.de>
References: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Richard Kojedzinszky <krichy@tvnetwork.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbYJOEQp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Oct 2008 00:16:45 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810141631130.30331@krichy.tvnetwork.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, 
Thanks for reporting this.

On Tue, Oct 14, 2008 at 04:43:55PM +0200, Richard Kojedzinszky wrote:
> dear all,
> 
> I got an embedded system, where I use ramdisk, minix on it as a filesystem 
> for /etc. With kernels 2.4 and with 2.6.19 kernels also, the following 
> code did exactly what i wanted, creating an image of the /etc without 
> unmounting it:
> 
> # mount -o remount,ro /etc
> # cat /dev/ram0 > /tmp/image
> # mount -o remount,rw /etc
> 
> And then I had a consistent image from /etc in /tmp/image.
> 
> This worked still with kernel version 2.6.23.14, but nowadays i upgraded 
> to 2.6.26.2, and noticed that the little code didnt work anymore. I wrote 
> a simple test script for checking, and reproducing the issue, which is 
> also attached. Unfortunately this does not work with ext2 also.
> 
> my linux version is:
> Linux version 2.6.26 (root@krichy.tvnetwork.hu) (gcc version 4.2.4 (Debian 
> 4.2.4-3)) #27 SMP PREEMPT Tue Oct 14 15:19:30 CEST 2008
> 
> i use debian lenny/sid.
> 
> Were there any intended change that made this behaviour change or was it 
> by an accident?

That shouldn't have been changed on purpose, unless it is doing something
funny that worked by accident before.

/dev/ram will behave much more like any other block device now (with brd)
wheras previously it was probably more coherent between filesystem and
block device node. Hmm, does all the filesystems cache get written back
before remount ro return?

Could you try sticking a sync after remount,ro?

Thanks,
Nick
