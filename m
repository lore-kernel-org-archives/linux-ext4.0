From: Pedro Fonseca <pfonseca@mpi-sws.org>
Subject: Re: Data races in ext4
Date: Thu, 10 Apr 2014 17:40:54 +0200
Message-ID: <5346BB86.50001@mpi-sws.org>
References: <53446306.7020005@mpi-sws.org> <20140409213340.GB15303@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:56720 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaDJPlA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Apr 2014 11:41:00 -0400
In-Reply-To: <20140409213340.GB15303@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/09/2014 11:33 PM, Theodore Ts'o wrote:
> The ones relating to ext4_do_update_inode() and generic_fillattr()
> look fine to me.  Basically the first may happen if there are two
> CPU's simultaneously trying to update the on-disk data structure for
> an inode from the in-memory data structure, and that's not a problem
> since the in-memory data structure is always authoratative.  The
> second happens if someone tries to stat(2) an inode while some inode
> field is getting updated.  Most of the inode field updates will be for
> things like mtime and atime updates, or a chown or chmod, where a
> single field is getting updated, and that's not a problem since there
> is no guarantee which version of the inode information you'll get when
> you call stat(2) while the inode is getting modified out from under
> you.  It is possible that the userspace might see the i_blocks and
> i_size be out of sync, but I really can't bring myself to care about
> that.

Regarding the generic_fillattr() function, apart from the inconsistency 
between i_blocks/i_size, it looks like it can also cause wrong values to 
be returned because several of those fields are 64 bits. This means that 
each assignment gets converted into multiple instructions (in 32-bit 
architectures), allowing other instructions to interleave in between. 
For example, this is the assembly code I get when compiling 
generic_fillattr():
>     stat->atime = inode->i_atime;
> c10aa017:   8b 48 3c                mov    0x3c(%eax),%ecx
> c10aa01a:   8b 58 40                mov    0x40(%eax),%ebx
> c10aa01d:   89 4a 28                mov    %ecx,0x28(%edx)
> c10aa020:   89 5a 2c                mov    %ebx,0x2c(%edx)
>     stat->mtime = inode->i_mtime;
> c10aa023:   8b 48 44                mov    0x44(%eax),%ecx
> c10aa026:   8b 58 48                mov    0x48(%eax),%ebx
> c10aa029:   89 4a 30                mov    %ecx,0x30(%edx)
> c10aa02c:   89 5a 34                mov    %ebx,0x34(%edx)
>     stat->ctime = inode->i_ctime;
> c10aa02f:   8b 48 4c                mov    0x4c(%eax),%ecx
> c10aa032:   8b 58 50                mov    0x50(%eax),%ebx
> c10aa035:   89 4a 38                mov    %ecx,0x38(%edx)
> c10aa038:   89 5a 3c                mov    %ebx,0x3c(%edx)
...
>     stat->blocks = inode->i_blocks;
> c10aa048:   8b 58 60                mov    0x60(%eax),%ebx
> c10aa04b:   8b 48 5c                mov    0x5c(%eax),%ecx
> c10aa04e:   89 5a 48                mov    %ebx,0x48(%edx)
> c10aa051:   89 4a 44                mov    %ecx,0x44(%edx)


I still don't understand why the races in ext4_do_update_inode() won't 
cause problems. Similarly to generic_fillattr(), in 
ext4_do_update_inode() wrong values can end up being written to the 
inode fields. Is there some mechanism to recover/ignore these values 
that I'm missing?


> As for the rest, some are obviously false positives.  For example, if
> you take a look at:
>
> Variable: journal->j_running_transaction	Addresses: c1138ca1 c1136b02 c1136ca9
> c1136ca9 jbd2_get_transaction /linux-3.13.5/fs/jbd2/transaction.c:103
> c1138ca1 jbd2_journal_commit_transaction /linux-3.13.5/fs/jbd2/commit.c:539
> c1136b02 start_this_handle /linux-3.13.5/fs/jbd2/transaction.c:280
>
> It's obvious from the code path that start_this_handle() is extremely
> careful to always revalidate j_running_transaction after either (a)
> taking a read lock on the j_state_lock for the first time, or (b)
> after dropping the read_lock and grabbing a write_lock on
> j_state_lock, and if things have changed, it loops and tries again.
You're right, start_this_handle() revalidates the value read so I also 
don't see harm in this race.


> There are a couple that require some closer examination; for some of
> them, for example the two reported cases of ext4_isize_set() vs
> ext4_isize(), having the stack trace would be really helpful.

Those two pairs of functions were actually also called from the 
ext4_do_update_inode() function:
> 4338     if (ei->i_disksize != ext4_isize(raw_inode)) {
> 4339         ext4_isize_set(raw_inode, ei->i_disksize);
> 4340         need_datasync = 1;
> 4341     }

So the top part of the stack trace is:
   ext4_mark_inode_dirty() -> ext4_mark_iloc_dirty() -> 
ext4_do_update_inode() -> ext4_isize()
   ext4_mark_inode_dirty() -> ext4_mark_iloc_dirty() -> 
ext4_do_update_inode() -> ext4_isize_set()




