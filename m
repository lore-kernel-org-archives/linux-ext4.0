From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 2/2] libext2fs/e2fsck: implement metadata prefetching
Date: Thu, 27 Feb 2014 12:03:56 -0500
Message-ID: <530F6FFC.4040903@ubuntu.com>
References: <20140130235044.31064.38113.stgit@birch.djwong.org> <20140130235058.31064.21096.stgit@birch.djwong.org> <45DEEA58-69FD-42EF-BB51-1A8D80000469@dilger.ca> <20140131135325.GF7118@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63689 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaB0RD6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Feb 2014 12:03:58 -0500
In-Reply-To: <20140131135325.GF7118@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/31/2014 8:53 AM, Theodore Ts'o wrote:
> Something that we might need to go to in the future is instead of 
> using mmap(), to maintain our own explicit buffer cache inside 
> unix_io, and use direct I/O to avoid caching the disk blocks
> twice. Then when we use a single-threaded disk prefetcher, managed
> by the unix_io, it will know when a particular I/O request has
> completed, and more importantly, if there is a synchronous read
> request coming in from main body of the program, it can stop
> prefetching and allow the higher priority read to complete.  We can
> also experiment with how many threads might make sense --- even
> with an HDD, using multiple threads so that we can take advantage
> of NCQ might still be a win.

Why build your own cache instead of letting the kernel take care of
it?  I  believe the IO elevator already gives preferential treatment
to blocking reads so just using readahead() to prefetch and sticking
with plain old read() should work nicely.

> Finally, if we are managing our own buffer cache, we should
> consider adding a bforget method to the I/O manager.  That way
> e2fsck can give hints to the caching layer that a block isn't
> needed any more.  If it is in the cache, it can be dropped, to free
> memory, and if it is still on the to-be-prefetched list it should
> also be dropped.  (Of course, if a block is on the to-be-prefetched
> list, and a synchronous read request comes in for that block, we
> should have dropped it from the to-be-prefetched list at that
> point.)  The main use for having a bforget method is for the most
> part, once we are done scanning a non-directory extent tree block,
> we won't be needing it again.

Good idea, but this also could just be translated to posix_fadvise to
have the kernel drop the pages from the cache.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTD2/8AAoJEI5FoCIzSKrwN9QIAKKyOssDAoy6Zab7w+j6aXdH
f8Lzw/+WWevPpvX1o9SakQXVYejkiZBcEhJ/NrtQoDzQjesrERpKIj7m+Yb2blaQ
VYu9hj21ReVYngmmOlUHL9LJJtfwGptyO3SGvuSZv3NooMjEu51tCXxHLxONaYAb
SqvRBVH57E7hY1HckKTbD14YleKn/SD7peNIp1KP39zQw1soR83+oHh2qZ3Zaq7E
fa/UG7tnIMcOjHghacr83LA7XW+sQYn8pDeAmw38SKe+uiHvcqjzych6lQlKLw19
pKdzERd8zaPsiS2y4og/RzWZHolohiDp67cWRncYKm3ai2w4KbU9KXlQHa/6Fy0=
=orjY
-----END PGP SIGNATURE-----
