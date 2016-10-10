From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 13/17] dax: dax_iomap_fault() needs to call iomap_end()
Date: Mon, 10 Oct 2016 16:05:50 -0600
Message-ID: <20161010220550.GA22793@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-14-git-send-email-ross.zwisler@linux.intel.com>
 <20161010155004.GD19343@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161010155004.GD19343-jcswGhMUV9g@public.gmane.org>
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

On Mon, Oct 10, 2016 at 05:50:04PM +0200, Christoph Hellwig wrote:
> On Fri, Oct 07, 2016 at 03:09:00PM -0600, Ross Zwisler wrote:
> > Currently iomap_end() doesn't do anything for DAX page faults for both ext2
> > and XFS.  ext2_iomap_end() just checks for a write underrun, and
> > xfs_file_iomap_end() checks to see if it needs to finish a delayed
> > allocation.  However, in the future iomap_end() calls might be needed to
> > make sure we have balanced allocations, locks, etc.  So, add calls to
> > iomap_end() with appropriate error handling to dax_iomap_fault().
> 
> Is there a way to just have a single call to iomap_end at the end of
> the function, after which we just return a previosuly setup return
> value?
> 
> e.g.
> 
> out:
> 	if (ops->iomap_end) {
> 		error = ops->iomap_end(inode, pos, PAGE_SIZE,
> 				PAGE_SIZE, flags, &iomap);
> 	}
> 
> 	if (error == -ENOMEM)
> 		return VM_FAULT_OOM | major;
> 	if (error < 0 && error != -EBUSY)
> 		return VM_FAULT_SIGBUS | major;
> 	return ret;

Sure, will do.
