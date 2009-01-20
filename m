From: fdbugs <fdbugs@dupoux.com>
Subject: bug when we do an mkfs.ext4 + tune2fs
Date: Tue, 20 Jan 2009 13:21:45 +0000
Message-ID: <580e35610901200521x20a9bc85l66ea520151008bc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:29009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZATNVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jan 2009 08:21:46 -0500
Received: by rv-out-0506.google.com with SMTP id k40so3113349rvb.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jan 2009 05:21:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have an error when I try to mount an ext4 after having changed its
uuid with tune2fs. If I just do an mkfs.ext4 I can mount it, but if I
do an mkfs.ext4 and then an e2label -U on it, it can't be mounted.
Fortunately this bug is quite easy to reproduce.

1) mkfs.ext4 /dev/xxxx  -b 4096  -I 256 -O
has_journal,ext_attr,resize_inode,dir_index,filetype,extent,flex_bg,sparse_super,large_file,huge_file,uninit_bg,dir_nlink,extra_isize,^journal_dev

2) "mount -t ext4 /dev/xxxx /mnt/test" works

3) umount /dev/xxxx

4) tune2fs /dev/xxxx  -U 19ad8325-2e39-4be1-a6b1-a5d2d1015eeb

5) "mount -t ext4 /dev/xxxx /mnt/test" fails

6) we can see the following error in the log messages
EXT4-fs: ext4_check_descriptors: Checksum for group 0 failed (10987!=27579)
EXT4-fs: group descriptors corrupted!


I am running a 64bit 2.6.27.12 kernel with 64bit binaries, and e2fsprogs-1.41.3.

Another user using Ubuntu jaunty alpha3 on a 32bit system has exactly
the same problem, so it sounds that all recent ext4 versions are
impacted.

The mkfs command is quite long just because the list of filesystem
features have been saved by a tool which must recreate the filesystem
with the same attributes.

Thanks
