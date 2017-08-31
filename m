From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [fstests PATCH] generic: add test for executables on read-only
 DAX mounts
Date: Wed, 30 Aug 2017 22:01:46 -0600
Message-ID: <20170831040146.GA17095@linux.intel.com>
References: <20170829213721.GA27686@linux.intel.com>
 <20170829223715.26507-1-ross.zwisler@linux.intel.com>
 <20170830105930.GE27835@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Randy Dodgen <rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170830105930.GE27835-+7p9VZFSOIEFmhoHi+V13ACJwEvxM/w9@public.gmane.org>
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

On Wed, Aug 30, 2017 at 06:59:30PM +0800, Eryu Guan wrote:
> On Tue, Aug 29, 2017 at 04:37:15PM -0600, Ross Zwisler wrote:
> > This adds a regression test for the following kernel patch:
> > 
> > commit 42d4a99b09cb ("ext4: fix fault handling when mounted with -o dax,ro")
> > 
> > The above patch fixes an issue with ext4 where executables cannot be run on
> > read-only filesystems mounted with the DAX option.
> > 
> > This issue does not appear to be present in ext2 or XFS, as they both pass
> > the test.  I've also confirmed outside of the test that they are both
> > indeed able to execute binaries on read-only DAX mounts.
> > 
> > Thanks to Randy Dodgen for the bug report and reproduction steps.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Randy Dodgen <rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> > 
> > ---
> > 
> > Sorry if we collided, Randy, but I was 90% done with the test by the time I
> > saw your mail. :)
> > ---
> >  tests/generic/452     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/452.out |  2 ++
> >  tests/generic/group   |  1 +
> >  3 files changed, 90 insertions(+)
> >  create mode 100755 tests/generic/452
> >  create mode 100644 tests/generic/452.out
> > 
> > diff --git a/tests/generic/452 b/tests/generic/452
> > new file mode 100755
> > index 0000000..54dda8c
> > --- /dev/null
> > +++ b/tests/generic/452
> > @@ -0,0 +1,87 @@
> > +#! /bin/bash
> > +# FS QA Test 452
> > +#
> > +# This is a regression test for kernel patch:
> > +#   commit 42d4a99b09cb ("ext4: fix fault handling when mounted with -o dax,ro")
> > +# created by Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
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
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +# real QA test starts here
> > +# format and mount
> > +_scratch_mkfs > $seqres.full 2>&1
> > +_scratch_mount >> $seqres.full 2>&1
> 
> Need to _notrun if scratch device was mounted with "noexec" option.
> 
> _exclude_scratch_mount_option "noexec"
> 
> > +
> > +LS=$(which ls --skip-alias --skip-functions) 2>/dev/null
> > +if [ $? -ne 0 ]; then
> > +	status=$?
> > +	echo "Couldn't find 'ls'!?"
> > +	exit
> > +fi
> > +
> > +cp $LS $SCRATCH_MNT
> > +SCRATCH_LS=$SCRATCH_MNT/ls
> > +
> > +$SCRATCH_LS >/dev/null 2>&1
> > +if [ $? -ne 0 ]; then
> > +	status=$?
> > +	echo "$SCRATCH_LS not working before remount"
> > +	exit
> > +fi
> > +
> > +_scratch_remount ro
> > +
> > +$SCRATCH_LS >/dev/null 2>&1
> > +if [ $? -ne 0 ]; then
> > +	status=$?
> > +	echo "$SCRATCH_LS not working after remount"
> > +	exit
> > +fi
> 
> Hmm, I don't think all these checks on return value are needed, just
> print out the error messages on failure and that will break the golden
> image, as this is not a destructive test, continuing with errors only
> fail the test :)
> 
> I think this can be simplified to something like:
> 
> LS=$(which ls ....)
> SCRATCH_LS=$SCRATCH_MNT/ls_on_scratch
> cp $LS $SCRATCH_LS
> 
> $SCRATCH_LS $SCRATCH_LS | _filter_scratch
> 
> _scratch_remount ro
> 
> $SCRATCH_LS $SCRATCH_LS | _filter_scratch
> 
> And update .out file accordingly.
> 
> Thanks,
> Eryu

Awesome, thanks for the review!  I'll fix all of these in v2.
