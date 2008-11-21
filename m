From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: Mounting corrupted ext3 image results in infinite loop
Date: Fri, 21 Nov 2008 10:32:06 +0100
Message-ID: <20081121093206.GA2672@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51097 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751883AbYKUJcL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2008 04:32:11 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

mounting an intentionally corrupted ext3 image results in
an infinite loop during the mount.

The compressed image can be found here:
http://www.cccmz.de/~snakebyte/ext3.57.img.bz2


mount ./cfs/ext3.57.img /media/test -t ext3 -o debug,data=journal -o
loop

gives the following dmesg output

[  159.477815] EXT3-fs error (device loop0): ext3_free_branches: Read
failure, inode=8, block=2147483648
[  159.488844] Aborting journal on device loop0.
[  159.492602] Remounting filesystem read-only
[  159.492987] EXT3-fs error (device loop0): ext3_free_branches: Read
failure, inode=8, block=1048576
[  159.499747] EXT3-fs error (device loop0): ext3_free_branches: Read
failure, inode=8, block=134217792
[  159.516484] EXT3-fs error (device loop0) in ext3_reserve_inode_write:
Journal has aborted
[  159.516757] EXT3-fs error (device loop0) in ext3_reserve_inode_write:
Journal has aborted
[  159.516972] EXT3-fs error (device loop0) in ext3_orphan_del: Journal
has aborted
[  181.628434] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.628643] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.628815] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.628999] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.629215] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.629383] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes
[  181.629567] ext3_orphan_cleanup: truncating inode 8 to 1049088 bytes

the ext3_orphan_cleanup message is then repeated forever.

Greetings, Eric
