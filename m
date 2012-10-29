From: Dave Chinner <david@fromorbit.com>
Subject: Re: semi-stable page writes
Date: Tue, 30 Oct 2012 09:01:22 +1100
Message-ID: <20121029220122.GT29378@dastard>
References: <20121026101909.GB19617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121026101909.GB19617@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 26, 2012 at 03:19:09AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Are people still annoyed about writes taking unexpectedly long amounts of tme
> due to the stable page write patchset?  I'm guessing yes...

I haven't heard anyone except th elunatic fringe complain
recently...

> I'm close to posting a patchset that (a) gates the wait_on_page_writeback calls
> on a flag that you can set in the bdi to indicate that you need stable writes
> (which blk_integrity_register will set);

I'd prefer stable pages by default (e.g. btrfs needs it for sane
data crc calculations), with an option to turn it off.

> (b) (ab)uses a page flag bit (PG_slab)
> to indicate that a page is actually being sent out to disk hardware; and (c)

I don't think you can do that. You can send slab allocated memory to
disk (e.g. kmalloc()d memory) and XFS definitely does that for
sub-page sized metadata. I'm pretty sure that means the PG_slab
flag is not available for (ab)use in the IO path....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
