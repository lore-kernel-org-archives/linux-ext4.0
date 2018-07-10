From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [fstests PATCH 2/2] generic/999: test DAX DMA vs
 truncate/hole-punch
Date: Tue, 10 Jul 2018 15:15:19 -0600
Message-ID: <20180710211519.GA25279@linux.intel.com>
References: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
 <20180620225147.12151-2-ross.zwisler@linux.intel.com>
 <20180621024033.GK2780@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180621024033.GK2780@desktop>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 21, 2018 at 10:40:33AM +0800, Eryu Guan wrote:
> On Wed, Jun 20, 2018 at 04:51:47PM -0600, Ross Zwisler wrote:
<>

> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..8f488cb5
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,50 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2018 Intel Corporation.  All Rights Reserved.
> > +#
> > +# FS QA Test generic/999
> > +#
> > +# This is a regression test for kernel patch:
> > +#   ext4: handle layout changes to pinned DAX mapping
> > +# created by Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > +#
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
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_test
> > +_require_test_program "t_mmap_collision"
> 
> _require_xfs_io_command "fpunch"
> _require_xfs_io_command "fcollapse"
> _require_xfs_io_command "fzero"

I don't think I need these because I don't actually require this functionality
from xfs_io.  I did try and use xfs_io for this test, but the way the
threading needs to work I ended up having to write my own C program.  So,
even if xfs_io happens to be old and without fpunch, for example, as long as
fallocate can use FALLC_FL_PUNCH_HOLE I think the test should do the right
thing.

> > diff --git a/tests/generic/group b/tests/generic/group
> > index 83a6fdab..793f71ed 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -501,3 +501,4 @@
> >  496 auto quick swap
> >  497 auto quick swap collapse
> >  498 auto quick log
> > +999 auto quick dax
> 
> Also need "punch collapse zero" groups.

I'm assuming I should still add my test to these 3 groups, even though I'm not
getting this functionality via xfs_io?

Thank you for the review, I'll address the rest of your comments in v2.
