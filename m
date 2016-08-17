From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] ext4: allow DAX writeback for hole punch
Date: Wed, 17 Aug 2016 12:07:22 -0600
Message-ID: <20160817180722.GB16779@linux.intel.com>
References: <20160817161102.2185-1-ross.zwisler@linux.intel.com>
 <20160817171955.GA30893@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160817171955.GA30893-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
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

On Wed, Aug 17, 2016 at 07:19:55PM +0200, Jan Kara wrote:
> On Wed 17-08-16 10:11:02, Ross Zwisler wrote:
> > Currently when doing a DAX hole punch with ext4 we fail to do a writeback.
> > This is because the logic around filemap_write_and_wait_range() in
> > ext4_punch_hole() only looks for dirty page cache pages in the radix tree,
> > not for dirty DAX exceptional entries.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Thanks. The patch looks correct, you can add:
> 
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> 
> Although why don't we just simplify the test below to
> mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)? After all the mapping should
> not have the dirty tag set if there are no pages / no entries?

Sure, that works.  I'll update to that in V2, and I'll add stable.  Thanks!
