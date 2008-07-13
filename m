From: Christian Kujau <lists@nerdbynature.de>
Subject: 5% diskspace used for ext4?
Date: Mon, 14 Jul 2008 01:04:20 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0807140054000.4469@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.174]:52195 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYGMXEY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Jul 2008 19:04:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I suspect this being a FAQ already, but I could not find[0] it:
does ext4 really use 5% of available space for internal housekeeping? 
After formatting and mounting a ~917GB partition I see:

# df -h /mnt/bench/
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             917G  200M  871G   1% /mnt/bench

The "200 MB used" would seem more sensible, but the difference between
"available" and "size" is really 46 GB. How comes?

Thanks,
Christian.

[0] http://ext4.wiki.kernel.org/index.php/Frequently_Asked_Questions

PS, a few more details how the filesystem got created and mounted:

# /opt/e2fsprogs/sbin/mkfs.ext4 -V
mke2fs 1.41.0 (10-Jul-2008)
 	Using EXT2FS Library version 1.41.0

# /opt/e2fsprogs/sbin/mkfs.ext4 /dev/sdb1
[...]

# /opt/e2fsprogs/sbin/tune2fs -E test_fs /dev/sdb1 
tune2fs 1.41.0 (10-Jul-2008)
Setting test filesystem flag

# /opt/e2fsprogs/sbin/blkid /dev/sdb1 
/dev/sdb1: UUID="cb2892a3-e42f-47c1-930b-6adab0cf023f" TYPE="ext4dev"

# /opt/e2fsprogs/sbin/tune2fs -l /dev/sdb1 | egrep 'features|flags'
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash test_filesystem

# mount -t ext4dev /dev/sdb1 /mnt/bench
# dmesg | tail
[35021.126539] kjournald2 starting.  Commit interval 5 seconds
[35021.126963] EXT4 FS on sdb1, internal journal
[35021.126963] EXT4-fs: mounted filesystem with ordered data mode.
[35021.126963] EXT4-fs: file extents enabled
[35021.307115] EXT4-fs: mballoc enabled

# grep sdb1 /proc/mounts 
/dev/sdb1 /mnt/bench ext4dev rw,barrier=1,noextents,nomballoc,data=ordered 0 0

-- 
BOFH excuse #398:

Data for intranet got routed through the extranet and landed on the internet.
