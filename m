From: Theodore Tso <tytso@mit.edu>
Subject: Re: Question on readdir implementation
Date: Tue, 15 Sep 2009 10:53:37 -0400
Message-ID: <20090915145337.GB23118@mit.edu>
References: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zhang Huan <zhhuan@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:54637 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZIOOxp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Sep 2009 10:53:45 -0400
Content-Disposition: inline
In-Reply-To: <20090915095724.GA8440@zhanghuan.nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 15, 2009 at 05:57:24PM +0800, Zhang Huan wrote:
> Hi all,
> 
> I'm reading EXT4 codes and has some questions about readdir
> implementation.
> 
> Why traverse the directory in hash order? This brings lots of code to
> build and traverse a red-black tree. Why not just plainly traverse the
> directory's blocks?
> 
> Since the red-black tree is built every time a NFS readdir request comes
> in, in case of hash collision, the nfs client may receive duplicate dir
> entries if the buffer is not large enough to return all entries with the
> same hash value in once.

The reason why we have to do this is because of the telldir() and
seekdir() interfaces.  NFS is implicated in this as well, because it
traverses the directory using a 32-bit offset on the protocol wire.

The fundamental problem is they presume that directory is stored as a
linear array.  For file systems which use some kind of B-tree or other
non-linear data structure to speed up directory lookups, the problem
is what to do when we need to split a B-tree leaf.  When this happens,
half of the directory entries in the that B-tree leaf must be moved to
a new directory block.  However, readdir() must still return every
single entry in the directory once and exactly once; and this must be
true even if even if telldir()/seekdir() is used, and even if NFS
decides to wait for several minutes or hours between reading the first
set of directory entries, and then reading the next set of directory
entries, sending to the NFS server nothing but the 32-bit offset
token.

It is for this reason that we must traverse the directory in hash
order; so that directory entries are returned once and only once even
in the face of node splits.  We try very hard to avoid a hash
collisions, including using a keyed hash which is kept secret to
prevent users from deliberately trying to trigger the failure mode.

Looking more closely at what we have done, we should be able to do
better on architectures where off_t is 64 bits.  Internally, we use a
64-bit hash, but we only put the high 32 bits of the hash in f_offset
because we can't tell whether the telldir() or telldir64() call might
be used by an application, and we can't tell whether the NFS server is
speaking NFSv2 (where the readdir cookie is only 32 bits) or NFSv3
(where the readdir cookie is cookie is 64 bits).  On platforms where
off_t is 64-bytes, we could store the full 64-bit hash value in
f_offset, but we would swap the low and high 32-bit values, so that 32
LSB are in the high 32 bits of f_offset and vice versa.  

The NFS v2 server would still get a 64-bit f_offset, but it currently
doesn't do any range checking before dropping it into the 32-bit
cookie, so the high 32 bits would get truncated.  This would result in
the same behaviour we have today for those poor benighted souls which
are still using NFSv2, but allow for better behavior for NFSv3 at
least on 64-bit platforms.

So this is something we could do in the future.  In practice, no one
has complained about this as far as NFS is concerned, so it's not high
priority for me to pursue.  Were you worried about this as a practical
matter, or as a theoretical one?

Regards,

						- Ted
