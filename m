From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 5/7] dax, iomap: Add support for synchronous faults
Date: Tue, 1 Aug 2017 03:56:08 -0700
Message-ID: <20170801105608.GD6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-6-jack@suse.cz>
 <20170727224245.GF22000@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170727224245.GF22000-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Thu, Jul 27, 2017 at 04:42:45PM -0600, Ross Zwisler wrote:
> I wonder if we should name this flag something a little stronger and more
> specific to its usage with respect to DAX and sync faults?  Maybe
> "VM_FAULT_NEEDDSYNC" for consistency with the iomap flag?

Agreed.
