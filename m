From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Date: Tue, 22 Aug 2017 12:08:01 +0200
Message-ID: <20170822100801.GF4909@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
 <20170821210916.GF26220@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170821210916.GF26220-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Mon 21-08-17 15:09:16, Ross Zwisler wrote:
> On Thu, Aug 17, 2017 at 06:08:13PM +0200, Jan Kara wrote:
> > Add a flag to iomap interface informing the caller that inode needs
> > fdstasync(2) for returned extent to become persistent and use it in DAX
> > fault code so that we map such extents only read only. We propagate the
> > information that the page table entry has been inserted write-protected
> > from dax_iomap_fault() with a new VM_FAULT_RO flag. Filesystem fault
> > handler is then responsible for calling fdatasync(2) and updating page
> > tables to map pfns read-write. dax_iomap_fault() also takes care of
> > updating vmf->orig_pte to match the PTE that was inserted so that we can
> > safely recheck that PTE did not change while write-enabling it.
> > 
> > Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> > ---
> >  fs/dax.c              | 31 +++++++++++++++++++++++++++++++
> >  include/linux/iomap.h |  2 ++
> >  include/linux/mm.h    |  6 +++++-
> >  3 files changed, 38 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index bc040e654cc9..ca88fc356786 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1177,6 +1177,22 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
> >  			goto error_finish_iomap;
> >  		}
> >  
> > +		/*
> > +		 * If we are doing synchronous page fault and inode needs fsync,
> > +		 * we can insert PTE into page tables only after that happens.
> > +		 * Skip insertion for now and return the pfn so that caller can
> > +		 * insert it after fsync is done.
> > +		 */
> > +		if (write && (vma->vm_flags & VM_SYNC) &&
> > +		    (iomap.flags & IOMAP_F_NEEDDSYNC)) {
> > +			if (WARN_ON_ONCE(!pfnp)) {
> > +				error = -EIO;
> > +				goto error_finish_iomap;
> > +			}
> > +			*pfnp = pfn;
> > +			vmf_ret = VM_FAULT_NEEDDSYNC | major;
> > +			goto finish_iomap;
> > +		}
> 
> Sorry for the second reply, but I spotted this during my testing.
> 
> The radix tree entry is inserted and marked as dirty by the
> dax_insert_mapping_entry() call a few lines above this newly added block.

Yes I know and this is actually deliberate. My original thinking was that
we *want* following vfs_fsync_range() to flush out any changes that are
possibly lingering in CPU caches for the block. Now thinking about this
again, changes through write(2) or pre-zeroing of block are non-temporal
anyway and changes through mmap(2) will already dirty the radix tree entry
so it seems you are right that we don't need the dirtying here. I'll change
this. Thanks for asking.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
