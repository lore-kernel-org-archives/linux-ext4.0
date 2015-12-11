From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 2/3] ext4 crypto: add ioctls to allow backup of
 encryption metadata
Date: Thu, 10 Dec 2015 21:45:49 -0500
Message-ID: <20151211024549.GE8898@thunk.org>
References: <1449759879-2166-1-git-send-email-tytso@mit.edu>
 <1449759879-2166-3-git-send-email-tytso@mit.edu>
 <649A5882-2F1C-4A55-ADB1-AFECA3FD560C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	mhalcrow@google.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52065 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbbLKCpx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Dec 2015 21:45:53 -0500
Content-Disposition: inline
In-Reply-To: <649A5882-2F1C-4A55-ADB1-AFECA3FD560C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 10, 2015 at 04:48:56PM -0700, Andreas Dilger wrote:
> 
> Instead of exposing these via ioctls, why not use virtual xattrs
> (e.g. "trusted.crypt_meta" or similar) so that this can be backed
> up and restored using a normal backup tool instead of basically
> nothing that exists today.

We're going to have to have an encrypted-aware backup tool anyway ---
if for no other reason than to deal with the fact that if i_size is
not a multiple of the cipher's block size, that we need to backup at
least ROUND_UP(i_size, cipher_block_size) bytes, but we need to store
the original i_size field somewhere else.

The problem gets even worse to do encrypted backup *restores* because
we need to be able to pass encrypted filenames that include NUL
characters through the VFS, but the raw encrypted filename is
different from the human-friendly encrypted filename which is what we
want in the dentry cache.  So I don't think it's worth the effort to
try to make it possible to do backups using standard tools.

Hmm, thinking about this some more, I might be able to support
encrypted restores w/o having access to the key by using a magic ioctl
that takes two file descriptors (one for the encrypted directory, and
another one for the encrypted file, plus the encrypted filename), and
do this bypassing the VFS layer entirely.  It's something I may look
at.  But the point is this is even further away from an interface that
could be hacked using xattrs.

> For reading the ciphertext, do existing tools such as tar and rsync
> allow reading with O_DIRECT with CIPHERTEXT_ACCESS?

No.  None of the standard tools understand that you might have to
remount the file system with a special mount option.  And neither tar
nor rsync have an option so they will read their files using O_DIRECT.

> If not, one might
> consider to allow normal reads w/o the file key to return the
> ciphertext so that "tar --xattr" by some process with CAP_SYS_ADMIN
> but out any keys could be used to backup and restore the ciphertext
> in a sensible manner.  That is no more risk than the same process
> reading the blocks from the disk device directly, but would be a lot
> more useful (i.e. it is practical to use normal backup tools for
> encrypted files).

The reason why I'm using O_DIRECT is so we don't have to worry about
potentially posioning the page cache with encrypted pages.  In our
current design, the page cache for an encrypted file always contains
the plaintext.  This is necessary so that mmap(2) will work correctly.
So if user B is logged onto a machine where user A is active, and user
A's keys are in the kernel, we don't determine access control
descisions for user B based on whether or not the user has the
appropriate keyring in a keyring accessible to them.  We use Unix
permissions to provide security isolation between two users which are
logged in.

In theory, when user A logs out, userspace should do the equivalent of
"echo 3 > /proc/sys/vm/drop_caches" to drop the plaintext pages from
the page cache.  But I don't want the correctness of an encrypted
backup to depend on that.  Also, if someone wants to insist on doing
an encrypted backup while the keys are present, that should work as
well.  That's why using O_DIRECT to bypass the page cache was a key
part of the design, and why it's problematic to allow normal file
reads to be used for this purpose.

The bottom line is that it's impossible to use normal backup tools for
encrypted files work correctly _anyway_ (because of the i_size /
ciphertext block size rounding issue), and between wanting to allow
for encrypted backups even if the user the keys are available, and the
page cache poisioning issue, it's simpler all around to use specific
ioctls.

					- Ted

P.S.  I actually have another use case in mind besides just encrypted
backups, but (a) I'm not allowed to comment about features that might
or might not show up in unreleased products, (b) you never know when
pesky reporters from Android Central might be hanging about, and (c)
being able to do encrypted backups is a feature which Dmitry Monakhov
explicitly requested, and a mark of a good design is one that will
work well for more than one use case.  :-)
