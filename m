From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: Re: ext4 metadata corruption bug?
Date: Wed, 23 Apr 2014 20:05:22 +0200
Message-ID: <20140423180522.GA2221@dot.freshdot.net>
References: <20140420163211.GT10985@gradx.cs.jhu.edu>
 <20140423072311.GD10163@dot.freshdot.net>
 <20140423143642.GA29925@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nathaniel W Filardo <nwf@cs.jhu.edu>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:47463 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDWSF0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2014 14:05:26 -0400
Content-Disposition: inline
In-Reply-To: <20140423143642.GA29925@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quoting Theodore Ts'o (tytso@mit.edu):
> First, of all, can you go through your log files and find me as many
> instances of these two pairs of ext4 error messges:
> EXT4-fs (vdd): pa ffff88000dea9b90: logic 0, phys. 1934464544, len 32
> EXT4-fs error (device vdd): ext4_mb_release_inode_pa:3729: group 59035, free 14, pa_free 12

I've got quite a few of them (yay, remote syslog) and i will keep them
pasted on https://8n1.org/9765/e6d5


> Secondly, can you send me the output of dumpe2fs -h for the file
> systems in question.

The FS was created with 'mkfs.ext4 -m 0 /dev/vdb', iirc.
Dumpe2fs output:
| Filesystem volume name:   <none>
| Last mounted on:          /srv/storage
| Filesystem UUID:          02acfb89-2752-4b82-8604-72b035933f8c
| Filesystem magic number:  0xEF53
| Filesystem revision #:    1 (dynamic)
| Filesystem features:      has_journal ext_attr resize_inode dir_index
|     filetype needs_recovery extent flex_bg sparse_super large_file
|     huge_file uninit_bg dir_nlink extra_isize
| Filesystem flags:         signed_directory_hash 
| Default mount options:    user_xattr acl
| Filesystem state:         clean
| Errors behavior:          Continue
| Filesystem OS type:       Linux
| Inode count:              671088640
| Block count:              2684354560
| Reserved block count:     0
| Free blocks:              1158458306
| Free inodes:              670928082
| First block:              0
| Block size:               4096
| Fragment size:            4096
| Reserved GDT blocks:      384
| Blocks per group:         32768
| Fragments per group:      32768
| Inodes per group:         8192
| Inode blocks per group:   512
| Flex block group size:    16
| Filesystem created:       Sat Jul 20 19:24:38 2013
| Last mount time:          Wed Apr 23 08:59:15 2014
| Last write time:          Wed Apr 23 08:59:15 2014
| Mount count:              1
| Maximum mount count:      -1
| Last checked:             Wed Apr 23 08:53:15 2014
| Check interval:           0 (<none>)
| Lifetime writes:          3444 GB
| Reserved blocks uid:      0 (user root)
| Reserved blocks gid:      0 (group root)
| First inode:              11
| Inode size:           256
| Required extra isize:     28
| Desired extra isize:      28
| Journal inode:            8
| Default directory hash:   half_md4
| Directory Hash Seed:      4e54f4fb-479e-464c-80ba-1478cc56181a
| Journal backup:           inode blocks
| Journal features:         journal_incompat_revoke
| Journal size:             128M
| Journal length:           32768
| Journal sequence:         0x000ada49
| Journal start:            1


> Finally, since the both of you are seeing these messages fairly
> frequently, would you be willing to run with a patched kernel?
> Specifically, can you add a WARN_ON(1) to fs/ext4/mballoc.c here:

I can test away on this box. As long as my data stays safe. :-)
I have to admit i haven't compiled my own *kernel* since 2.4.x so i took
the Ubuntu package and patched that with the WARN_ON(1) call. Building
takes ages, but i will report my findings.


> The two really interesting commonalities which I've seen so far is:
> 1)  You are both using virtualization via qemu/kvm
> 2)  You are both using file systems > 8TB.
> Yes? And Sander, you're not using a remote block device, correct?
> You're using a local disk to back the large fileystem on the host OS
> side?

This is all correct. The host has LVM running, one logical volume is
'exported' to the guest through qemu (2.0) with virtio driver.


-Sndr.
-- 
| A bicycle can't stand alone; it is two tired. 
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
