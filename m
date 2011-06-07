From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Subject: Re: Oops fs/ext4/inode.c:2188
Date: Tue, 07 Jun 2011 09:01:00 +0200
Message-ID: <4DEDCCAC.9040600@odi.ch>
References: <4DEBD1B4.3000307@odi.ch> <20110605224731.GD1001@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050908030405090805030701"
To: Ted Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fep12.mx.upcmail.net ([62.179.121.32]:52970 "EHLO
	fep12.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1FGHBM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 03:01:12 -0400
In-Reply-To: <20110605224731.GD1001@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050908030405090805030701
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



On 06/06/2011 12:47 AM, Ted Ts'o wrote:
> Were there any messages in the syslog before this relating to ext4 or
> jbd2?
> 
>> Jun  5 20:34:12 box kernel: JBD2: Detected IO errors while flushing file
>> data on sdc1-8
>> Jun  5 20:34:12 box kernel: Aborting journal on device sdc1-8.
>> Jun  5 20:34:12 box kernel: JBD2: I/O error detected when updating
>> journal superblock for sdc1-8.
> 
> For example, anything like these messages *before* the oops messages?
> 
>     	     	      	   	 	  	       - Ted

Of course. I am attaching all relevant log.

The box had a USB disk attached. Unfortunately the USB code detected
only a slow link:
Jun  3 08:36:26 box kernel: usb 2-1: not running at top speed; connect
to a high speed hub

A job was still copying a large file when I disconnected the disk
accidentially two hours later. Of course ext4 didn't like that. But
clearly the Oops should not have happened.

Thanks.

Ortwin

--------------050908030405090805030701
Content-Type: text/plain;
 name="messages"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="messages"

Jun  3 08:36:22 box kernel: usb 1-1: new high speed USB device using ehci_hcd and address 9
Jun  3 08:36:25 box kernel: hub 1-0:1.0: unable to enumerate USB device on port 1
Jun  3 08:36:26 box kernel: usb 2-1: new full speed USB device using uhci_hcd and address 3
Jun  3 08:36:26 box kernel: usb 2-1: not running at top speed; connect to a high speed hub
Jun  3 08:36:26 box kernel: usb 2-1: New USB device found, idVendor=04fc, idProduct=0c25
Jun  3 08:36:26 box kernel: usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
Jun  3 08:36:26 box kernel: usb 2-1: Product: USB to Serial-ATA bridge
Jun  3 08:36:26 box kernel: usb 2-1: Manufacturer: Sunplus Technology Inc.
Jun  3 08:36:26 box kernel: usb 2-1: SerialNumber: Hitachi HT090305PB0300QKG2MVAA
Jun  3 08:36:26 box kernel: scsi7 : usb-storage 2-1:1.0
Jun  3 08:36:27 box kernel: scsi 7:0:0:0: Direct-Access     Hitachi  HTS545032B9A300       PQ: 0 ANSI: 2
Jun  3 08:36:27 box kernel: sd 7:0:0:0: Attached scsi generic sg3 type 0
Jun  3 08:36:27 box kernel: sd 7:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
Jun  3 08:36:27 box kernel: sd 7:0:0:0: [sdc] Write Protect is off
Jun  3 08:36:27 box kernel: sd 7:0:0:0: [sdc] Mode Sense: 38 00 00 00
Jun  3 08:36:27 box kernel: sd 7:0:0:0: [sdc] Assuming drive cache: write through
Jun  3 08:36:27 box kernel: sd 7:0:0:0: [sdc] Assuming drive cache: write through
Jun  3 08:36:28 box kernel: sdc: sdc1
Jun  3 08:36:28 box kernel: sd 7:0:0:0: [sdc] Assuming drive cache: write through
Jun  3 08:36:28 box kernel: sd 7:0:0:0: [sdc] Attached SCSI disk
Jun  5 18:44:06 box kernel: EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
Jun  5 20:34:11 box kernel: usb 2-1: USB disconnect, address 3
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc] Unhandled error code
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc] CDB: Write(10): 2a 00 14 e6 d6 1f 00 00 f0 00
Jun  5 20:34:11 box kernel: end_request: I/O error, dev sdc, sector 350672415
Jun  5 20:34:11 box kernel: quiet_error: 50 callbacks suppressed
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834044
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834045
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834046
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834047
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834048
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834049
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834050
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834051
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834052
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: Buffer I/O error on device sdc1, logical block 43834053
Jun  5 20:34:11 box kernel: lost page write due to I/O error on sdc1
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc] Unhandled error code
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc]  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jun  5 20:34:11 box kernel: sd 7:0:0:0: [sdc] CDB: Write(10): 2a 00 14 e6 d7 0f 00 00 f0 00
Jun  5 20:34:11 box kernel: end_request: I/O error, dev sdc, sector 350672655
Jun  5 20:34:11 box kernel: EXT4-fs (sdc1): delayed block allocation failed for inode 21 at logical offset 1787904 with max blocks 2048 with error -5
Jun  5 20:34:11 box kernel: EXT4-fs (sdc1): This should not happen!! Data will be lost
Jun  5 20:34:11 box kernel: 
Jun  5 20:34:11 box kernel: EXT4-fs (sdc1): delayed block allocation failed for inode 21 at logical offset 1787904 with max blocks 2048 with error -5
Jun  5 20:34:11 box kernel: EXT4-fs (sdc1): This should not happen!! Data will be lost
Jun  5 20:34:11 box kernel: 
Jun  5 20:34:11 box kernel: ------------[ cut here ]------------
Jun  5 20:34:11 box kernel: kernel BUG at fs/ext4/inode.c:2188!
Jun  5 20:34:11 box kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jun  5 20:34:11 box kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/host7/target7:0:0/7:0:0:0/block/sdc/dev
Jun  5 20:34:11 box kernel: Modules linked in:
Jun  5 20:34:11 box kernel: 
Jun  5 20:34:11 box kernel: Pid: 13696, comm: flush-8:32 Not tainted 2.6.38.7 #2 To Be Filled By O.E.M. To Be Filled By O.E.M./P4P800
Jun  5 20:34:12 box kernel: EIP: 0060:[<c1106622>] EFLAGS: 00010246 CPU: 1
Jun  5 20:34:12 box kernel: EIP is at mpage_da_map_and_submit+0x56c/0x5ba
Jun  5 20:34:12 box kernel: EAX: 40000024 EBX: dfe17e00 ECX: 0000000e EDX: 00000000
Jun  5 20:34:12 box kernel: ESI: 001b4800 EDI: 001b4fff EBP: c1dafd4c ESP: c1dafcb0
Jun  5 20:34:12 box kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jun  5 20:34:12 box kernel: Process flush-8:32 (pid: 13696, ti=c1dae000 task=df2a0f40 task.ti=c1dae000)
Jun  5 20:34:12 box kernel: Stack:
Jun  5 20:34:12 box kernel: 0000000e c14898ca c1494b28 00000015 001b4800 00000000 00000800 fffffffb
Jun  5 20:34:12 box kernel: 0000000c 00000000 001b500a 00000000 dedfe390 0000000e 00000000 0000000e
Jun  5 20:34:12 box kernel: 00000004 dfe17e00 dfcd8220 dfdbe980 dfd0bc40 dfbed540 dfca32e0 dfe94cc0
Jun  5 20:34:12 box kernel: Call Trace:
Jun  5 20:34:12 box kernel: [<c11066c0>] mpage_add_bh_to_extent+0x50/0xdd
Jun  5 20:34:12 box kernel: [<c110696c>] write_cache_pages_da+0x21f/0x312
Jun  5 20:34:12 box kernel: [<c1106c97>] ext4_da_writepages+0x238/0x45f
Jun  5 20:34:12 box kernel: [<c1070335>] do_writepages+0x17/0x2d
Jun  5 20:34:12 box kernel: [<c10afa73>] writeback_single_inode+0x78/0x1b1
Jun  5 20:34:12 box kernel: [<c10aff7d>] writeback_sb_inodes+0x86/0x118
Jun  5 20:34:12 box kernel: [<c10b0691>] wb_writeback+0x162/0x235
Jun  5 20:34:12 box kernel: [<c107057e>] ? global_dirty_limits+0x23/0xb9
Jun  5 20:34:12 box kernel: [<c10b07c9>] wb_do_writeback+0x65/0x191
Jun  5 20:34:12 box kernel: [<c10b0958>] bdi_writeback_thread+0x63/0x10b
Jun  5 20:34:12 box kernel: [<c10b08f5>] ? bdi_writeback_thread+0x0/0x10b
Jun  5 20:34:12 box kernel: [<c10406a0>] kthread+0x68/0x6a
Jun  5 20:34:12 box kernel: [<c1040638>] ? kthread+0x0/0x6a
Jun  5 20:34:12 box kernel: [<c1002fb6>] kernel_thread_helper+0x6/0x10
Jun  5 20:34:12 box kernel: Code: 24 04 c7 04 24 80 a0 48 c1 e8 f2 42 2d 00 8b 86 08 02 00 00 89 44 24 04 c7 04 24 9e a0 48 c1 e8 dc 42 2d 00 8b 03 e9 64 fd ff ff <0f> 0b eb fe 0f 0b eb fe 89 f0 e8 98 44 ff ff 09 c2 75 07 8b 03 
Jun  5 20:34:12 box kernel: EIP: [<c1106622>] mpage_da_map_and_submit+0x56c/0x5ba SS:ESP 0068:c1dafcb0
Jun  5 20:34:12 box kernel: JBD2: Detected IO errors while flushing file data on sdc1-8
Jun  5 20:34:12 box kernel: Aborting journal on device sdc1-8.
Jun  5 20:34:12 box kernel: JBD2: I/O error detected when updating journal superblock for sdc1-8.
Jun  5 20:34:12 box kernel: ---[ end trace 736424b87d636c31 ]---
Jun  5 20:34:12 box kernel: EXT4-fs error (device sdc1): ext4_journal_start_sb:260: Detected aborted journal
Jun  5 20:34:12 box kernel: EXT4-fs (sdc1): Remounting filesystem read-only
Jun  5 20:34:12 box kernel: EXT4-fs (sdc1): previous I/O error to superblock detected

--------------050908030405090805030701--
