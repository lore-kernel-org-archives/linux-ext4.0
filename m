From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Tue, 9 Sep 2014 18:13:28 -0700
Message-ID: <20140910011328.GA2883@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <427E29B6-1780-4CD1-8E31-FE50490F153E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27011 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIJBNf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 21:13:35 -0400
Content-Disposition: inline
In-Reply-To: <427E29B6-1780-4CD1-8E31-FE50490F153E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2014 at 04:53:16PM -0600, Andreas Dilger wrote:
> On Sep 8, 2014, at 5:11 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Patch 1 introduces journal_csum v3 to fix numerous journal block tag
> > size handling bugs when metadata_csum+journal_checksum are turned on.
> > The test of 64bitness should not rely on guessing the tag size when it
> > could simply query the feature flags, since it was guessing
> > incorrectly.  Furthermore, the journal_csum v2 structure had memory
> > access alignment issues.  Just replace this all with a 16-byte tag
> > with everything in it; the overhead for checksums is no more than
> > 0.1%.
> 
> It's really too bad that we are introducing a new journal checksum
> feature, when the current journal checksum implementation is
> essentially unusable.  Any minor corruption in one transaction block
> that has following un-checkpointed transactions will almost certainly
> result in _more_ corruption of the filesystem rather than less, due
> to all of the *committed* but uncheckpointed blocks being discarded
> from the journal.  This would also result in a silent rollback of
> filesystem state and loss of user data if running with data=journal.
> 
> As a result, there is no practical value (IMHO) to enabling this
> feature at all currently.
> 
> We've discussed in the past that having per-block checksums is
> necessary in order to fix this, so that only corrupt blocks in the
> journal are skipped during replay, and may not result in any visible
> filesystem corruption if the blocks are overwritten later during
> replay.  Otherwise, this will itself result in yet a new block tag
> format and journal checksum feature.
> 
> Is there any chance you could take a look at implementing this as
> part of journal_checksum_v3 instead of fixing the current bugs only
> to have a "correctly working" but not usable feature?

Journal checksum v2 implements this.  The kernel skips the corrupt block,
continues the journal replay and refuses to mount, thereby forcing a fsck run.
fsck does the same, but it (obviously) runs a full check after the replay to
find anything other damage.

>From tests/j_corrupt_journal_block/image.gz, we see these journal contents:

debugfs:  logdump -c
Journal starts at block 1, transaction 3
Found expected sequence 3, type 1 (descriptor block) at block 1
Found expected sequence 3, type 2 (commit block) at block 4
Found expected sequence 4, type 5 (revoke table) at block 5
Found expected sequence 4, type 2 (commit block) at block 6
Found expected sequence 5, type 1 (descriptor block) at block 7
Found expected sequence 5, type 2 (commit block) at block 9
Found expected sequence 6, type 1 (descriptor block) at block 10
Found expected sequence 6, type 2 (commit block) at block 12
No magic number at block 13: end of journal.

This test checks the "continues replaying even after a corrupt journal block"
feature by using the journal to overwrite the blocks of a file.  Originally, /a
contains 3 blocks worth of 'a':

debugfs:  cat /a
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<snip>
debugfs:  stat /a
Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 3642437594    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 3072
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 6
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x53eb0316:145457c8 -- Tue Aug 12 23:17:58 2014
 atime: 0x53eb0316:145457c8 -- Tue Aug 12 23:17:58 2014
 mtime: 0x53eb0316:145457c8 -- Tue Aug 12 23:17:58 2014
crtime: 0x53eb0316:145457c8 -- Tue Aug 12 23:17:58 2014
Size of extra inode fields: 28
Inode checksum: 0x98f0c609
EXTENTS:
(0-2):1090-1092

(For the ease of the reader, 1090 == 0x442.)

In the first transaction, we overwrite the first two blocks of /a with 'b'.

debugfs:  bmap <8> 1
33
debugfs:  bd 33
0000  c03b 3998 0000 0001 0000 0003 0000 0442  .;9............B
0020  0000 0000 0000 0000 cdc6 611c 0000 0000  ..........a.....
0040  0000 0000 0000 0000 0000 0000 0000 0443  ...............C
0060  0000 000a 0000 0000 cdc6 611c 0000 0000  ..........a.....

Note the two descriptor tags referring to blocks 1090-1091.

debugfs:  bmap <8> 2
35
debugfs:  bd 35
0000  6262 6262 6262 6262 6262 6262 6262 6262  bbbbbbbbbbbbbbbb
*
debugfs:  bmap <8> 3
36
debugfs:  bd 36
0000  6262 6262 6262 6262 6262 6262 6262 6262  bbbbbbbbbbbbbbbb
*

We commit the first transaction in block 4.

In the second transaction, we revoke the first block of the first transaction.
At this point, /a will be left with a block of 'a', a block of 'b', and another
block of 'a':

debugfs:  bmap <8> 5
38
debugfs:  bd 38
0000  c03b 3998 0000 0005 0000 0004 0000 0018  .;9.............
0020  0000 0000 0000 0442 0000 0000 0000 0000  .......B........

This was done mostly to test ... NUTS, a bug.  When we see an error, we ought
to kill all the revoke records and restart the replay, because the revoke table
could've nixed a previous journal block.

Ok, I'll go fix that.

In the third transaction, we overwrite the first block of /a (1090) with 'c'.
However, I have corrupted the journal block (by overwriting some of it with
'-') so that this block should not replay:

debugfs:  bmap <8> 7
40
debugfs:  bd 40
0000  c03b 3998 0000 0001 0000 0005 0000 0442  .;9............B
0020  0000 0008 0000 0000 9881 d4c5 0000 0000  ................
debugfs:  bmap <8> 8
41
debugfs:  bd 41
0000  2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0020  6363 6363 6363 6363 6363 6363 6363 6363  cccccccccccccccc
*

In the fourth transaction, we overwrite the last block of /a (1092) with 'd':

debugfs:  bmap <8> 10
43
debugfs:  bd 43
0000  c03b 3998 0000 0001 0000 0006 0000 0444  .;9............D
0020  0000 0008 0000 0000 61ac 3738 0000 0000  ........a.78....
debugfs:  bmap <8> 11
44
debugfs:  bd 44
0000  6464 6464 6464 6464 6464 6464 6464 6464  dddddddddddddddd
*

As you can see from the expect output, after replaying the journal, the file
contents are a block of 'a', then a block of 'b', and then a block of 'd',
which is consistent with skipping the corrupted block but replaying the rest.

This is actually broken; the file contents SHOULD be two blocks of 'b' and a
block of 'd'.

--D

> 
> Cheers, Andreas
> 
> > NOTE: The test "j_corrupt_journal_block" in patch 21 ensures that
> > e2fsck will replay everything but the corrupt block, and then proceeds
> > with the fsck to fix up whatever might be broken.  You can decompress
> > the image.gz and try to mount it to verify that it's unmountable (and
> > hence requires e2fsck to be run).
> > 
> > Patches 23-25 implement v2 of the e2fsck readahead functionality,
> > which promises to reduce fsck runtime by 10-30%.  You might want to
> > read the report: http://marc.info/?l=linux-ext4&m=140755433701165&w=2
> > ("e2fsck readahead speedup performance report") for all the juicy
> > details!
> > 
> > I've tested these e2fsprogs changes against the -next branch as of
> > 8/29.  The patches have been tested against the 'make check' suite and
> > some amount of e2fuzz testing.
> > 
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


