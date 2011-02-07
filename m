From: bryan.coleman@dart.biz
Subject: ext4 problems with external RAID array via SAS connection
Date: Mon, 7 Feb 2011 13:53:18 -0500
Message-ID: <OFFAEBAC93.6731CA9F-ON85257830.0067BABF-85257830.0067C1CB@dart.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from comns1.dartcontainer.com ([173.241.223.201]:4257 "EHLO
	MAS-NS06.dartcontainer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab1BGSxU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Feb 2011 13:53:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I am experiencing problems with an ext4 file system.

At first, the drive seemed to work fine.  I was primarily copying things 
to the drive migrating data from another server.  After many GBs of data, 
that seemingly successfully were done being transferred, I started seeing 
ext4 errors in /var/log/messages.  I then unmounted the drive and ran fsck 
on it (which took multiple hours to run).  I then ls'ed around and one of 
the areas caused the system to again throw ext4 errors.

I did run memtest through one complete pass and it found no problems.

I then went looking for help on the fedora forum and it was suggested that 
I increase my journal size.  So I recreated the ext4 partition (with 
larger journal) and started the migration process again.  After several 
days of copying, the errors started again.


Here are some of the errors from /var/log/messages:

Feb 2 04:48:30 mdct-00fs kernel: [672021.519914] EXT4-fs error (device 
dm-2): ext4_mb_generate_buddy: EXT4-fs: group 22307: 460 blocks in bitmap, 
0 in gd
Feb 2 04:48:30 mdct-00fs kernel: [672021.520429] EXT4-fs error (device 
dm-2): ext4_mb_generate_buddy: EXT4-fs: group 22308: 1339 blocks in 
bitmap, 0 in gd
Feb 2 04:48:30 mdct-00fs kernel: [672021.520927] EXT4-fs error (device 
dm-2): ext4_mb_generate_buddy: EXT4-fs: group 22309: 3204 blocks in 
bitmap, 0 in gd
Feb 2 04:48:30 mdct-00fs kernel: [672021.521409] EXT4-fs error (device 
dm-2): ext4_mb_generate_buddy: EXT4-fs: group 22310: 2117 blocks in 
bitmap, 0 in gd
Feb 4 05:08:29 mdct-00fs kernel: [845547.724807] EXT4-fs error (device 
dm-2): ext4_dx_find_entry: inode #311951364: (comm scp) bad entry in 
directory: directory entry across blocks - 
block=1257308156offset=0(9166848), inode=3143403788, rec_len=80864, 
name_len=168
Feb 4 05:08:29 mdct-00fs kernel: [845547.733034] EXT4-fs error (device 
dm-2): ext4_add_entry: inode #311951364: (comm scp) bad entry in 
directory: directory entry across blocks - block=1257308156offset=0(0), 
inode=3143403788, rec_len=80864, name_len=168
Feb 4 05:19:41 mdct-00fs kernel: [846217.922351] EXT4-fs error (device 
dm-2): ext4_dx_find_entry: inode #311951364: (comm scp) bad entry in 
directory: directory entry across blocks - 
block=1257308156offset=0(9166848), inode=3143403788, rec_len=80864, 
name_len=168
Feb 4 05:19:41 mdct-00fs kernel: [846217.928922] EXT4-fs error (device 
dm-2): ext4_add_entry: inode #311951364: (comm scp) bad entry in 
directory: directory entry across blocks - block=1257308156offset=0(0), 
inode=3143403788, rec_len=80864, name_len=168 


Here is my setup:

        Promise Vtrak RAID array with 12 drives in a RAID 6 configuration 
(over 5TB).
        The promise array is connected to my server using a external SAS 
connection.
        OS: Fedora 14
 
        One logical volume on the promise.
        One logical volume at the external SAS level.
        One logical volume at the OS level.
        So from my OS, I see one logical volume depicting one big drive.

        I then setup the ext4 system using the following command: 
'mkfs.ext4 -v -m 1 -J size=1024 -E stride=16,stripe-width=160 
/dev/vg_storage/lv_storage'


Any thoughts/tips on how to track down the problem?

My thought now is to try using ext3; however, my fear is that I will just 
run into the problem with it.  Is ext4 production ready?


Thoughts?
