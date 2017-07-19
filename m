From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 1/5] mm: add vm_insert_mixed_mkwrite()
Date: Wed, 19 Jul 2017 11:51:12 -0600
Message-ID: <20170719175112.GA24588@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
 <20170628220152.28161-2-ross.zwisler@linux.intel.com>
 <20170719141659.GB15908@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170719141659.GB15908-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Wed, Jul 19, 2017 at 04:16:59PM +0200, Jan Kara wrote:
> On Wed 28-06-17 16:01:48, Ross Zwisler wrote:
> > To be able to use the common 4k zero page in DAX we need to have our PTE
> > fault path look more like our PMD fault path where a PTE entry can be
> > marked as dirty and writeable as it is first inserted, rather than waiting
> > for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
> > 
> > Right now we can rely on having a dax_pfn_mkwrite() call because we can
> > distinguish between these two cases in do_wp_page():
> > 
> > 	case 1: 4k zero page => writable DAX storage
> > 	case 2: read-only DAX storage => writeable DAX storage
> > 
> > This distinction is made by via vm_normal_page().  vm_normal_page() returns
> > false for the common 4k zero page, though, just as it does for DAX ptes.
> > Instead of special casing the DAX + 4k zero page case, we will simplify our
> > DAX PTE page fault sequence so that it matches our DAX PMD sequence, and
> > get rid of dax_pfn_mkwrite() completely.
> > 
> > This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
> > and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set insert_pfn()
> > will do the work that was previously done by wp_page_reuse() as part of the
> > dax_pfn_mkwrite() call path.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Just one small comment below.
> 
> > @@ -1658,14 +1658,26 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> >  	if (!pte)
> >  		goto out;
> >  	retval = -EBUSY;
> > -	if (!pte_none(*pte))
> > -		goto out_unlock;
> > +	if (!pte_none(*pte)) {
> > +		if (mkwrite) {
> > +			entry = *pte;
> > +			goto out_mkwrite;
> 
> Can we maybe check here that (pte_pfn(*pte) == pfn_t_to_pfn(pfn)) and
> return -EBUSY otherwise? That way we are sure insert_pfn() isn't doing
> anything we don't expect 

Sure, that's fine.  I'll add it as a WARN_ON_ONCE() so it's a very loud
failure.  If the pfns don't match I think we're insane (and would have been
insane prior to this patch series as well) because we are getting a page fault
and somehow have a different PFN already mapped at that location.

> and if I understand the code right, we need to
> invalidate all zero page mappings at given file offset (via
> unmap_mapping_range()) before mapping an allocated block there and thus the
> case of filling the hole won't be affected by this?

Correct.  Here's the call tree if we already have a zero page mapped and are
now faulting in an allocated block:

dax_iomap_pte_fault()
  dax_insert_mapping()
    dax_insert_mapping_entry()
      unmap_mapping_range() for our zero page
    vm_insert_mixed_mkwrite() installs the new PTE. We have pte_none(), so we
    				skip the new mkwrite goto in insert_pfn().
