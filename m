From: frankcmoeller@arcor.de
Subject: Aw: Re: Ext4: Slow performance on first write after mount
Date: Sun, 19 May 2013 21:36:02 +0200 (CEST)
Message-ID: <2107573271.1630063.1368992162152.JavaMail.ngmail@webmail18.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:44825 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab3ESTgD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 May 2013 15:36:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

> Simply adding "cat /proc/fs/<dev>/mb_groups > /dev/null" to one of the
> /etc/init.d scripts, or to /etc/rc.local is probably the simplest fix,
> yes.
Thanks for confirming that the workaround fixes the problem!

> Given the simple nature of the above workaround, it's not obvious to
> me that trying to make file system format changes, or even adding a
> new mount option, is really worth it.  This is especially true given
> that mount -a is sequential so if there are a large number of big file
> systems, using this as a mount option would be slow down the boot
> significantly.  It would be better to do this parallel, which you
> could do in userspace much more easily using the "cat
> /proc/fs/<dev>/mb_groups" workaround.
>From my point (end user) I would prefer a builtin solution. I'm also a
programmer and I can therefore understand why you don't want to change 
anything. It's a little bit surprising for me, that only few people seems to have 
this problem. But I believe that many live with it and don't know that the slow
boot or write is caused by ext4 (and many end user have small ext4 partitions
and servers are running 24/7 without remounting fs...). Only few applications 
rely on a constant write throughput.

> > - I can see (see debug output) that the call of ext4_wait_block_bitmap in
> mballoc.c line 848 takes during buffer cache initialization the longest time
> (some 1/100 of a second). Can this be improved?
> 
> The delay is caused purely by I/O delay, so short of replacing the HDD
> with a SSD, not really....
Well, SSDs are really cool, but for a PVR a hdd is still a good choice: Cheap,
big, more reliable (hopefully), quick enough and has no problems writing several 
GB data per day.

Regards,
Frank

> 
> Regards,
> 
> 						- Ted
> 
