From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Tue, 30 Sep 2014 15:10:55 -0700
Message-ID: <20140930221055.GD9942@birch.djwong.org>
References: <542B1C38.9010409@redhat.com>
 <542B1EFC.4050500@redhat.com>
 <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43205 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaI3WLC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Sep 2014 18:11:02 -0400
Content-Disposition: inline
In-Reply-To: <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 30, 2014 at 03:36:17PM -0600, Andreas Dilger wrote:
> On Sep 30, 2014, at 3:22 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> > On 9/30/14 4:10 PM, Eric Sandeen wrote:
> >> Hey all -
> >> 
> >> So the following testcase will overrun the 1-credit journal reservation
> >> made during a delalloc write in ext4_da_write_begin(), because we
> >> may cross the 2G threshold, and need to modify both the inode and the
> >> superblock in the same transaction.
> >> 
> >> I see a few was to fix this:
> >> 
> >> 1) Always set LARGE_FILE on mount if not set.  This will break
> >>   RW compatiblity with very old kernels.  Do we care?
> > 
> >  1.5) Don't update the feature on the fly - we don't for
> >       HUGE_FILE, either.
> > 
> >  1.5a) Always set the large_file feature with a fresh mkfs, insteadl
> >        of relying on the accident of the resize inode being > 2G!
> 
> I think that 1.5a is definitely the way to go for new mke2fs, I'm a
> bit surprised that we didn't do this for "-t ext4" a long time ago
> given that we've enabled lots of other features automatically.

Sounds good to me.

> There shouldn't be any problem to do this retroactively in e2fsck
> and potentially at mount time for filesystems that already have some
> features enabled that are post-large_file (e.g. extents, flex_bg, etc.)
> This definitely would not impose any compatibility issues, because any
> kernel that supports those features already understands large_file.
> 
> I'm pretty sure that e2fsck doesn't turn off large_file automatically
> anymore if it can't find any files over 2GB, but it is worthwhile to
> verify this.

It doesn't.

> >> 2) Bump the reservation to 2 under the fiddly condition of
> >>   large file not yet set but this write might do it
> >> 3) bump the delalloc reservation to 2 just in case, always
> 
> Given how many other reservations we have for normal operations,
> I don't think it is so bad to reserve an extra block if the
> large_file feature isn't enabled yet.  This could be fine tuned
> based on the size and offset of the write, but I'm not sure if
> the extra complexity warrants it.
> 
> It doesn't make sense to reserve this block if the feature
> is already set, and I don't think that there are (m)any features
> that are turned on automatically by the kernel anymore so it is
> overhead to reserve the block if you know it won't be needed.
> 
> I don't know if this is belt and suspenders, but it might be
> something to consider for supporting older kernels and we may not
> need it in newer kernels.

1.5a and (2 if ^large_file) seem fine to me.

--D
> 
> Cheers, Andreas
> 
> >> I'll be happy to write the patch to fix it, just wondering what
> >> people think the best approach is
> >> 
> >> Thoughts?
> >> -Eric
> >> 
> >> 
> >> #!/bin/bash
> >> 
> >> # A 400m fs won't get the large_file feature, oddly
> >> # enough, because the resize inode will be < 2G.
> >> 
> >> truncate --size=400m test.img
> >> mkfs.ext4 -F test.img
> >> # This shouldn't have large_file set, exit if it does for some reason
> >> dumpe2fs -h test.img | grep large_file && exit
> >> 
> >> mkdir -p mnt
> >> mount -o loop test.img mnt
> >> 
> >> echo "writing 1 byte at 2147483646" 
> >> dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483646 count=1 conv=notrunc of=mnt/testfile
> >> sync
> >> 
> >> # This will make sure i_disksize is on disk, and
> >> # that the buffer will be mapped on the next write.
> >> #
> >> # This is critical because ext4_da_should_update_i_disksize()
> >> # checks buffer_mapped():
> >> #
> >> #        if (!buffer_mapped(bh) || (buffer_delay(bh)) || buffer_unwritten(bh))
> >> #                return 0;
> >> #        return 1;
> >> 
> >> # This tries to update i_disksize, and also requires a superblock
> >> # update for the large_file feature flag, but only has 1 credit
> >> # available on the delalloc write path
> >> 
> >> echo "writing 1 byte at 2147483647"
> >> dd if=/dev/zero of=mnt/testfile bs=1 seek=2147483647 count=1 conv=notrunc of=mnt/testfile
> >> 
> >> # Should go boom, but if not, unmount
> >> umount mnt
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 


