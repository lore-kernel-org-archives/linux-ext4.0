From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypt: Howto resolve hash collisions?
Date: Wed, 5 Oct 2016 11:45:05 -0400
Message-ID: <20161005154504.f72uovnew52jts4w@thunk.org>
References: <859a9544-fe9d-4656-7b45-b25719c8eadc@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <859a9544-fe9d-4656-7b45-b25719c8eadc@nod.at>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 05, 2016 at 04:00:36PM +0200, Richard Weinberger wrote:
> 
> UBIFS uses the r5 hash algorithm for filenames and is able to resolve hash collisions.
> Unless I miss something it is not possible to resolve hash collisions for bignames
> in fscrypto....
>
> What do I miss? Are ext4 and f2fs not able to resolve hash collisions and therefore
> nobody noticed?


"Resolve hash collisions" is a fairly generic term.  There are many
ways to resolve hash collisions, including linear probing --- which is
what ext4 uses.

Let's take a step back and understand what we're doing here.  The
requirement which we're trying to support here is the ability for root
to be able to delete encrypted files without having access to the key.
For example, imagine a ChromeOS device which is shared between
multiple users, and where each user's files are protected by a
different key.  This means that while user A is logged in, even if
there is a security exposure which allows a bad guy to execute code as
root, the files of user B and C are not at risk.  However, if user A
needs more disk space, one of the things things which a privileged
service can do is to delete files in user B's and user C's cache
directory, since cache files are safe to delete in order to make
space.

So in order to do this, we need to be able to allow root to be able to
run readdir on an encrypted directory, and get handles on directory
entries which can be then sent back into the kernel so that system
calls such as unlink(2) and opendir(2) can work.

For small files, we can just base-64 encode the encrypted directory,
and then send that back.  However, base-64 encoding expands the size
of the filename by (plus or minus) by 33%; and we can't send back a
filename longer than 255 bytes through the syscall interface.

To get around this, there is an alternate mechanism where the file
system can encode an encrypted filename, and that's to send back a
64-bit cookie to userspace via readdir(), and then when the user space
sends the base-64 encoded filename to unlink(2), fscrypt will either
provide the file system with the encrypted filename if it is short, or
with the 64-bit cookie.  Because the fscrypto code was originally
factored out of ext4, we use two 32-bit longs and name them "hash" and
"minor_hash", but they don't actually have to be a hash.

For example, POSIX requires that file systems supports telldir()
return a 64-bit cookie which will be valid in the face of intervening
additions and deletions, and this cookie must be able to be fed back
to seekdir() and resume the readdir() session from the location of the
last telldir().  So you might be able to use whatever scheme you use
to support telldir() and seekdir().  In retrospect, it probably would
have been better if, when we refactored the code, to have made the
interface be a 8 byte cookie.

It sounds like the main problem here is that Ubifs is using a 32-bit
hash, and so the chances of collisions are much higher --- 1 in 65536,
to be precise.  So the technique of using linear probing probably
wouldn't work as well for Ubifs.  However, feel free to use the minor
hash any which way you want.  The key is that you're starting with the
encrypted filename in readdir, so you also know where the file is located.

I'm not sure which mechanism of "collision resolution" you're using,
so at this point I can only make some conjections.  For example, are
you using the mechanism of hash(name || counter), where you keep
incrementing the counter until you find an empty slot in the your hash
tree?  If so, what you could do is to figure out what counter value
resulted in the location of the encrypted filename to that location in
the hash tree, and you could store that counter value in the
minor_hash field.

Finally, if it would help, we could change the fs/crypt interface so
that instead of using a 2x4 byte "cookie", we could make it be (for
example) a 128 bit cookie.  However, given that ubifs must have some
solution to the 64-bit telldir/seekdir cookie, maybe you can use that
mechanism for handling the encrypted readdir() functionality.

Hope this helps,

						- Ted
