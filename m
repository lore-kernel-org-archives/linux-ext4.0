From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Date: Fri, 25 Nov 2016 13:49:18 +1100
Message-ID: <20161125024918.GX31101@dastard>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161124173220.GR1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161124173220.GR1555-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
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

On Thu, Nov 24, 2016 at 05:32:20PM +0000, Al Viro wrote:
> On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> > Tracepoints are the standard way to capture debugging and tracing
> > information in many parts of the kernel, including the XFS and ext4
> > filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> > tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> > be done in the same way as the filesystem tracing so that developers can
> > look at them together and get a coherent idea of what the system is doing.
> 
> 	It also has one hell of potential for becoming a massive nuisance.
> Keep in mind that if any userland code becomes dependent on those - that's it,
> they have become parts of stable userland ABI and are to be maintained
> indefinitely.  Don't expect "tracepoints are special case" to prevent that.

I call bullshit just like I always do when someone spouts this
"tracepoints are stable ABI" garbage.

If we want to provide stable tracepoints, then we need to /create a
stable tracepoint API/ and convert all the tracepoints that /need
to be stable/ to use it. Then developers only need to be careful
about modifying code around the /explicitly stable/ tracepoints and
we avoid retrospectively locking the kernel implementation into a
KABI so tight we can't do anything anymore....

Quite frankly, anyone that wants to stop us from
adding/removing/changing tracepoints or the code that they are
reporting information about "because ABI" can go take a long walk
off a short cliff.  Diagnostic tracepoints are not part of the
stable ABI. End of story.

> 	So treat anything you add in that manner as potential stable ABI
> you might have to keep around forever.  It's *not* a glorified debugging
> printk.

trace_printk() is the glorified debugging printk for tracing, not
trace events.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
