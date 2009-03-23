From: Theodore Tso <tytso@mit.edu>
Subject: Re: Severe data corruption with ext4
Date: Sun, 22 Mar 2009 22:05:22 -0400
Message-ID: <20090323020522.GF29466@mit.edu>
References: <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com> <20090320030121.1fa8e6d3.akpm@linux-foundation.org> <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com> <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Richard <richard@r-selected.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59393 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZCWCF1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Mar 2009 22:05:27 -0400
Content-Disposition: inline
In-Reply-To: <b2080d80903220626s5fffdbf3i907cb4b215670ce6@mail.gmail.com> <b2080d80903200244u7fbcc150g6724a84c9b3b2054@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 20, 2009 at 10:44:02AM +0100, Richard wrote:
> Mar 19 08:42:43 bakunin kernel: BUG: scheduling while atomic:
> install-info/27020/0x00000002

This was casued by the call to ext4_error(); the "scheduling while
atomic" BUG error was fixed in 2.6.29-rc1:

commit 5d1b1b3f492f8696ea18950a454a141381b0f926
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Mon Jan 5 22:19:52 2009 -0500

    ext4: fix BUG when calling ext4_error with locked block group
    
    The mballoc code likes to call ext4_error while it is holding locked
    block groups.  This can causes a scheduling in atomic context BUG.  We
    can't just unlock the block group and relock it after/if ext4_error
    returns since that might result in race conditions in the case where
    the filesystem is set to continue after finding errors.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


It's going to be moderately painful to backport this to 2.6.28 and
2.6.27, but we can look into it.

> Looking into /var/log/kernel.log, I found the following message:
> 
> Mar 19 08:42:43 bakunin kernel: EXT4-fs error (device dm-13):
> ext4_mb_generate_buddy: EXT4-fs: group 0: 16470 blocks in bitmap, 4354
> in gd

This was caused by an on-disk filesystme corruption which mballoc
detected, which flagged an EXT4 error, which then triggered the BUG.

> Mar 19 08:42:48 bakunin kernel: EXT4-fs error (device dm-13):
> mb_free_blocks: double-free of inode 0's block 11457(bit 11457 in
> group 0)
> Mar 19 08:42:48 bakunin kernel:

More evidence of on-disk filesystem corruption....

> Using "dmsetup ls", I figured that dm-13 was /usr; so I fsck'd it.
> fsck revealed hundreds of errors, which I let "fsck -y" fix automatically.
> Now there's plenty (more than 250) of files and directories in /usr/lost+found.

Sounds like an inode table got corrupted.

> Mar 19 00:04:51 bakunin kernel: init_special_inode: bogus i_mode (336)

Yeah, we have a patch queued up so we can identified the bad inode
number that caused that, but it points to more inode table corruption.

> Hello again,
> 
> now on the same system (hardware configuration unchanged, except that
> I attached a DVD burner yesterday), I got dozens of errors like these:
> 
> ----------
> Mar 22 13:47:33 bakunin kernel: __find_get_block_slow() failed.
> block=197478301302784, b_blocknr=0
> Mar 22 13:47:33 bakunin kernel: b_state=0x00188021, b_size=4096
> Mar 22 13:47:33 bakunin kernel: device blocksize: 4096
> Mar 22 13:47:33 bakunin kernel: __find_get_block_slow() failed.
> block=197478301302784, b_blocknr=0
> Mar 22 13:47:33 bakunin kernel: b_state=0x00188021, b_size=4096
> Mar 22 13:47:33 bakunin kernel: device blocksize: 4096
> Mar 22 13:47:33 bakunin kernel: grow_buffers: requested out-of-range
> block 197478301302784 for device dm-14
> Mar 22 13:47:33 bakunin kernel: EXT4-fs error (device dm-14):
> ext4_xattr_delete_inode: inode 1022: block 197478301302784 read error

That's another indication of data corruption in inode 1022.  This
could be hardware induced corruption; or it could be a software
induced error.  There's been one other user with a RAID that had
reported a strange corruption near the beginning of the filesystem, in
the inode table.  How big is your filesystem, exactly?  It could be
something that only shows up with sufficiently large filesystems, or
it could be a hardware problem.

Can you send me the output of dumpe2fs of the filesystem in question?
And something that would be worth doing is to use debugfs like this:

debugfs /dev/XXXX

debugfs: imap <1022>

you'll see something like this:

Inode 1022 is part of block group 0
      located at block 128, offset 0x0d00

Take the block number, and then use it as follows:

dd if=/dev/XXXX of=itable.img bs=4k count=1 skip=128

Where the parameter to "skip=NNN" should be replaced with the block
number reported by debugfs's imap command.

Thanks,

						- Ted
