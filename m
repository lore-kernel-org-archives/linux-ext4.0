From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Sun, 08 Dec 2013 20:16:04 -0700
Message-ID: <1386558964.6872.14.camel@gala>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
	 <20131206031354.GS10988@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131206031354.GS10988@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2013-12-06 at 14:13 +1100, Dave Chinner wrote:
> On Thu, Dec 05, 2013 at 01:02:46PM -0700, Ross Zwisler wrote:
> > This is a port of the XIP functionality found in the current version of
> > ext2.  This patch set is intended to achieve feature parity with XIP in
> > ext2 rather than non-XIP in ext4.  In particular, it lacks support for
> > splice and AIO.  We'll be submitting patches in the future to add that
> > functionality, but we think this is a good start.
> > 
> > The motivation behind this work is that we believe that the XIP feature
> > will begin to find new uses as various persistent memory devices and
> > technologies come on to the market.  Having direct, byte-addressable
> > access to persistent memory without having an additional copy in the
> > page cache can be a win in terms of I/O latency and overall memory
> > usage.
> > 
> > This patch applies cleanly to v3.13-rc2, and was tested using brd as our
> > block driver.
> 
> I think I see a significant problem here with XIP write support:
> unwritten extents.
> 
> xip_file_write() has no concept of post IO completion processing -
> it assumes that all that is necessary is to memcpy() the data into
> the backing memory obtained by ->get_xip_mem(), and that's all it
> needs to do.
> 
> For ext4 (and other filesystems that use unwritten extents) they
> need a callback - normally done from bio completion - to run
> transactions to convert extent status from unwritten to written, or
> run other post-IO completion operations.
> 
> I don't see any hooks into ext4 to turn off preallocation (e.g.
> fallocate is explicitly hooked up for XIP) when XIP is in use, so I
> can't see how XIP can work with such filesystem requirements without
> further infrastructure being added. i.e. bypassing the need for the
> page cache does not remove the need to post-IO completion
> notification to the filesystem....
> 
> Indeed, for making filesystems like XFS be able to use XIP, we're
> going to need such facilities to be provided by the XIP
> infrastructure....
> 
> Cheers,
> 
> Dave.

Hi Dave,

You're absolutely correct, unwritten extents are an issue that was
overlooked.  Thank you very much for pointing this out!

My best guess on how to fix this (as proposed by Matthew) is to wrap the
generic code in ext4 specific code that deals with unwritten extents.

For writes, I think that we need to potentially split the unwritten
extent in to up to three extents (two unwritten, one written), in the
spirit of the ext4_split_unwritten_extents().

For reads, I think we will probably have to zero the extent, mark it as
written, and then return the data normally.

For mmap, we can probably add code to the page fault handler which will
zero the unwritten extent and mark it as written, similar to what is
done for read.

My hope is that we can do this all inline in the XIP wrappers for ext4,
and avoid having to deal with callbacks.

Does this all sound generally correct?  I'll start work on an example 
implementation.

Regarding fragmentation on XIP, yep, this is also an issue, but one I
was hoping to address in a future patch set.

Thanks,
- Ross


