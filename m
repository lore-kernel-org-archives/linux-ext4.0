From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug in mount options handling in EXT4?
Date: Wed, 04 Feb 2015 21:57:24 -0600
Message-ID: <54D2EA24.70206@redhat.com>
References: <alpine.LNX.2.03.1502050418390.11412@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: linux-ext4@vger.kernel.org
To: Enrico Mioso <mrkiko.rs@gmail.com>, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbbBED52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Feb 2015 22:57:28 -0500
In-Reply-To: <alpine.LNX.2.03.1502050418390.11412@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/4/15 9:22 PM, Enrico Mioso wrote:
> Hello guys.
> I noticed from some time, that I can make mount options accumulate simply continously repeating them.
> By typing:
> sudo mount -t ext4 -o rw,noatime,nobarrier,nobarrier,nobarrier, ...
> I can get:
> $ dmesg | tail
> [  216.075581] EXT4-fs (sdb): mounted filesystem without journal. Opts: nobarrier
> [  472.851105] snd_hda_intel 0000:00:1b.0: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
> [41950.250515] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
> [42093.049879] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
> [42095.673967] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
> [42095.954595] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
> [42096.220220] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier
> [42103.212371] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier
> [42128.137609] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier
> [42144.960612] EXT4-fs (sdc1): re-mounted. Opts: nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier,nobarrier

Hm, yes, it's really only cosmetic in that printk.

> But the problem seems limited to the filesystem messages / something like that:
> $ cat /proc/mounts

...

> /dev/sdc1 /mnt/trekstor ext4 rw,noatime,nobarrier 0 0

Yep, because when this is printed, it simply looks at the set option flags,
and essentially prints the option name once for each (non-default) flag
that is set.

What we probably would want is something similar to that code (in
_ext4_show_options) which is more generic, and could generate a string
for use in the remount case as well.

-Eric

