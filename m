From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 10/12] dax: add struct iomap based DAX PMD support
Date: Fri, 7 Oct 2016 09:24:02 +0200
Message-ID: <20161007072402.GB16260@quack2.suse.cz>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-11-git-send-email-ross.zwisler@linux.intel.com>
 <20161003105949.GP6457@quack2.suse.cz>
 <20161003210557.GA28177@linux.intel.com>
 <20161006213424.GA4569@linux.intel.com>
 <20161007025833.GA2934@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161007025833.GA2934-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

On Thu 06-10-16 20:58:33, Ross Zwisler wrote:
> On Thu, Oct 06, 2016 at 03:34:24PM -0600, Ross Zwisler wrote:
> > Interesting - adding iomap_end() calls to the DAX PTE fault handler causes an
> > AA deadlock because we try and retake ei->dax_sem.  We take dax_sem in
> > ext2_dax_fault() before calling into the DAX code, then if we end up going
> > through the error path in ext2_iomap_end(), we call 
> >   ext2_write_failed()
> >     ext2_truncate_blocks()
> >       dax_sem_down_write()
> > 
> > Where we try and take dax_sem again.  This error path is really only valid for
> > I/O operations, but we happen to call it for page faults because 'written' in
> > ext2_iomap_end() is just 0.
> > 
> > So...how should we handle this?  A few ideas:
> > 
> > 1) Just continue to omit the calls to iomap_end() in the DAX page fault
> > handlers for now, and add them when there is useful work to be done in one of
> > the filesystems.
> > 
> > 2) Add an IOMAP_FAULT flag to the flags passed into iomap_begin() and
> > iomap_end() so make it explicit that we are calling as part of a fault handler
> > and not an I/O operation, and use this to adjust the error handling in
> > ext2_iomap_end().
> > 
> > 3) Just work around the existing error handling in ext2_iomap_end() by either
> > unsetting IOMAP_WRITE or by setting 'written' to the size of the fault.
> > 
> > For #2 or #3, probably add a comment explaining the deadlock and why we need
> > to never call ext2_write_failed() while handling a page fault.
> > 
> > Thoughts?
> 
> Never mind, #3 it is, I think it was just a plain bug to call iomap_end() with
> 'length' != 'written'.

Yup, that's what I'd think as well.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
