From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v4 00/12] re-enable DAX PMD support
Date: Fri, 30 Sep 2016 09:43:45 +1000
Message-ID: <20160929234345.GG27872@dastard>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475189370-31634-1-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Thu, Sep 29, 2016 at 04:49:18PM -0600, Ross Zwisler wrote:
> DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> locking.  This series allows DAX PMDs to participate in the DAX radix tree
> based locking scheme so that they can be re-enabled.
> 
> Ted, can you please take the ext2 + ext4 patches through your tree?  Dave,
> can you please take the rest through the XFS tree?

That will make merging this difficult, because later patches in the
series are dependent on the ext2/ext4 patches early in the series.
I'd much prefer they all go through the one tree to avoid issues
like this.

> 
> Changes since v3:
>  - Corrected dax iomap code namespace for functions defined in fs/dax.c.
>    (Dave Chinner)
>  - Added leading "dax" namespace to new static functions in fs/dax.c.
>    (Dave Chinner)
>  - Made all DAX PMD code in fs/dax.c conditionally compiled based on
>    CONFIG_FS_DAX_PMD.  Otherwise a stub in include/linux/dax.h that just
>    returns VM_FAULT_FALLBACK will be used.  (Dave Chinner)
>  - Removed dynamic debugging messages from DAX PMD fault path.  Debugging
>    tracepoints will be added later to both the PTE and PMD paths via a
>    later patch set. (Dave Chinner)
>  - Added a comment to ext2_dax_vm_ops explaining why we don't support DAX
>    PMD faults in ext2. (Dave Chinner)
> 
> This was built upon xfs/for-next with PMD performance fixes from Toshi Kani
> and Dan Williams.  Dan's patch has already been merged for v4.8, and
> Toshi's patches are currently queued in Andrew Morton's mm tree for v4.9
> inclusion.

the xfs/for-next branch is not a stable branch - it can rebase at
any time just like linux-next can. The topic branches that I merge
into the for-next branch, OTOH, are usually stable. i.e. The topic
branch you should be basing this on is "iomap-4.9-dax".

And then you'll also see that there are already ext2 patches in this
topic branch to convert it to iomap for DAX. So I'm quite happy to
take the ext2/4 patches in this series in the same way.

The patches from Dan and Toshi: is you patch series dependent on
them? Do I need to take them as well?

Finally: none of the patches in your tree have reviewed-by tags.
That says to me that none of this code has been reviewed yet.
Reviewed-by tags are non-negotiable requirement for anything going
through my trees. I don't have time right now to review this code,
so you're going to need to chase up other reviewers before merging.

And, really, this is getting very late in the cycle to be merging
new code - we're less than one working day away from the merge
window opening and we've missed the last linux-next build. I'd
suggest that we'd might be best served by slipping this to the PMD
support code to the next cycle when there's no time pressure for
review and we can get a decent linux-next soak on the code.

> This tree has passed xfstests for ext2, ext4 and XFS both with and without DAX,
> and has passed targeted testing where I inserted, removed and flushed DAX PTEs
> and PMDs in every combination I could think of.
> 
> Previously reported performance numbers:
> 
>   [global]
>   bs=4k
>   size=2G
>   directory=/mnt/pmem0
>   ioengine=mmap
>   [randrw]
>   rw=randrw
> 
> Here are the performance results with XFS using only pte faults:
>    READ: io=1022.7MB, aggrb=557610KB/s, minb=557610KB/s, maxb=557610KB/s, mint=1878msec, maxt=1878msec
>   WRITE: io=1025.4MB, aggrb=559084KB/s, minb=559084KB/s, maxb=559084KB/s, mint=1878msec, maxt=1878msec
> 
> Here are performance numbers for that same test using PMD faults:
>    READ: io=1022.7MB, aggrb=1406.7MB/s, minb=1406.7MB/s, maxb=1406.7MB/s, mint=727msec, maxt=727msec
>   WRITE: io=1025.4MB, aggrb=1410.4MB/s, minb=1410.4MB/s, maxb=1410.4MB/s, mint=727msec, maxt=727msec

The numbers look good - how much of that is from lower filesystem
allocation overhead and how much of it is from fewer page faults?
You can probably determine this by creating the test file with
write() to ensure it is fully allocated and so all the filesystem
is doing on both the read and write paths is mapping allocated
regions....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
