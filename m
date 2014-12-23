From: Maxim Malkov <malkov@ispras.ru>
Subject: Online resizing of filesystem mounted with backup superblock causes
 corruption
Date: Wed, 24 Dec 2014 01:32:42 +0300
Message-ID: <5499ED8A.5010907@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andrey Tsyvarev <tsyvarev@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:45190 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaLWWcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Dec 2014 17:32:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

# mkfs.ext4 /dev/loop0 100M # adjust if necessary, should be less than
partition size

Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729
(pick one)

# mount -t ext4 -o sb=40961 /dev/loop0 /media/
# resize2fs /dev/loop0
resize2fs 1.42.12 (29-Aug-2014)
Filesystem at /dev/loop0 is mounted on /media; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 4

Now, depending on your luck, various things may happen. resize2fs may hang.
You might see BUG() in your dmesg. Either way, system will become
severely corrupted (as indicated by fsck). You won't be able to mount
it, either.

[ 2669.510800] EXT4-fs (loop0): resizing filesystem from 128000 to
256000 blocks
[ 2669.513558] EXT4-fs warning (device loop0): reserve_backup_gdb:969:
reserved block 32770 not at offset 1
[ 2669.513569] EXT4-fs (loop0): resized filesystem to 256000
[ 2669.516328] EXT4-fs warning (device loop0): ext4_group_extend:1734:
can't shrink FS - resize aborted


-- 
Maxim Malkov
Software Engineering Department, ISPRAS 

