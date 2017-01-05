From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 1/1] xfstests: ext4/023: reproduces incorrect right
 shift (insert range)
Date: Thu, 5 Jan 2017 20:04:10 +0800
Message-ID: <20170105120410.GW1859@eguan.usersys.redhat.com>
References: <20170104190806.10795-1-roman.penyaev@profitbricks.com>
 <20170105092812.GT1859@eguan.usersys.redhat.com>
 <CAJrWOzBkqoN3oxJRgDG5KBaY8xXma_GmaEYg-7PDBGfhMFO7zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org
To: Roman Penyaev <roman.penyaev@profitbricks.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJrWOzBkqoN3oxJRgDG5KBaY8xXma_GmaEYg-7PDBGfhMFO7zg@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 05, 2017 at 11:56:14AM +0100, Roman Penyaev wrote:
> On Thu, Jan 5, 2017 at 10:28 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Wed, Jan 04, 2017 at 08:08:06PM +0100, Roman Pen wrote:
> >> Test tries to insert many blocks at the same offset to reproduce
> >> the following layout:
> >>
> >>    block #0  block #1
> >>    |ext0 ext1|ext2 ext3 ...|
> >>         ^
> >>      insert of a new block
> >>
> >> Because of an incorrect range first block is never reached,
> >> thus ext1 is untouched, resulting to a hole at a wrong offset:
> >>
> >> What we got:
> >>
> >>    block #0   block #1
> >>    |ext0 ext1|   ext2 ext3 ...|
> >>               ^
> >>               hole at a wrong offset
> >>
> >> What we expect:
> >>
> >>    block #0    block #1
> >>    |ext0   ext1|ext2 ext3 ...|
> >>         ^
> >>         hole at a correct offset
> >>
> >> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.com>
> >> Cc: "Theodore Ts'o <tytso@mit.edu>"
> >> Cc: linux-ext4@vger.kernel.org
> >> Cc: fstests@vger.kernel.org
> >
> > Thanks for the test! A few comments inline.
> >
> >> ---
> >> v1..v2:
> >>
> >> '_require_xfs_io_command "finsert"' line was added to prevent
> >> the test to fail on "ext3", "bigalloc" and "bigalloc_1k"
> >> configurations.
> >>
> >>  tests/ext4/023     | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/ext4/023.out |   2 +
> >>  tests/ext4/group   |   1 +
> >>  3 files changed, 128 insertions(+)
> >>  create mode 100755 tests/ext4/023
> >>  create mode 100644 tests/ext4/023.out
> >>
> >> diff --git a/tests/ext4/023 b/tests/ext4/023
> >> new file mode 100755
> >> index 000000000000..2cd890731eb5
> >> --- /dev/null
> >> +++ b/tests/ext4/023
> >> @@ -0,0 +1,125 @@
> >> +#! /bin/bash
> >> +# FS QA Test 023
> >> +#
> >> +# Regression test which reproduces an incorrect right shift
> >> +# (insert range) for the first extent in a range.
> >> +#
> >> +# Test tries to insert many blocks at the same offset to reproduce
> >> +# the following layout:
> >> +#
> >> +#    block #0  block #1
> >> +#    |ext0 ext1|ext2 ext3 ...|
> >> +#         ^
> >> +#      insert of a new block
> >> +#
> >> +# Because of an incorrect range first block is never reached,
> >> +# thus ext1 is untouched, resulting to a hole at a wrong offset:
> >> +#
> >> +# What we got:
> >> +#
> >> +#    block #0   block #1
> >> +#    |ext0 ext1|   ext2 ext3 ...|
> >> +#               ^
> >> +#               hole at a wrong offset
> >> +#
> >> +# What we expect:
> >> +#
> >> +#    block #0    block #1
> >> +#    |ext0   ext1|ext2 ext3 ...|
> >> +#         ^
> >> +#         hole at a correct offset
> >> +#
> >> +#-----------------------------------------------------------------------
> >> +# Copyright (c) 2017 Roman Penyaev.  All Rights Reserved.
> >> +#
> >> +# This program is free software; you can redistribute it and/or
> >> +# modify it under the terms of the GNU General Public License as
> >> +# published by the Free Software Foundation.
> >> +#
> >> +# This program is distributed in the hope that it would be useful,
> >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> +# GNU General Public License for more details.
> >> +#
> >> +# You should have received a copy of the GNU General Public License
> >> +# along with this program; if not, write the Free Software Foundation,
> >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> +#-----------------------------------------------------------------------
> >> +#
> >> +
> >> +seq=`basename $0`
> >> +seqres=$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=`pwd`
> >> +tmp=/tmp/$$
> >> +status=1     # failure is the default!
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +     cd /
> >> +     rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/filter
> >> +
> >> +# remove previous $seqres.full before test
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +
> >> +# Modify as appropriate.
> >> +_supported_fs ext4
> >
> > This test can be made generic, there's nothing ext4-specific in this
> > test, and you can use helper function "get_block_size" to query
> > filesystem blocksize, so ..
> 
> Test is generic, true.  My thoughts were that it targets specific ext4
> bug. But you are right, better to make it generic.  Will move it there.
> 
> >
> >> +_supported_os Linux
> >> +_require_test
> >> +_require_dumpe2fs
> >
> > no need to require & use dumpe2fs.
> 
> ok.
> 
> >
> >> +_require_xfs_io_command "finsert"
> >> +
> >> +pattern=$tmp
> >> +testfile=$TEST_DIR/023.file
> >
> > Use $seq number not hardcoded number. e.g.
> >
> > testfile=$TEST_DIR/$seq.file
> 
> ok.
> 
> >
> >> +
> >> +blksize=`$DUMPE2FS_PROG -h $TEST_DEV 2>/dev/null | grep "Block size" | \
> >> +     awk '{print $3}'`
> >
> > blksize=`get_block_size $TEST_DIR`
> 
> good hint, thanks.
> 
> >
> >> +
> >> +# Generate a block with a repeating number represented as 4 bytes decimal.
> >> +function generate_pattern() {
> >> +     blkind=$1
> >> +     printf "%04d" $blkind | awk  '{ while (c++ < '$(($blksize/4))') \
> >> +             printf "%s", $0 }' > $pattern
> >> +}
> >
> > I don't think this is necessary, see below
> >
> >> +
> >> +echo -n > $testfile
> >> +$XFS_IO_PROG -c "falloc 0 $(($blksize * 2))" $testfile \
> >> +                      >> $seqres.full 2>&1
> >
> > $XFS_IO_PROG -f -c "...", -f option creates the file for you if it's not
> > existed :)
> 
> This 'echo -n' it creates & truncates a test file.  Truncation is important,
> I experienced that the file is not removed between runs.
> 
> Where is the good place to remove testfile?  Put rm to cleanup() ?

