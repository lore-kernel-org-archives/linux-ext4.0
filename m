From: Dave Chinner <david@fromorbit.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Thu, 15 Aug 2013 14:29:30 +1000
Message-ID: <20130815042930.GO6023@dastard>
References: <520BB9EF.5020308@linux.intel.com> <20130815002436.GI6023@dastard>
	<20130815022401.GQ23412@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Andi Kleen <ak@linux.intel.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130815022401.GQ23412@tassilo.jf.intel.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 14, 2013 at 07:24:01PM -0700, Andi Kleen wrote:
> > And FWIW, it's no secret that XFS has more per-operation overhead
> > than ext4 through the write path when it comes to allocation, so
> > it's no surprise that on a workload that is highly dependent on
> > allocation overhead that ext4 is a bit faster....
> 
> This cannot explain a worse scaling curve though?

The scaling curve is pretty much identical. The difference in
performance will be the overhead of timestamp updates through
the transaction subsystems of the filesystems.

> w-i-s is all about scaling.

Sure, but scaling *what*? It's spending all it's time in the
filesystem through the .page_mkwrite path. It's not a page fault
scaling test - it's a filesystem overwrite test that uses mmap.
Indeed, I bet if you replace the mmap() with a write(fd, buf, 4096)
loop, you'd get almost identical behaviour from the filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
