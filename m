From: Jan Kara <jack@suse.cz>
Subject: Re: BUG in ext3_sync_fs
Date: Thu, 15 May 2008 16:35:50 +0200
Message-ID: <20080515143550.GA19325@atrey.karlin.mff.cuni.cz>
References: <19f34abd0805010433x7634666bpf7de34248a394480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: Vegard Nossum <vegard.nossum@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:38370 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbYEOOfv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 10:35:51 -0400
Content-Disposition: inline
In-Reply-To: <19f34abd0805010433x7634666bpf7de34248a394480@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> With current git (+ kmemcheck, see below) patches I get the following
> during boot:
> 
> BUG: unable to handle kernel paging request at 00001108
> IP: [<c04effcf>] ext3_sync_fs+0x3f/+x80
> 
> I inserted some printks in ext3_sync_fs():
>         printk(KERN_EMERG "sb = %p\n", sb);
>         printk(KERN_EMERG "sb->s_fs_info = %p\n", sb->s_fs_info);
> 
> And they show:
> sb = f7f61e00
> sb->s_fs_info = 00000000
> 
> Monitorshot: http://folk.uio.no/vegardno/linux/DSCF2905.JPG
> Config: http://folk.uio.no/vegardno/linux/config-20080501.txt
> 
> I am booting a USB stick with an ext2 filesystem as root partition. It
> mounts fine in other machines.
> 
> It could of course be my kmemcheck patches that are causing this
> (though I find it unlikely as they are disabled on boot => no-op, and
> everything was fine a couple of days ago), but recompiling this config
> takes a few hours, and I thought I'd just post early in case the
> problem is really with ext3.
> 
> I can send vmlinux image and/or disk image if necessary.
  Looks like a bug introduced by quota change - it should be fixed in
the current Linus's kernel. Thanks for report anyway.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