You're right, I forgot that $testfile is in $TEST_DIR, not $SCRATCH_MNT.
Yeah, remove testfile in _cleanup().

> 
> >
> >> +
> >> +# First block, has 0001 as a pattern
> >> +generate_pattern 1
> >> +$XFS_IO_PROG -c "pwrite -i $pattern        0 $blksize" $testfile \
> >> +                      >> $seqres.full 2>&1
> >> +
> >> +# Second block, has 0002 as a pattern
> >> +generate_pattern 2
> >> +$XFS_IO_PROG -c "pwrite -i $pattern $blksize $blksize" $testfile \
> >> +                      >> $seqres.full 2>&1
> >> +
> >> +# Insert 998 blocks after the first block
> >> +for (( block=3; block<=1000; block++ )); do
> >> +     $XFS_IO_PROG -c "finsert $blksize $blksize" $testfile \
> >> +                              >> $seqres.full 2>&1
> >> +
> >> +     generate_pattern $block
> >> +     $XFS_IO_PROG -c "pwrite -i $pattern $blksize $blksize" $testfile \
> >> +                              >> $seqres.full 2>&1
> >> +done
> >
> > I think we can write any non-zero pattern to the file, and check if
> > there's any zero pattern in the file after doing all the insert & write
> > operations, because every zero block meant to be written by xfs_io in
> > the loop. If we see zero pattern, we know insert happens at the wrong
> > offset. So I'd suggest something like:
> 
> Yes, that was my first variant.  'xfs_io -c pwrite' is able to write
> random bytes (also pattern), I used this feature.  The test looked nicer
> and not so bloated.
> 
> But, the thing is that behind this 'insert range' bug, there is another
> one: https://www.spinics.net/lists/linux-ext4/msg54934.html
> 
> This is hard to reproduce and the major symptom is that you do not see
> zero blocks, but the order of blocks are wrong.
> 
> (It can be reproduced if we stop insertion just after we got this layout
> |ext0 ext1|ext2 ext3 ...|.  So probably the test could be modified and
>  after each insert 'debugfs dump_extents' should be called in order
>  to stop in a correct moment.  But seems that's overkill.)
> 
> That's why I decided to make a test more robust and to write blocks with
> some index inside to make sure, that the test will immediately observe
> the wrong order.

Thanks for the explanation! Then I think you need to describe this bug
in commit log and in test comments too, so others could know what you
want to test.

> 
> Also, I would like to use this -S 0xXX feature of pwrite, but unfortunately
> the pattern can be only 1 byte long, but I insert 1000 blocks (with smaller
> number the reproduction can be lost because of a physical block merge), so
> at least I need 2 bytes for pattern to make blocks unique.

It's also good to know why you need 1000 blocks by adding comments :)

> 
> That's why so complicated :(
> 
> So, I would like to keep the test as is.  Probably this generate_pattern()
> can be simplified, but I did not find a good way.

I can't figure out a better way right now either.. but at least please
use $tmp.<suffix> to hold the pattern, otherwise "rm -f $tmp.*" won't
clean it up. e.g.

pattern=$tmp.pattern

Thanks,
Eryu
