From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 6/7] dax: Implement dax_pfn_mkwrite()
Date: Thu, 27 Jul 2017 16:53:22 -0600
Message-ID: <20170727225322.GG22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-7-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-7-jack-AlSwsSmVLrQ@public.gmane.org>
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

On Thu, Jul 27, 2017 at 03:12:44PM +0200, Jan Kara wrote:
> Implement a function that marks existing page table entry (PTE or PMD)
> as writeable and takes care of marking it dirty in the radix tree. This
> function will be used to finish synchronous page fault where the page
> table entry is first inserted as read-only and then needs to be marked
> as read-write.
> 
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> ---
>  fs/dax.c            | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dax.h |  1 +
>  2 files changed, 49 insertions(+)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 8a6cf158c691..90b763c86dc2 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1485,3 +1485,51 @@ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
>  	}
>  }
>  EXPORT_SYMBOL_GPL(dax_iomap_fault);
> +
> +/**
> + * dax_pfn_mkwrite - make page table entry writeable on a DAX file
> + * @vmf: The description of the fault
> + * @pe_size: size of entry to be marked writeable
> + *
> + * This function mark PTE or PMD entry as writeable in page tables for mmaped
> + * DAX file. It takes care of marking corresponding radix tree entry as dirty
> + * as well.
> + */
> +int dax_pfn_mkwrite(struct vm_fault *vmf, enum page_entry_size pe_size)

I wonder if this incarnation of this function should be named something other
than *_pfn_mkwrite so that it's clear that unlike in previous versions of the
codd, this version isn't supposed to be called via
vm_operations_struct->pfn_mkwrite, but is instead a helper for sync faults?
Maybe just dax_mkwrite()?

> +{
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> +	void *entry, **slot;
> +	pgoff_t index = vmf->pgoff;
> +	pfn_t pfn = pfn_to_pfn_t(pte_pfn(vmf->orig_pte));
> +	int vmf_ret, error;
> +
> +	spin_lock_irq(&mapping->tree_lock);
> +	entry = get_unlocked_mapping_entry(mapping, index, &slot);
> +	/* Did we race with someone splitting entry or so? */
> +	if (!entry || (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
> +	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
> +		put_unlocked_mapping_entry(mapping, index, entry);
> +		spin_unlock_irq(&mapping->tree_lock);

The previous version of this function had tracepoints in this failure path and
in the successful completion path.  I use this kind of tracing daily for
debugging, so lets add it back in.

> +		return VM_FAULT_NOPAGE;
> +	}
> +	radix_tree_tag_set(&mapping->page_tree, index, PAGECACHE_TAG_DIRTY);
> +	entry = lock_slot(mapping, slot);
> +	spin_unlock_irq(&mapping->tree_lock);
> +	switch (pe_size) {
> +	case PE_SIZE_PTE:
> +		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);

This path goes through the 'mkwrite' branch in insert_pfn() where we validate
that the PFN we are about to map matches the one pointed to by the existing
PTE, but I don't see any checks in this path that validate against
vmf->orig_pte?

This kind of check was done by the old
dax_pfn_mkwrite()->finish_mkwrite_fault() path via the pte_same() check in
finish_mkwrite_fault().

Do we need to add an equivalent check somewhere in this path, since we're
going through the trouble of setting vmf->orig_pte in the DAX fault handlers?
