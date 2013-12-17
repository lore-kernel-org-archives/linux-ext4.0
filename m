From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 09:30:50 +1100
Message-ID: <20131217223050.GB20579@dastard>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1387307259.git.matthew.r.wilcox@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Dec 17, 2013 at 02:18:25PM -0500, Matthew Wilcox wrote:
> For v3, we've addressed the problem with unwritten extents that Dave
> Chinner pointed out. 

No, you haven't addressed the problem. There is nothing in this
patch set that converts an unwritten extent after it is written to.
Hence on every subsequent read will return zeros because the block
is still marked as unwritten.

Further, write page faults won't do unwritten extent conversion or
block allocation, either, because:

+#ifdef CONFIG_EXT4_FS_XIP
+const struct file_operations ext4_xip_file_operations = {
+       .llseek         = ext4_llseek,
+       .read           = xip_file_read,
+       .write          = xip_file_write,
+       .unlocked_ioctl = ext4_ioctl,
+#ifdef CONFIG_COMPAT
+       .compat_ioctl   = ext4_compat_ioctl,
+#endif
+       .mmap           = xip_file_mmap,
+       .open           = ext4_file_open,
+       .release        = ext4_release_file,
+       .fsync          = ext4_sync_file,
+       .fallocate      = ext4_fallocate,
+};

You wire .mmap up to xip_file_mmap, which wires up .page_mkwrite
like this:

static const struct vm_operations_struct xip_file_vm_ops = {
        .fault  = xip_file_fault,
        .page_mkwrite   = filemap_page_mkwrite,
        .remap_pages = generic_file_remap_pages,
};

and filemap_page_mkwrite() does none of the special stuff that
ext4_page_mkwrite() does for handling unwritten extents, allocating
blocks for faults over holes in files, etc.

We actually have an xfstests test that test whether mmap and
unwritten extents work correctly - xfs/166 - but there's nothing
XFS specific about it anymore. it could easily be made generic
simply by replacing xfs_bmap with the xfs_io fiemap command....

Also, you haven't address the read vs truncate races I pointed out.
That is, buffered read currently serialises against truncate via a
combination of inode size checks and page locks. i.e. after each
page is locked, it is checked to see if it is beyond EOF before
the read proceeds into that page. the XIP path does not have any
page locks, nor read IO locks, and so is not in any way serialised
against a truncate changing the size of the inode while the read is
in progress.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
