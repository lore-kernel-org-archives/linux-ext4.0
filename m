From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e4defrag: Corrupt file after running e4defrag
Date: Thu, 8 Jun 2017 18:35:11 -0400
Message-ID: <20170608223511.2dw7gyqzgwgxxz2q@thunk.org>
References: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34238 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751598AbdFHWfT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 8 Jun 2017 18:35:19 -0400
Content-Disposition: inline
In-Reply-To: <a9518dce-b61a-3c28-b597-f21b6db9be0a@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 08, 2017 at 03:12:27PM +0100, Marc Thomas wrote:
> Hello All,
> 
> After running "e4defrag" on an idle filesystem, I found a single file
> out of 893084 regular files had become corrupt (md5sum changed).
> I have repeated the process using an almost identical copy of the
> original filesystem, and a different single file became corrupt.

How big is the file system, and what file system features are enabled.
Can you send me a copy of "dumpe2fs -h" on the file system?  Something
else that would be useful would be to unmount the file system after
seeing the md5sum failure, and run e2fsck -fn to see if e2fsck noticed
any file system corruption.

I don't know if this will be doable, since it depends on how big the
file system is and how much extra space you have in your LVM volume
group, but what would be *wonderful* would be if you can do a full
image backup, or failing that, an compressed raw e2image backup (see
the e2image man page, or the "REPORTING BUGS" section of the e2fsck
man page).  The compressed raw e2image backup only contains the file
system metadata, and no the data blocks, so it takes much less space.

The idea then is after you discover which file is getting corrupted,
you can look that inode both on the "before" file system image
(looking only at the metadata blocks) and the "after" file system
image, and see if there are any clues about how to make a reproducible
test case, using the "stat" command of debugfs.  Getting a full
dumpe2fs output of the filesystem before and after might give us a
clue.

Thanks,

					- Ted
