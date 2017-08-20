From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fscrypt: add a documentation file for filesystem-level
 encryption
Date: Sat, 19 Aug 2017 22:32:27 -0400
Message-ID: <20170820023227.slfqjq6dbcva74du@thunk.org>
References: <20170818194730.61575-1-ebiggers3@gmail.com>
 <8EA94C5A-A3F7-48BC-91BE-3C0BD17D7927@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-fscrypt@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33804 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752533AbdHTCcd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 19 Aug 2017 22:32:33 -0400
Content-Disposition: inline
In-Reply-To: <8EA94C5A-A3F7-48BC-91BE-3C0BD17D7927@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 18, 2017 at 03:06:52PM -0600, Andreas Dilger wrote:
> On Aug 18, 2017, at 1:47 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> > +Key hierarchy
> > +=============
> > +
> > +Master Keys
> > +-----------
> > +
> > +Userspace should generate master keys either using a cryptographically
> > +secure random number generator, e.g. by reading from ``/dev/urandom``
> > +or calling getrandom(), or by using a KDF (Key Derivation Function).
> > +Note that whenever a KDF is used to "stretch" a lower-entropy secret
> > +such as a passphrase, it is critical that a KDF designed for this
> > +purpose be used, such as scrypt, PBKDF2, or Argon2.
> 
> One minor suggestion - when generating a master key for a filesystem,
> I'd think it is preferable to use /dev/random instead of /dev/urandom
> to ensure there is enough entropy.

I would just say "use getrandom" and be done with it.  More
importantly, we probably just want to direct users to use either
https://github.com/google/fscrypt or Android key management system at
the beginning of the file.

If the readers of this documentation file need to be told how to get
good random number generators, they're very likely to make any number
of other basic security mistakes.  If people don't think the fscrypt
user program isn't user-friendly or flexible enough to encompass their
use case, it's probably better to encourage them to submit
enhancements to an existing open source key management system such as
google/fscrypt.  If we minimize the number of userspace
implementations, the easier it will be to make sure they are
appropriately audited for security issues...

						- Ted
