From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 04/11] ext2: remove support for DAX PMD faults
Date: Wed, 28 Sep 2016 12:46:43 -0600
Message-ID: <20160928184643.GA16000@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475009282-9818-5-git-send-email-ross.zwisler@linux.intel.com>
 <20160927214720.GD27872@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160927214720.GD27872@dastard>
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

On Wed, Sep 28, 2016 at 07:47:20AM +1000, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 02:47:55PM -0600, Ross Zwisler wrote:
> > DAX PMD support was added via the following commit:
> > 
> > commit e7b1ea2ad658 ("ext2: huge page fault support")
> > 
> > I believe this path to be untested as ext2 doesn't reliably provide block
> > allocations that are aligned to 2MiB.  In my testing I've been unable to
> > get ext2 to actually fault in a PMD.  It always fails with a "pfn
> > unaligned" message because the sector returned by ext2_get_block() isn't
> > aligned.
> > 
> > I've tried various settings for the "stride" and "stripe_width" extended
> > options to mkfs.ext2, without any luck.
> > 
> > Since we can't reliably get PMDs, remove support so that we don't have an
> > untested code path that we may someday traverse when we happen to get an
> > aligned block allocation.  This should also make 4k DAX faults in ext2 a
> > bit faster since they will no longer have to call the PMD fault handler
> > only to get a response of VM_FAULT_FALLBACK.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ....
> > @@ -154,7 +133,6 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
> >  
> >  static const struct vm_operations_struct ext2_dax_vm_ops = {
> >  	.fault		= ext2_dax_fault,
> > -	.pmd_fault	= ext2_dax_pmd_fault,
> >  	.page_mkwrite	= ext2_dax_fault,
> >  	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
> >  };
> 
> Would it be better to put a comment mentioning this here? So as the
> years go by, this reminds people not to bother trying to implement
> it?
> 
> /*
>  * .pmd_fault is not supported for DAX because allocation in ext2
>  * cannot be reliably aligned to huge page sizes and so pmd faults
>  * will always fail and fail back to regular faults.
>  */

Sure, this seems like a good idea.  I'll add it, thanks.
