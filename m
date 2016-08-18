From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 5/7] dax: lock based on slot instead of [mapping, index]
Date: Thu, 18 Aug 2016 16:15:50 +0200
Message-ID: <20160818141550.GA2382@quack2.suse.cz>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
 <20160815190918.20672-6-ross.zwisler@linux.intel.com>
 <20160816092816.GE27284@quack2.suse.cz>
 <20160817202556.GA13009@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817202556.GA13009-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Wed 17-08-16 14:25:56, Ross Zwisler wrote:
> On Tue, Aug 16, 2016 at 11:28:16AM +0200, Jan Kara wrote:
> > On Mon 15-08-16 13:09:16, Ross Zwisler wrote:
> > > DAX radix tree locking currently locks entries based on the unique
> > > combination of the 'mapping' pointer and the pgoff_t 'index' for the entry.
> > > This works for PTEs, but as we move to PMDs we will need to have all the
> > > offsets within the range covered by the PMD to map to the same bit lock.
> > > To accomplish this, lock based on the 'slot' pointer in the radix tree
> > > instead of [mapping, index].
> > 
> > I'm not convinced this is safe. What makes the slot pointer still valid
> > after you drop tree_lock? At least radix_tree_shrink() or
> > radix_tree_expand() could move your slot without letting the waiter know
> > and he would be never woken.
> > 
> > 								Honza
> 
> Yep, you're right, thanks for catching that.
> 
> Given that we can't rely on 'slot' being stable, my next idea is to use a
> combination of [mapping, index], but tweak 'index' so that it's always the
> beginning of the entry.  So for 4k entries we'd leave it alone, but for 2MiB
> entries we'd mask it down to the appropriate 2MiB barrier.
> 
> Let me hack on that for a bit, unless you've a better idea.

No, that's what I'd do as well.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
