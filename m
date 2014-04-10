From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 metadata corruption bug?
Date: Thu, 10 Apr 2014 10:03:16 -0400
Message-ID: <20140410140316.GD15925@thunk.org>
References: <20140409223820.GU10985@gradx.cs.jhu.edu>
 <CAGagf4eEzY4+3cfNWSEENTo1PKe40nq1Ne6ZzOLGm-O78W7RcA@mail.gmail.com>
 <20140410050428.GV10985@gradx.cs.jhu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@google.com>, Mike Rubin <mrubin@google.com>,
	Frank Mayhar <fmayhar@google.com>, admins@acm.jhu.edu,
	linux-ext4@vger.kernel.org
To: Nathaniel W Filardo <nwf@cs.jhu.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52528 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933829AbaDJODV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 10:03:21 -0400
Content-Disposition: inline
In-Reply-To: <20140410050428.GV10985@gradx.cs.jhu.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 01:04:28AM -0400, Nathaniel W Filardo wrote:
> We use QEMU directives like
> 
>         -drive format=raw,file=rbd:rbdafs-mirror/mirror-0,id=drive5,if=none,cache=writeback \
>         -device driver=ide-hd,drive=drive5,discard_granularity=512,bus=ahci0.3
> 
> We've never had, so far as I know, an unexpected shutdown of the QEMU
> process, so I don't think that unexpected loss of cache contents is to
> blame.
> 
> Perhaps the dmesg I sent was not representative; some days ago, we saw, only
> (comparatively!) late in the machine's uptime:
> 
> [309894.428685] EXT4-fs (sdd): pa ffff88000d9f9440: logic 832, phys.  957458972, len 192
> [309894.430023] EXT4-fs error (device sdd): ext4_mb_release_inode_pa:3729: group 29219, free 192, pa_free 191
> [309894.431822] Aborting journal on device sdd-8.
> [309894.442913] EXT4-fs (sdd): Remounting filesystem read-only
> 
> with Debian kernel 3.13.5-1; sdd here is the same filesystem as in the
> earlier dmesg.

What is your workload?  Can you reproduce this easily?  And can you
try using a local disk to see if the problem goes away, so we can
start to bisect which software components might be at fault?

I'm not aware of any corruption problem with a 3.13 based kernel which
matches your signature, and the ext4 errors that you are showing
(minor accounting discrepancies in the number free blocks and number
of free inodes between the allocation bitmap and the summary
statistics in the block group descriptors) is very closely matches the
signature of some part of the storage stack not honoring FLUSH CACHE
("barrier") operations, either by ignoring them completely, or
reordring writes across a barrier / flush cache request.

Cheers,

					- Ted
