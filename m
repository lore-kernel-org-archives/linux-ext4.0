From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 0/3] ext4 crypto: back up encrypted files
Date: Wed, 16 Dec 2015 16:10:10 +0100
Message-ID: <20151216151010.GB16918@quack.suse.cz>
References: <1449759879-2166-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLPPKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 10:10:13 -0500
Content-Disposition: inline
In-Reply-To: <1449759879-2166-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 10-12-15 10:04:36, Ted Tso wrote:
> This patches allow backing up encrypted files without having access to
> the key.  Unfortunately, the key *is* necessary to restore the files,
> because establishing a link means that we have to manipulate the both
> the encrypted directory and the encrypted file, and doing this through
> the VFS interface is non-trivial.  So we have an ioctl which extracts
> the encrypted file name, and that in combination with the encryption
> metadata for the directory should be sufficient to restore the file
> name assuming the restore is done with access to the user's master
> key.
> 
> The other tricky bit is that if the file's i_size is not a multiple of
> the AES block size, we need to be able to copy a handful of bytes
> before i_size --- and O_DIRECT reads don't allow that.  There are two

Umm, I don't quite follow. O_DIRECT reads will actually read final file
block in full even if i_size is somewhere in the middle of it. We then
report only data upto i_size as transferred but that's not really
important for you. That being said I agree that relying on this is hacky
but for direct IO it kind of makes sense and creating special shadow
inode is IMO even bigger hack...

> ways of solving this.  One would be an new DIO_FLAG that rounds i_size
> up to the file system blocksize, which we would pass when reading
> encrypted files using O_DIRECT.  This would require changes to the
> core direct I/O, and may be controversial.  It also may make it more
> difficult to back port these patches to ancient BSP kernels.
> 
> So what we're doing for now is admittedly a hack.  Since encrypted
> files are read-only without access to the key, it is safe to create a
> shadow copy of the inode structure, and round up i_size in the shadow
> structure.  We only do this when reading the last block in the file,
> so the overhead shouldn't be too bad.

I'm rather concerned about the locking implications of the shadow inode.
For example holding i_data_sem for reading in ext4_get_blocks() no longer
protects against changes of inode allocation information. Thus if e.g.
another process does mmaped write allocating more blocks, we can see
inconsistent extent tree from direct read. And that's just one example of
problems we can hit, I'm not sure there are not others.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
