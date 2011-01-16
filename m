From: Stuart Pook <slp4725@pook.it>
Subject: error ext4_mb_generate_buddy:726 & add_dirent_to_buf:1272 after online
 resize
Date: Sun, 16 Jan 2011 15:03:57 +0100
Message-ID: <4D32FACD.7020907@pook.it>
References: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:60235 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab1APOEH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Jan 2011 09:04:07 -0500
Received: from shiva (unknown [88.171.134.228])
	by smtp6-g21.free.fr (Postfix) with ESMTP id C985B82298
	for <linux-ext4@vger.kernel.org>; Sun, 16 Jan 2011 15:04:00 +0100 (CET)
In-Reply-To: <S1752440Ab1APNtL/20110116134911Z+826@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi

I'm getting these errors on my home filesystem

[ 5147.616006] EXT4-fs (dm-28): error count: 11
[ 5147.616888] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
[ 5147.617827] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578

I have done a fsck -f and that didn't make them stop. The errors started a few minutes
after I did an online resize of my filesystem.

To resize the filesystem I did something like this:

	lvextend --size +14G vg_root/stuart
	cryptsetup resize _dev_dm_21
	resize2fs  /dev/mapper/_dev_dm_21

It took me a couple of attemps to find the correct arguments for the "cryptsetup resize" but I don't think I broke anything. When I saw the errors from "mv" at 12:32:46 I unmounted the filesystem and did a fsck. That corrected some errors but I'm still getting "ext4_mb_generate_buddy:726" and "add_dirent_to_buf:1272" errors.

The filesystem in question is an encrypted partition on top of a lvm partition on a SSD.

thanks
Stuart

:; uname -a
Linux kooka 2.6.37-trunk-amd64 #1 SMP Thu Jan 6 14:13:28 UTC 2011 x86_64 GNU/Linux
:; fsck.ext4 -V
e2fsck 1.41.12 (17-May-2010)
	Using EXT2FS Library version 1.41.12, 17-May-2010

:; grep  'EXT4-fs.*error' /var/log/syslog
Jan 16 12:32:46 kooka kernel: : [2379819.157537] EXT4-fs error (device dm-27): ext4_mb_generate_buddy:726: group 3232766 blocks in bitmap, 32254 in gd
Jan 16 12:32:46 kooka kernel: : [2379819.157840] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.158226] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.158500] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.158520] EXT4-fs error (device dm-27): ext4_free_blocks:4591: comm mv: Freeing blocks in system zone - Block = 1048579, count = 1
Jan 16 12:32:46 kooka kernel: : [2379819.158769] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.158784] EXT4-fs error (device dm-27): ext4_free_blocks:4591: comm mv: Freeing blocks in system zone - Block = 1048580, count = 1
Jan 16 12:32:46 kooka kernel: : [2379819.159003] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.159216] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.159449] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.159464] EXT4-fs error (device dm-27): ext4_free_blocks:4591: comm mv: Freeing blocks in system zone - Block = 1048581, count = 1
Jan 16 12:32:46 kooka kernel: : [2379819.159679] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.159907] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:32:46 kooka kernel: : [2379819.159923] EXT4-fs error (device dm-27): ext4_free_blocks:4591: comm mv: Freeing blocks in system zone - Block = 1048582, count = 1
Jan 16 12:32:46 kooka kernel: : [2379819.160154] EXT4-fs error (device dm-27): add_dirent_to_buf:1272: inode #262145: block 1048578: comm mv: bad entry in directory: inode out of bounds - offset=0(0), inode=65552832, rec_len=4096, name_len=0
Jan 16 12:55:05 kooka kernel: : [2381158.368007] EXT4-fs (dm-18): error count: 11
Jan 16 12:55:05 kooka kernel: : [2381158.368020] EXT4-fs (dm-18): initial error at 1295177566: ext4_mb_generate_buddy:726
Jan 16 12:55:05 kooka kernel: : [2381158.368030] EXT4-fs (dm-18): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
Jan 16 13:05:23 kooka kernel: : [2381775.840005] EXT4-fs (dm-18): error count: 11
Jan 16 13:05:23 kooka kernel: : [2381775.840009] EXT4-fs (dm-18): initial error at 1295177566: ext4_mb_generate_buddy:726
Jan 16 13:05:23 kooka kernel: : [2381775.840012] EXT4-fs (dm-18): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
Jan 16 13:19:47 kooka kernel: : [  364.512007] EXT4-fs (dm-28): error count: 11
Jan 16 13:19:47 kooka kernel: : [  364.512392] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
Jan 16 13:19:47 kooka kernel: : [  364.512776] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
Jan 16 13:42:54 kooka kernel: : [ 1752.032005] EXT4-fs (dm-28): error count: 11
Jan 16 13:42:54 kooka kernel: : [ 1752.032010] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
Jan 16 13:42:54 kooka kernel: : [ 1752.032014] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
Jan 16 14:39:30 kooka kernel: : [ 5147.616006] EXT4-fs (dm-28): error count: 11
Jan 16 14:39:30 kooka kernel: : [ 5147.616888] EXT4-fs (dm-28): initial error at 1295177566: ext4_mb_generate_buddy:726
Jan 16 14:39:30 kooka kernel: : [ 5147.617827] EXT4-fs (dm-28): last error at 1295177566: add_dirent_to_buf:1272: inode 262145: block 1048578
