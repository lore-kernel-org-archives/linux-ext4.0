From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] generic: test bug when zero range is crossing isize
 within single block
Date: Mon, 27 Apr 2015 16:27:41 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1504271624500.4586@localhost.localdomain>
References: <1429886309-30383-1-git-send-email-lczerner@redhat.com> <20150427040803.GB17534@dhcp-13-216.nay.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20150427040803.GB17534@dhcp-13-216.nay.redhat.com>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 27 Apr 2015, Eryu Guan wrote:

> Date: Mon, 27 Apr 2015 12:08:03 +0800
> From: Eryu Guan <eguan@redhat.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] generic: test bug when zero range is crossing isize
>     within single block
> 
> On Fri, Apr 24, 2015 at 04:38:29PM +0200, Lukas Czerner wrote:
> > Exercise the situation that cause ext4 to BUG_ON() when we use
> > zero range to zero a range which starts within the isize but ends
> > past the isize but still in the same block. This particular problem
> > has only been seen on systems with page_size > block_size.
> > 
> > This tests exercises the problem fixed in kernel with commit
> > a94b84e9ea3922220ae8bd654f6cb202904bbcac
> > ext4: Allocate entire range in zero range
> 
> Seems the commit id is 0f2af21aae11972fa924374ddcf52e88347cf5a8 in Linus tree

Hmm it's a94b84e9ea3922220ae8bd654f6cb202904bbcac on my
repository, but I might have something custom forgotten there.

Will resend, Thanks.

> 
> Tested with 1k block size ext4 without the kernel patch, ext4 hit BUG_ON
> as expected. xfs and btrfs passed this test.
> 
> Reviewed-by: Eryu Guan <eguan@redhat.com>
> 
> (with two minor comments inline)
> 
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  tests/generic/084     | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/084.out |  1 +
> >  tests/generic/group   |  1 +
> >  3 files changed, 62 insertions(+)
> >  create mode 100644 tests/generic/084
> 
> Change mode to 755? So git won't report mode chage after running the test
> 
> >  create mode 100644 tests/generic/084.out
> > 
> > diff --git a/tests/generic/084 b/tests/generic/084
> > new file mode 100644
> > index 0000000..5066b14
> > --- /dev/null
> > +++ b/tests/generic/084
> > @@ -0,0 +1,60 @@
> > +#! /bin/bash
> > +# FS QA Test 084
> > +#
> > +# Exercise the situation that cause ext4 to BUG_ON() when we use
> > +# zero range to zero a range which starts within the isize but ends
> > +# past the isize but still in the same block. This particular problem
> > +# has only been seen on systems with page_size > block_size.
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
> > +_require_xfs_io_command "fzero"
> > +
> > +testfile=$TEST_DIR/$seq.$$
> > +
> > +$XFS_IO_PROG -f -c "pwrite 4096 512" -c "fzero 4351 512" $testfile > $seqres.full 2>&1
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/084.out b/tests/generic/084.out
> > new file mode 100644
> > index 0000000..d0aa380
> > --- /dev/null
> > +++ b/tests/generic/084.out
> > @@ -0,0 +1 @@
> > +QA output created by 084
> 
> Add "Silence is golden" to indicate no output from test is expected?
> 
> Thanks,
> Eryu
> > diff --git a/tests/generic/group b/tests/generic/group
> > index c6ea3d8..6cb7dc3 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -86,6 +86,7 @@
> >  081 auto quick
> >  082 auto prealloc preallocrw quick
> >  083 rw auto enospc stress
> > +084 auto prealloc quick
> >  088 perms auto quick
> >  089 metadata auto
> >  091 rw auto quick
> > -- 
> > 1.8.3.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
