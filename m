From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 09:14:47 -0600
Message-ID: <20061023151447.GL3509@schatzie.adilger.int>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59068 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S964919AbWJWPOt
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 11:14:49 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20061023141641.GA29649@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 23, 2006  10:16 -0400, Theodore Tso wrote:
> As a suggestion, I would pass the inode number and inode generation
> number into the ext3_file_mode_data array:
> 
> struct ext3_file_move_data {
> 	int extents;
> 	struct ext3_reloc_extent __user *ext_array;
> };
> 
> This will be much more efficient for the userspace relocator, since it
> won't need to translate from an inode number to a pathname, and then
> try to open the file before relocating it.
> 
> I'd also use an explicit 64-bit block numbers type so that we don't
> have to worry about the ABI changing when we support 64-bit block
> numbers.

I would in fact go so far as to allow only a single extent to be specified
per call.  This is to avoid the passing of any pointers as part of the
interface (hello ioctl police :-), and also makes the kernel code simpler.
I don't think the syscall/ioctl overhead is significant compared to the
journal and IO overhead.

Also, I would specify both the source extent and the target extent in
the inode.  This first allows defragmenting only part of the file
instead of (it appears) requiring the whole file to be relocated.  That
would be a killer if the file being defragmented is larger than free
space.  It secondly provides a level of insurance that what the kernel
is relocating matches what userspace thinks it is doing.  It would
protect against problems if the kernel ever does block relocation
itself (e.g. merge fragments into a single extent on (re)write, or for
snapshot/COW).

> The other problem I see with this patch is that there will be cache
> coherency problems between the buffer cache and the page cache.  I
> think you will want to pull the data blocks of the file into the page
> cache, and then write them out from the page cache, and only *then*
> update the indirect blocks and commit the transaction.

Alternately (maybe even better) is to treat it as O_DIRECT and ensure
the page cache is flushed.  This also avoids polluting the whole page
cache while running a defragmenter on the filesystem.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
