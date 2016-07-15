From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: short-cut orphan cleanup on error
Date: Thu, 14 Jul 2016 23:49:04 -0400
Message-ID: <20160715034904.GC26465@thunk.org>
References: <1468104604-18997-1-git-send-email-vegard.nossum@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbcGODtK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jul 2016 23:49:10 -0400
Content-Disposition: inline
In-Reply-To: <1468104604-18997-1-git-send-email-vegard.nossum@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jul 10, 2016 at 12:50:04AM +0200, Vegard Nossum wrote:
> If we encounter a filesystem error during orphan cleanup, we should stop.
> Otherwise, we may end up in an infinite loop where the same inode is
> processed again and again.
> 
>     EXT4-fs (loop0): warning: checktime reached, running e2fsck is recommended
>     EXT4-fs error (device loop0): ext4_mb_generate_buddy:758: group 2, block bitmap and bg descriptor inconsistent: 6117 vs 0 free clusters
>     Aborting journal on device loop0-8.
>     EXT4-fs (loop0): Remounting filesystem read-only
>     EXT4-fs error (device loop0) in ext4_free_blocks:4895: Journal has aborted
>     EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
>     EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
>     EXT4-fs error (device loop0) in ext4_ext_remove_space:3068: IO failure
>     EXT4-fs error (device loop0) in ext4_ext_truncate:4667: Journal has aborted
>     EXT4-fs error (device loop0) in ext4_orphan_del:2927: Journal has aborted
>     EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
>     EXT4-fs (loop0): Inode 16 (00000000618192a0): orphan list check failed!
>     [...]
>     EXT4-fs (loop0): Inode 16 (0000000061819748): orphan list check failed!
>     [...]
>     EXT4-fs (loop0): Inode 16 (0000000061819bf0): orphan list check failed!
>     [...]
> 
> See-also: c9eb13a9105 ("ext4: fix hang when processing corrupted orphaned inode list")
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>

Applied, thanks.

							- Ted
