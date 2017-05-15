From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: fsmap tests
Date: Mon, 15 May 2017 10:04:48 -0700
Message-ID: <20170515170448.GB4510@birch.djwong.org>
References: <20170513035813.GA4514@birch.djwong.org>
 <20170515163331.GW7250@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, fstests <fstests@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170515163331.GW7250@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 16, 2017 at 12:33:31AM +0800, Eryu Guan wrote:
> On Fri, May 12, 2017 at 08:58:13PM -0700, Darrick J. Wong wrote:
> > Test the GETFSMAP ioctl against ext4.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/ext4        |   11 +++++++
> >  tests/ext4/700     |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/ext4/700.out |    7 ++++
> >  tests/ext4/701     |   65 +++++++++++++++++++++++++++++++++++++++
> >  tests/ext4/701.out |    3 ++
> >  tests/ext4/702     |   66 ++++++++++++++++++++++++++++++++++++++++
> >  tests/ext4/702.out |    4 ++
> >  tests/ext4/group   |    3 ++
> >  8 files changed, 245 insertions(+)
> >  create mode 100644 common/ext4
> >  create mode 100755 tests/ext4/700
> >  create mode 100644 tests/ext4/700.out
> >  create mode 100755 tests/ext4/701
> >  create mode 100644 tests/ext4/701.out
> >  create mode 100755 tests/ext4/702
> >  create mode 100644 tests/ext4/702.out
> > 
> > diff --git a/common/ext4 b/common/ext4
> > new file mode 100644
> > index 0000000..1528c86
> > --- /dev/null
> > +++ b/common/ext4
> > @@ -0,0 +1,11 @@
> > +#
> > +# ext4 specific common functions
> > +#
> > +
> > +_ext4_sbfield()
> > +{
> > +	field="$1"
> > +	dev="$2"
> > +
> > +	dumpe2fs -h $dev 2>/dev/null | grep "^$field" | sed -e "s/^.*$field:[[:space:]]*\(.*\)$/\1/g"
> 
> $DUMPE2FS_PROG?
> 
> > +}
> > diff --git a/tests/ext4/700 b/tests/ext4/700
> > new file mode 100755
> > index 0000000..64c86ed
> > --- /dev/null
> > +++ b/tests/ext4/700
> > @@ -0,0 +1,86 @@
> > +#! /bin/bash
> > +# FS QA Test No. 700
> > +#
> > +# Check that getfsmap reports the BG metadata we're expecting.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
> 
> rm -rf looks dangerous, there're no directories, rm -f should just work,
> and 'testout' isn't used in this test.

<nod> I was merely copy-pasting from all the other scripts... :)

> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/ext4
> 
> Hmm, I think we should source common/ext4 in common/rc, as where we
> source common/{xfs,btrfs}, not in individual test.
> 
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ext4
> > +_require_scratch
> > +_require_xfs_io_command "fsmap"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +blocks=$(_ext4_sbfield "Block count" $SCRATCH_DEV)
> > +blocks_per_group=$(_ext4_sbfield "Blocks per group" $SCRATCH_DEV)
> > +bg_per_flex=$(_ext4_sbfield "Flex block group size" $SCRATCH_DEV)
> > +bgs=$(( (blocks + blocks_per_group - 1) / blocks_per_group ))
> > +if [ -z "$bg_per_flex" ]; then
> > +	fbg=$((bgs / bg_per_flex))
> > +else
> > +	fbg=$bgs
> > +fi
> 
> I don't see how these vars are used, blocks, blocks_per_ground, bgs and
> fbg, test still passes even if I comment the whole code block out.
> Missed some checks on these vars?

Nah, that was a leftover remnant from when I thought I would check that
the number of bitmap blocks and group descriptors matched the fs
geometry.  Then I realized that repaired and resize2fs'd flexbgs would
screw all that up, so ... we can just abandon the whole thing.  That
gets rid of common/ext4, so even better....

