From: Jan Kara <jack@suse.cz>
Subject: Re: [4.7-rc6 ext3 BUG] kernel BUG at fs/ext4/xattr.c:1331
Date: Thu, 28 Jul 2016 15:54:32 +0200
Message-ID: <20160728135432.GA19398@quack2.suse.cz>
References: <20160718022356.GC1922@dastard>
 <20160718030256.GD1922@dastard>
 <83e3076d-4f84-705d-5259-b3ac1aaf90b7@redhat.com>
 <20160718052447.GE1922@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbcG1Nyf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jul 2016 09:54:35 -0400
Content-Disposition: inline
In-Reply-To: <20160718052447.GE1922@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 18-07-16 15:24:47, Dave Chinner wrote:
> On Sun, Jul 17, 2016 at 09:07:16PM -0700, Eric Sandeen wrote:
> > On 7/17/16 8:02 PM, Dave Chinner wrote:
> > > # rm !$
> > > rm /mnt/scratch/fsr_test_file.27768.14.6
> > > #
> > > 
> > > And, by removing an attribute, I can successfully remove the file.
> > > So this definitely looks like a corner case xattr handling issue in
> > > ext3/4.
> > 
> > I told xfs/227 that it could run on ext3 and ran it, but this
> > didn't reproduce for me.
> > 
> > Can you provide a dumpe2fs -h for the root fs, this might depend on
> > inode size etc.
> 
> # dumpe2fs -h /dev/sda1
> dumpe2fs 1.43-WIP (18-May-2015)
> Filesystem volume name:   <none>
> Last mounted on:          /
> Filesystem UUID:          b21615e5-fe8a-4ffc-ab80-c24cdc8b740a
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery sparse_super large_file
> Filesystem flags:         signed_directory_hash 
> Default mount options:    (none)
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              624624
> Block count:              2496091
> Reserved block count:     124804
> Free blocks:              567319
> Free inodes:              352653
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      609
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8112
> Inode blocks per group:   507
> Filesystem created:       Thu Mar 25 18:10:55 2010
> Last mount time:          Tue Jul 19 01:21:57 2016
> Last write time:          Tue Jul 19 01:21:57 2016
> Mount count:              10
> Maximum mount count:      27
> Last checked:             Mon Jul 18 21:59:01 2016
> Check interval:           15552000 (6 months)
> Next check after:         Sat Jan 14 22:59:01 2017
> Lifetime writes:          13 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> First orphan inode:       219355
> Default directory hash:   half_md4
> Directory Hash Seed:      740ffa95-af8d-4e89-b68c-5e768a27ece3
> Journal backup:           inode blocks
> Journal features:         journal_incompat_revoke
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x01c975b5
> Journal start:            12

Thanks for report! So I see at least part of what happened: Your filesystem
was created with 'extra inode size' 28 and likely your inodes were created
with this amount of space reserved in the extended attribute area of the
inode because you still created them with some older kernel (but that means
that it had to be a kernel prior to commit 8b4953e13f4c which landed in
4.4-rc5 because newer kernels would automatically reserve 32-bytes in the
inode, not 28 as specified by the superblock).

The above mentioned commit has added project ID to the inode so new kernels
now ask for 32 bytes in the extended attribute area. So when you tried to
modify the inode with newer kernel, we were trying to shift extended
attributes around to make space for those additional 4 bytes. So that makes
it clear why Eric was not able to reproduce the issue.

I've tried creating file with an old kernel and deleting it with a new one
and the bugon indeed triggers. Going through ext4_expand_extra_isize_ea() I
see so many bugs that it's not nice. I guess we should add some inode size
expansion tests...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
