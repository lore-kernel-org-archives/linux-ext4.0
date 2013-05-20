From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Ext4: Slow performance on first write after mount
Date: Mon, 20 May 2013 00:39:50 -0600
Message-ID: <FB0094B8-15F8-4190-ABC6-2C06C6BC2521@dilger.ca>
References: <1679869241.585607.1368809483337.JavaMail.ngmail@webmail12.arcor-online.net> <20130519140023.GB7183@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "frankcmoeller@arcor.de" <frankcmoeller@arcor.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56202 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3ETGju convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 May 2013 02:39:50 -0400
Received: by mail-pa0-f51.google.com with SMTP id ld10so5361673pab.38
        for <linux-ext4@vger.kernel.org>; Sun, 19 May 2013 23:39:49 -0700 (PDT)
In-Reply-To: <20130519140023.GB7183@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-05-19, at 8:00, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, May 17, 2013 at 06:51:23PM +0200, frankcmoeller@arcor.de wrote:
>> - Why do you throw away buffer cache and don't store it on disk during umount? The initialization of the buffer cache is quite awful for application which need a specific write throughput.
>> - A workaround would be to read whole /proc/.../mb_groups file right after every mount. Correct?
> 
> Simply adding "cat /proc/fs/<dev>/mb_groups > /dev/null" to one of the
> /etc/init.d scripts, or to /etc/rc.local is probably the simplest fix,
> yes.
> 
>> - I can try to add a mount option to initialize the cache at mount time. Would you be interested in such a patch?
> 
> Given the simple nature of the above workaround, it's not obvious to
> me that trying to make file system format changes, or even adding a
> new mount option, is really worth it.  This is especially true given
> that mount -a is sequential so if there are a large number of big file
> systems, using this as a mount option would be slow down the boot
> significantly.  It would be better to do this parallel, which you
> could do in userspace much more easily using the "cat
> /proc/fs/<dev>/mb_groups" workaround.

Since we already have a thread starting at mount time to check the
inode table zeroing, it would also be possible to co-opt this thread
for preloading the group metadata from the bitmaps. 

>> - I can see (see debug output) that the call of ext4_wait_block_bitmap in mballoc.c line 848 takes during buffer cache initialization the longest time (some 1/100 of a second). Can this be improved?
> 
> The delay is caused purely by I/O delay, so short of replacing the HDD
> with a SSD, not really....

Well, with a larger flex_bg factor at format time there will be more
bitmaps allocated together on disk, so fewer seeks needed to load
them after a new mount. We use a flex_bg factor of 256 for this
reason on our very large storage targets.

Cheers, Andreas