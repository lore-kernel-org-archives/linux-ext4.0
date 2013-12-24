From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Tue, 24 Dec 2013 09:27:14 -0700
Message-ID: <20131224162713.GG11091@parisc-linux.org>
References: <20131218142749.GA9207@parisc-linux.org> <20131219020759.GA27469@thunk.org> <20131219041240.GA19166@parisc-linux.org> <20131219054303.GA4391@thunk.org> <20131219152049.GB19166@parisc-linux.org> <20131219161728.GA9130@thunk.org> <20131219171201.GD19166@parisc-linux.org> <20131219171848.GC9130@thunk.org> <20131220181731.GG19166@parisc-linux.org> <20131223031616.GE3220@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57118 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3LXQ1Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 11:27:16 -0500
Content-Disposition: inline
In-Reply-To: <20131223031616.GE3220@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 02:16:16PM +1100, Dave Chinner wrote:
> > Actually, I now see a second way to read what you wrote.  If you meant
> > "we can map in ZERO_PAGE or one of its analogs", then no.  The amount
> > of cruft that optimisation added to the filemap_xip code is horrendous.
> > I don't think it's a particularly common workload (mmap a holey file,
> > read lots of zeroes out of it without ever writing to it), so I think
> > it's far better to allocate a page of storage and zero it.
> 
> Happens far more often than you think in scientific calculations.
> Sparse matrices are extremely common, and it's a valid optimistion
> to walk then with mmap and have all the uninitialised vectors simply
> return zero without having storage space allocated. In this sort of
> situation, you really don't want to be allocating and zeroing
> persistent memory just because a terabyte sized sparse identity
> matrix was mmapped and read in it's entirity during a calculation....

It turns out not to be too bad.  I think the real problem with the old
XIP code was that they tried to microoptimise by using a single zero
page for every hole rather than doing what the generic pagecache code
does and use a page per hole.  Patch at the end of this mail.

> Persistent memory needs to handle sparse files efficiently. I'd
> suggest that we already have very well tested mechanism to do
> that: the mapping tree on each inode. use the radix tree to index
> the space, mapping either a zero page into each hole index that is
> mapped read only, and replace it with an allocated, zeroed mapping
> at page_mkwrite() time. i.e. use the mapping radix tree to point at
> all the pages we've mapped from the backing device rather than just
> mapping an anonymous memory address from the backing device
> into userspace.

We could reuse the radix tree for things that aren't pages, like
swp_to_radix_entry() does.  I don't see what that will give us over
the current system.

> That also opens the door for easily retrofitting buffered writes
> into persistent memory if we need them (e.g. mmap() of encrypted
> persistent memory).

I don't see why we'd do it that way.  If we're layering software
encryption between the app and the storage then it's no longer direct
access.  It's no longer XIP.  You'd just use the normal bio paths.

Optimisation for reading sparse pages:

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 7d6e492..b28bc6f 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -31,6 +31,11 @@ static int ext2_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return xip_fault(vma, vmf, ext2_get_block);
 }
 
+static int ext2_xip_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return xip_mkwrite(vma, vmf, ext2_get_block);
+}
+
 static int ext2_xip_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 						pmd_t *pmd, unsigned int flags)
 {
@@ -40,6 +45,7 @@ static int ext2_xip_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 static const struct vm_operations_struct ext2_xip_vm_ops = {
 	.fault		= ext2_xip_fault,
 	.pmd_fault	= ext2_xip_pmd_fault,
+	.page_mkwrite	= ext2_xip_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6211f56..4eea421 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -211,9 +211,15 @@ static int ext4_xip_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 	return xip_pmd_fault(vma, addr, pmd, flags, ext4_get_block);
 }
 
+static int ext4_xip_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return xip_mkwrite(vma, vmf, ext4_get_block);
+}
+
 static const struct vm_operations_struct ext4_xip_vm_ops = {
 	.fault		= ext4_xip_fault,
 	.pmd_fault	= ext4_xip_pmd_fault,
+	.page_mkwrite	= ext4_xip_mkwrite,
 	.remap_pages	= generic_file_remap_pages,
 };
 #else
diff --git a/fs/xip.c b/fs/xip.c
index b6a8e0c..8049703 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -187,7 +202,26 @@ ssize_t xip_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(xip_do_io);
 
+static int xip_read_hole(struct address_space *mapping, struct vm_fault *vmf)
+{
+	unsigned long size;
+	struct inode *inode = mapping->host;
+	struct page *page = find_or_create_page(mapping, vmf->pgoff,
+						GFP_KERNEL | __GFP_ZERO);
+	if (!page)
+		return VM_FAULT_OOM;
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size) {
+		unlock_page(page);
+		page_cache_release(page);
+		return VM_FAULT_SIGBUS;
+	}
+
+	vmf->page = page;
+	return VM_FAULT_LOCKED;
+}
+
 static void copy_user_bh(struct page *to, struct inode *inode,
 				struct buffer_head *bh, unsigned long vaddr)
 {
@@ -226,12 +252,14 @@ static int do_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	bh.b_size = PAGE_SIZE;
 	error = get_block(inode, block, &bh, 0);
 
-	/* Don't allocate backing store if we're going to COW a hole */
 	if (!error && !buffer_mapped(&bh) && !vmf->cow_page) {
-		error = get_block(inode, block, &bh, 1);
-		count_vm_event(PGMAJFAULT);
-		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-		major = VM_FAULT_MAJOR;
+		if (vmf->flags & FAULT_FLAG_WRITE) {
+			error = get_block(inode, block, &bh, 1);
+			count_vm_event(PGMAJFAULT);
+			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+			major = VM_FAULT_MAJOR;
+		} else
+			return xip_read_hole(mapping, vmf);
 	}
 
 	if (error)
@@ -279,19 +316,45 @@ int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 EXPORT_SYMBOL_GPL(xip_fault);
 
+/**
+ * xip_mkwrite - convert a read-only page to read-write in an XIP file
+ * @vma: The virtual memory area where the fault occurred
+ * @vmf: The description of the fault
+ * @get_block: The filesystem method used to translate file offsets to blocks
+ *
+ * XIP handles reads of holes by adding pages full of zeroes into the
+ * mapping.  If the page is subsequenty written to, we have to allocate
+ * the page on media and free the page that was in the cache.
+ */
+int xip_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+			get_block_t get_block)
+{
+	int result;
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+	result = do_xip_fault(vma, vmf, get_block);
+	sb_end_pagefault(sb);
+
+	if (!(result & VM_FAULT_ERROR)) {
+		struct page *page = vmf->page;
+		unmap_mapping_range(page->mapping,
+					(loff_t)page->index << PAGE_CACHE_SHIFT,
+					PAGE_CACHE_SIZE, 0);
+		delete_from_page_cache(page);
+	}
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(xip_mkwrite);
+
 /*
  * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
  * more often than one might expect in the below function.
diff --git a/mm/memory.c b/mm/memory.c
index 0d332cf..2a9cfb2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2708,6 +2708,7 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			vmf.pgoff = old_page->index;
 			vmf.flags = FAULT_FLAG_WRITE|FAULT_FLAG_MKWRITE;
 			vmf.page = old_page;
+			vmf.cow_page = NULL;
 
 			/*
 			 * Notify the address space that the page is about to

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
