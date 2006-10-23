From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 18:03:10 +0200
Message-ID: <20061023160310.GB11353@atrey.karlin.mff.cuni.cz>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <20061023151447.GL3509@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45226 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1751886AbWJWQCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 12:02:21 -0400
To: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061023151447.GL3509@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Oct 23, 2006  10:16 -0400, Theodore Tso wrote:
> > As a suggestion, I would pass the inode number and inode generation
> > number into the ext3_file_mode_data array:
> > 
> > struct ext3_file_move_data {
> > 	int extents;
> > 	struct ext3_reloc_extent __user *ext_array;
> > };
> > 
> > This will be much more efficient for the userspace relocator, since it
> > won't need to translate from an inode number to a pathname, and then
> > try to open the file before relocating it.
> > 
> > I'd also use an explicit 64-bit block numbers type so that we don't
> > have to worry about the ABI changing when we support 64-bit block
> > numbers.
> 
> I would in fact go so far as to allow only a single extent to be specified
> per call.  This is to avoid the passing of any pointers as part of the
> interface (hello ioctl police :-), and also makes the kernel code simpler.
> I don't think the syscall/ioctl overhead is significant compared to the
> journal and IO overhead.
  I'm not sure it makes the kernel code simplier - if we have to replace
just a part of the file, we have to rewrite references to blocks at
several places inside indiretc tree. If we relocate whole file, we just
replace block pointers from inode. Furthermore it makes it kind of
harder to tell where indirect blocks would go - and it would be
impossible for the defragmenter to force some unusual placement of
indirect blocks... Currently blocks (including indirect ones) are just
being allocated in the DFS order from the given list.

> Also, I would specify both the source extent and the target extent in
> the inode.  This first allows defragmenting only part of the file
> instead of (it appears) requiring the whole file to be relocated.  That
> would be a killer if the file being defragmented is larger than free
> space.  It secondly provides a level of insurance that what the kernel
> is relocating matches what userspace thinks it is doing.  It would
> protect against problems if the kernel ever does block relocation
> itself (e.g. merge fragments into a single extent on (re)write, or for
> snapshot/COW).
  I agree that this is the positive side of your approach :).

> > The other problem I see with this patch is that there will be cache
> > coherency problems between the buffer cache and the page cache.  I
> > think you will want to pull the data blocks of the file into the page
> > cache, and then write them out from the page cache, and only *then*
> > update the indirect blocks and commit the transaction.
> 
> Alternately (maybe even better) is to treat it as O_DIRECT and ensure
> the page cache is flushed.  This also avoids polluting the whole page
> cache while running a defragmenter on the filesystem.
  That's what I'm trying to do (but maybe my code is buggy).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
