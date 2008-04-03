From: Paul Slootman <paul@wurtel.net>
Subject: #blocks per group too big: 37265
Date: Thu, 3 Apr 2008 18:19:04 +0200
Message-ID: <20080403161904.GA31670@msgid.wurtel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lw.wurtel.net ([82.192.92.211]:1409 "EHLO lw.wurtel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbYDCQeo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Apr 2008 12:34:44 -0400
Received: from wurtel.local ([192.168.1.1]:58272 helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <paul@wurtel.net>)
	id 1JhS9c-0002vF-HX
	for linux-ext4@vger.kernel.org; Thu, 03 Apr 2008 18:19:08 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.69)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1JhS9Y-00006n-M2
	for linux-ext4@vger.kernel.org; Thu, 03 Apr 2008 18:19:04 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I wanted to try out ext4 on my shiny new 9+TB RAID5 device
(11 x 1TB disks in md raid5).

I obtained the 1.39-tyt3 version of e2fsprogs, and did:

./mkfs.ext3 -j -m 0 -N 1000000000 -O dir_index,filetype,resize_inode -E stride=65536,resize=5120000000 -J device=/dev/mapper/vg11-md15--journal -L data2 /dev/md15

(If using a separate device for the journal is inadvisable, please let
me know; this is on a different set of spindles that md15 is running on.)

The stride was calculated from the 64k chunk of the raid5 device.
Mainly a guess, as I couldn't find any clear reference on how to plug in
the values to fill this in.

Anyway, that did:

| mke2fs 1.38 (30-Jun-2005)
| Filesystem label=data2
| OS type: Linux
| Block size=4096 (log=2)
| Fragment size=4096 (log=2)
| 1000204128 inodes, 2441859680 blocks
| 0 blocks (0.00%) reserved for the super user
| First data block=0
| Maximum filesystem blocks=5485408000
| 65527 block groups
| 37265 blocks per group, 37265 fragments per group
| 15264 inodes per group
| Superblock backups stored on blocks: 
|     37265, 111795, 186325, 260855, 335385, 931625, 1006155, 1825985, 
|     3018465, 4658125, 9055395, 12781895, 23290625, 27166185, 81498555, 
|     89473265, 116453125, 244495665, 582265625, 626312855, 733486995, 
|     2200460985
| 
| Writing inode tables: done                            
| Adding journal to device /dev/mapper/vg11-md15--journal: done
| Writing superblocks and filesystem accounting information: done
| 
| This filesystem will be automatically checked every 27 mounts or
| 180 days, whichever comes first.  Use tune2fs -c or -i to override.


Note the "37265 blocks per group".
Trying to mount this (after of course "tune2fs -E test_fs /dev/md15",
which BTW didn't work with the 1.39-tyt3 version) gave a kernel error:

| EXT4-fs: #blocks per group too big: 37265

I then tried adding "-g 16384" to the mkfs.ext3 invocation, but that
apparently got ignored and still showed "37265 blocks per group".
Removing the stride option didn't help. Removing all options didn't
help...

Is it impossible to create ext4 on such a device? I must be overlooking
something... the Documentation/filesystems/ext4.txt file doesn't help
(2.6.25-rc8).


thanks,
Paul Slootman
