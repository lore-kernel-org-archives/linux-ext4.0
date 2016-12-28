From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] fscrypt: fix the test_dummy_encryption mount option
Date: Wed, 28 Dec 2016 15:27:59 -0600
Message-ID: <20161228212759.GC8557@zzz>
References: <20161228005147.751-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161228005147.751-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Tue, Dec 27, 2016 at 07:51:47PM -0500, Theodore Ts'o wrote:
> Commit f1c131b45410a: "crypto: xts - Convert to skcipher" now fails
> the setkey operation if the AES key is the same as the tweak key.
> Previously this check was only done if FIPS mode is enabled.  Now this
> check is also done if weak key checking was requested.  This is
> reasonable, but since we were using the dummy key which was a constant
> series of 0x42 bytes, it now caused dummy encrpyption test mode to
> fail.
> 
> Fix this by using 0x42... and 0x24... for the two keys, so they are
> different.
> 

This problem would also be fixed by my patch to make the test_dummy_encryption
encryption keys go through the regular keyring lookup and key derivation paths,
which IMO is a better solution long-term:

	fscrypt / ext4: make test_dummy_encryption require a keyring key

and corresponding xfstests-bld patch:

	xfstests-bld: populate keyring with default key for test_dummy_encryption

Would it make any sense to apply those patches instead?

I'd also be okay with your patch for 4.10 and mine for 4.11 or something like
that.

Eric
