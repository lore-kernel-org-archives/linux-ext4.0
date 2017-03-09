From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Thu, 9 Mar 2017 14:47:20 +0100
Message-ID: <20170309134720.GJ15874@quack2.suse.cz>
References: <20170211031942.11783-1-tytso@mit.edu>
 <FD2DE284-B640-4369-9A7C-E2224011541F@dilger.ca>
 <20170212022738.vhr532yybcictgcz@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48465 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754427AbdCIOYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 9 Mar 2017 09:24:01 -0500
Content-Disposition: inline
In-Reply-To: <20170212022738.vhr532yybcictgcz@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 11-02-17 21:27:38, Ted Tso wrote:
> On Sat, Feb 11, 2017 at 12:26:52AM -0700, Andreas Dilger wrote:
> > The reason truncated orphans are on the orphan list is because the
> > transaction that sets i_size may be restarted if the inode is larger
> > than can be truncated in a single transaction.  If the system crashes
> > before the truncate finishes then the truncate should be completed
> > so that old data is not returned if the file is truncated larger again.
> 
> Another way of fixing this is at the time when the file is truncated
> to a larger size.  Of course the other case we need handle is what
> happens if there is data after i_size and the file is mmaped.
> 
> One advantage of doing when the file is truncated larger again is at
> that point we will have the encryption key.  In the case of an
> encrypted file, both the kernel and e2fsck *can't* zero fill past
> i_size if the key is not available.  And during the orphan replay the
> encryption key won't be available.
> 
> The other way to solve the problem would be zero the portion of the
> last remaining datablock *first* and journal the data block along with
> the initial transaction which sets the i_size in the inode.  But that
> gets tricky, since all data writes for that last block must not go to
> the disk, and then once the journal has been committed we can't write
> the block to via the normal page_io routines (since otherwise it might
> get overwritten), until we write it back and then revoke the block in
> the journal, and the revoke is committed.  Messy....

Going through some old email... I don't think this would be really
reasonably doable. What would fixup the missing zeroing on orphan cleanup
though is to zero the tail of the last page on readpage, extending
truncate and write beyond EOF. That may be acceptable cost for encrypted
inodes. 

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
