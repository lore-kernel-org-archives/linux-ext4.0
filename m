From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [fstests PATCH v2] generic: add test for DAX MAP_SYNC support
Date: Wed, 25 Oct 2017 11:12:24 -0600
Message-ID: <20171025171224.GA12331@linux.intel.com>
References: <20171020052943.15104-1-ross.zwisler@linux.intel.com>
 <20171020212556.30816-1-ross.zwisler@linux.intel.com>
 <CAOQ4uxjWp3khOix__jqfsiyjhNehGtkqXXv1o7EuGB1j3b2moQ@mail.gmail.com>
 <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fstests <fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Wed, Oct 25, 2017 at 03:19:22PM +0300, Amir Goldstein wrote:
> On Sun, Oct 22, 2017 at 9:56 AM, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Sat, Oct 21, 2017 at 12:25 AM, Ross Zwisler
> > <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >> Add a test that exercises DAX's new MAP_SYNC flag.
> >>
> >> This test creates a file and writes to it via an mmap(), but never syncs
> >> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
> >>
> >> If MAP_SYNC is working the dm-log-writes replay will show the test file
> >> with 1MiB of on-media block allocations.  This is because each allocating
> >> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> >> (which you can test by fiddling with the parameters to mmap()) the file
> >> will be smaller or missing entirely.
> >>
> >> Note that dm-log-writes doesn't track the data that we write via the
> >> mmap(), so we can't do any data integrity checking.  We can only verify
> >> that the metadata writes for the page faults happened.
> >>
> >> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>
> >> ---
> >>
> >> Changes since v1:
> >>  - Addressed review feedback from Amir.  Thank you for the review!
> >
> > Looks good.
> >
> >>
> >> ---
> >>  .gitignore            |  1 +
> >>  common/dmlogwrites    |  1 -
> >>  src/Makefile          |  3 +-
> >>  src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
> >>  tests/generic/466.out |  3 ++
> >>  tests/generic/group   |  1 +
> >>  7 files changed, 175 insertions(+), 2 deletions(-)
> >>  create mode 100644 src/t_map_sync.c
> >>  create mode 100755 tests/generic/466
> >>  create mode 100644 tests/generic/466.out
> >>
> >> diff --git a/.gitignore b/.gitignore
> >> index 2014c08..9fc0695 100644
> >> --- a/.gitignore
> >> +++ b/.gitignore
> >> @@ -119,6 +119,7 @@
> >>  /src/t_getcwd
> >>  /src/t_holes
> >>  /src/t_immutable
> >> +/src/t_map_sync
> >>  /src/t_mmap_cow_race
> >>  /src/t_mmap_dio
> >>  /src/t_mmap_fallocate
> >> diff --git a/common/dmlogwrites b/common/dmlogwrites
> >> index 247c744..5b57df9 100644
> >> --- a/common/dmlogwrites
> >> +++ b/common/dmlogwrites
> >> @@ -23,7 +23,6 @@ _require_log_writes()
> >>         [ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
> >>                 _notrun "This test requires a valid \$LOGWRITES_DEV"
> >>
> >> -       _exclude_scratch_mount_option dax
> 
> Wait. It this really ok to relax no dax from _require_log_writes()?
> Shouldn't you check log-write target version or something to verify
> that log-writes+dax is really supported?
> I think you should.

Ah, yep, that makes sense.  I'll update for v3.
