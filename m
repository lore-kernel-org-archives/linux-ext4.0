From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] dax: use common 4k zero page for dax mmap reads
Date: Fri, 16 Jun 2017 13:45:40 -0600
Message-ID: <20170616194540.GB20742@linux.intel.com>
References: <20170614172211.19820-1-ross.zwisler@linux.intel.com>
 <20170614172211.19820-4-ross.zwisler@linux.intel.com>
 <20170615145856.GO1764@quack2.suse.cz>
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
In-Reply-To: <20170615145856.GO1764-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Thu, Jun 15, 2017 at 04:58:56PM +0200, Jan Kara wrote:
> On Wed 14-06-17 11:22:11, Ross Zwisler wrote:
> > @@ -216,17 +217,6 @@ static void dax_unlock_mapping_entry(struct address_space *mapping,
> >  	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
> >  }
> >  
> > -static void put_locked_mapping_entry(struct address_space *mapping,
> > -				     pgoff_t index, void *entry)
> > -{
> > -	if (!radix_tree_exceptional_entry(entry)) {
> > -		unlock_page(entry);
> > -		put_page(entry);
> > -	} else {
> > -		dax_unlock_mapping_entry(mapping, index);
> > -	}
> > -}
> > -
> 
> The naming becomes asymetric with this. So I'd prefer keeping
> put_locked_mapping_entry() as a trivial wrapper around
> dax_unlock_mapping_entry() unless we can craft more sensible naming / API
> for entry grabbing (and that would be a separate patch anyway).

Sure, that works for me.  I'll fix for v3.

> > -static int dax_load_hole(struct address_space *mapping, void **entry,
> > +static int dax_load_hole(struct address_space *mapping, void *entry,
> >  			 struct vm_fault *vmf)
> >  {
> >  	struct inode *inode = mapping->host;
> > -	struct page *page;
> > -	int ret;
> > -
> > -	/* Hole page already exists? Return it...  */
> > -	if (!radix_tree_exceptional_entry(*entry)) {
> > -		page = *entry;
> > -		goto finish_fault;
> > -	}
> > +	unsigned long vaddr = vmf->address;
> > +	int ret = VM_FAULT_NOPAGE;
> > +	struct page *zero_page;
> > +	void *entry2;
> >  
> > -	/* This will replace locked radix tree entry with a hole page */
> > -	page = find_or_create_page(mapping, vmf->pgoff,
> > -				   vmf->gfp_mask | __GFP_ZERO);
> 
> With this gone, you can also remove the special DAX handling from
> mm/filemap.c: page_cache_tree_insert() and remove from dax.h
> dax_wake_mapping_entry_waiter(), dax_radix_locked_entry() and RADIX_DAX
> definitions. Yay! As a separate patch please.

Oh, yay!  :)  Sure, I'll have this patch for v3.
