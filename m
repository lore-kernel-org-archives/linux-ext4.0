From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v3 0/3] ext4 crypto: back up encrypted files
Date: Thu, 10 Dec 2015 10:04:36 -0500
Message-ID: <1449759879-2166-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50532 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbbLJPEo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 10:04:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patches allow backing up encrypted files without having access to
the key.  Unfortunately, the key *is* necessary to restore the files,
because establishing a link means that we have to manipulate the both
the encrypted directory and the encrypted file, and doing this through
the VFS interface is non-trivial.  So we have an ioctl which extracts
the encrypted file name, and that in combination with the encryption
metadata for the directory should be sufficient to restore the file
name assuming the restore is done with access to the user's master
key.

The other tricky bit is that if the file's i_size is not a multiple of
the AES block size, we need to be able to copy a handful of bytes
before i_size --- and O_DIRECT reads don't allow that.  There are two
ways of solving this.  One would be an new DIO_FLAG that rounds i_size
up to the file system blocksize, which we would pass when reading
encrypted files using O_DIRECT.  This would require changes to the
core direct I/O, and may be controversial.  It also may make it more
difficult to back port these patches to ancient BSP kernels.

So what we're doing for now is admittedly a hack.  Since encrypted
files are read-only without access to the key, it is safe to create a
shadow copy of the inode structure, and round up i_size in the shadow
structure.  We only do this when reading the last block in the file,
so the overhead shouldn't be too bad.

The process doing the store will need to truncate the file back down
to the original file when it has access to the key.  We can't do this
without the key because the kernel zero fills the block between i_size
and the end of the block.  (This is also why it's not a security issue
to round i_size up to the end of the block; there is no chance we will
be revealing stale data.)  So this means that for the purposes of
doing the encrypted backup, the backup will need to store the
encrypted file name, the directory's encrypted metadata, and the
original i_size in some convenient ouf-of-band backup metadata store.

Theodore Ts'o (3):
  ext4 crypto: add ciphertext_access mount option
  ext4 crypto: add ioctls to allow backup of encryption metadata
  ext4 crypto: add missing locking for keyring_key access

 fs/ext4/crypto_key.c  | 61 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/ext4.h        | 12 ++++++++++
 fs/ext4/ext4_crypto.h |  8 +++++++
 fs/ext4/file.c        |  5 +++-
 fs/ext4/indirect.c    | 24 +++++++++++++++----
 fs/ext4/inode.c       | 17 ++++++++------
 fs/ext4/ioctl.c       | 64 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/namei.c       | 24 +++++++++++++++++++
 fs/ext4/super.c       | 48 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 249 insertions(+), 14 deletions(-)

-- 
2.5.0

