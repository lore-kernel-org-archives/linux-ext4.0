From: Jan Kara <jack@suse.cz>
Subject: Re: busy inodes -> ext3 umount crash
Date: Tue, 20 Apr 2010 17:28:44 +0200
Message-ID: <20100420152844.GB3885@quack.suse.cz>
References: <4BC8A7C1.20102@gmail.com>
 <20100419141158.GB5439@quack.suse.cz>
 <4BCC69B4.2050308@gmail.com>
 <4BCDB633.9040901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	adilger@sun.com, linux-ext4@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	mszeredi@suse.cz
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab0DTP2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 11:28:45 -0400
Content-Disposition: inline
In-Reply-To: <4BCDB633.9040901@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 20-04-10 16:12:03, Jiri Slaby wrote:
> On 04/19/2010 04:33 PM, Jiri Slaby wrote:
> > The trigger for busy inodes is as simple as (I=initialization done only
> > once):
> > I> # dd if=/dev/zero of=/dev/shm/ext3 bs=1024 count=1 seek=$((100*1024))
> > I> # mkfs.ext3 -m 0 /dev/shm/ext3
> > # mount -oloop /dev/shm/ext3 /mnt/c
> > # umount /mnt/c
> > # dmesg|tail
> > VFS: Busy inodes after unmount of loop0. Self-destruct in 5 seconds.
> > Have a nice day...
> > 
> > (The printk time varies -- this sequence really suffices.)
> 
> Well, this happens only after gnome-session is started and it's fuzzy --
> sometimes it happens, sometimes not. I didn't find 100% trigger yet.
  Hmph - maybe something in inotify? Dunno...

> >> So if you can easily reproduce
> >> the "busy inodes" message then I'd start with debugging that one. Do you
> >> see it also with vanilla kernels?
> 
> Vanilla seems not to be affected. It's in next/master already though
> (2603ecd9). I'll investigate it further later.
  Do you mean it's in today's linux-next but not in Linus' tree?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
