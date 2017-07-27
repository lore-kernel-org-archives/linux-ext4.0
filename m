From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/7] dax: Add sync argument to dax_iomap_fault()
Date: Thu, 27 Jul 2017 16:06:37 -0600
Message-ID: <20170727220637.GC22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-3-jack@suse.cz>
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
In-Reply-To: <20170727131245.28279-3-jack-AlSwsSmVLrQ@public.gmane.org>
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

On Thu, Jul 27, 2017 at 03:12:40PM +0200, Jan Kara wrote:
> Add 'sync' argument to dax_iomap_fault(). It will be used to communicate
> the fact that synchronous fault is requested.

I don't actually think you need to pass this 'sync' parameter around.  I think
you can completely rely on IOMAP_F_NEEDSYNC being set in iomap.flags.  The DAX
fault handlers can call ops->iomap_begin() and use that flag for all the
tests and make it our once source of truth.

That flag also tells us that we are doing a write fault (from
ext4_iomap_begin()):

	if ((flags & IOMAP_FAULT) && (flags & IOMAP_WRITE) && IS_SYNC(inode) &&
	    !jbd2_transaction_committed(EXT4_SB(inode->i_sb)->s_journal,
					EXT4_I(inode)->i_datasync_tid))
		iomap->flags |= IOMAP_F_NEEDDSYNC;

So conditionals like this from dax_iomap_pte_fault():

	force_ro = (vmf->flags & FAULT_FLAG_WRITE) && sync &&
			(iomap.flags & IOMAP_F_NEEDDSYNC);

can be simplified to:

	force_ro = (iomap.flags & IOMAP_F_NEEDDSYNC);
