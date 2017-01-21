From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 deadlock (+lockdep splat) during rsync
Date: Sat, 21 Jan 2017 08:30:49 -0500
Message-ID: <20170121133049.bsrp55gi4x5x5wcv@thunk.org>
References: <20170120144026.bvg2mpe3uvb5yspi@thunk.org>
 <20170120175723.17324.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, linux-ext4@vger.kernel.org
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:39740 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdAUNay (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 21 Jan 2017 08:30:54 -0500
Content-Disposition: inline
In-Reply-To: <20170120175723.17324.qmail@ns.sciencehorizons.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 20, 2017 at 12:57:23PM -0500, George Spelvin wrote:
> So I'm guessing the problem is that the required empty system.data
> attribute is missing (due to the preceding extra_isize changing mess),
> and if I just created it, everything would magically come back to life
> 
> Something like ea_set <inode> system.data ""

Well, it would still a corrupted, innconsistent inode, in that there
would still be a block attached to the inode, and i_size would be
different from the size of the data xattr used by inline_data.  So you
might as well just clri the inode and rerun fsck, or clri the inode
and then unlink the directory entry in lost+found.

You might get it to a state where the kernel isn't explicitly
complaining any more, but you might end up unmasking other bugs where
the kernel is further failing to handle an inconsistent inode relating
to inline_data.  Which is fine if you want to potentially exposing
more problems, but if this is file system with Data You Care about, my
suggestsion to run debugfs's clri and then e2fsck -f really is the
most conservative advice to give.

					- Ted
