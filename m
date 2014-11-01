From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 bug fixes for 3.18
Date: Sat, 1 Nov 2014 09:38:02 -0400
Message-ID: <20141101133802.GA31245@thunk.org>
References: <20141031214949.GA644@thunk.org>
 <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwiFx6ejtnEvZYJewHaskwjTr39bPstFvWYimqi6hMCsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 31, 2014 at 04:26:16PM -0700, Linus Torvalds wrote:
> On Fri, Oct 31, 2014 at 2:49 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Theodore Ts'o (1):
> >       jbd2: use a better hash function for the revoke table
> 
> Does it really make sense to use hash_u64()? It can be quite expensive
> (mainly on 32-bit targets), and since the low bits are where all the
> information is anyway, I'd suggest using hash_32() here even if the
> block number in theory can have a few bits above the 32-bit mark.

Hmm... the problem is that since the block group size is normally
32768 blocks, and most metadata blocks (which is what needs to be
revoked) is located at the beginning of the block groups, if we drop
the high 32-bits, then there would be some hash aliasing going on.

What we could do is use hash_32() unless we have a file system large
enough that it matters, and then if we still wanted to avoid using
hash_u64(), we could do something like this:

	hash_32(__swab32(blk >> 32) | (blk & 0xFFFFFFFF))

That way we get the information from the block group number as well,
and in a way where it doesn't interfere with the information in the
low bits of the block number.

I didn't think hash_64 was *that* slow, so it's not clear the above
would be faster, though.  And if someone is using a > 16TB file system
on a 32-bit platform, I suspect they might be having other problems.  :-)

					- Ted
