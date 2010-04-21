From: Eric Paris <eparis@redhat.com>
Subject: Re: busy inodes -> ext3 umount crash
Date: Wed, 21 Apr 2010 11:24:10 -0400
Message-ID: <1271863450.2899.12.camel@dhcp235-240.rdu.redhat.com>
References: <4BC8A7C1.20102@gmail.com> <20100419141158.GB5439@quack.suse.cz>
	 <4BCC69B4.2050308@gmail.com> <4BCDB633.9040901@gmail.com>
	 <20100420152844.GB3885@quack.suse.cz>  <4BCF16CE.2080403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	mszeredi@suse.cz
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab0DUPYY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 11:24:24 -0400
In-Reply-To: <4BCF16CE.2080403@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-04-21 at 17:16 +0200, Jiri Slaby wrote:
> On 04/20/2010 05:28 PM, Jan Kara wrote:
> > On Tue 20-04-10 16:12:03, Jiri Slaby wrote:
> >> On 04/19/2010 04:33 PM, Jiri Slaby wrote:
> >>> The trigger for busy inodes is as simple as (I=initialization done only
> >>> once):
> >>> I> # dd if=/dev/zero of=/dev/shm/ext3 bs=1024 count=1 seek=$((100*1024))
> >>> I> # mkfs.ext3 -m 0 /dev/shm/ext3
> >>> # mount -oloop /dev/shm/ext3 /mnt/c
> >>> # umount /mnt/c
> >>> # dmesg|tail
> >>> VFS: Busy inodes after unmount of loop0. Self-destruct in 5 seconds.
> >>> Have a nice day...
> >>>
> >>> (The printk time varies -- this sequence really suffices.)
> >>
> >> Well, this happens only after gnome-session is started and it's fuzzy --
> >> sometimes it happens, sometimes not. I didn't find 100% trigger yet.
> >   Hmph - maybe something in inotify? Dunno...
> 
> fsnotify...
> 
> >>>> So if you can easily reproduce
> >>>> the "busy inodes" message then I'd start with debugging that one. Do you
> >>>> see it also with vanilla kernels?
> >>
> >> Vanilla seems not to be affected. It's in next/master already though
> >> (2603ecd9). I'll investigate it further later.
> >   Do you mean it's in today's linux-next but not in Linus' tree?
> 
> Yes, exactly.
> 
> And the winner is (seemingly):
> commit 69c1182c4e5d8b7da772ddad512c6f6b67ec1bb8
> Author: Eric Paris <eparis@redhat.com>
> Date:   Thu Dec 17 21:24:27 2009 -0500
> 
>     fsnotify: vfsmount marks generic functions
> 
>     Much like inode-mark.c has all of the code dealing with marks on inodes
>     this patch adds a vfsmount-mark.c which has similar code but is intended
>     for marks on vfsmounts.
> 
>     Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> 
> I can't verify it by reverting on the top of -mm as it doesn't revert
> cleanly. Do you see any bug in there?

You cannot revert, but you can certainly reset --hard before and after
this patch.  I'll take a look, but I'm not seeing a problem right off
hand.  This patch wasn't supposed to mess with inode refcounting at
all....

-Eric

