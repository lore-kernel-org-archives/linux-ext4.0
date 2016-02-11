From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: test partial blocksize defrag integrity issue
Date: Thu, 11 Feb 2016 08:55:54 -0800
Message-ID: <20160211165554.GB6338@birch.djwong.org>
References: <1455117464-15565-1-git-send-email-eguan@redhat.com>
 <20160210231614.GC19486@dastard>
 <20160211033628.GZ11419@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28147 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbcBKQ4E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Feb 2016 11:56:04 -0500
Content-Disposition: inline
In-Reply-To: <20160211033628.GZ11419@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 11, 2016 at 11:36:28AM +0800, Eryu Guan wrote:
> On Thu, Feb 11, 2016 at 10:16:14AM +1100, Dave Chinner wrote:
> > On Wed, Feb 10, 2016 at 11:17:44PM +0800, Eryu Guan wrote:
> > > Calling EXT4_IOC_MOVE_EXTENT on file not aligned with block size and
> > > block size is smaller than page size would cause integrity issue on the
> > > partial-blocksize part when copying data between orign file and donor
> > > file.
> > > 
> > > This ext4 kernel patch would fix it, titled
> > > "ext4: don't read blocks from disk after extents being swapped in
> > > move_extent_per_page())"
> > > 
> > > Though this bug only happens in the blocksize smaller than pagesize
> > > case, there's no harm to test on various block size fs, so no block size
> > > is specified in the test, it depends on the test configurations.
> > > 
> > > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > > ---
> > >  tests/ext4/020     | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/ext4/020.out |  6 ++++
> > >  tests/ext4/group   |  1 +
> > >  3 files changed, 96 insertions(+)
> > >  create mode 100755 tests/ext4/020
> > >  create mode 100644 tests/ext4/020.out
> > > 
> > > diff --git a/tests/ext4/020 b/tests/ext4/020
> > > new file mode 100755
> > > index 0000000..6740c7e
> > > --- /dev/null
> > > +++ b/tests/ext4/020
> > > @@ -0,0 +1,89 @@
> > > +#! /bin/bash
> > > +# FS QA Test 020
> > > +#
> > > +# Test partial blocksize defrag integrity issue.
> > > +#
> > > +# Calling EXT4_IOC_MOVE_EXTENT on file not aligned with block size and block
> > > +# size is smaller than page size would cause integrity issue on the
> > > +# partial-blocksize part when copying data between orign file and donor file.
> > > +#
> > > +#-----------------------------------------------------------------------
> > > +# Copyright (c) 2016 Red Hat Inc. All Rights Reserved.
> > > +#
> > > +# This program is free software; you can redistribute it and/or
> > > +# modify it under the terms of the GNU General Public License as
> > > +# published by the Free Software Foundation.
> > > +#
> > > +# This program is distributed in the hope that it would be useful,
> > > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +# GNU General Public License for more details.
> > > +#
> > > +# You should have received a copy of the GNU General Public License
> > > +# along with this program; if not, write the Free Software Foundation,
> > > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > > +#-----------------------------------------------------------------------
> > > +#
> > > +
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/defrag
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +# real QA test starts here
> > > +_supported_fs ext4
> > > +_supported_os Linux
> > > +_require_scratch
> > > +_require_defrag
> > > +
> > > +e4compact=$here/src/e4compact
> > > +if [ ! -x $d4compact ]; then
> >               ^^^^^^^^^
> 
> My test run didn't complain about missing the binary and I found out
> that I should have added quotes around $d4compact, that way test _notrun
> as expect and catches the typo. Thanks for the review!
> 
> > > +	_notrun "$e4compact executable not found"
> > > +fi
> > 
> > And, yes, we really need that _requires_test_command function that
> > Darrick was adding to his patchset...
> 
> I'll wait for the new patch from Darrick and send v2 then.

I'll have it out later today -- I'm planning to spot-check the patches for
obvious errors after breakfast.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
