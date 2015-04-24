From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] generic: test data corruption on ext4 caused by
 written/delayed extent
Date: Fri, 24 Apr 2015 12:46:10 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1504241245520.17731@localhost.localdomain>
References: <1429714555-22133-1-git-send-email-lczerner@redhat.com> <20150423034909.GS17534@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20150423034909.GS17534@dhcp-13-216.nay.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 23 Apr 2015, Eryu Guan wrote:

> Date: Thu, 23 Apr 2015 11:49:09 +0800
> From: Eryu Guan <eguan@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] generic: test data corruption on ext4 caused by
>     written/delayed extent
> 
> On Wed, Apr 22, 2015 at 04:55:55PM +0200, Lukas Czerner wrote:
> > This test excercises the problem with unwritten and delayed extents
> > in ext4 extent status tree where we might in some cases lose a block
> > worth of data. Even though this was a ext4 specific problem the
> > reproducer can be easily tun on any file system so let's do that just
> > in case.
> > 
> > This tests excercises the problem fixed in kernel with commit
> > "ext4: Fix data corruption caused by unwritten and delayed extents"
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  tests/generic/082     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/082.out | 14 +++++++++
> >  2 files changed, 98 insertions(+)
> >  create mode 100755 tests/generic/082
> >  create mode 100644 tests/generic/082.out
> 
> update to tests/generic/group file is missing
> 
> > 
> > diff --git a/tests/generic/082 b/tests/generic/082
> > new file mode 100755
> > index 0000000..2fa22c6
> > --- /dev/null
> > +++ b/tests/generic/082
> > @@ -0,0 +1,84 @@
> > +#! /bin/bash
> > +# FS QA Test 082
> > +#
> > +# This test excercises the problem with unwritten and delayed extents
> > +# in ext4 extent status tree where we might in some cases lose a block
> > +# worth of data. Even though this was a ext4 specific problem the
> > +# reproducer can be easily tun on any file system so let's do that just
> > +# in case.
> > +#
> > +# This tests excercises the problem fixed in kernel with commit
> > +# "ext4: Fix data corruption caused by unwritten and delayed extents"
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2015 Red Hat, Inc., Lukas Czerner <lczerner@redhat.com>
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
> > +#
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os IRIX Linux
> > +_require_test
> 
> _require_xfs_io_command "falloc" too
> 
> I saw failure on cifs because it doesn't support fallocate so the file
> size is not extended, and hexdump output differs
> 
> > +
> > +test_file=${TEST_DIR}/testfile-082
> 
> use $seq not hardcoded 082?
> 
> > +
> > +rm -f $test_file
> 
> rm -f $seqres.full too, otherwise the file keeps growing

Will resend.

Thanks!
-Lukas

> 
> Thanks,
> Eryu
> > +
> > +# The first write creates a delayed extent, fallocate creates
> > +# unwritten extent which will be marked as delayed in ext4
> > +# extent status tree. Second write will convert unwritten/delayed
> > +# block into written/delayed.
> > +$XFS_IO_PROG -f -c "pwrite -S 0xaa 4096 2048" \
> > +		-c "falloc 0 131072" \
> > +		-c "pwrite -S 0xbb 65536 2048" \
> > +		-c "fsync"  $test_file >> $seqres.full 2>&1
> > +
> > +# Drop the caches to evict dirty buffers from memory
> > +echo 3 > /proc/sys/vm/drop_caches
> > +
> > +# Write into the second part of the block with 0xbb write from before
> > +# will create new empty! buffer because the block is still marked as
> > +# delayed even though it's already written - resulting in
> > +# overwriting previous data.
> > +$XFS_IO_PROG -c "pwrite -S 0xdd 67584 2048" $test_file >> $seqres.full 2>&1
> > +
> > +# On a faulty ext4 oxbb data will be missing, overwritten by zeroes.
> > +hexdump -C $test_file
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/082.out b/tests/generic/082.out
> > new file mode 100644
> > index 0000000..ef28b9a
> > --- /dev/null
> > +++ b/tests/generic/082.out
> > @@ -0,0 +1,14 @@
> > +QA output created by 082
> > +00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > +*
> > +00001000  aa aa aa aa aa aa aa aa  aa aa aa aa aa aa aa aa  |................|
> > +*
> > +00001800  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > +*
> > +00010000  bb bb bb bb bb bb bb bb  bb bb bb bb bb bb bb bb  |................|
> > +*
> > +00010800  dd dd dd dd dd dd dd dd  dd dd dd dd dd dd dd dd  |................|
> > +*
> > +00011000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> > +*
> > +00020000
> > -- 
> > 1.8.3.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
