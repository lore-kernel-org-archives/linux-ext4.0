From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fscrypt: Howto resolve hash collisions?
Date: Sat, 8 Oct 2016 16:46:12 -0400
Message-ID: <20161008204612.4qdgxraourstksob@thunk.org>
References: <859a9544-fe9d-4656-7b45-b25719c8eadc@nod.at>
 <20161005154504.f72uovnew52jts4w@thunk.org>
 <3da5f592-0c1d-1b68-8a76-e6d4a6d616a8@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        David Gstir <david@sigma-star.at>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43300 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752366AbcJHXR3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 8 Oct 2016 19:17:29 -0400
Content-Disposition: inline
In-Reply-To: <3da5f592-0c1d-1b68-8a76-e6d4a6d616a8@nod.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 08, 2016 at 04:33:29PM +0200, Richard Weinberger wrote:
> 
> But hash collisions can happen and ext4 aborts then, right?

No, in case of hash collisions we use linear probing, as I said.

I tested this a while back by using a hash function which always
returns 42, and it works just fine.

> Some time ago I saw this:
> http://blog.merovius.de/2013/10/20/ext4-mysterious-no-space-left-on.html

The blog author is confused.  I'm guessing what happened is that he's
using a file system with a 1k block size, and htree currently has a
limitation that the tree depth can be no more than two deep.  (Yes,
it's a hack.  The original htree implementation was done by Daniel
Phillips, and we never got around to fix it.)  In practice, for file
systems with a 4k block size, the fanout is so wide that it's not an
issue.

> UBIFS accepts the fact that multiple directory entries can have the same
> hash (also on flash). Upon lookup it computes hash(name), finds the first
> directory entry with that hash _and_ compares the name. If the name
> does not match we're facing a hash collision and lookup the next entry
> with the same hash.

OK, so that's simple.  It's what ext4 does as well.

The difference is that we use a 64-bit hash, and we normally only
store 32-bit on disk for lookup purposes.  On 32-bit systems, we use
the 32-bit hash for the telldir cookie, and we accept the fact that
there can be hash collisions that will cause telldir/seekdir may not
return the directory pointer back to the exact location.  We do the
same thing for NFSv2, which also only supports a 32-bit telldir
cookie.

But what we do is we use the *other* 32-bits of the 64-bit hash as the
"minor hash", and on 64-bit architectures, the telldir cookie uses the
high 32-bits to store the "major" hash, and use the low 32-bits to
store the "minor" hash.  The readdir(2) system call returns the
directory entries in 64-bit hash order, and when we get the telldir
cookie, we use the "minor" hash as part of the virtual 64-bit hash.

> Long story short, UBIFS has no solution to offer a telldir/seekdir cookie.
> And I fear this time, for fscrypto, it really hurts.

So you could do the same thing.  Just use another 32-bit hash and use
that as the "minor" hash.  Now when you do the lookup, if there are
multiple files that have the same 32-bit hash you can use the "minor"
hash to disambiguate.  The chances of a collision is at that point is
1 in 4,294,967,296.

The reason why I haven't bothered to do more is that in practice, for
our use case if you do an rm -rf, you might just end up deleting the
files in the opposite order, but it's not a problem in practice ---
and even if you did care, one in 4 billion are pretty good odds.  (For
context: your chances of getting killed by a falling coconut is one in
250 million; your chances of getting killed by shark attack is one in
300 million; your chances of getting killed by food poisioning is one
in 3 million; and your chances of getting killed by a terrorist is one
in 25 million.  Funny thing that US citizens tend to be more freaked
out about getting killed by a terrorist as opposed to food poisoning,
but no one ever said civilians were rational.)

If for some reason you want to do better than one in 4 billion, what
we could do as chose yet another 64-bit hash, and then store that
alongside the major and minor hashes, and then compare against the
64-bit hash plus the minor hash.  At that point the chances of failure
is one in 18,446,744,073,709,551,616.  This could be done without
making a on-disk format change, so if we ever wanted to make this
change, we could do it.


Cheers,

						- Ted
