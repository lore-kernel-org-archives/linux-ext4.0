From: luvar@plaintext.sk
Subject: Re: ext4 unknown problem
Date: Tue, 31 Jul 2012 08:18:42 +0100 (GMT+01:00)
Message-ID: <1343355595.179511343719122536.JavaMail.root@shiva>
References: <613523755.179491343719039762.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([81.0.124.6]:47412 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab2GaHSt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jul 2012 03:18:49 -0400
In-Reply-To: <613523755.179491343719039762.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
dmesg is probably useles:

Probably some logs after mounting...:

# dmesg | grep EXT
EXT3-fs (md2): mounted filesystem with ordered data mode
EXT3-fs (md2): using internal journal
EXT3-fs (dm-2): using internal journal
EXT3-fs (dm-2): mounted filesystem with ordered data mode
EXT4-fs (dm-8): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts: (null)
EXT4-fs (dm-12): mounted filesystem without journal. Opts: (null)
EXT4-fs (dm-8): re-mounted. Opts: commit=0
EXT4-fs (dm-3): re-mounted. Opts: commit=0
EXT4-fs (dm-12): re-mounted. Opts: commit=0
EXT4-fs (dm-28): mounted filesystem with ordered data mode. Opts: (null)
EXT3-fs (dm-10): using internal journal
EXT3-fs (dm-10): mounted filesystem with ordered data mode

On last few lines, there is some info about usb key used on thic pc:

# dmesg | tail -n 30
sd 14:0:0:0: [sdg] Asking for cache data failed
sd 14:0:0:0: [sdg] Assuming drive cache: write through
 sdg: sdg1
sd 14:0:0:0: [sdg] Asking for cache data failed
sd 14:0:0:0: [sdg] Assuming drive cache: write through
sd 14:0:0:0: [sdg] Attached SCSI disk
mdadm: sending ioctl 1261 to a partition!
mdadm: sending ioctl 1261 to a partition!
usb 2-4.4: USB disconnect, device number 10
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
usb 1-1: new high-speed USB device number 2 using ehci_hcd
usb 1-1: New USB device found, idVendor=0951, idProduct=1687
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: DT R400
usb 1-1: Manufacturer: Kingston
usb 1-1: SerialNumber: 0018F30C7FX10B000XX029
scsi15 : usb-storage 1-1:1.0
scsi 15:0:0:0: Direct-Access     Kingston DT R400          PMAP PQ: 0 ANSI: 0 CCS
sd 15:0:0:0: Attached scsi generic sg6 type 0
sd 15:0:0:0: [sdg] 7774208 512-byte logical blocks: (3.98 GB/3.70 GiB)
sd 15:0:0:0: [sdg] Write Protect is off
sd 15:0:0:0: [sdg] Mode Sense: 23 00 00 00
sd 15:0:0:0: [sdg] No Caching mode page present
sd 15:0:0:0: [sdg] Assuming drive cache: write through
sd 15:0:0:0: [sdg] No Caching mode page present
sd 15:0:0:0: [sdg] Assuming drive cache: write through
 sdg: sdg1 sdg2
sd 15:0:0:0: [sdg] No Caching mode page present
sd 15:0:0:0: [sdg] Assuming drive cache: write through
sd 15:0:0:0: [sdg] Attached SCSI removable disk

Other lines from dmesg seems not relevant. Should I post them too?

PS: Writing to disk from jbd2/dm-3-8 still active (iotop shows it still on top of I/O activity).

LuVar

----- "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Mon, Jul 30, 2012 at 08:26:20PM +0100, LuVar wrote:
> > Hi,
> > I have seriouse issue here. I have copyied about 7GB files to one of
> my ext4 partitions and from that point of time there is sustained
> write to that partition from jbd2/dm-3-8 process. I have lunched "sudo
> sync" command (about day ago :) and a few hours a after sync start, I
> have tryied to use umount on that partition... Booth of them are still
> running...
> > 
> > I have no serious data there, but if I could be helpfull in
> bugreport, give me some info what to do.
> 
> Try running the dmesg command, and see if there's anything
> interesting
> there.  If you're not sure if it's interesting, send it to us and we
> can take a quick look at it.
> 
> Regards,
> 
> 					- Ted
