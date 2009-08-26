From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 26 Aug 2009 18:55:15 -0400
Message-ID: <20090826225515.GK6997@mit.edu>
References: <4A93103B.2000909@redhat.com> <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int> <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int> <4A94287C.9060509@redhat.com> <20090825211132.GV17684@mit.edu> <20090826095035.GH5931@webber.adilger.int> <20090826131403.GN32712@mit.edu> <20090826220045.GG4197@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:32955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbZHZWzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 18:55:19 -0400
Content-Disposition: inline
In-Reply-To: <20090826220045.GG4197@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 26, 2009 at 04:00:45PM -0600, Andreas Dilger wrote:
> I'm still missing something.  With async_commit enabled, it doesn't
> matter if the commit block is reordered, since the transaction checksum
> will verify if all of the data + commit block are written for that
> transaction, in case of a crash.  That is the whole point of async_commit.

The problem isn't reordering with respect to the journal blocks alone;
the problem is reordering with respect to the journal blocks *plus*
normal filesystem metadata.

The key point here is that jbd pins filesystem metadata blocks and
prevents them from being pushed out to disk until the transaction has
committed.  Once the transaction has been commited, they are free to
be written to disk, and {directory,indirect,extent} blocks which have
been released during the last transactoin are now freed to be reused
by the block allocator.

If the system is under memory pressure and is gettings lots of
fsync(), there are a large number of transaction boundaries.  So it's
possible for I/O stream of the form:

	 ...
	 commit seq #17
	 journal of block #12
	 journal of block #52
	 journal of block #36
	 journal of block allocation bitmap releasing block #23
	 commit seq #18
	 update of block #12
	 write of reallocated block #23
	 ..,

Could get reorderd as follows:

         ...
	 commit seq #17
	 journal of block #12
	 journal of block #52
	 update of block #12
	 write of reallocated block #23
	 journal of block #36
	 <crash>
	 (journal of block allocation bitmap releasing block #23)
	 (commit seq #18)

OK, so what's happened?  Since there was no barrier when we write the
commit block for transaction #18, some of the (non-journal) I/O that
was only supposed to have happened *after* the commit has completed,
has happened too early, and then the system crashed before all of the
journal blocks associated with commit #18 could be written out.

So from the perspective of the journal replay commit #18 never
happened.  So among other things the act of releasing block #23 never
happened --- but block #23 has gotten reused already, since a write
that took place *after* commit #18 has taken place, due to reordering
that took place on the disk drive.

This is what Chris Mason has demonstrated with his barrier=0 file
system corruption workload.  And this is something which journal
checksums don't help, because it's not about the commit block getting
written out before the rest of the journal blocks.  *That* case will
be detected by an incorrect journal checksum.  The problem is other
I/O taking place to other parts of the filesystem.

I've actually used bad numbers here, since the journal is typically at
the very front of the disk (for ext3) or in the middle of the disk
(for ext4).  If the I/O for the rest of the filesystem is at the very
end of the disk, it's in fact very believable that drive might defer
the journal update (at the beginning of the disk) and try to do lots
of filesystem metadata updates (at the end of the disk) to avoid
seeking back and forth, without realizing that this violates the
ordering constraints that the jbd layer needs for correctness.

Unfortunately, the only way we can communicate these constraints to the
disk drive is via barriers.

						- Ted
