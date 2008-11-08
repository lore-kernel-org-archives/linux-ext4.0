From: "Roc Valles" <vallesroc@gmail.com>
Subject: EXT4-fs error (device sda3): ext4_mb_generate_buddy: EXT4-fs: group 923: 18046 blocks in bitmap, 32768 in gd
Date: Sat, 8 Nov 2008 14:37:03 +0000
Message-ID: <3d3ce57e0811080637k3de96b09q28abeb4ebea0463c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:32948 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbYKHOhF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 09:37:05 -0500
Received: by fk-out-0910.google.com with SMTP id 18so2101490fkq.5
        for <linux-ext4@vger.kernel.org>; Sat, 08 Nov 2008 06:37:03 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I get the following soon after booting, each time I boot:
[  245.033381] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
EXT4-fs: group 923: 18046 blocks in bitmap, 32768 in gd
[  245.033411]
[  245.036258] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
EXT4-fs: group 924: 18113 blocks in bitmap, 32768 in gd
[  245.036275]
[  245.038909] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
EXT4-fs: group 925: 18000 blocks in bitmap, 32768 in gd
[  245.038926]
[  245.041258] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
EXT4-fs: group 926: 18142 blocks in bitmap, 32768 in gd
[  245.041274]
[  245.043624] EXT4-fs error (device sda3): ext4_mb_generate_buddy:
EXT4-fs: group 927: 18026 blocks in bitmap, 32768 in gd

Kernel is 2.6.27.5 with the oneliner for the recent mmap problem. Same
problem was there with .4 with the oneliner too. Never noticed it
before using the oneliner.

Linux kaguya 2.6.27.5 #1 SMP Sat Nov 8 03:43:33 UTC 2008 x86_64
Intel(R) Atom(TM) CPU 330 @ 1.60GHz GenuineIntel GNU/Linux

fsck.ext4 (shutdown -Fr now) finds/fixes nothing.

kaguya ~ # dumpe2fs -h /dev/sda3
dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          <not available>
Filesystem UUID:          07520665-bfed-4d37-a38e-0a7cb04cff59
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash test_filesystem
Default mount options:    (none)
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              91430912
Block count:              365693619
Reserved block count:     0
Free blocks:              242506667
Free inodes:              90878491
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      936
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri Oct 31 13:43:31 2008
Last mount time:          Sat Nov  8 03:50:45 2008
Last write time:          Sat Nov  8 03:51:30 2008
Mount count:              1
Maximum mount count:      31
Last checked:             Sat Nov  8 03:47:31 2008
Check interval:           15552000 (6 months)
Next check after:         Thu May  7 03:47:31 2009
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:               256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
First orphan inode:       17705890
Default directory hash:   half_md4
Directory Hash Seed:      ba0cc33f-c339-4fd9-aa04-bfdad45ecf92
Journal backup:           inode blocks
Journal size:             128M
