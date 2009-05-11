From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 04:37:54 -0400
Message-ID: <20090511083754.GA29082@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090510165259.GA31850@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbZEKIiD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 May 2009 04:38:03 -0400
Content-Disposition: inline
In-Reply-To: <20090510165259.GA31850@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 10, 2009 at 06:53:00PM +0200, J=F6rn Engel wrote:
> I'm somewhat surprised.  Imo both the current performance impact and
> much of your proposal above is ludicrous.  Given the alternative, I
> would much rather accept that overlapping writes and discards (and
> possibly reads) are illegal and will give undefined results than deal
> with an rbtree.  If necessary, the filesystem itself can generate
> barriers - and hopefully not an insane number of them.
>=20
> Independently of that question, though, you seem to send down a large
> number of fairly small discard requests.  And I'd wager that many, if
> not most, will be completely useless for the underlying device.  Unle=
ss
> at least part of the discard matches the granularity, it will be
> ignored.

Well, no one has actually implemented the low-level TRIM support yet;
and what I did is basically the same as the TRIM support which Matthew
Wilcox implemented (most of which was never merged, although the call
so that the FAT filesystem would call TRIM is in mainline ---
currently the two users of sb_issue_blkdev() are the FAT and ext4
filesystems).  And actually, what I did is much *better* than what
Matthew implemented --- he sent the sb_issue_discard() after every
single unlink command, whereas with ext4 at leat we combined the trim
requests and only issued them after the journal commit.  So for
example, in the test where I deleted 200 files, ext4 only sent 42
discard requests.  For the FAT filesystem, which issues the discard
after each unlink() system call, it would have issued at least 200
discard requests, and perhaps significantly more if the file system
was fragmented.

> And even on large discards, the head and tail bits will likely
> be ignored.  So I would have expected that you already handle discard=
 by
> looking at the allocator and combining the current request with any f=
ree
> space on either side.

Well, no, Matthew's changes didn't do any of that, I suspect because
most SSD's, including X25-M, are expected to have a granularity size
of 1 block.  It's the crazy people in the SCSI standards world who've
been pushing for granlarity sizes in the 1-4 megabyte range; as I
understand things, the granularity issue was not going to be a problem
for the ATA TRIM command.

Hence my suggestion that if they want to support these large
granlarity writes, since they're the ones who are going to be making
$$$ on these thin-provisioned clients, we ought to hit them up for
funding to implement discard management layer.  Personally, I only
care about SSD's (because I have one in my laptop) and the associated
performance issues.  If they want to make huge amounts of money, and
they're too lazy to track unallocated regions on a smaller granularity
than multiple megabytes, and want to push this complexity into Linux,
let *them* help pay for the development work.  :-)


As far as thinking that the proposal is ludicrous --- what precisely
did you find ludicrous about it?  These are problems that all
filesystems will have to face; so we might as well solve the problem
once, generically.  Figuring out when we have to issue discards is a
very hard problem.  It may very well be that for thin-provisioned
clients, the answer may be that we should only issue the discard
requests at unmount time.  That means that the system won't be
informed about a large-scale "rm -rf", but at least it will be much
simpler; we can have a program that reads out the block allocation
bitmaps, and then updates the thin-provisioned client after the
filesystem has been unmounted.

However, the requirements are different for SSD's, where (a) the SSD's
want the SSD information on a fine-grained basis, and (b) from a
wear-management point of view, giving the SSD the information sooner
rather than later is a *good* thing, since if the blocks have been
deleted, you want the SSD to know right away, to avoid needlessly
GC'ing that region of disk, since that will improve the SSD's write
endurance.

The only problem with SSD's is the people who designed the ATA TRIM
command requires us to completely drian the I/O queue before issuing
it.  Because of this incompetence, we need to be a bit more careful
about how we issue them.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
