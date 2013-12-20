From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Fri, 20 Dec 2013 09:45:30 -0700
Message-ID: <20131220164529.GE19166@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218123319.GH31386@dastard> <20131218152234.GB9207@parisc-linux.org> <20131219004831.GU31386@dastard> <20131219010530.GA17545@parisc-linux.org> <20131219015843.GE20579@dastard> <20131219153213.GC19166@parisc-linux.org> <20131219234653.GD31386@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131219234653.GD31386@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 20, 2013 at 10:46:54AM +1100, Dave Chinner wrote:
> Then perhaps we need to get rid of the xip_sparse_mutex first? :/

Yeah, already done in my tree.  Just finishing up a few other pieces.

> > > And that solves the unwritten extent problem for the IO path. Now we
> > > just need to solve it for the mmap path. That, I suspect will
> > > require a custom .page_mkwrite handler....
> > 
> > No, page_mkwrite() never gets called.  At this point, I'm thinking a
> > custom ->fault handler that looks something like this:
> 
> And that's another difference to the normal filesystem mmap paths.
> .fault is a read-only operation for filesystems and
> .page-mkwrite is the write-fault modification path. i.e.
> .fault is only supposed to populate the page into the page
> cache by reading it from disk via ->readpage(s). It does not do
> block allocation - if the fault is over a hole then a new, zeroed
> page is placed in the page cache regardless of whether it is a read
> or write page fault.
> 
> ->page_mkwrite is then used by page fault infrstructure to inform
> filesystem that a write fault has occurred and they may need to
> allocate backing store for the page, or convert unwritten extents to
> written.
> 
> What xip_file_fault() does is ask the fielsystem to allocate blocks
> for writeable mappings, rather than just inserting a sparse page
> over holes and unwritten extents. That fails to handle unwritten
> extents correctly - they remain unwritten despite the fact that
> userspace can now write to the page.

I agree with you up to this point.  But xip_file_fault() uses the same
get_block_t callback to allocate blocks that block_page_mkwrite() does.
So there's no real difference from the fs' point of view.

> IOWs, xip_file_fault() needs to drop the allocation of blocks and
> only ever insert mappings for pages that have data in them or sprase
> pages for holes and unwritten extents. Then the filesystem needs to
> provide it's own ->page_mkwrite callout to do block allocation and
> unwritten extent conversion on write page faults, and the XIP code
> needs to provide a helper function to replace the sparse page in the
> mappings with the correct page mapped from the backing device after
> allocation or unwritten extent conversion.
> 
> That will make XIP behave almost identically to the normal page
> cache based page fault path, requiring only a small addition to the
> filesystem page_mkwrite handler to support XIP...

I decided to see if there was anything particularly hard about the XFS
code in this area.  I really think it's just this for you:

+++ b/fs/xfs/xfs_file.c
@@ -957,12 +957,27 @@ xfs_file_readdir(
        return 0;
 }
 
+static int xfs_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+       return xip_fault(vma, vmf, xfs_get_blocks);
+}
+
+static const struct vm_operations_struct xfs_xip_vm_ops = {
+       .fault          = xfs_xip_fault,
+       .remap_pages    = generic_file_remap_pages,
+};
+
 STATIC int
 xfs_file_mmap(
        struct file     *filp,
        struct vm_area_struct *vma)
 {
-       vma->vm_ops = &xfs_file_vm_ops;
+       if (IS_XIP(file_inode(filp))) {
+               vma->vm_ops = &xfs_xip_vm_ops;
+               vma->vm_flags |= VM_MIXEDMAP;
+       } else {
+               vma->vm_ops = &xfs_file_vm_ops;
+       }
 
        file_accessed(filp);
        return 0;


> > static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> > {
> > 	return xip_fault(vma, vmf, ext4_get_block_write, ext4_end_io_dio);
> > }
> 
> I think the xip fault handler should be generic as there's no reason
> for it to do anything other that read-only operations. It's the
> page_mkwrite callout that needs custom code for each filesystem.

With no struct page for the XIP memory, it's just not feasible to do it
that way.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
