From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Tue, 13 Sep 2011 03:48:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109130346210.9183@trent.utfs.org>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com> <alpine.DEB.2.01.1109130319100.9183@trent.utfs.org> <CABeR261eWW1vi1Xk9E6SWdy7PN=oiDbQdT_LiHgZf7+6V7Sv8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:37264 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1IMKsM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 06:48:12 -0400
In-Reply-To: <CABeR261eWW1vi1Xk9E6SWdy7PN=oiDbQdT_LiHgZf7+6V7Sv8Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


[ Cc'ing linux-ext4 again ]

On Tue, 13 Sep 2011 at 05:44, Matt Parnell wrote:
> > Did you try booting with init=/bin/bash, i.e. bypassing all initscripts?
> > Also, try booting w/o an initrd image if you can, thus bypassing all the
> > early boot magic.
> 
> Not exactly, but I had it drop out to perform an fsck, and the mtab
> indicated it was mounted according to my options, but this was when
> the disk was mounted read only from grub. Also, I don't use an
> initrd...so that's not it either.

Yeah, mtab is no good when your rootfs is readonly. What did /proc/mounts 
say?

C.

> > Shot in the dark: if it worked with 2.6.39 but not with 3.x and the
> > initscript have not changed, maybe some initscript went mad when it
> > could not parse the new kernel version number?
> >
> > Christian.
> 
> It's not that either... Arch has been using 3.0+ as it's default for a
> few weeks now, so they would've updated their scripts for that.
> Furthermore, I tried using OpenRC (the gentoo init system) and got the
> same results.
> 

-- 
BOFH excuse #359:

YOU HAVE AN I/O ERROR -> Incompetent Operator error
