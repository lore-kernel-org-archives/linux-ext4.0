From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Thu, 5 Dec 2013 21:07:22 -0700
Message-ID: <20131206040722.GA15325@parisc-linux.org>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com> <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com> <20131206031354.GS10988@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131206031354.GS10988@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Dec 06, 2013 at 02:13:54PM +1100, Dave Chinner wrote:
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

The two are mutually exclusive:

        if (ext4_use_xip(inode->i_sb))
                inode->i_mapping->a_ops = &ext4_xip_aops;
        else if (test_opt(inode->i_sb, DELALLOC))
                inode->i_mapping->a_ops = &ext4_da_aops;
        else
                inode->i_mapping->a_ops = &ext4_aops;

Is it worth implementing delayed allocation support on top of XIP?  Indeed,
what would that *mean*?  Assuming that the backing store is close to DRAM
speeds, we don't want to cache in DRAM first, then copy to the backing
store, we just want to write to the backing store.

> Indeed, for making filesystems like XFS be able to use XIP, we're
> going to need such facilities to be provided by the XIP
> infrastructure....

I have a patch in my development tree right now which changes the
create argument to get_xip_mem into a flags argument, with 'GXM_CREATE'
and 'GXM_HINT' as the first two flags.  Adding a GXM_ALLOC flag would
presumably be enough of a hint to the filesystem that it's time to commit
this range to disk.  Admitedly, it's pre-write and not post-write,
but does that matter when the write is a memcpy?  I must admit to not
quite understanding all 100k+ lines of XFS, so maybe you really do need
to know when the memcpy has finished.

I also don't see a problem with the filesystem either having a wrapper
around xip_file_write or providing its own entire implementation of
->write.  Equally, I'm sure we could add some other callback in, say,
address_space_operations that the XIP code could call after the memcpy
if that's what XFS needs.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
