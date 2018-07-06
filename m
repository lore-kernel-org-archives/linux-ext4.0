From: dann frazier <dann.frazier@canonical.com>
Subject: [Bisect] ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt
 inode bitmap
Date: Fri, 6 Jul 2018 11:43:24 -0600
Message-ID: <20180706174324.GA3049@xps13.dannf>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, yanaijie@huawei.com,
        colin.king@canonical.com, kamal.mostafa@canonical.com,
        ike.pan@canonical.com
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
  We're seeing a regression triggered by the stress-ng[*] "chdir" test
that I've bisected to:

044e6e3d74a3 ext4: don't update checksum of new initialized bitmaps

So far we've only seen failures on servers based on HiSilicon's family
of ARM64 SoCs (D05/Hi1616 SoC, D06/Hi1620 SoC). On these systems it is
very reproducible.

= Test Case =
#!/bin/sh
umount /tmp/mnt || /bin/true
mkdir -p /tmp/mnt
mkfs.ext4 -F /dev/sda1
mount /dev/sda1 /tmp/mnt
# Running directly under /tmp/mnt doesn't trigger the issue, we need
# this subdirectory for some reason
dir="/tmp/mnt/tmp/disk_stress_ng_f70f0f26-b332-4c48-9e07-67c529770e3d"
mkdir -p "$dir"
stress-ng --aggressive --verify --timeout 240 --temp-path "$dir" \
	  --chdir 0 --hdd-opts dsync --readahead-bytes 16M -k

= Result =
[70586.263840] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[70586.637085] EXT4-fs error (device sda1): ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt inode bitmap - block_group = 43936, inode_bitmap = 1439694864
[70602.296551] EXT4-fs error (device sda1): ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt inode bitmap - block_group = 48896, inode_bitmap = 1602224144
[70602.409291] EXT4-fs error (device sda1): ext4_validate_inode_bitmap:98: comm stress-ng: Corrupt inode bitmap - block_group = 48928, inode_bitmap = 1603272720

Full dmesg:
  http://people.canonical.com/~dannf/d05-stress-ng/d05-sas-chdir-4.18.0-rc3+.dmesg

[*] http://kernel.ubuntu.com/~cking/stress-ng/
