From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 1/5] mm: add mkwrite param to vm_insert_mixed()
Date: Mon, 24 Jul 2017 09:13:03 -0600
Message-ID: <20170724151303.GA1639@linux.intel.com>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
 <20170721223956.29485-2-ross.zwisler@linux.intel.com>
 <CAA9_cmdoEVx88FCuCSOB1Qmom_X8uJPB4-uUx7MA3X5H4fZ=GQ@mail.gmail.com>
 <20170724111531.GG652@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org,
 linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
 linux-samsung-soc <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Joonyoung Shim <jy0922.shim-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Patrik Jakobsson <patrik.r.jakobsson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>,
 ext4 hackers <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
 "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWNGWvitb5QawA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170724111531.GG652-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Mon, Jul 24, 2017 at 01:15:31PM +0200, Jan Kara wrote:
> On Sat 22-07-17 09:21:31, Dan Williams wrote:
> > On Fri, Jul 21, 2017 at 3:39 PM, Ross Zwisler
> > <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > > To be able to use the common 4k zero page in DAX we need to have our PTE
> > > fault path look more like our PMD fault path where a PTE entry can be
> > > marked as dirty and writeable as it is first inserted, rather than waiting
> > > for a follow-up dax_pfn_mkwrite() => finish_mkwrite_fault() call.
> > >
> > > Right now we can rely on having a dax_pfn_mkwrite() call because we can
> > > distinguish between these two cases in do_wp_page():
> > >
> > >         case 1: 4k zero page => writable DAX storage
> > >         case 2: read-only DAX storage => writeable DAX storage
> > >
> > > This distinction is made by via vm_normal_page().  vm_normal_page() returns
> > > false for the common 4k zero page, though, just as it does for DAX ptes.
> > > Instead of special casing the DAX + 4k zero page case, we will simplify our
> > > DAX PTE page fault sequence so that it matches our DAX PMD sequence, and
> > > get rid of the dax_pfn_mkwrite() helper.  We will instead use
> > > dax_iomap_fault() to handle write-protection faults.
> > >
> > > This means that insert_pfn() needs to follow the lead of insert_pfn_pmd()
> > > and allow us to pass in a 'mkwrite' flag.  If 'mkwrite' is set insert_pfn()
> > > will do the work that was previously done by wp_page_reuse() as part of the
> > > dax_pfn_mkwrite() call path.
> > >
> > > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > > ---
> > >  drivers/dax/device.c                    |  2 +-
> > >  drivers/gpu/drm/exynos/exynos_drm_gem.c |  3 ++-
> > >  drivers/gpu/drm/gma500/framebuffer.c    |  2 +-
> > >  drivers/gpu/drm/msm/msm_gem.c           |  3 ++-
> > >  drivers/gpu/drm/omapdrm/omap_gem.c      |  6 ++++--
> > >  drivers/gpu/drm/ttm/ttm_bo_vm.c         |  2 +-
> > >  fs/dax.c                                |  2 +-
> > >  include/linux/mm.h                      |  2 +-
> > >  mm/memory.c                             | 27 +++++++++++++++++++++------
> > >  9 files changed, 34 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/drivers/dax/device.c b/drivers/dax/device.c
> > > index e9f3b3e..3973521 100644
> > > --- a/drivers/dax/device.c
> > > +++ b/drivers/dax/device.c
> > > @@ -273,7 +273,7 @@ static int __dev_dax_pte_fault(struct dev_dax *dev_dax, struct vm_fault *vmf)
> > >
> > >         pfn = phys_to_pfn_t(phys, dax_region->pfn_flags);
> > >
> > > -       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
> > > +       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn, false);
> > 
> > Ugh, I generally find bool flags unreadable. They place a tax on
> > jumping to function definition to recall what true and false mean. If
> > we want to go this 'add an argument' route can we at least add an enum
> > like:
> > 
> > enum {
> >     PTE_MKDIRTY,
> >     PTE_MKCLEAN,
> > };
> > 
> > ...to differentiate the two cases?
> 
> So how I usually deal with this is that I create e.g.:
> 
> __vm_insert_mixed() that takes the bool argument, make vm_insert_mixed()
> pass false, and vm_insert_mixed_mkwrite() pass true. That way there's no
> code duplication, old call sites can stay unchanged, the naming clearly
> says what's going on...

Ah, that does seem cleaner.  I'll try that for v5.
