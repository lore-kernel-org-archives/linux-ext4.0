From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] dax: use common 4k zero page for dax mmap reads
Date: Wed, 19 Jul 2017 10:26:45 -0600
Message-ID: <20170719162645.GA26445@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
 <20170628220152.28161-4-ross.zwisler@linux.intel.com>
 <20170719153314.GC15908@quack2.suse.cz>
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
In-Reply-To: <20170719153314.GC15908-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Wed, Jul 19, 2017 at 05:33:14PM +0200, Jan Kara wrote:
> On Wed 28-06-17 16:01:50, Ross Zwisler wrote:
> > Another major change is that we remove dax_pfn_mkwrite() from our fault
> > flow, and instead rely on the page fault itself to make the PTE dirty and
> > writeable.  The following description from the patch adding the
> > vm_insert_mixed_mkwrite() call explains this a little more:
> > 
> > ***
> >   To be able to use the common 4k zero page in DAX we need to have our PTE
> >   fault path look more like our PMD fault path where a PTE entry can be
> >   marked as dirty and writeable as it is first inserted, rather than
> >   waiting for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
> > 
> >   Right now we can rely on having a dax_pfn_mkwrite() call because we can
> >   distinguish between these two cases in do_wp_page():
> > 
> >   	case 1: 4k zero page => writable DAX storage
> >   	case 2: read-only DAX storage => writeable DAX storage
> > 
> >   This distinction is made by via vm_normal_page().  vm_normal_page()
> >   returns false for the common 4k zero page, though, just as it does for
> >   DAX ptes.  Instead of special casing the DAX + 4k zero page case, we will
> >   simplify our DAX PTE page fault sequence so that it matches our DAX PMD
> >   sequence, and get rid of dax_pfn_mkwrite() completely.
> > 
> >   This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
> >   and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set
> >   insert_pfn() will do the work that was previously done by wp_page_reuse()
> >   as part of the dax_pfn_mkwrite() call path.
> > ***
> 
> Hum, thinking about this in context of this patch... So what if we have
> allocated storage, a process faults it read-only, we map it to page tables
> writeprotected. Then the process writes through mmap to the area - the code
> in handle_pte_fault() ends up in do_wp_page() if I'm reading it right.

Yep.

> Then, since we are missing ->pfn_mkwrite() handlers, the PTE will be marked
> writeable but radix tree entry stays clean - bug. Am I missing something?

I don't think we ever end up with a writeable PTE but with a clean radix tree
entry.  When we get the write fault we do a full fault through
dax_iomap_pte_fault() and dax_insert_mapping().

dax_insert_mapping() sets up the dirty radix tree entry via
dax_insert_mapping_entry() before it does anything with the page tables via
vm_insert_mixed_mkwrite().

So, this mkwrite fault path is exactly the path we would have taken if the
initial read to real storage hadn't happened, and we end up in the same end
state - with a dirty DAX radix tree entry and a writeable PTE.
