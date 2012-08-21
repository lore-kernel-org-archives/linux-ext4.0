From: Curtis Jones <curtis.jones@gmail.com>
Subject: Re: Can't resize2fs - combination of flex_bg and !resize_inode
Date: Mon, 20 Aug 2012 23:23:55 -0400
Message-ID: <E046A276-D096-4A56-9B4D-B7912087B88F@gmail.com>
References: <0FB0C67C-CF56-4589-857F-8B57BC25AB7D@gmail.com> <20120821030245.GA4222@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56901 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2HUDX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 23:23:58 -0400
Received: by yhmm54 with SMTP id m54so5578075yhm.19
        for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 20:23:57 -0700 (PDT)
In-Reply-To: <20120821030245.GA4222@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 20, 2012, at 23.02.45, Theodore Ts'o <tytso@mit.edu> wrote:

> Yes, you should definitely get a newer version of e2fsprogs.  The
> latest version is 1.42.5.

Done.


> As to whether you'll need to recreate the filesystem, I'll need to see
> the output of dumpe2fs -h.  It may be that file system was created in
> sufficiently poor configuration that it would be highly advisable that
> you recreate the file system.

Thanks for the reply. Below, as requested, the output from dumpe2fs and the mke2fs.conf file (Ubuntu 12.04). I look forward to hearing that my file system isn't in a state of "sufficiently poor configuration"; however, since I originally posted my question I've managed to secure a means to duplicate the data so that I can recreate the file system (if necessary).

Thanks a lot for your help.



dumpe2fs 1.42.5 (29-Jul-2012)
Filesystem volume name:   <none>
Last mounted on:          /media/Bigger
Filesystem UUID:          baecfa03-74c1-42ad-8e19-3b823f05f502
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              274700288
Block count:              4395202560
Reserved block count:     219760128
Free blocks:              247712956
Free inodes:              274636266
First block:              0
Block size:               4096
Fragment size:            4096
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         2048
Inode blocks per group:   128
RAID stride:              128
RAID stripe width:        768
Flex block group size:    16
Filesystem created:       Fri Aug 17 02:54:50 2012
Last mount time:          Mon Aug 20 02:21:51 2012
Last write time:          Mon Aug 20 12:28:57 2012
Mount count:              0
Maximum mount count:      -1
Last checked:             Mon Aug 20 12:28:57 2012
Check interval:           0 (<none>)
Lifetime writes:          16 TB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      b357ba49-60b1-4c55-837f-a70c8285a8f5
Journal backup:           inode blocks
Journal features:         journal_incompat_revoke journal_64bit
Journal size:             128M
Journal length:           32768
Journal sequence:         0x00009b36
Journal start:            0



[defaults]
	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
	default_mntopts = acl,user_xattr
	enable_periodic_fsck = 0
	blocksize = 4096
	inode_size = 256
	inode_ratio = 16384

[fs_types]
	ext3 = {
		features = has_journal
	}
	ext4 = {
		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
		auto_64-bit_support = 1
		inode_size = 256
	}
	ext4dev = {
		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
		inode_size = 256
		options = test_fs=1
	}
	small = {
		blocksize = 1024
		inode_size = 128
		inode_ratio = 4096
	}
	floppy = {
		blocksize = 1024
		inode_size = 128
		inode_ratio = 8192
	}
	big = {
		inode_ratio = 32768
	}
	huge = {
		inode_ratio = 65536
	}
	news = {
		inode_ratio = 4096
	}
	largefile = {
		inode_ratio = 1048576
		blocksize = -1
	}
	largefile4 = {
		inode_ratio = 4194304
		blocksize = -1
	}
	hurd = {
	     blocksize = 4096
	     inode_size = 128
	}

--
Curtis Jones




