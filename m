From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4: Slow performance on first write after mount
Date: Sun, 19 May 2013 10:00:23 -0400
Message-ID: <20130519140023.GB7183@thunk.org>
References: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: frankcmoeller@arcor.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49659 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab3ESOA2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 May 2013 10:00:28 -0400
Content-Disposition: inline
In-Reply-To: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 17, 2013 at 06:51:23PM +0200, frankcmoeller@arcor.de wrote:
> - Why do you throw away buffer cache and don't store it on disk during umount? The initialization of the buffer cache is quite awful for application which need a specific write throughput.
> - A workaround would be to read whole /proc/.../mb_groups file right after every mount. Correct?

Simply adding "cat /proc/fs/<dev>/mb_groups > /dev/null" to one of the
/etc/init.d scripts, or to /etc/rc.local is probably the simplest fix,
yes.

> - I can try to add a mount option to initialize the cache at mount time. Would you be interested in such a patch?

Given the simple nature of the above workaround, it's not obvious to
me that trying to make file system format changes, or even adding a
new mount option, is really worth it.  This is especially true given
that mount -a is sequential so if there are a large number of big file
systems, using this as a mount option would be slow down the boot
significantly.  It would be better to do this parallel, which you
could do in userspace much more easily using the "cat
/proc/fs/<dev>/mb_groups" workaround.

> - I can see (see debug output) that the call of ext4_wait_block_bitmap in mballoc.c line 848 takes during buffer cache initialization the longest time (some 1/100 of a second). Can this be improved?

The delay is caused purely by I/O delay, so short of replacing the HDD
with a SSD, not really....

Regards,

						- Ted
