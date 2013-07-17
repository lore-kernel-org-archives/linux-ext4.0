From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_release_space:1333: ext4_da_release_space: ino 12,
 to_free 1 with only 0 reserved data  blocks
Date: Wed, 17 Jul 2013 14:53:22 +0200
Message-ID: <20130717125322.GA29294@quack.suse.cz>
References: <20130716202533.GA16061@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab3GQMxZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jul 2013 08:53:25 -0400
Content-Disposition: inline
In-Reply-To: <20130716202533.GA16061@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-07-13 16:25:33, Dave Jones wrote:
> I've seen this happen a few times this week..
  Thanks for report! Was this when fuzzing or just normal desktop load?
What is inode with inode number 12 on your filesystem sdb1? What IO happens
to it? Apparently some delalloc accounting went wrong somewhere and it's
searching for a needle in a haystack unless we have more details...

								Honza
> 
> EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
> EXT4-fs warning (device sdb1): ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1 with only 0 reserved data  blocks
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 798 at fs/ext4/inode.c:1334 ext4_da_invalidatepage+0x39e/0x3c0()
> Modules linked in: btrfs snd_hda_codec_realtek xor snd_hda_intel snd_hda_codec snd_pcm raid6_pq libcrc32c zlib_deflate snd_pag e_alloc snd_timer edac_core snd pcspkr serio_raw soundcore r8169 mii sr_mod cdrom pata_atiixp radeon backlight drm_kms_helper ttm
> CPU: 3 PID: 798 Comm: fsx Not tainted 3.11.0-rc1+ #12
> Hardware name: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F12a 04/23/2010
>  ffffffff81a1bec7 ffff880126c81c18 ffffffff816b8a79 0000000000000000
>  ffff880126c81c50 ffffffff81043efc ffff88010b753020 0000000000000002
>  ffff88011bc237b0 ffff88011bc237b0 ffffea00045fbe00 ffff880126c81c60
> Call Trace:
>  [<ffffffff816b8a79>] dump_stack+0x4e/0x82
>  [<ffffffff81043efc>] warn_slowpath_common+0x8c/0xc0
>  [<ffffffff81043fea>] warn_slowpath_null+0x1a/0x20
>  [<ffffffff8124f1ae>] ext4_da_invalidatepage+0x39e/0x3c0
>  [<ffffffff81152b6e>] truncate_inode_page+0x8e/0x90
>  [<ffffffff81152f0a>] truncate_inode_pages_range+0x35a/0x650
>  [<ffffffff81153272>] truncate_pagecache+0x52/0x80
>  [<ffffffff81255f1d>] ext4_setattr+0x33d/0x840
>  [<ffffffff811d90a8>] notify_change+0x1d8/0x350
>  [<ffffffff811b91e9>] do_truncate+0x69/0x90
>  [<ffffffff811b953e>] do_sys_ftruncate.constprop.17+0x10e/0x160
>  [<ffffffff811b95ce>] SyS_ftruncate+0xe/0x10
>  [<ffffffff816ca8d4>] tracesys+0xdd/0xe2
> ---[ end trace 267735bac62efc6a ]---
> EXT4-fs warning (device sdb1): ext4_da_release_space:1333: ext4_da_release_space: ino 12, to_free 1 with only 0 reserved data blocks
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
