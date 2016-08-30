From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/9] re-enable DAX PMD support
Date: Tue, 30 Aug 2016 17:01:50 -0600
Message-ID: <20160830230150.GA12173@linux.intel.com>
References: <20160823220419.11717-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823220419.11717-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Tue, Aug 23, 2016 at 04:04:10PM -0600, Ross Zwisler wrote:
> DAX PMDs have been disabled since Jan Kara introduced DAX radix tree based
> locking.  This series allows DAX PMDs to participate in the DAX radix tree
> based locking scheme so that they can be re-enabled.
> 
> Changes since v1:
>  - PMD entry locking is now done based on the starting offset of the PMD
>    entry, rather than on the radix tree slot which was unreliable. (Jan)
>  - Fixed the one issue I could find with hole punch.  As far as I can tell
>    hole punch now works correctly for both PMD and PTE DAX entries, 4k zero
>    pages and huge zero pages.
>  - Fixed the way that ext2 returns the size of holes in ext2_get_block().
>    (Jan)
>  - Made the 'wait_table' global variable static in respnse to a sparse
>    warning.
>  - Fixed some more inconsitent usage between the names 'ret' and 'entry'
>    for radix tree entry variables.
> 
> Ross Zwisler (9):
>   ext4: allow DAX writeback for hole punch
>   ext2: tell DAX the size of allocation holes
>   ext4: tell DAX the size of allocation holes
>   dax: remove buffer_size_valid()
>   dax: make 'wait_table' global variable static
>   dax: consistent variable naming for DAX entries
>   dax: coordinate locking for offsets in PMD range
>   dax: re-enable DAX PMD support
>   dax: remove "depends on BROKEN" from FS_DAX_PMD
> 
>  fs/Kconfig          |   1 -
>  fs/dax.c            | 297 +++++++++++++++++++++++++++++-----------------------
>  fs/ext2/inode.c     |   3 +
>  fs/ext4/inode.c     |   7 +-
>  include/linux/dax.h |  29 ++++-
>  mm/filemap.c        |   6 +-
>  6 files changed, 201 insertions(+), 142 deletions(-)
> 
> -- 
> 2.9.0

Ping on this series?  Any objections or comments?
