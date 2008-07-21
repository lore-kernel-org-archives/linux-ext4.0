From: Andreas Dilger <adilger@sun.com>
Subject: Re: what should I do when an error occurred after write_begin()
Date: Sun, 20 Jul 2008 23:04:52 -0600
Message-ID: <20080721050452.GB3370@webber.adilger.int>
References: <20080718094315m-ota@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: m-ota@ys.jp.nec.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57740 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbYGUFEz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:04:55 -0400
In-reply-to: <20080718094315m-ota@mail.jp.nec.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  09:43 +0900, m-ota@ys.jp.nec.com wrote:
>  ext4 online defrag exchanges the data block in the following procedures.
>  
>  1. Creates a temporary inode and allocates contiguous blocks.
>  2. Read data from original file to memory page by write_begin()
>  3. Swap the blocks between the original inode and the temporary inode.
>     Updates the extent tree and registers the block to transaction by
>     ext4_journal_dirty_metadata().
>  4. Write data in memory page to new blocks by write_end().
>  
>  In the current implementation, when the block swap failed,
>  data could not move to the new block.
>  So the defrag process exits without calling write_end().
>  We try to defrag for the same file again, but the defrag process seems to stall.
>  After defrag process stalled, all acess to the file systems like "ls" command
>  also stall.
>  Both processes wait for unlock j_wait_transaction_locked.
>  
>  If the block exchange between write_begin() and write_end() failed,
>  what should I do?

It sounds like you are not closing the transaction correctly in the
case of the failed block swap.

One important rule when writing ext3/ext4 code is to try and ensure
all possible failure conditions are handled BEFORE starting the journal
operation.

It does not seem necessary to do the allocation and writing of the
temprorary inode under the same transaction as the block swapping
as long as it is in the orphan inode list with i_nlink == 0.  A first
transaction can be started to allocate the temporary inode, add it to
the orphan list, and then close the transaction.  Then, if the system
crashes during the defrag then the temporary inode will be removed at
and all allocated blocks freed at e2fsck/remount time like an
open-unlinked file would.

Multiple transactions may be needed for doing the file copying, depending
on the size of the blocks being copied.  Lustre could always do 1MB writes
in a single transaction without problems, without doing data journaling.
You can try to start a single transaction large enough to allocate, say,
min(file size, 4MB) blocks, and then if journal_start() returns -ENOSPC
reduce the allocation size by 1/2 each time.  A separate transaction can
be used to do the copying of the data into the temporary inode (with
journal_dirty_metadata() as you say to avoid the need to always fsync).


Then, once the copy is finished a separate transaction should be started
to do the final swapping of the i_block[] array in the inode and freeing
of the temporary inode.  It shouldn't really be possible to fail at that
point.

The other question I had about the defragmenter is that it would be
excellent if it is possible to "defragment" a block-mapped file into
an extent-mapped file.  This should be relatively easy so long as there
as the whole file is "defragmented" and then the i_block[] array is
swapped with the original inode and EXT4_EXTENTS_FL is set on the inode.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

