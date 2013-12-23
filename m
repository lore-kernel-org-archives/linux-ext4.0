From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Mon, 23 Dec 2013 15:14:47 +1100
Message-ID: <20131223041447.GG3220@dastard>
References: <20131217223050.GB20579@dastard>
 <20131218023143.GA24491@parisc-linux.org>
 <20131218123319.GH31386@dastard>
 <20131218152234.GB9207@parisc-linux.org>
 <20131219004831.GU31386@dastard>
 <20131219010530.GA17545@parisc-linux.org>
 <20131219015843.GE20579@dastard>
 <20131219153213.GC19166@parisc-linux.org>
 <20131219234653.GD31386@dastard>
 <20131220164529.GE19166@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131220164529.GE19166@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 20, 2013 at 09:45:30AM -0700, Matthew Wilcox wrote:
> On Fri, Dec 20, 2013 at 10:46:54AM +1100, Dave Chinner wrote:
> > Then perhaps we need to get rid of the xip_sparse_mutex first? :/
> 
> Yeah, already done in my tree.  Just finishing up a few other pieces.
> 
> > > > And that solves the unwritten extent problem for the IO path. Now we
> > > > just need to solve it for the mmap path. That, I suspect will
> > > > require a custom .page_mkwrite handler....
> > > 
> > > No, page_mkwrite() never gets called.  At this point, I'm thinking a
> > > custom ->fault handler that looks something like this:
> > 
> > And that's another difference to the normal filesystem mmap paths.
> > .fault is a read-only operation for filesystems and
> > .page-mkwrite is the write-fault modification path. i.e.
> > .fault is only supposed to populate the page into the page
> > cache by reading it from disk via ->readpage(s). It does not do
> > block allocation - if the fault is over a hole then a new, zeroed
> > page is placed in the page cache regardless of whether it is a read
> > or write page fault.
> > 
> > ->page_mkwrite is then used by page fault infrstructure to inform
> > filesystem that a write fault has occurred and they may need to
> > allocate backing store for the page, or convert unwritten extents to
> > written.
> > 
> > What xip_file_fault() does is ask the fielsystem to allocate blocks
> > for writeable mappings, rather than just inserting a sparse page
> > over holes and unwritten extents. That fails to handle unwritten
> > extents correctly - they remain unwritten despite the fact that
> > userspace can now write to the page.
> 
> I agree with you up to this point.  But xip_file_fault() uses the same
> get_block_t callback to allocate blocks that block_page_mkwrite() does.
> So there's no real difference from the fs' point of view.

I beg to differ. You're adding a new allocation path from page
faults into the filesystem code. We already have one - it's called
page_mkwrite.


> > IOWs, xip_file_fault() needs to drop the allocation of blocks and
> > only ever insert mappings for pages that have data in them or sprase
> > pages for holes and unwritten extents. Then the filesystem needs to
> > provide it's own ->page_mkwrite callout to do block allocation and
> > unwritten extent conversion on write page faults, and the XIP code
> > needs to provide a helper function to replace the sparse page in the
> > mappings with the correct page mapped from the backing device after
> > allocation or unwritten extent conversion.
> > 
> > That will make XIP behave almost identically to the normal page
> > cache based page fault path, requiring only a small addition to the
> > filesystem page_mkwrite handler to support XIP...
> 
> I decided to see if there was anything particularly hard about the XFS
> code in this area.  I really think it's just this for you:
> 
> +++ b/fs/xfs/xfs_file.c
> @@ -957,12 +957,27 @@ xfs_file_readdir(
>         return 0;
>  }
>  
> +static int xfs_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> +       return xip_fault(vma, vmf, xfs_get_blocks);
> +}
> +
> +static const struct vm_operations_struct xfs_xip_vm_ops = {
> +       .fault          = xfs_xip_fault,
> +       .remap_pages    = generic_file_remap_pages,
> +};

No, it doesn't. ->page_mkwrite re-enters the filesystem back in
->write_begin and ->write_end to do zeroing and allocation and to
set up tracking to trigger unwritten extent conversion, etc.

So, off the top of my head, how does xip_fault():

	- avoid triggering delayed allocation?
	- trigger unwritten extent conversion to occur?
	- ensure that partial blocks at EOF are zeroed correctly?
	- deal with partial write failure? (e.g. unwritten extent
	  conversion fails)

AFAICT, it can't. This is all stuff that is specific to the
filesystem imlpementation, and stuff that is already handled by the
page_mkwrite paths....

> > > static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > {
> > > 	return xip_fault(vma, vmf, ext4_get_block_write, ext4_end_io_dio);
> > > }
> > 
> > I think the xip fault handler should be generic as there's no reason
> > for it to do anything other that read-only operations. It's the
> > page_mkwrite callout that needs custom code for each filesystem.
> 
> With no struct page for the XIP memory, it's just not feasible to do it
> that way.

Yet we are making the major assumption that XIP memory is made up of
pages that can be mapped directly into page tables. So, it's pages
and we optimise filesystems to deal with native page sizes, but XIP
says it's not pages and so we have to deal with it completely
differently?

Perhaps XIP pages need to have struct pages allocated for them at
device initialisation time, such that all xip_get_mem turns into
xip_find_get_page() and the page gets inserted directly into the
mapping tree on the inode? All of a sudden, XIP looks almost the
same as the normal mmap path, and filesystems only need to ensure
that they zero the page and/or convert it if necessary before the
page fault returns...

Seriously, just because the current XIP code uses some hack to work
with *one device*, it doesn't mean that's the best way to approach
the problem. XIP is not something magic and different - it's just a
different way of inserting a page into the page cache....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
