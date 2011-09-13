From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Bug In ext4 in kernels > 2.6.39 - Not mounting with arguments/options
 I specify in fstab on root remount
Date: Tue, 13 Sep 2011 03:25:48 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109130319100.9183@trent.utfs.org>
References: <4E6F1B49.3010803@gmail.com> <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Matt Parnell <mparnell@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:59331 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab1IMKZw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Sep 2011 06:25:52 -0400
In-Reply-To: <CABeR262=5V1wuXPDVr_qLTeFTc4zDSFKVYKvO_+1w60XmwJvKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 13 Sep 2011 at 04:01, Matt Parnell wrote:
> I know this isn't my initscripts, as I've also tried this using
> openrc, aside from the default arch init system, and because upon
> downgrading to 2.6.39 everything is working normally again, I know it

Did you try booting with init=/bin/bash, i.e. bypassing all initscripts? 
Also, try booting w/o an initrd image if you can, thus bypassing all the 
early boot magic.

Shot in the dark: if it worked with 2.6.39 but not with 3.x and the 
initscript have not changed, maybe some initscript went mad when it 
could not parse the new kernel version number?

Christian.
-- 
BOFH excuse #141:

disks spinning backwards - toggle the hemisphere jumper.
