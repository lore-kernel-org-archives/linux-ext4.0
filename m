From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Date: Mon, 28 Nov 2016 15:46:51 -0700
Message-ID: <20161128224651.GA1243@linux.intel.com>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161125030059.GY31101@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161125030059.GY31101@dastard>
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

On Fri, Nov 25, 2016 at 02:00:59PM +1100, Dave Chinner wrote:
> On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> > Tracepoints are the standard way to capture debugging and tracing
> > information in many parts of the kernel, including the XFS and ext4
> > filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> > tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> > be done in the same way as the filesystem tracing so that developers can
> > look at them together and get a coherent idea of what the system is doing.
> > 
> > I added both an entry and exit tracepoint because future patches will add
> > tracepoints to child functions of dax_iomap_pmd_fault() like
> > dax_pmd_load_hole() and dax_pmd_insert_mapping(). We want those messages to
> > be wrapped by the parent function tracepoints so the code flow is more
> > easily understood.  Having entry and exit tracepoints for faults also
> > allows us to easily see what filesystems functions were called during the
> > fault.  These filesystem functions get executed via iomap_begin() and
> > iomap_end() calls, for example, and will have their own tracepoints.
> > 
> > For PMD faults we primarily want to understand the faulting address and
> > whether it fell back to 4k faults.  If it fell back to 4k faults the
> > tracepoints should let us understand why.
> > 
> > I named the new tracepoint header file "fs_dax.h" to allow for device DAX
> > to have its own separate tracing header in the same directory at some
> > point.
> > 
> > Here is an example output for these events from a successful PMD fault:
> > 
> > big-2057  [000] ....   136.396855: dax_pmd_fault: shared mapping write
> > address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> > max_pgoff 0x1400
> > 
> > big-2057  [000] ....   136.397943: dax_pmd_fault_done: shared mapping write
> > address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff 0x200
> > max_pgoff 0x1400 NOPAGE
> 
> Can we make the output use the same format as most of the filesystem
> code? i.e. the output starts with backing device + inode number like
> so:
> 
> 	xfs_ilock:            dev 8:96 ino 0x493 flags ILOCK_EXCL....
> 
> This way we can filter the output easily across both dax and
> filesystem tracepoints with 'grep "ino 0x493"'...

I think I can include the inode number, which I have via mapping->host.  Am I
correct in assuming "struct inode.i_ino" will always be the same as
"struct xfs_inode.i_ino"?

Unfortunately I don't have access to the major/minor (the dev_t) until I call
iomap_begin().  Currently we call iomap_begin() only after we've done most of
our sanity checking that would cause us to fall back to PTEs.

I don't think we want to reorder things so that we start with an iomap_begin()
- that would mean that we would begin by asking the filesystem for a block
allocation, when in many cases we would then do an alignment check or
something similar and then fall back to PTEs.

I'll add "ino" to the output so it looks something like this:

big-2057  [000] ....   136.397943: dax_pmd_fault_done: ino 0x493 shared
mapping write address 0x10505000 vm_start 0x10200000 vm_end 0x10700000 pgoff
0x200 max_pgoff 0x1400 NOPAGE
