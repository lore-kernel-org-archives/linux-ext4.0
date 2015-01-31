From: spamerx <spamerx@wp.pl>
Subject: ext4: protection against hardware failure - device size has changed
 for usb SD card and cannot fix filesystem afterwards
Date: Sat, 31 Jan 2015 14:07:55 +0100
Message-ID: <54CCD3AB.1010205@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:21441 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbbAaNOi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 31 Jan 2015 08:14:38 -0500
Received: from 89-68-73-139.dynamic.chello.pl (HELO [192.168.0.11]) (spamerx@[89.68.73.139])
          (envelope-sender <spamerx@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-SHA encrypted SMTP
          for <linux-ext4@vger.kernel.org>; 31 Jan 2015 14:07:55 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I came accross strange behavior when trying to check my ext4 filesystem.
I'm using 4 GB SD card with my Raspberry and it suddenly crashed. So
when connected with usb reader to another pc I got fancy logs about
device size in logs. First SD card size was detected correctly (3.99GB),
then few connectivity errors occurred, and voila - my SD card reported
1.68 TB capacity. My ext4 partition is sdg2 - whole log is related to
detecting the same sd card below:

Jan 27 18:35:23 byziek kernel: [   56.121960] scsi 10:0:0:0:
Direct-Access     ChipsBnk SD/MMCReader     4080 PQ: 0 ANSI: 2
Jan 27 18:35:23 byziek kernel: [   56.126827] sd 10:0:0:0: Attached scsi
generic sg7 type 0
Jan 27 18:35:23 byziek kernel: [   56.128453] sd 10:0:0:0: [sdg] 7806976
512-byte logical blocks: (3.99 GB/3.72 GiB)
Jan 27 18:35:23 byziek kernel: [   56.129847] sd 10:0:0:0: [sdg] Write
Protect is off
Jan 27 18:35:23 byziek kernel: [   56.129854] sd 10:0:0:0: [sdg] Mode
Sense: 0b 00 00 08
Jan 27 18:35:23 byziek kernel: [   56.131308] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:23 byziek kernel: [   56.131316] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:23 byziek kernel: [   56.135815] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:23 byziek kernel: [   56.135820] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:23 byziek kernel: [   56.137194]  sdg: sdg1 sdg2
Jan 27 18:35:23 byziek kernel: [   56.140837] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:23 byziek kernel: [   56.140845] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:23 byziek kernel: [   56.140849] sd 10:0:0:0: [sdg]
Attached SCSI removable disk
Jan 27 18:35:33 byziek kernel: [   66.461566] sd 10:0:0:0: [sdg] Media
Changed
Jan 27 18:35:33 byziek kernel: [   66.461572] sd 10:0:0:0: [sdg] 
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 27 18:35:33 byziek kernel: [   66.461577] sd 10:0:0:0: [sdg]  Sense
Key : Unit Attention [current]
Jan 27 18:35:33 byziek kernel: [   66.461582] sd 10:0:0:0: [sdg]  Add.
Sense: Not ready to ready change, medium may have changed
Jan 27 18:35:33 byziek kernel: [   66.461589] sd 10:0:0:0: [sdg] CDB:
Read(10): 28 00 00 76 4e f8 00 00 08 00
Jan 27 18:35:33 byziek kernel: [   66.461599] end_request: I/O error,
dev sdg, sector 7753464
Jan 27 18:35:33 byziek kernel: [   66.461605] Buffer I/O error on device
sdg2, logical block 950239
Jan 27 18:35:44 byziek kernel: [   76.645575] sd 10:0:0:0: [sdg] Media
Changed
Jan 27 18:35:44 byziek kernel: [   76.645581] sd 10:0:0:0: [sdg] 
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 27 18:35:44 byziek kernel: [   76.645586] sd 10:0:0:0: [sdg]  Sense
Key : Unit Attention [current]
Jan 27 18:35:44 byziek kernel: [   76.645591] sd 10:0:0:0: [sdg]  Add.
Sense: Not ready to ready change, medium may have changed
Jan 27 18:35:44 byziek kernel: [   76.645598] sd 10:0:0:0: [sdg] CDB:
Read(10): 28 00 00 00 18 b8 00 00 08 00
Jan 27 18:35:44 byziek kernel: [   76.645608] end_request: I/O error,
dev sdg, sector 6328
Jan 27 18:35:44 byziek kernel: [   76.645614] Buffer I/O error on device
sdg1, logical block 279
Jan 27 18:35:44 byziek kernel: [   76.647314] sd 10:0:0:0: [sdg]
3288073216 512-byte logical blocks: (1.68 TB/1.53 TiB)
Jan 27 18:35:44 byziek kernel: [   76.654827] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:44 byziek kernel: [   76.654835] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:44 byziek kernel: [   76.746816] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:44 byziek kernel: [   76.746822] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:44 byziek kernel: [   76.747709]  sdg: sdg1 sdg2
Jan 27 18:35:46 byziek kernel: [   78.525565] sd 10:0:0:0: [sdg] Media
Changed
Jan 27 18:35:46 byziek kernel: [   78.525571] sd 10:0:0:0: [sdg] 
Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jan 27 18:35:46 byziek kernel: [   78.525576] sd 10:0:0:0: [sdg]  Sense
Key : Unit Attention [current]
Jan 27 18:35:46 byziek kernel: [   78.525582] sd 10:0:0:0: [sdg]  Add.
Sense: Not ready to ready change, medium may have changed
Jan 27 18:35:46 byziek kernel: [   78.525589] sd 10:0:0:0: [sdg] CDB:
Read(10): 28 00 c3 fc 03 80 00 00 08 00
Jan 27 18:35:46 byziek kernel: [   78.525598] end_request: I/O error,
dev sdg, sector 3288073088
Jan 27 18:35:46 byziek kernel: [   78.525604] Buffer I/O error on device
sdg, logical block 411009136
Jan 27 18:35:46 byziek kernel: [   78.533318] sd 10:0:0:0: [sdg] 7806976
512-byte logical blocks: (3.99 GB/3.72 GiB)
Jan 27 18:35:46 byziek kernel: [   78.535809] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:46 byziek kernel: [   78.535814] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:46 byziek kernel: [   78.539817] sd 10:0:0:0: [sdg] No
Caching mode page found
Jan 27 18:35:46 byziek kernel: [   78.539822] sd 10:0:0:0: [sdg]
Assuming drive cache: write through
Jan 27 18:35:46 byziek kernel: [   78.540719]  sdg: sdg1 sdg2


As a result some directory entries are pointing to blocks which are out
of disk area. So when I try to fix filesystem with e2fsck i got:

e2fsck 1.42.12 (29-Aug-2014)
Pass 1: Checking inodes, blocks, and sizes
Error reading block 8796093119321 (Invalid argument) while reading
directory block.  Ignore error<y>? no
Error reading block 2147592353 (Invalid argument) while reading
directory block.  Ignore error<y>? no
Error reading block 274878023742 (Invalid argument) while reading
directory block.  Ignore error<y>? no
Error reading block 1073851752 (Invalid argument) while reading
directory block.  Ignore error<y>? no
Error reading block 274877916439 (Invalid argument) while reading
directory block.  Ignore error<y>? no
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

       53701 inodes used (23.57%, out of 227824)
         180 non-contiguous files (0.3%)
          27 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 2/1/1
             Extent depth histogram: 49736/72
      527274 blocks used (55.49%, out of 950272)
           0 bad blocks
         100 large files

       40265 regular files
        6741 directories
          61 character device files
          25 block device files
           1 fifo
       16928 links
        6580 symbolic links (3777 fast symbolic links)
          19 sockets

Block numbers are insane for 4GB filesystem, and e2fsck is unable to fix
them. Currently working on image copied from SD card to hard disk. While
trying to fix image with older fsck (1.42.4) image has grown from 4GB to
~1000GB.


Any hint how to approach such problem? e2fsck without force-ing treats
this filesystem as clean:
rpi_sdg2: clean, 53701/227824 files, 527274/950272 blocks

Martin




