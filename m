From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Does ext4 write anything during reading with relatime?
Date: Sun, 6 Dec 2015 16:14:54 -0500
Message-ID: <20151206211454.GB2614@thunk.org>
References: <5662C472.2050902@inbox.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: The Ghost <the-ghost@inbox.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41751 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbbLFVO5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Dec 2015 16:14:57 -0500
Content-Disposition: inline
In-Reply-To: <5662C472.2050902@inbox.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 05, 2015 at 02:03:14PM +0300, The Ghost wrote:
> When mounted read-only, naturally, reading from an ext4 filesystem does not
> cause any write operations. But if I mount it read-write and try to read
> from it, then apparently some write operations are issued, because my
> "write-mostly" drive in a RAID1 array spins up. Now, I understand that
> apparently the mount operation itself does write something, and I do mount
> it with a "relatime" option, but I'm just reading stuff over and over again
> - it shouldn't be caused by atime updating. Also, a bug with "write-mostly"
> finally got fixed, and I'm using a fixed kernel (latest 3.16 from Debian
> Jessie-backports).

Relatime doesn't guarantee that there will be _no_ atime updates.  You
would need to mount with noatime if you want to guarantee that there
will be zero atime updates.

Relatime will update atime if the file is accessed and the atime is
older than 24 hours.  This guarantees that atime is up to date to
approximately a day, so you can tell if a file has been accessed
recently.  This is useful for any system administrators.

But it does mean there will still be quite a bit of atime updates ---
especially since atime updates apply to directories as much as files.
Hence, if you haven't mounted the file system in 24 hours, and then
you run a find operation on the entire file system, the atime for
every single directory on the file system will need to be updated.

Cheers,

					- Ted
