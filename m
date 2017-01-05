From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt / ext4: make test_dummy_encryption require a
 keyring key
Date: Wed, 4 Jan 2017 16:16:06 -0800
Message-ID: <20170105001606.GC21696@gmail.com>
References: <1481611930-65173-1-git-send-email-ebiggers3@gmail.com>
 <20170102204342.vib5ayse4kthruma@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34705 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032289AbdAEAQJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2017 19:16:09 -0500
Content-Disposition: inline
In-Reply-To: <20170102204342.vib5ayse4kthruma@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

On Mon, Jan 02, 2017 at 03:43:43PM -0500, Theodore Ts'o wrote:
> The following patch is smaller (and causes a net reduction in code).
> It also uses allows us to properly test the context inheritance code,
> by completely removing any test_dummy_encryption specific hacks from
> fscrypt_inherit_context().
> 
> The suggested userspace shell script fragment works on big-endian
> systems, and uses fixed key instead of a random one.  The latter is
> useful for test sequences where it is useful to validate a file system
> that had been previously created using an older kernel.

I'm fine with your proposed version, though I'm not convinced it's really any
better than mine, since it basically just moves the "hack" from
fscrypt_inherit_context() to fscrypt_get_encryption_info().  The reason I
preferred it in fscrypt_inherit_context() was that allowing
fscrypt_get_encryption_info() to work on unencrypted files is kind of weird and
could allow for confusing scenarios where a previously existing unencrypted file
is accidentally treated as an encrypted one --- though that would require a
missing ext4_encrypted_inode() check of course.

Thanks,

Eric
