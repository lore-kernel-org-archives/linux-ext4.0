From: coly <colyli@gmail.com>
Subject: [RFC 4/5] inode reservation v0.1 (benchmark result)
Date: Thu, 24 May 2007 02:08:17 +0800
Message-ID: <1179943697.4179.55.camel@coly-t43.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Current patch avoids inodes from different directories mixed together in
the inode table. Therefore the benchmakr emulate a situation that mixes
inodes of different sub-directories together. and record the time on
removing them all.

In the first part, reserving 16 inodes for each new created directory.
Therefore 14 files can only use 1 reserved block for each directory in
inode table, obviously, the result of benchmark is the best case :-)

Enviornment:
1) create 9890 directory, create files in each directory alternatively
2) kernel version 2.6.20-mm, the ext4 subdir-inode-reservation is
patched based on 2.6.20-mm
3) 14 files in each subdirectory. 9890 sub directories in
mount_point/mailbox/
4) mount with option data=writeback
5) each operation followed by a reboot
6) EXT4_INIT_RESERVE_INODES = 16

===================== data=writeback ================================
remove directories and files by rm -rf:
* ext3
read 16m56.979s
user 0m0.156s
sys 0m21.449s

* ext4org
real 18m38.809s
user 0m0.636s
sys 0m37.422s

* ext4inores
real 7m57.437s
user 0m0.452s
sys 0m34.698s


===================== data=ordered ================================
remove directories and files by rm -rf:
* ext3
real 17m23.435s
user 0m0.140s
sys 0m21.709s

* ext4org
real 17m39.515s
user 0m0.120s
sys 0.22.097s

* ext4inores
real 7m41.365s
user 0m0.196s
sys 0m24.210s

===================== data=journal ================================
remove directories and files by rm -rf:
* ext3
real 12m50.545s
user 0m0.152s
sys 0m22.725s

* ext4org
real 13m43.910s
user 0m0.196s
sys 0m23.161s

* ext4inores
real 7m49.915s
user 0m0.168s
sys 0m23.633s


Due to the bad design of magic inode and the on-disk layout of magic
inode. When 30 files created alternatively in each directory, no
performance advantage exists. When 50 files created alternatively in
each directory, the patched ext4 will use double time on removing all
the files and directories.

Therefore, in the next version a new on-disk layout will be used.

