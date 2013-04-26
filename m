From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: metadata_csum + e4defrag seems to cause problems
Date: Fri, 26 Apr 2013 10:57:53 +0800
Message-ID: <20130426025753.GA21659@gmail.com>
References: <20130425174836.20362.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:52059 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897Ab3DZCk3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Apr 2013 22:40:29 -0400
Received: by mail-pa0-f53.google.com with SMTP id bh4so2211650pad.26
        for <linux-ext4@vger.kernel.org>; Thu, 25 Apr 2013 19:40:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130425174836.20362.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi George,

Thanks for reporting this.

Yes, metatdata_csum + e4defrag could corrupt ext4 file system.  We have
found this bug and it has been fixed by this commit (2656497b, it is in
dev branch of ext4 tree).  I am not sure whether you use dev branch.
Could you please tell me your kernel version?  If you don't use dev
branch, could you please try dev branch of ext4 tree?  Here is the git
link:
  https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git/log/?h=dev

Regards,
                                                - Zheng

On Thu, Apr 25, 2013 at 01:48:36PM -0400, George Spelvin wrote:
> I've been running metadata_csum on my SSE 4.2 machines (which I know
> isn't considered stable, but I'm willing to be guinea pig), and I've
> had some corruption problems with on-line e4defrag.
> 
> This is actually the second time something like this has happened,
> but I wasn't sure the first wasn't pilot error, and it didn't
> get recorded in detail.
> 
> Here's the file system info:
> dumpe2fs 1.43-WIP (22-Sep-2012)
> Filesystem volume name:   root
> Last mounted on:          /
> Filesystem UUID:          9bb69d2a-7357-4c8b-8177-48f00655c75a
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr dir_index filetype needs_recovery extent flex_bg sparse_super huge_file dir_nlink extra_isize metadata_csum
> Filesystem flags:         signed_directory_hash 
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              980720
> Block count:              9765511
> Reserved block count:     488275
> Free blocks:              6183452
> Free inodes:              687143
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         3280
> Inode blocks per group:   205
> Flex block group size:    16
> Filesystem created:       Fri Jun 29 03:35:27 2012
> Last mount time:          Thu Apr 25 15:09:10 2013
> Last write time:          Thu Apr 25 15:09:10 2013
> Mount count:              3
> Maximum mount count:      -1
> Last checked:             Thu Apr 25 14:53:36 2013
> Check interval:           0 (<none>)
> Lifetime writes:          49 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               256
> Required extra isize:     28
> Desired extra isize:      28
> Journal inode:            8
> Default directory hash:   half_md4
> Directory Hash Seed:      b57a282d-d8ac-4c16-863f-a81f1134a760
> Journal backup:           inode blocks
> Checksum type:            crc32c
> Checksum:                 0xaac36e3f
> Journal features:         journal_incompat_revoke
> Journal size:             128M
> Journal length:           32768
> Journal sequence:         0x00065b54
> Journal start:            8421
> 
> After running "e4defrag -v /" on the system, I get a bunch of nasty
> kernel messages (unfortunately lost in the process), and on rebooting
> I encountered:
> 
> e2fsck 1.43-WIP (22-Sep-2012)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 57 has an invalid extent node (blk 33356, lblk 0)
> Clear<y>? yes
> Inode 57, i_blocks is 150408, should be 0.  Fix<y>? yes
> Inode 52684 has an invalid extent node (blk 557295, lblk 0)
> Clear<y>? yes
> Inode 52684, i_blocks is 286832, should be 0.  Fix<y>? yes
> Inode 109466 has an invalid extent node (blk 1089048, lblk 0)
> Clear<y>? yes
> Inode 109466, i_blocks is 96, should be 0.  Fix<y>? yes
> Inode 110979 has an invalid extent node (blk 1082248, lblk 0)
> Clear<y>? yes
> Inode 110979, i_blocks is 88, should be 0.  Fix<y>? yes
> Inode 113316 has an invalid extent node (blk 1085426, lblk 0)
> Clear<y>? yes
> 
> etc.
> 
> Most of these were frequently-overwritten files that I expect the
> defragmenter actually migrated.
> 57      /usr/share/icons/HighContrast/icon-theme.cache
> 52684   /usr/share/icons/oxygen/icon-theme.cache
> 114026  /usr/src/linux/arch/powerpc/kvm/book3s_hv.c
> 116259  /usr/src/linux/lib/swiotlb.c
> 110979  /usr/src/linux/fs/.ioctl.o.cmd
> 118681  /usr/src/linux/fs/.compat.o.cmd
> 118828  /usr/src/linux/fs/.compat_ioctl.o.cmd
> 109466  /usr/src/linux/fs/.exec.o.cmd
> 113316  /usr/src/linux/fs/cifs/file.o
> 
> This also included a lot of /var/log and, unfortunately,
> 944676  /usr/src/linux/.git/objects/pack/pack-db2414b587cfe1e06e3beafd81231137700ad6be.pack
> (which i *know* the defragmenter worked on, because it took a while.)
> 
> Ouch, that hurt.  Fortunately, I hadn't done much since my last backup.
> 
> I'm a bit reluctant to volunteer my root FS for more testing of
> this sort, but maybe some ext4 hacker can try to confirm my guess
> that the in-kernel defragmenter is corrupting the metadata checksum?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
