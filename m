From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: frequent kernel bugs with 2.6.26-gentoo-r1
Date: Sat, 16 Aug 2008 18:58:10 -0500
Message-ID: <48A76992.7090709@redhat.com>
References: <609868.63309.qm@web25408.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Markus d <supersud501@yahoo.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYHPX7O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Aug 2008 19:59:14 -0400
In-Reply-To: <609868.63309.qm@web25408.mail.ukl.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Markus d wrote:
> (i sent a part of this mail from another email address which is not registered in this list, so i'm not sure whether it was deliverd or not. so here it is again with some more information)
> 
> hi all,
> 
> i used ext4 some months ago but switched back to ext3 then.
> 
> today i wanted to try out ext4 again and did the following:
> 
> i'm using latest gentoo-kernel, which is based on 2.6.26.2 and some few
> patches
> (patchlist: http://dev.gentoo.org/~dsd/genpatches/patches-2.6.26-1.htm).
> 
> i patched the kernel with
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST-2.6.26/2.6.26-ext4-6.bz2
> and compiled it successfully.
> 
> after a "ssv flags 4" and a "tune2fs -O extents" i could mount one of my
> ext3 partitions as a ext4dev-drive. first, everything seemed to work,
> but after some read/write to that drive i got the first kernel oops.
> 
> thought it might be because it was an old ext3-drive, so i formated the
> drive with mkfs.ext4dev. but no change, still the same problems. now i'm
> nearly always getting a kernel bug on umounting an ext4-drive (and then
> the device is not accessible/mountable anymore). here's the recent one:
> 
> [  830.270166] ------------[ cut here ]------------
> [  830.270166] kernel BUG at fs/ext4/inode.c:1561!
> [  830.270166] invalid opcode: 0000 [1] PREEMPT SMP


<lazy>can you correlate to where this is in the 2.6.26.2 kernel?</lazy>

> 
> and here's a kernel fault while using the filesystem (happened on quitting firefox, the profile is located on the drive). the drive was unusuable after this:
> 
> [13251.598595] ------------[ cut here ]------------
> [13251.598600] kernel BUG at fs/ext4/mballoc.c:3963!

AFAIK, this one has been addressed; see the thread at:
http://marc.info/?l=linux-ext4&m=121865380302199&w=4

-Eric
