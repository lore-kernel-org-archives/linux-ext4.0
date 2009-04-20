From: Jeremy Sanders <jss@ast.cam.ac.uk>
Subject: Re: fsck.ext4: Group descriptors look bad... trying backup
 blocks...
Date: Mon, 20 Apr 2009 17:40:32 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0904201727080.17316@xpc17.ast.cam.ac.uk>
References: <gs9nm5$8m1$1@ger.gmane.org> <49E8B5AD.6030907@redhat.com> <gshfgl$o6m$1@ger.gmane.org> <20090420113534.GR19186@mit.edu> <alpine.LFD.2.00.0904201237500.17316@xpc17.ast.cam.ac.uk> <20090420124810.GT19186@mit.edu> <49EC8B97.6010308@redhat.com>
 <49EC9A11.1080105@redhat.com> <alpine.LFD.2.00.0904201652540.17316@xpc17.ast.cam.ac.uk> <49ECA218.4080106@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:37677 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZDTQkf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Apr 2009 12:40:35 -0400
In-Reply-To: <49ECA218.4080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Apr 2009, Eric Sandeen wrote:

> Jeremy Sanders wrote:
>> On Mon, 20 Apr 2009, Eric Sandeen wrote:
> ...
>
>>> One other question - do you make use of xattrs on this filesystem?
>>
>> No.
>
> I've commandeered about 10T of disk space to see if I can hit this.
> Would you mind providing dumpe2fs -h output for your 8.2T filesystem so
> I can exactly replicate the geometry?

I formatted with

mkfs.ext4 -m0 -b 4096 -E stride=8,stripe-width=72  /dev/md0

[root@xback2 ~]#  dumpe2fs -h /dev/md0
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          34fefacb-0494-4df7-b189-e11b2064dd90
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              549314560
Block count:              2197239840
Reserved block count:     0
Free blocks:              2162717221
Free inodes:              549314549
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      500
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
RAID stride:              8
RAID stripe width:        72
Flex block group size:    16
Filesystem created:       Mon Apr 20 17:29:14 2009
Last mount time:          n/a
Last write time:          Mon Apr 20 17:38:28 2009
Mount count:              0
Maximum mount count:      38
Last checked:             Mon Apr 20 17:29:14 2009
Check interval:           15552000 (6 months)
Next check after:         Sat Oct 17 17:29:14 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      06d43af3-a75c-405a-8f25-e51517dae7f6
Journal backup:           inode blocks
Journal size:             128M

