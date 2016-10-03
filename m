From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 07/12] dax: coordinate locking for offsets in PMD range
Date: Mon, 3 Oct 2016 12:40:02 -0600
Message-ID: <20161003184002.GB2044@linux.intel.com>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-8-git-send-email-ross.zwisler@linux.intel.com>
 <20161003095518.GM6457@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161003095518.GM6457-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Mon, Oct 03, 2016 at 11:55:18AM +0200, Jan Kara wrote:
> On Thu 29-09-16 16:49:25, Ross Zwisler wrote:
> > DAX radix tree locking currently locks entries based on the unique
> > combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> > This works for PTEs, but as we move to PMDs we will need to have all the
> > offsets within the range covered by the PMD to map to the same bit lock.
> > To accomplish this, for ranges covered by a PMD entry we will instead lock
> > based on the page offset of the beginning of the PMD entry.  The 'mapping'
> > pointer is still used in the same way.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  fs/dax.c            | 37 ++++++++++++++++++++++++-------------
> >  include/linux/dax.h |  2 +-
> >  mm/filemap.c        |  2 +-
> >  3 files changed, 26 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/dax.c b/fs/dax.c
> > index baef586..406feea 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -64,10 +64,17 @@ static int __init init_dax_wait_table(void)
> >  }
> >  fs_initcall(init_dax_wait_table);
> >  
> > +static pgoff_t dax_entry_start(pgoff_t index, void *entry)
> > +{
> > +	if (RADIX_DAX_TYPE(entry) == RADIX_DAX_PMD)
> > +		index &= (PMD_MASK >> PAGE_SHIFT);
> 
> Hum, but if we shift right, top bits of PMD_MASK will become zero - not
> something we want I guess... You rather want to mask with something like:
> 	~((1UL << (PMD_SHIFT - PAGE_SHIFT)) - 1)

Great catch, thanks.  Fixed for v5.

> > @@ -447,10 +457,11 @@ restart:
> >  	return entry;
> >  }
> >  
> > -void dax_wake_mapping_entry_waiter(struct address_space *mapping,
> > +void dax_wake_mapping_entry_waiter(void *entry, struct address_space *mapping,
> >  				   pgoff_t index, bool wake_all)
> 
> Nitpick: Ordering of arguments would look more logical to me like:
> 
> dax_wake_mapping_entry_waiter(mapping, index, entry, wake_all)

Cool, I'll reorder them for v5.

Thanks for the review!
