From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: what should I do when an error occurred after write_begin()
Date: Mon, 04 Aug 2008 21:51:33 +0900
Message-ID: <4896FB55.60303@rs.jp.nec.com>
References: <20080718094315m-ota@mail.jp.nec.com> <20080721050452.GB3370@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:59673 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbYHDMvj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 08:51:39 -0400
In-Reply-To: <20080721050452.GB3370@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andreas,

Andreas Dilger wrote:
 > > On Jul 18, 2008  09:43 +0900, m-ota@ys.jp.nec.com wrote:
 >> >>  ext4 online defrag exchanges the data block in the following procedures.
 >> >>
 >> >>  1. Creates a temporary inode and allocates contiguous blocks.
 >> >>  2. Read data from original file to memory page by write_begin()
 >> >>  3. Swap the blocks between the original inode and the temporary inode.
 >> >>     Updates the extent tree and registers the block to transaction by
 >> >>     ext4_journal_dirty_metadata().
 >> >>  4. Write data in memory page to new blocks by write_end().
 >> >>
 >> >>  In the current implementation, when the block swap failed,
 >> >>  data could not move to the new block.
 >> >>  So the defrag process exits without calling write_end().
 >> >>  We try to defrag for the same file again, but the defrag process seems to stall.
 >> >>  After defrag process stalled, all acess to the file systems like "ls" command
 >> >>  also stall.
 >> >>  Both processes wait for unlock j_wait_transaction_locked.
 >> >>
 >> >>  If the block exchange between write_begin() and write_end() failed,
 >> >>  what should I do?
 > >
 > > It sounds like you are not closing the transaction correctly in the
 > > case of the failed block swap.
 > >
 > > One important rule when writing ext3/ext4 code is to try and ensure
 > > all possible failure conditions are handled BEFORE starting the journal
 > > operation.
 > >
 > > It does not seem necessary to do the allocation and writing of the
 > > temprorary inode under the same transaction as the block swapping
 > > as long as it is in the orphan inode list with i_nlink == 0.  A first
 > > transaction can be started to allocate the temporary inode, add it to
 > > the orphan list, and then close the transaction.  Then, if the system
 > > crashes during the defrag then the temporary inode will be removed at
 > > and all allocated blocks freed at e2fsck/remount time like an
 > > open-unlinked file would.
 > >

Ohta-san and I mistook in the previous mail.
In the current(v9) implementation, defrag never fails between write_begin()
and write_end(), because all possible failure conditions already have been
handled before write_begin().
So the transaction which starts in write_begin is always closed correctly
in defrag.  Sorry for the noise.

 > > The other question I had about the defragmenter is that it would be
 > > excellent if it is possible to "defragment" a block-mapped file into
 > > an extent-mapped file.  This should be relatively easy so long as there
 > > as the whole file is "defragmented" and then the i_block[] array is
 > > swapped with the original inode and EXT4_EXTENTS_FL is set on the inode.

Do you mean that the combination of defrag and migration in kernel space
not e4defrag command just calls migrate ioctl in user space to block mapped file to
extent mapped file then defrag it?
I'm not familiar with migration, but it sounds nice.
I'll try to consider about it.

Regards,
Akira Fujita
