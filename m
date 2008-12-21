From: Norbert Preining <preining@logic.at>
Subject: linux ext3 partition hosed, is this hardware of software error?
Date: Sun, 21 Dec 2008 15:36:40 +0100
Message-ID: <20081221143640.GF1509@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:44570 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbYLUOgm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Dec 2008 09:36:42 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi everyone,

(please cc)

since a few month I have a new Sony laptop and yesterday shutting down
didn't work out, but due to a graphics bug (which I reported already
several times) I couldn't see anything going on (console garbled). After
some time the laptop still flashed madly (which it usually does for some
time before turning off) I decided that something has gone mad, no idea
what. I used Sysrc-s  u  o and went to bed.

THis morning grub didn't boot. Booting from an usb stick did give error
messages, bummer. INterestingly the second partition with ntfs I could
mount from my rescue stick (riplinux), but the third=linux did not work.
Here are the error messages from dmesg:

scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS LV01 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 2:0:0:0: [sda] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sr 3:0:0:0: Attached scsi generic sg1 type 5
scsi8 : pata_legacy
ata7: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
scsi9 : pata_legacy
ata8: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 10
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
sd 10:0:0:0: [sdb] 15794176 512-byte hardware sectors (8087 MB)
sd 10:0:0:0: [sdb] Write Protect is off
sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 10:0:0:0: [sdb] Assuming drive cache: write through
sd 10:0:0:0: [sdb] 15794176 512-byte hardware sectors (8087 MB)
sd 10:0:0:0: [sdb] Write Protect is off
sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 10:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 10:0:0:0: [sdb] Attached SCSI removable disk
sd 10:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:08:28:3d:95/00:00:0a:00:00/40 tag 1 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:00:28:3d:95/00:00:0a:00:00/40 tag 0 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:08:28:3d:95/00:00:0a:00:00/40 tag 1 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:00:28:3d:95/00:00:0a:00:00/40 tag 0 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:08:28:3d:95/00:00:0a:00:00/40 tag 1 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/40:00:28:3d:95/00:00:0a:00:00/40 tag 0 ncq 32768 in
         res 41/40:40:38:3d:95/91:00:0a:00:00/6a Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/100
sd 2:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 2:0:0:0: [sda] Sense Key : 0x3 [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00 
        0a 95 3d 38 
sd 2:0:0:0: [sda] ASC=0x11 ASCQ=0x4
end_request: I/O error, dev sda, sector 177552696
Buffer I/O error on device sda3, logical block 12
Buffer I/O error on device sda3, logical block 13
Buffer I/O error on device sda3, logical block 14
Buffer I/O error on device sda3, logical block 15
Buffer I/O error on device sda3, logical block 16
Buffer I/O error on device sda3, logical block 17
Buffer I/O error on device sda3, logical block 18
Buffer I/O error on device sda3, logical block 19
Buffer I/O error on device sda3, logical block 20
Buffer I/O error on device sda3, logical block 21
ata1: EH complete
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA



I tried fsck, no chance, nothing did work.

Is there any way to get at the stuff on the disk?

Is the disk hosed? Is the controller hosed? Is something else hosed?

Thanks a lot for any suggestion, I am a bit destroyed...

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
BRADWORTHY
One who is skilled in the art of naming loaves.
			--- Douglas Adams, The Meaning of Liff
