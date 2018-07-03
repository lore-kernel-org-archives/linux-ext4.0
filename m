From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] dax: dax_layout_busy_page() warn on !exceptional
Date: Tue, 3 Jul 2018 09:41:37 -0600
Message-ID: <20180703154137.GB13019@linux.intel.com>
References: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
 <20180627212252.31032-2-ross.zwisler@linux.intel.com>
 <20180702221503.GA12830@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180702221503.GA12830-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
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

On Mon, Jul 02, 2018 at 06:15:03PM -0400, Theodore Y. Ts'o wrote:
> On Wed, Jun 27, 2018 at 03:22:51PM -0600, Ross Zwisler wrote:
> > Inodes using DAX should only ever have exceptional entries in their page
> > caches.  Make this clear by warning if the iteration in
> > dax_layout_busy_page() ever sees a non-exceptional entry, and by adding a
> > comment for the pagevec_release() call which only deals with struct page
> > pointers.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> 
> Thanks, applied (to the ext4 tree).  If someone thinks they should go
> in via some other tree, holler.
> 
> 					- Ted

Hey Ted,

It looks like you only picked up patch 1/2?  (I'm looking at the 'dev' branch
in your repo.)  Was that intentional?

You can find the final version of the 2nd patch here:

https://lists.01.org/pipermail/linux-nvdimm/2018-July/016602.html

Thanks,
- Ross
