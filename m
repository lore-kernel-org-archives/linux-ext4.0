From: "George Spelvin" <linux@sciencehorizons.net>
Subject: badblocks(8) bug with 3-byte and random patterns
Date: 28 Jul 2016 07:23:13 -0400
Message-ID: <20160728112313.21399.qmail@ns.sciencehorizons.net>
Cc: jack@suse.cz, linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:18375 "HELO
	ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757236AbcG1LXP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jul 2016 07:23:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is one basic code bug with multiple symptoms, but the first one
I'll describe is a performance bug that affects every mode including
read-only.  A simplified version of the main test loop in test_ro(),
which is duplicated in test_rw() and test_nd(), is:

	try = blocks_at_once;
	currently_testing = first_block;
	while (currently_testing < last_block)
	{
		if (currently_testing + try > last_block)
			try = last_block - currently_testing;
		got = do_read (dev, blkbuf, try, block_size, currently_testing);
		if (got == 0 && try == 1)
			bb_count += bb_output(currently_testing++, READ_ERROR);
		currently_testing += got;
		if (got != try) {
			try = 1;
			if (recover_block == ~0U)
				recover_block = currently_testing - got +
					blocks_at_once;
			continue;
		} else if (currently_testing == recover_block) {
			try = blocks_at_once;
			recover_block = ~0;
		}
	}

Suppose we are testing with the default parameters of blocks_at_once = 64,
and there is an error reading block 63.

The first do_read() will return got = 63.  Because try = 64, this will
result in recover_block being set to 64 (it's always set to a multiple
of blocks_at_once), and the read of block 63 being retried with try = 1.

When the retry also fails, currently_testing will be incremented
to 64, but the (got != try) branch will be taken again, and the
(currently_testing == recover_block) condition will never be tested.

The result is that currenty_testing advances past recover_block, try is
never reset to blocks_at_once, and the remaining test is performed with
try = 1.  This really hurts performance.


A second problem is that, in test_rw(), the memcmp() loop is after the
continue above, so corruption preceding a read error is not detected.
(This can be fixed by just deleting the "continue" in that branch.)


The third problem is the really bad one, which started me on this bug hunt.

When badblocks(8) is run with a pattern length which does not divide
the block_size (for a typical power-of-2 block size, that means "-w -t
0x123456" or "-w -t random"), then the pattern_fill() creates a pattern
buffer in which the various blocks are not identical.

The problem is that the memcmp() code in the above loop compares the
block just read off disk to the *beginning* of the pattern buffer.
If the blocks in the pattern buffer aren't all the same, this can result
in a false CORRUPTION_ERROR.

Particularly bad, if the scan gets stuck in the preceding try = 1
mode, then it will start spamming spurious CORRUPTION_ERROR on most
of the remaining blocks on the disk.  Only 1/3 or 1/blocks_at_once of
the blocks read will be compared successfully.  This results in quite
useless badblocks output: it's slow *and* wrong.


A *fourth* bug, if anyone cares, is that test_ro() only allocates *one*
block worth of pattern buffer when using the -t flag, so again doesn't
work right if the pattern length does not divide the block length.
(More specifically, it doesn't match what test_rw() writes.)


And a *fifth* bug... in test_ro(), if a bad block was detected on a
previous pass, try is decreased to ensure the read stops before next_bad,
but it's never increased again.  Again, severe performance loss.


This isn't the world's most subtle code, but fixing it requires some
pretty major surgery and I worry I'll exacerbate the cruftiness of
the code.  Would the Poor Bloody Maintainer like to express any wishes
on the subject?
