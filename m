From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 21/22] Add support for pmd_faults
Date: Mon, 23 Dec 2013 17:11:45 +0200
Message-ID: <20131223151145.GA15839@node.dhcp.inet.fi>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
 <e944917f571781b46ca4dbb789ae8a86c5166059.1387748521.git.matthew.r.wilcox@intel.com>
 <20131223134113.GA14806@node.dhcp.inet.fi>
 <20131223145031.GB11091@parisc-linux.org>
 <20131223150408.GC11091@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131223150408.GC11091@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 23, 2013 at 08:04:09AM -0700, Matthew Wilcox wrote:
> On Mon, Dec 23, 2013 at 07:50:31AM -0700, Matthew Wilcox wrote:
> > > > +	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> > > > +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > > > +	if (pgoff >= size)
> > > > +		return VM_FAULT_SIGBUS;
> > > > +	if ((pgoff | PG_PMD_COLOUR) >= size)
> > > > +		return VM_FAULT_FALLBACK;
> > > 
> > > I don't think it's necessary to fallback in this case.
> > > Do you care about SIGBUS behaviour or what?
> > 
> > I'm looking to preserve the same behaviour we see with PTE mappings.  I mean,
> > it's supposed to be _transparent_ huge pages, right?
> 
> Speaking of which ... we also need to check if the PMD is entirely within
> the VMA.  So, this is needed:
> 
> @@ -308,6 +308,11 @@ static int do_xip_pmd_fault(struct vm_area_struct *vma, uns
>         /* Fall back to PTEs if we're going to COW */
>         if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
>                 return VM_FAULT_FALLBACK;
> +       /* Fall back to PTEs if the mapping would extend outside the VMA */
> +       if ((address & ~PMD_MASK) < vma->vm_start)
> +               return VM_FAULT_FALLBACK;
> +       if (ALIGN(address, PMD_SIZE) >= vma->vm_end)
> +               return VM_FAULT_FALLBACK;
>  
>         pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
>         size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> 
> I'll fold that into the next round of patches.

Agree with this part.

-- 
 Kirill A. Shutemov
