From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [fstests PATCH v3] generic: add test for DAX MAP_SYNC support
Date: Thu, 26 Oct 2017 07:59:39 +0300
Message-ID: <CAOQ4uxjAnMed7-BTZWe6JUC4Fa-nApKvx9-_PzewmfcZ48cP7g@mail.gmail.com>
References: <CAOQ4uxh25JmAv3DjCp11fAfpHVP=d2sp+=Gk4SxYfBtmOgaUPw@mail.gmail.com>
 <20171025204704.3382-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20171025204704.3382-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Wed, Oct 25, 2017 at 11:47 PM, Ross Zwisler
<ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> Add a test that exercises DAX's new MAP_SYNC flag.
>
> This test creates a file and writes to it via an mmap(), but never syncs
> via fsync/msync.  This process is tracked via dm-log-writes, then replayed.
>
> If MAP_SYNC is working the dm-log-writes replay will show the test file
> with 1MiB of on-media block allocations.  This is because each allocating
> page fault included an implicit metadata sync.  If MAP_SYNC isn't working
> (which you can test by fiddling with the parameters to mmap()) the file
> will be smaller or missing entirely.
>
> Note that dm-log-writes doesn't track the data that we write via the
> mmap(), so we can't do any data integrity checking.  We can only verify
> that the metadata writes for the page faults happened.
>
> Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>
> ---
>
> Changes since v2:
>  - Fixed _require_log_writes() so that DAX will be disallowed if the
>    version of the dm-log-writes target is older than v1.1.0.  (Amir)

It seems like your kernel patch bumped the version to 1.0.1...

>
> ---
>  .gitignore            |  1 +
>  common/dmlogwrites    |  4 ++-
>  common/rc             |  6 ++--
>  src/Makefile          |  3 +-
>  src/t_map_sync.c      | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/466     | 76 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/466.out |  3 ++
>  tests/generic/group   |  1 +
>  8 files changed, 182 insertions(+), 4 deletions(-)
>  create mode 100644 src/t_map_sync.c
>  create mode 100755 tests/generic/466
>  create mode 100644 tests/generic/466.out
>
> diff --git a/.gitignore b/.gitignore
> index 2014c08..9fc0695 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -119,6 +119,7 @@
>  /src/t_getcwd
>  /src/t_holes
>  /src/t_immutable
> +/src/t_map_sync
>  /src/t_mmap_cow_race
>  /src/t_mmap_dio
>  /src/t_mmap_fallocate
> diff --git a/common/dmlogwrites b/common/dmlogwrites
> index 247c744..71d008d 100644
> --- a/common/dmlogwrites
> +++ b/common/dmlogwrites
> @@ -23,8 +23,10 @@ _require_log_writes()
>         [ -z "$LOGWRITES_DEV" -o ! -b "$LOGWRITES_DEV" ] && \
>                 _notrun "This test requires a valid \$LOGWRITES_DEV"
>
> -       _exclude_scratch_mount_option dax
>         _require_dm_target log-writes
> +       if [[ ${DMTARGET_VER[0]} == 1 && ${DMTARGET_VER[1]} < 1 ]]; then
> +               _exclude_scratch_mount_option dax
> +       fi

IMO, this would be better as:

        local z=0
        _scratch_has_mount_option dax && z=1
        _require_dm_target log-writes 1 0 $z

Or something like that
