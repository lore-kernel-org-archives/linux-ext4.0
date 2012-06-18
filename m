From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Kernel 3.3.8 breaks accidental ext3 mount of extended partition
Date: Mon, 18 Jun 2012 15:03:21 -0400
Message-ID: <x49fw9smohy.fsf@segfault.boston.devel.redhat.com>
References: <4FDEC3C2.4060909@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab2FRTD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 15:03:28 -0400
In-Reply-To: <4FDEC3C2.4060909@secunet.com> (Torsten Hilbrich's message of
	"Mon, 18 Jun 2012 07:59:30 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Torsten Hilbrich <torsten.hilbrich@secunet.com> writes:

> Hello,
>
> a software that tries to mount each existing partition as ext3 file
> system started to fail when updating from v3.3.7 to v3.3.8.
>
> The applications then hangs-up in the mount syscall, here is a
> snapshot of its stack at this moment:
>
> [<ffffffff81060c6a>] __cond_resched+0x2a/0x40
> [<ffffffff81134b3f>] __getblk+0x1bf/0x270
> [<ffffffff811362b3>] __bread+0x13/0xb0
> [<ffffffff81182222>] ext3_fill_super+0x132/0x1b00
> [<ffffffff8110891a>] mount_bdev+0x1aa/0x1f0
> [<ffffffff8117ffc5>] ext3_mount+0x15/0x20
> [<ffffffff81107fc3>] mount_fs+0x43/0x1a0
> [<ffffffff81123102>] vfs_kern_mount+0x72/0x100
> [<ffffffff81123882>] do_kern_mount+0x52/0x110
> [<ffffffff8112519a>] do_mount+0x25a/0x7d0
> [<ffffffff811257a8>] sys_mount+0x98/0xf0
> [<ffffffff814f3e92>] system_call_fastpath+0x16/0x1b
>
> The expected behaviour (which was still there in v3.3.7) is that the
> mount syscall fails because the partition contains no valid ext3 file
> system.
>
> I have create more snapshot of the stack in the following pastebin:
> http://pastebin.com/99x9EpnM
>
> Using bisecting I found the following commit to be the cause of the issue:
>
> commit 3735b0a1d73af536484ddefef4d8438dd468c4a6
> Author: Jeff Moyer <jmoyer@redhat.com>
> Date:   Fri May 11 16:34:10 2012 +0200
>
>     block: don't mark buffers beyond end of disk as mapped
>     
>     commit 080399aaaf3531f5b8761ec0ac30ff98891e8686 upstream.
>     
> Reverting this commit brought back the desired behaviour of the mount
> syscall failing because of invalid superblock.
>
> It seems to be that ext3_fill_super is unable to read the super block
> because there is no blocked for an extended partition.
>
> The same issue can be found in v3.4, where the upstream commit
> (080399aa) was released.

I am unable to reproduce this behaviour.  Can you give more information
about your storage configuration?  What is the partition layout, which
partition are you trying to mount, and are you using the standard mount
command to try to mount it?  Is there anything else you can provide that
would help me reproduce the problem?

Thanks,
Jeff
