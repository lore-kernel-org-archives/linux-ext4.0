From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v4 21/22] Add support for pmd_faults
Date: Mon, 23 Dec 2013 07:50:31 -0700
Message-ID: <20131223145031.GB11091@parisc-linux.org>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com> <e944917f571781b46ca4dbb789ae8a86c5166059.1387748521.git.matthew.r.wilcox@intel.com> <20131223134113.GA14806@node.dhcp.inet.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58787 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab3LWOud (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Dec 2013 09:50:33 -0500
Content-Disposition: inline
In-Reply-To: <20131223134113.GA14806@node.dhcp.inet.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 03:41:13PM +0200, Kirill A. Shutemov wrote:
> > +	/* Fall back to PTEs if we're going to COW */
> > +	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
> > +		return VM_FAULT_FALLBACK;
> 
> Why?

If somebody mmaps a file with MAP_PRIVATE and changes a single byte, I
think we should allocate a single page to hold that change, not a PMD's
worth of pages.

> > +	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> > +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	if (pgoff >= size)
> > +		return VM_FAULT_SIGBUS;
> > +	if ((pgoff | PG_PMD_COLOUR) >= size)
> > +		return VM_FAULT_FALLBACK;
> 
> I don't think it's necessary to fallback in this case.
> Do you care about SIGBUS behaviour or what?

I'm looking to preserve the same behaviour we see with PTE mappings.  I mean,
it's supposed to be _transparent_ huge pages, right?

> > + insert:
> > +	length = xip_get_pfn(inode, &bh, &pfn);
> > +	if (length < 0)
> > +		return VM_FAULT_SIGBUS;
> > +	if (length < PMD_SIZE)
> > +		return VM_FAULT_FALLBACK;
> > +	if (pfn & PG_PMD_COLOUR)
> > +		return VM_FAULT_FALLBACK;	/* not aligned */
> 
> Without assistance from get_unmapped_area() you will hit this all the time
> (511 of 512 on x86_64).

Yes ... I thought you were working on that part for your transparent huge
page cache patchset?

> And the check should be moved before get_block(), I think.

Can't.  The PFN we're checking is the PFN of the storage.  We have to
call get_block() to find out where it's going to be.

> > +static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
> > +			pmd_t *pmd, unsigned long pfn, pgprot_t prot)
> > +{
> > +	struct mm_struct *mm = vma->vm_mm;
> > +	int retval;
> > +	pmd_t entry;
> > +	spinlock_t *ptl;
> > +
> > +	ptl = pmd_lock(mm, pmd);
> > +	retval = -EBUSY;
> > +	if (!pmd_none(*pmd))
> > +		goto out_unlock;
> > +
> > +	/* Ok, finally just insert the thing.. */
> > +	entry = pfn_pmd(pfn, prot); /* XXX: pmd_mkspecial? */
> > +	set_pmd_at(mm, addr, pmd, entry);
> > +	update_mmu_cache_pmd(vma, addr, pmd);
> 
> Here you need to allocate pgtable and deposit it to be able to split the page.

You've mentioned that in the past, and looking at it further is on my
todo list.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
