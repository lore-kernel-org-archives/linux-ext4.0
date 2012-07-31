From: "Nelson, John R" <John_Nelson@student.uml.edu>
Subject: Serious bug?
Date: Tue, 31 Jul 2012 02:17:03 +0000
Message-ID: <0408C81F72528E40A0D3235A1F67FFC804A61E@SN2PRD0202MB144.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:52314
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2GaCRI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Jul 2012 22:17:08 -0400
Received: from mail24-db3 (localhost [127.0.0.1])	by mail24-db3-R.bigfish.com
 (Postfix) with ESMTP id C46A41C0229	for <linux-ext4@vger.kernel.org>; Tue, 31
 Jul 2012 02:17:06 +0000 (UTC)
Received: from DB3EHSMHS003.bigfish.com (unknown [10.3.81.238])	by
 mail24-db3.bigfish.com (Postfix) with ESMTP id 85A411E0048	for
 <linux-ext4@vger.kernel.org>; Tue, 31 Jul 2012 02:17:05 +0000 (UTC)
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
 I created a big 400GB file image and formatted it with mkfs.ext4. the format failed with

Warning: could not erase sector 2: Attempt to write block to filesystem resulted in short write
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
26214400 inodes, 104857600 blocks
5242880 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
3200 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
        102400000

Allocating group tables: done                            
Warning: could not read block 0: Attempt to read block from filesystem resulted in short read
Warning: could not erase sector 0: Attempt to write block to filesystem resulted in short write
mkfs.ext4: Attempt to write block to filesystem resulted in short write while zeroing block 104857584 at end of filesystem
Writing inode tables: done                            
Creating journal (32768 blocks): mkfs.ext4: Attempt to write block to filesystem resulted in short write 
        while trying to create journal
john@john-K53E:~$ 

i then checked my dmesg and found error on my sda3 partition
[  119.578077] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 53, depth: 2 pblock 0
[  119.578209] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 54, depth: 2 pblock 0
[  119.578340] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 55, depth: 2 pblock 0
[  119.578449] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 56, depth: 2 pblock 0
[  119.578569] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 57, depth: 2 pblock 0
[  119.578695] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 58, depth: 2 pblock 0
[  119.578827] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 59, depth: 2 pblock 0
[  119.578958] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 60, depth: 2 pblock 0
[  119.579090] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 61, depth: 2 pblock 0
[  119.579221] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 62, depth: 2 pblock 0
[  119.579330] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 63, depth: 2 pblock 0
[  119.579450] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 64, depth: 2 pblock 0
[  119.579576] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 65, depth: 2 pblock 0
[  119.579708] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 66, depth: 2 pblock 0
[  119.579844] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 67, depth: 2 pblock 0
[  119.579977] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 68, depth: 2 pblock 0
[  119.580106] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 69, depth: 2 pblock 0
[  119.580214] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 70, depth: 2 pblock 0
[  119.580332] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 71, depth: 2 pblock 0
[  119.580458] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 72, depth: 2 pblock 0
[  119.580590] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 73, depth: 2 pblock 0
[  119.580731] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 74, depth: 2 pblock 0
[  119.580854] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 75, depth: 2 pblock 0
[  119.580985] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 76, depth: 2 pblock 0
[  119.581116] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 77, depth: 2 pblock 0
[  119.581227] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 78, depth: 2 pblock 0
[  119.581347] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 79, depth: 2 pblock 0
[  119.581473] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 80, depth: 2 pblock 0
[  119.581604] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 81, depth: 2 pblock 0
[  119.581735] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 82, depth: 2 pblock 0
[  119.581844] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 83, depth: 2 pblock 0
[  119.581964] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 84, depth: 2 pblock 0
[  119.582091] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 85, depth: 2 pblock 0
[  119.582222] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 86, depth: 2 pblock 0
[  119.582354] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 87, depth: 2 pblock 0
[  119.582494] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 88, depth: 2 pblock 0
[  119.582594] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 89, depth: 2 pblock 0
[  119.582715] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 90, depth: 2 pblock 0
[  119.582886] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 91, depth: 2 pblock 0
[  119.582986] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 92, depth: 2 pblock 0
[  119.583108] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 93, depth: 2 pblock 0
[  119.583238] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 94, depth: 2 pblock 0
[  119.583368] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 95, depth: 2 pblock 0
[  119.583561] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 96, depth: 2 pblock 0
[  119.583651] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 97, depth: 2 pblock 0
[  119.583802] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 98, depth: 2 pblock 0
[  119.584024] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 99, depth: 2 pblock 0
[  119.584127] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 100, depth: 2 pblock 0
[  119.584252] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 101, depth: 2 pblock 0
[  119.584382] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 102, depth: 2 pblock 0
[  119.584511] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 103, depth: 2 pblock 0
[  119.584620] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 104, depth: 2 pblock 0
[  119.584740] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 105, depth: 2 pblock 0
[  119.584867] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 106, depth: 2 pblock 0
[  119.584998] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 107, depth: 2 pblock 0
[  119.585130] EXT4-fs error (device sda3): ext4_ext_map_blocks:3769: inode #32243725: comm mkfs.ext4: bad extent address lblock: 108, depth: 2 pblock 0

i deleted the image and rebooted and fsck was forced, but i didnt find any errors. But im not sure why this is happening. and please note this. the iblock in my log continues all the way down to 924.

John Nelson
