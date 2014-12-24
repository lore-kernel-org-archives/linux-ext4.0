From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Online resizing of filesystem mounted with backup superblock
 causes corruption
Date: Wed, 24 Dec 2014 17:33:16 -0500
Message-ID: <20141224223316.GD29088@thunk.org>
References: <5499ED8A.5010907@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Maxim Malkov <malkov@ispras.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42291 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbaLXWdV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Dec 2014 17:33:21 -0500
Content-Disposition: inline
In-Reply-To: <5499ED8A.5010907@ispras.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 24, 2014 at 01:32:42AM +0300, Maxim Malkov wrote:
> # mkfs.ext4 /dev/loop0 100M # adjust if necessary, should be less than
> partition size
> 
> Superblock backups stored on blocks:
>         8193, 24577, 40961, 57345, 73729
> (pick one)
> 
> # mount -t ext4 -o sb=40961 /dev/loop0 /media/
> # resize2fs /dev/loop0
> resize2fs 1.42.12 (29-Aug-2014)
> Filesystem at /dev/loop0 is mounted on /media; on-line resizing required
> old_desc_blocks = 1, new_desc_blocks = 4
> 
> Now, depending on your luck, various things may happen. resize2fs may hang.
> You might see BUG() in your dmesg. Either way, system will become
> severely corrupted (as indicated by fsck). You won't be able to mount
> it, either.

Thanks for the bug report; I've can reproduce this using a 3.18 based
kernel.

It may be that simplest bug fix is to simply disallow resizing if we
are using a backup superblock.

						- Ted
