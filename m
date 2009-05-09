From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Is TRIM/DISCARD going to be a performance problem?
Date: Sat, 09 May 2009 17:14:14 -0400
Message-ID: <E1M2ts6-0005jr-Cg@closure.thunk.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Currently, ext4 is wired up to call sb_issue_discard, which is a wrapper
around blkdev_issue_discard().  The way we do this is we keep track of
deleted extents, coalescing them as much as possible, and then once we
commit the transaction where they are deleted, we send the discards down
the pipe via sb_issue_discard.  For example, after marking approximately
200 mail messages as deleted, and running the mbsync command which
synchronizes my local Maildir store with my IMAP server (and thus
deleting approximately 200 files), and the next commit, we see this:

3480.770129: jbd2_start_commit: dev dm-0 transaction 760204 sync 0
3480.783797: ext4_discard_blocks: dev dm-0 blk 15967955 count 1
3480.783830: ext4_discard_blocks: dev dm-0 blk 15970048 count 104
3480.783839: ext4_discard_blocks: dev dm-0 blk 17045096 count 14
3480.783842: ext4_discard_blocks: dev dm-0 blk 15702398 count 2
	     .
	     .
	     .
3480.784009: ext4_discard_blocks: dev dm-0 blk 15461632 count 32
3480.784015: ext4_discard_blocks: dev dm-0 blk 17057632 count 32
3480.784023: ext4_discard_blocks: dev dm-0 blk 17049120 count 32
3480.784026: ext4_discard_blocks: dev dm-0 blk 17045408 count 32
3480.784031: ext4_discard_blocks: dev dm-0 blk 15448634 count 6
3480.784036: ext4_discard_blocks: dev dm-0 blk 17146618 count 1
3480.784039: ext4_discard_blocks: dev dm-0 blk 17146370 count 1
3480.784043: ext4_discard_blocks: dev dm-0 blk 15967947 count 6
3480.784046: jbd2_end_commit: dev dm-0 transaction 760204 sync 0 head 758551

There were 42 calls to blkdev_issue_discard (I ommitted some for the
sake of brevity), and that's a relatively minimal example.  A "make
mrclean" in the kernel tree, especially one that tends to be more
fragmented due to a mix of source and binary files getting updated via
"git pull", will be much, much worse, and could result in potential
hundreds of calls to blkev_issue_discard().  Given that each call to
blkdeV_issue_discard() acts like a barrier command and requires that the
queue be completely drained (of both read and write requests, if I
understand things correctly) if there's anything else happening in
parallel, such as other write or read requests, performance is going to
go down the tubes.

What I'm thinking that we might have to do is:

*)  Batch the trim requests more than a single commit, by having a
	separate rbtree for trim requests
*)  If blocks get reused, we'll need to remove them from the rbtree
*)  In some cases, we may be able to collapse the rbtree by querying the
	filesystem block allocation data structures to determine that if
	we have an entry for blocks 1003-1008 and 1011-1050, and block
	1009 and 1010 are unused, we can combine this into a single
	trim request for 1003-1050.
*)  Create an upcall from the block layer to the trim management layer
	indicating that the I/O device is idle, so this would be a good
	time to send down a whole bunch of trim requeusts.
*)  Optionally have a mode to support stupid thin-provision
	devices that require the trim request to be aligned on some
	large 1 or 4 megabyte boundaries, and be multiples of 1-4
	megabyte ranges, or they will ignroe them.
*)  Optionally have a mode which allows the filesystem's block allocator
	to query the list of blocks on the "to be trimmed" list, so they
	can be reused and hopefully avoid needing to send the trim
	request in the first place.

This could either be done as ext4-specific code, or as a generic "trim
management layer" which could be utilized by any filesystem.

So, a couple of questions:  First of all, do people agree with my
concerns?   Secondly, does the above design seem sane?   And finally, if
the answers to the first two questions are yes, I'm rather busy and
could really use a minion to implement my evil plans --- anyone have any
ideas about how to contact the vendors of these large thin-provisioning
devices, and perhaps gently suggest to them that if they plan to make
$$$ off their devices, maybe they should fund this particular piece of
work?   :-)

						- Ted
