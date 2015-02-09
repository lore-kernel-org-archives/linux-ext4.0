From: Kevin Liao <kevinlia@gmail.com>
Subject: Possible file system corruption?
Date: Mon, 9 Feb 2015 19:33:28 +0800
Message-ID: <CAF_MivHO0nVcqUTv6M2rMBkAS0pmSGBa-KSurPdbqaN+MGp=iQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:44082 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809AbbBILdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Feb 2015 06:33:49 -0500
Received: by mail-qg0-f53.google.com with SMTP id f51so20873175qge.12
        for <linux-ext4@vger.kernel.org>; Mon, 09 Feb 2015 03:33:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

Recently whenvevr I try to access one file, I saw the following kernel log:

"EXT4-fs error (device md0): ext4_ext_find_extent:400: inode #95223833: comm
 fio: bad header/extent: invalid magic - magic e2b6, entries 59156, max
 58100(0), depth 43399(0)"

inode 95223833 is just the file I want to read. I guess there may be some
corruption in the file system. Therefore I umount it and run e2fsck command
but get the following result:

"ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
./e2fsck: Group descriptors look bad... trying backup blocks...
Corruption found in superblock. (reserved_gdt_blocks = 16384).

The superblock could not be read or does not describe a valid ext2/ext3/ext4
filesystem. If the device is valid and it really contains an ext2/ext3/ext4
filesystem (and not swap or ufs or something else), then the superblock
is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
 or
    e2fsck -b 32768 <device>"

It seems that the superblock is bad, however I can still mount it and access
to other files without error. The kernel version is 3.4.23. Is there anything
I can do to recover the file? Any help is very appreciated. Thank a lot.

Kevin
