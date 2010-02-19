From: James Cloos <cloos@jhcloos.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
Date: Fri, 19 Feb 2010 16:37:30 -0500
Message-ID: <m3wry8nbyl.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	<20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	<21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
To: Dave Airlie <airlied@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from eagle.jhcloos.com ([207.210.242.212]:40407 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0BSViM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Feb 2010 16:38:12 -0500
In-Reply-To: <21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	(Dave Airlie's message of "Sat, 20 Feb 2010 07:02:23 +1000")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Dave" == Dave Airlie <airlied@gmail.com> writes:

Dave> On Thu, Feb 18, 2010 at 6:04 AM, James Cloos <cloos@jhcloos.com> wrote:
>> While getting re-aquainted with perf, and after upgrading to the current
>> version, I see that do_page_fault, unmap_vmas, get_page_from_freelist,
>> handle_mm_fault, __do_fault and T.1339 tend to get the most time when the
>> kernel is spinning.

Dave> We have an AGP related issue with WC/UC paging that might be related,
Dave> but I'd need more info.

OK.  I do use radeon kms (r100).

On a lark, I tried out a non-kms boot this morning, but X never started;
I was going to update all of the user-mode code (dri2, mesa, x, the ati
driver, etc) before tyring again to check whether kms was required to
hit the issue.  That takes a few hours to do on this box.

Dave> dmesg?

The only reelvant part of dmesg are of the form:

Feb 14 01:37:27 [kernel] [ 3720.582130] INFO: task btrfs-transacti:2527 blocked for more than 120 seconds.
Feb 14 01:37:27 [kernel] [ 3720.582140] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Feb 14 01:37:27 [kernel] [ 3720.582149] btrfs-transac D da2ba5b0     0  2527      2 0x00000000
Feb 14 01:37:27 [kernel] [ 3720.582163]  da33af60 00000046 c170f240 da2ba5b0 037a730a 00000343 da2ba854 da2ba5b0
Feb 14 01:37:27 [kernel] [ 3720.582181]  df9557f4 da2ba5b0 df9557f8 da33af84 c152c406 df9557f8 df9557f8 da2ba5b0
Feb 14 01:37:27 [kernel] [ 3720.582199]  ffffffff da212000 da33afa0 da2ba5b0 da33af8c c152bf81 da33afc0 c11b4ecc
Feb 14 01:37:27 [kernel] [ 3720.582216] Call Trace:
Feb 14 01:37:27 [kernel] [ 3720.582241]  [<c152c406>] __mutex_lock_slowpath+0x96/0x120
Feb 14 01:37:27 [kernel] [ 3720.582253]  [<c152bf81>] mutex_lock+0x11/0x20
Feb 14 01:37:27 [kernel] [ 3720.582269]  [<c11b4ecc>] transaction_kthread+0xcc/0x1e0
Feb 14 01:37:27 [kernel] [ 3720.582281]  [<c152b643>] ? preempt_schedule+0x33/0x50
Feb 14 01:37:27 [kernel] [ 3720.582292]  [<c11b4e00>] ? transaction_kthread+0x0/0x1e0
Feb 14 01:37:27 [kernel] [ 3720.582306]  [<c104c684>] kthread+0x74/0x80
Feb 14 01:37:27 [kernel] [ 3720.582316]  [<c104c610>] ? kthread+0x0/0x80
Feb 14 01:37:27 [kernel] [ 3720.582328]  [<c1003356>] kernel_thread_helper+0x6/0x10

Dave>  lspci -vv?

00:00.0 Host bridge: Intel Corporation 82815 815 Chipset Host Bridge and Memory Controller Hub (rev 04)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [88] Vendor Specific Information <?>
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Kernel driver in use: agpgart-intel

00:01.0 PCI bridge: Intel Corporation 82815 815 Chipset AGP Bridge (rev 04) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fc000000-fdffffff
	Prefetchable memory behind bridge: e0000000-e7ffffff
	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=02, subordinate=10, sec-latency=32
	I/O behind bridge: 0000d000-0000ffff
	Memory behind bridge: f2000000-fbffffff
	Prefetchable memory behind bridge: 20000000-27ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:1f.0 ISA bridge: Intel Corporation 82801BAM ISA Bridge (LPC) (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Kernel modules: intel-rng

00:1f.1 IDE interface: Intel Corporation 82801BAM IDE U100 Controller (rev 03) (prog-if 80 [Master])
	Subsystem: Intel Corporation Device 4541
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at bfa0 [size=16]
	Kernel driver in use: ata_piix

00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Device 4541
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 10
	Region 4: I/O ports at bce0 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility M7 LW [Radeon Mobility 7500] (prog-if 00 [VGA controller])
	Subsystem: Dell Radeon Mobility M7 LW (Dell Inspiron 8100)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping+ SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at cc00 [size=256]
	Region 2: Memory at fcff0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at fc000000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
		Status: RQ=48 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x4
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: radeon
	Kernel modules: radeonfb

02:03.0 Multimedia audio controller: ESS Technology ES1983S Maestro-3i PCI Audio Accelerator (rev 10)
	Subsystem: Dell ES1983S Maestro-3i (Dell Inspiron 8100)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 6000ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at dc00 [size=256]
	Region 1: Memory at f6ffe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: Maestro3

02:06.0 PCI bridge: Actiontec Electronics Inc Mini-PCI bridge (rev 11) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Bus: primary=02, secondary=08, subordinate=08, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: f8000000-f9ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [90] CompactPCI hot-swap <?>

02:0f.0 CardBus bridge: Texas Instruments PCI4451 PC card Cardbus Controller
	Subsystem: Dell PCI4451 PC card CardBus Controller (Inspiron 8100)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f2000000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=09, subordinate=0c, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 28000000-2bfff000
	I/O window 0: 0000d000-0000d0ff
	I/O window 1: 0000d400-0000d4ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

02:0f.1 CardBus bridge: Texas Instruments PCI4451 PC card Cardbus Controller
	Subsystem: Dell PCI4451 PC card CardBus Controller (Inspiron 8100)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 168, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f2001000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=02, secondary=0d, subordinate=10, sec-latency=176
	Memory window 0: 24000000-27fff000 (prefetchable)
	Memory window 1: 2c000000-2ffff000
	I/O window 0: 0000d800-0000d8ff
	I/O window 1: 0000f000-0000f0ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt- PostWrite+
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus

02:0f.2 FireWire (IEEE 1394): Texas Instruments PCI4451 IEEE-1394 Controller (prog-if 10 [OHCI])
	Subsystem: Dell PCI4451 IEEE-1394 Controller (Dell Inspiron 8100)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f6ffd800 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at f6ff8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: firewire_ohci

08:04.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev 08)
	Subsystem: Actiontec Electronics Inc EtherExpress PRO/100B (TX) (MiniPCI Ethernet+Modem)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f8fff000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at ecc0 [size=64]
	Region 2: Memory at f8e00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at f9000000 [disabled] [size=1M]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
	Kernel driver in use: e100

08:08.0 Communication controller: Agere Systems WinModem 56k (rev 01)
	Subsystem: Actiontec Electronics Inc LT WinModem 56k (MiniPCI Ethernet+Modem)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (63000ns min, 3500ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f8ffec00 (32-bit, non-prefetchable) [size=256]
	Region 1: I/O ports at ecb8 [size=8]
	Region 2: I/O ports at e800 [size=256]
	Capabilities: [f8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-

0d:00.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 22, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 1: Memory at 2c000800 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at d880 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

0d:00.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 62) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 22, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 1: Memory at 2c000900 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at d8a0 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd

0d:00.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65) (prog-if 20 [EHCI])
	Subsystem: VIA Technologies, Inc. USB 2.0
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 22, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at 2c000a00 (32-bit, non-prefetchable) [size=256]
	Region 1: Memory at 2c000b00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

0d:00.3 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev 80) (prog-if 10 [OHCI])
	Subsystem: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at 2c000000 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at d800 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: firewire_ohci

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
