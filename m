From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Ext4 external journal UUID mismatch?
Date: Mon, 16 Jul 2012 12:26:10 +0930
Message-ID: <20120716025610.GB2562@tuon.disenchant.local>
References: <20120715234058.GA2562@tuon.disenchant.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38583 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751723Ab2GPC4Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 15 Jul 2012 22:56:16 -0400
Content-Disposition: inline
In-Reply-To: <20120715234058.GA2562@tuon.disenchant.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 16, 2012 at 09:10:58AM +0930, Kevin Shanahan wrote:
> I have created some filesystems with external journals, and after
> reboot (clean shutdown) these will not mount anymore. I see in dmesg:
> 
>   [42214.365496] EXT4-fs (dm-10): journal UUID does not match
> 
> However, the UUIDs look fine when viewed with dumpe2fs:
> 
> # dumpe2fs -h /dev/it8/nfs-kvmhost0
> Filesystem volume name:   <none>
> Last mounted on:          /srv/nfs4/kvmhost0-rootfs
> Filesystem UUID:          8a543c99-8a66-4ec2-9664-e82e3642cee0
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
> Filesystem flags:         signed_directory_hash 
> Default mount options:    journal_data user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              983040
> Block count:              3932160
> Reserved block count:     196608
> Free blocks:              3628551
> Free inodes:              939811
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Reserved GDT blocks:      959
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         8192
> Inode blocks per group:   512
> RAID stride:              128
> RAID stripe width:        768
> Flex block group size:    16
> Filesystem created:       Sun Jul  8 10:45:26 2012
> Last mount time:          Sun Jul  8 10:45:26 2012
> Last write time:          Sun Jul 15 20:47:20 2012
> Mount count:              1
> Maximum mount count:      -1
> Last checked:             Sun Jul  8 10:45:26 2012
> Check interval:           0 (<none>)
> Lifetime writes:          2024 MB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:	          256
> Required extra isize:     28
> Desired extra isize:      28
> Journal UUID:             9e21ab2e-533e-41b1-a006-21bcf7574a45
> Journal device:	          0xfd0c
> Default directory hash:   half_md4
> Directory Hash Seed:      61c03a7c-947b-4432-a134-7b0dfd307228
> 
> # dumpe2fs -h /dev/ssdvg/jnl-kvmhost0
> Filesystem volume name:   <none>
> Last mounted on:          <not available>
> Filesystem UUID:          9e21ab2e-533e-41b1-a006-21bcf7574a45
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      journal_dev
> Default mount options:    user_xattr acl
> Filesystem state:         clean
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              0
> Block count:              262144
> Reserved block count:     0
> Free blocks:              0
> Free inodes:              0
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         0
> Inode blocks per group:   0
> Filesystem created:       Sun Jul  8 10:45:20 2012
> Last mount time:          n/a
> Last write time:          Sun Jul  8 10:45:21 2012
> Mount count:              0
> Maximum mount count:      -1
> Last checked:             Sun Jul  8 10:45:20 2012
> Check interval:           0 (<none>)
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:	          256
> Required extra isize:     28
> Desired extra isize:      28
> Default directory hash:   half_md4
> Directory Hash Seed:      9f3616f0-a8e2-4e61-8e31-2632a0fb2287
> 
> Journal block size:       4096
> Journal length:           262144
> Journal first block:      2
> Journal sequence:         0x000120d6
> Journal start:            0
> Journal number of users:  1
> Journal users:            8a543c99-8a66-4ec2-9664-e82e3642cee0
> 
> I don't understand why mount/kernel unhappy with this. Can someone
> shed some light on this?
> 
> # uname -r
> 3.4.4-3-ARCH
> 
> Thanks,
> Kevin.

Here is what e2fsck said about it.

# e2fsck -p -j /dev/ssdvg/jnl-kvmhost0 /dev/it8/nfs-kvmhost0
/dev/it8/nfs-kvmhost0: Superblock hint for external superblock should be 0xfd0d.  FIXED.
/dev/it8/nfs-kvmhost0: clean, 43229/983040 files, 303609/3932160 blocks

I guess that is the "Journal Device" field? Mount worked fine after
that and the data looks okay.

Any idea how this might have happened across all three fs with
external journals?

Thanks,
Kevin.
 
