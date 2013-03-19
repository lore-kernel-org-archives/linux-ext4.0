From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_block_to_path block > max warning.
Date: Tue, 19 Mar 2013 08:22:44 -0400
Message-ID: <20130319122244.GA32310@thunk.org>
References: <20130319033555.GA1582@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130319033555.GA1582@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 18, 2013 at 11:35:55PM -0400, Dave Jones wrote:
> Not sure what I did to trigger this, but it's happened a few times while fuzzing syscalls.
> Rebooted and fscked, didn't find anything wrong.
> 
> 	Dave
> 
> [ 5084.436288] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 1874853625 > max in inode 34
> [ 5167.723925] EXT4-fs warning (device sda1): ext4_block_to_path:105: block 2507988634 > max in inode 34

Yes, this wouldn't be a problem that would be be reflected in an fsck
problem.  What warning indicates is that there was an attempt to write
to file offset which is larger than what is supported by using
indirect blocks.  (Presumably this was probably a ext3 file system
mounted using ext4?)

This should have been caught by checks earlier, but because we didn't,
instead of returning EFBIG to userspace, the userspace application
received an EIO instead, and it triggered the above warning
message.

.... and I think I see the problem.  We do have checks ext4_llseek()
and ext4_file_write(), but we use iov_length to do the checks.  And
documentation for iov_length states:

/*
 * Total number of bytes covered by an iovec.
 *
 * NOTE that it is not safe to use this function until all the iovec's
 * segment lengths have been validated.  Because the individual lengths can
 * overflow a size_t when added together.
 */

Basically, iov_length() doesn't check for overflow, and the individual
lengths of the iovec don't get verified until later in the call stack,
by generic_file_aio_write().

So we either need to create a version of iov_length() which does check
for overflow, or we need to add an extra call to
generic_segment_checks() in ext4_file_write().  It will be more
slightly more CPU-efficient to have an overflow-cognizant
iov_length(), though.

The alternative would be to simply remove the ext4_warning() and
change the error return in the case where ext4_block_to_path() returns
0, but I think it's good add the extra upfront checks, and reserve the
ext4_block_to_path() check as a last-ditch sanity check.  I'm a big
believer in having belt-and-suspender safety checks.

							- Ted
