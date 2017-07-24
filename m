From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: eliminate bad update link count attempt
Date: Mon, 24 Jul 2017 00:11:53 -0400
Message-ID: <20170724041153.o7q6m3svvjkgrmkr@thunk.org>
References: <20170717125035.12852-1-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52766 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbdGXELy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 24 Jul 2017 00:11:54 -0400
Content-Disposition: inline
In-Reply-To: <20170717125035.12852-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 17, 2017 at 05:50:35AM -0700, Tahsin Erdogan wrote:
> Extended attribute inodes have a link count of 1 but they are not
> attached to any directories. When an xattr inode with zero ea
> references is found, the remedy is to reconnect it to lost+found dir.
> Since reconnect operation increments the link count, it would normally
> become 2 but to avoid that, check_ea_inode() sets the link count to
> zero in anticipation of reconnect operation. And it does it even when
> e2fsck is invoked with -n option which causes a fatal e2fsck failure
> as can be demonstrated with the following test script:
> 
>   mke2fs -b 4096 -I 256 -F -O extent,ea_inode /dev/sdb 1G
>   mount /dev/sdb /mnt/sdb
>   touch /mnt/sdb/x
>   setfattr -n user.ie1 -v $(python -c "print 'v'*5000") /mnt/sdb/x
>   umount /dev/sdb
>   debugfs -w -R 'rm x' /dev/sdb
>   e2fsck -f -n /dev/sdb
> 
> In this case, e2fsck fails with the following error:
> 
>   e2fsck 1.43.5-WIP (17-Feb-2017)
>   Pass 1: Checking inodes, blocks, and sizes
>   Pass 2: Checking directory structure
>   Pass 3: Checking directory connectivity
>   Pass 4: Checking reference counts
>   ext2fs_write_inode: Attempt to write to filesystem opened read-only
>   while writing inode 13 in check_ea_inode
>   e2fsck: aborted
> 
> Setting link count to zero is not really required because e2fsck will
> detect the discrepancy in link count and offer to fix it.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, applied.

					- Ted