> > +_scratch_mount
> > +
> > +echo "Get fsmap" | tee -a $seqres.full
> > +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT > $TEST_DIR/fsmap
> > +cat $TEST_DIR/fsmap >> $seqres.full
> > +
> > +echo "Check fs metadata" | tee -a $seqres.full
> > +x=$(grep -c 'static fs metadata' $TEST_DIR/fsmap)
> > +test $x -gt 0 || echo "No fs metadata?"
> > +
> > +echo "Check block bitmap" | tee -a $seqres.full
> > +x=$(grep -c 'special 102:1' $TEST_DIR/fsmap)
> > +test $x -gt 0 || echo "No block bitmaps?"
> > +
> > +echo "Check inode bitmap" | tee -a $seqres.full
> > +x=$(grep -c 'special 102:2' $TEST_DIR/fsmap)
> > +test $x -gt 0 || echo "No inode bitmaps?"
> > +
> > +echo "Check inodes" | tee -a $seqres.full
> > +x=$(grep -c 'inodes' $TEST_DIR/fsmap)
> > +test $x -gt 0 || echo "No inodes?"
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ext4/700.out b/tests/ext4/700.out
> > new file mode 100644
> > index 0000000..3984319
> > --- /dev/null
> > +++ b/tests/ext4/700.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 700
> > +Format and mount
> > +Get fsmap
> > +Check fs metadata
> > +Check block bitmap
> > +Check inode bitmap
> > +Check inodes
> > diff --git a/tests/ext4/701 b/tests/ext4/701
> > new file mode 100755
> > index 0000000..c50bbf2
> > --- /dev/null
> > +++ b/tests/ext4/701
> > @@ -0,0 +1,65 @@
> > +#! /bin/bash
> > +# FS QA Test No. 701
> > +#
> > +# Populate filesystem, check that fsmap -n10000 matches fsmap -n1.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf "$tmp".* $TEST_DIR/a $TEST_DIR/b
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/populate
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ext4
> > +_require_scratch
> > +_require_populate_commands
> > +_require_xfs_io_command "fsmap"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > +
> > +echo "Compare fsmap" | tee -a $seqres.full
> > +_scratch_mount
> > +$XFS_IO_PROG -c 'fsmap -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/a
> > +$XFS_IO_PROG -c 'fsmap -n 1' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
> > +cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
> > +
> > +diff -uw $TEST_DIR/a $TEST_DIR/b
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ext4/701.out b/tests/ext4/701.out
> > new file mode 100644
> > index 0000000..41ef1c6
> > --- /dev/null
> > +++ b/tests/ext4/701.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 701
> > +Format and mount
> > +Compare fsmap
> > diff --git a/tests/ext4/702 b/tests/ext4/702
> > new file mode 100755
> > index 0000000..d5e15ef
> > --- /dev/null
> > +++ b/tests/ext4/702
> > @@ -0,0 +1,66 @@
> > +#! /bin/bash
> > +# FS QA Test No. 702
> > +#
> > +# Check that getfsmap reports external log devices
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename "$0"`
> > +seqres="$RESULT_DIR/$seq"
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs ext4
> > +_require_logdev
> 
> ext4 has no SCRATCH_LOGDEV support yet. Jeff added such support to ext4
> in his patchset, but I haven't looked at that patch closely yet..
> 
> > +_require_scratch
> > +_require_xfs_io_command "fsmap"
> > +
> > +rm -f "$seqres.full"
> > +
> > +echo "Format and mount"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +echo "Get fsmap" | tee -a $seqres.full
> > +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
> > +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
> > +
> > +echo "Check device field of FS metadata and journalling log"
> > +data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
> > +journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
> > +test "${data_dev}" != "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
> 
> Test passed even if there's no LOGDEV support for ext4, as long as I
> have SCRATCH_LOGDEV set and USE_EXTERNAL set to yes. But journal_dev is
> empty in this case, apparently "8:34" != "" :)

I had a hunk somewhere to add this to _scratch_mkfs_ext4, but it clearly
fell out somewhere along the way. :(

I'll go review Jeff's patch then resubmit.

--D

> 
> Thanks,
> Eryu
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/ext4/702.out b/tests/ext4/702.out
> > new file mode 100644
> > index 0000000..1d3b7ef
> > --- /dev/null
> > +++ b/tests/ext4/702.out
> > @@ -0,0 +1,4 @@
> > +QA output created by 702
> > +Format and mount
> > +Get fsmap
> > +Check device field of FS metadata and journalling log
> > diff --git a/tests/ext4/group b/tests/ext4/group
> > index 664c059..9007adf 100644
> > --- a/tests/ext4/group
> > +++ b/tests/ext4/group
> > @@ -37,3 +37,6 @@
> >  306 auto rw resize quick
> >  307 auto ioctl rw defrag
> >  308 auto ioctl rw prealloc quick defrag
> > +700 auto quick fsmap
> > +701 auto quick fsmap
> > +702 auto quick fsmap
