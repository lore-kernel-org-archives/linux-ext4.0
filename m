From: Jan Kara <jack@suse.cz>
Subject: Re: Is there any reason for us to use EXT4_MAXQUOTAS_INIT_BLOCKS?
Date: Wed, 15 Apr 2015 22:47:54 +0200
Message-ID: <20150415204754.GA13039@quack.suse.cz>
References: <20150415155537.GA32494@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbbDOUsA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Apr 2015 16:48:00 -0400
Content-Disposition: inline
In-Reply-To: <20150415155537.GA32494@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 15-04-15 11:55:37, Ted Tso wrote:
> It looks to me like EXT4_MAXQUOTAS_INIT_BLOCKS includes the credits
> neede to set up the quota records.  So if we move the call to
> dquot_initialize(inode) outside of the normal transaction (which we
> should probably do in all cases), that means that we shouldn't ever
> need to use EXT4_MAX_QUOTAS_INIT_BLOCKS.  Is that right?
  Correct. EXT4_MAX_QUOTAS_INIT_BLOCKS is only needed if we create the
first file for a user. So chown / chgrp may need this and inode creation
may need this. As you say, if dquot_init() is in a separate transaction,
then inode creation has to account only for a standard quota operation.

> The reason why I ask is the following is a easy way to trigger a file
> system problem:
> 
> mke2fs -Fq -t ext4 -b 4096 /dev/vdc 50M
> mount -t ext4 -o usrquota,grpquota /dev/vdc
> l8=12345678
> l16=$l8$l8
> l32=$l16$l16
> l64=$l32$l32
> dmesg -n 7
> ln -s $l64 /vdc/link
> 
> This will result in:
> 
> [    5.229165] JBD2: ln wants too many credits (156 > 128)
> [    5.230194] EXT4-fs error (device vdc) in __ext4_new_inode:843: error 28
> 
> In other places where we are allocating a new inode (such as mknod),
> we're doing the following:
> 
> 	credits = EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
> 			EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3;
> 
> Which is 37 blocks, and I suspect that's still too darned much.  But
> if we don't need to use EXT4_MAXQUOTAS_INIT_BLOCKS in ext4_mknod(), we
> shouldn't be needing it in ext4_symlink(), either.
> 
> Am I missing anything?
  Yeah, the credit estimate in ext4_symlink():
credits = 4 + EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb) + EXT4_XATTR_TRANS_BLOCKS;
  is just too pessimistic. Actually what we need for long symlinks is only
credits for inode creation + addition to orphan list (so 4 +
EXT4_MAXQUOTAS_TRANS_BLOCKS -- sb, gdt, bitmap, inode). Then we stop the
transaction and add block to the symlink in a separate transaction. And
then we link symlink into a directory in yet another transaction.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
