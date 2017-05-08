From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 4/4] dax: Fix data corruption when fault races with write
Date: Mon, 8 May 2017 11:25:27 -0600
Message-ID: <20170508172527.GA18408@linux.intel.com>
References: <20170505072500.25692-1-jack@suse.cz>
 <20170505072500.25692-5-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170505072500.25692-5-jack-AlSwsSmVLrQ@public.gmane.org>
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

On Fri, May 05, 2017 at 09:25:00AM +0200, Jan Kara wrote:
> Currently DAX read fault can race with write(2) in the following way:
> 
> CPU1 - write(2)			CPU2 - read fault
> 				dax_iomap_pte_fault()
> 				  ->iomap_begin() - sees hole
> dax_iomap_rw()
>   iomap_apply()
>     ->iomap_begin - allocates blocks
>     dax_iomap_actor()
>       invalidate_inode_pages2_range()
>         - there's nothing to invalidate
> 				  grab_mapping_entry()
> 				  - we add zero page in the radix tree
> 				    and map it to page tables
> 
> The result is that hole page is mapped into page tables (and thus zeros
> are seen in mmap) while file has data written in that place.
> 
> Fix the problem by locking exception entry before mapping blocks for the
> fault. That way we are sure invalidate_inode_pages2_range() call for
> racing write will either block on entry lock waiting for the fault to
> finish (and unmap stale page tables after that) or read fault will see
> already allocated blocks by write(2).
> 
> Fixes: 9f141d6ef6258a3a37a045842d9ba7e68f368956
> CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Yep, this looks correct to me.  Thanks!

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
