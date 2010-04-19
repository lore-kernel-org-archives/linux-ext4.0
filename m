From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: busy inodes -> ext3 umount crash
Date: Mon, 19 Apr 2010 16:33:24 +0200
Message-ID: <4BCC69B4.2050308@gmail.com>
References: <4BC8A7C1.20102@gmail.com> <20100419141158.GB5439@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com,
	linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	mszeredi@suse.cz
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:65498 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab0DSOd3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Apr 2010 10:33:29 -0400
In-Reply-To: <20100419141158.GB5439@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/19/2010 04:11 PM, Jan Kara wrote:
>> I have no idea how to reproduce it :(, but it usually happens when I do
>> shutdown/kexec.
>   If it's the patch I suspect above, then moving one directory over another
> one might trigger the leak which would be later spotted on umount of the
> filesystem. Or maybe to trigger the leak you have to have a process which
> has its CWD in the directory you are going to delete by the rename... not
> sure.

The trigger for busy inodes is as simple as (I=initialization done only
once):
I> # dd if=/dev/zero of=/dev/shm/ext3 bs=1024 count=1 seek=$((100*1024))
I> # mkfs.ext3 -m 0 /dev/shm/ext3
# mount -oloop /dev/shm/ext3 /mnt/c
# umount /mnt/c
# dmesg|tail
VFS: Busy inodes after unmount of loop0. Self-destruct in 5 seconds.
Have a nice day...

(The printk time varies -- this sequence really suffices.)

> So if you can easily reproduce
> the "busy inodes" message then I'd start with debugging that one. Do you
> see it also with vanilla kernels?

I don't know, now I'm going to play with that as I have the trigger ;).
Will be back soon.

thanks,
-- 
js
