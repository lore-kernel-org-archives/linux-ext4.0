From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: EXT4 Larger Than 16TB
Date: Mon, 22 Jul 2013 08:52:27 +0800
Message-ID: <20130722005227.GA19341@gmail.com>
References: <CAGJTRcg0SHP3-9V-0nDttZ+atn5Kbhf9RRnn_VOaNOq8MgDe6Q@mail.gmail.com>
 <20130709021403.GC6000@thunk.org>
 <CAGJTRchb5KpYLEOKB1bzNSmJ4SQQ9YVf9UZEsd+Hu38D5mW05g@mail.gmail.com>
 <51EC64E8.8090509@zytor.com>
 <20130721234325.GA15659@gmail.com>
 <CAGJTRchJ4Mq5in0nXeeF8mA2A=yub7kv4OohUb_QpKtEKCWM-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Michael <mike@draftx.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34166 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab3GVAwe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jul 2013 20:52:34 -0400
Received: by mail-pb0-f50.google.com with SMTP id wz7so6463501pbc.9
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jul 2013 17:52:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAGJTRchJ4Mq5in0nXeeF8mA2A=yub7kv4OohUb_QpKtEKCWM-A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Michael,

On Sun, Jul 21, 2013 at 07:44:12PM -0500, Michael wrote:
> Also, in /etc/mke2fs.conf(Ubuntu has this by default):
>         ext4 = {
>                 features =
> has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
>                 auto_64-bit_support = 1
>                 inode_size = 256
>         }
> 
>         ext4dev = {
>                 features =
> has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize
>                 inode_size = 256
>                 options = test_fs=1
>         }
> 
> 
> 
> Also, any info on how to find out if my fs is 64 bit or not? I don't
> know what this config was back when I made the system.

You could use 'tune2fs -l ${DEV}' to check whether 64bit feature is
enabled.  Here is a sample result:

$ sudo tune2fs -l /dev/sda1
tune2fs 1.43-WIP (21-Jan-2013)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          5abc13bd-01d9-41ff-b7ca-a028b3d610f8
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype extent 64bit flex_bg sparse_super large_file huge_file
                ^^^^^

uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              5021696
Block count:              20081242
Reserved block count:     1004062
Free blocks:              19719931
Free inodes:              5021685
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      1024
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Mon Jul 22 08:50:15 2013
Last mount time:          n/a
Last write time:          Mon Jul 22 08:50:25 2013
Mount count:              0
Maximum mount count:      -1
Last checked:             Mon Jul 22 08:50:15 2013
Check interval:           0 (<none>)
Lifetime writes:          1358 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      7d9a465d-3e37-4d41-af45-fff9c682f8ec
Journal backup:           inode blocks

Regards,
                                                - Zheng
