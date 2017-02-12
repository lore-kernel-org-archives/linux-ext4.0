From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Sat, 11 Feb 2017 21:27:38 -0500
Message-ID: <20170212022738.vhr532yybcictgcz@thunk.org>
References: <20170211031942.11783-1-tytso@mit.edu>
 <FD2DE284-B640-4369-9A7C-E2224011541F@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59100 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751106AbdBLC1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 11 Feb 2017 21:27:41 -0500
Content-Disposition: inline
In-Reply-To: <FD2DE284-B640-4369-9A7C-E2224011541F@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 11, 2017 at 12:26:52AM -0700, Andreas Dilger wrote:
> The reason truncated orphans are on the orphan list is because the
> transaction that sets i_size may be restarted if the inode is larger
> than can be truncated in a single transaction.  If the system crashes
> before the truncate finishes then the truncate should be completed
> so that old data is not returned if the file is truncated larger again.

Another way of fixing this is at the time when the file is truncated
to a larger size.  Of course the other case we need handle is what
happens if there is data after i_size and the file is mmaped.

One advantage of doing when the file is truncated larger again is at
that point we will have the encryption key.  In the case of an
encrypted file, both the kernel and e2fsck *can't* zero fill past
i_size if the key is not available.  And during the orphan replay the
encryption key won't be available.

The other way to solve the problem would be zero the portion of the
last remaining datablock *first* and journal the data block along with
the initial transaction which sets the i_size in the inode.  But that
gets tricky, since all data writes for that last block must not go to
the disk, and then once the journal has been committed we can't write
the block to via the normal page_io routines (since otherwise it might
get overwritten), until we write it back and then revoke the block in
the journal, and the revoke is committed.  Messy....

In the mean time, given this is a denial of service attack, and this
is no worse than what e2fsck has been doing for years and years, we
need to skip the zero-fill for encrypted files if we don't have the
key, since crashing is not acceptable.

						- Ted
