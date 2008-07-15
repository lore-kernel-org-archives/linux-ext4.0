From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Tue, 15 Jul 2008 06:43:21 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0807150608020.31651@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de>
 <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu>
 <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de>
 <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker>
 <20080710092517.GB16451@skywalker> <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de>
 <20080711124304.GB8154@mit.edu> <Pine.LNX.4.64.0807141938250.28835@diagnostix.dwd.de>
 <20080714202813.GC3382@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:42364 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbYGOGnZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 02:43:25 -0400
In-Reply-To: <20080714202813.GC3382@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 14 Jul 2008, Theodore Tso wrote:

> On Mon, Jul 14, 2008 at 07:55:10PM +0000, Holger Kiehl wrote:
>> You are right. I did compare the .config of both and noticed that
>> CONFIG_FAIR_GROUP_SCHED was set in the rc9 test but not in rc8 test.
>> Doing the test without CONFIG_FAIR_GROUP_SCHED gave me back 6%.
>> Sorry.
>
> You may have told us already, but can you tell me the full
> configuration of your benchmark machine?  (i.e., how many CPU's, how
> much memory, etc.)  Also, what are the current mount options you are
> currently using?  And have you redone the ext3 benchmark number with
> barriers enabled?  Or was that the original number done with default
> mount options that leave barriers disabled?
>
System has 4 Opteron 848 (2200MHz) CPU's, 8GB DDR400 memory (2GB per CPU),
8 15K SCSI U320 disk connected via two dual Adaptec ASC-39320A controllers
used as data disk, system disk is on 2 sata disks. The eight data disks,
where I do the testing, are combined to a software raid 1+0 (not Raid 10).
Because I am using software raid barriers are disabled, so for all testing
barriers where disabled. The mount options are: noatime,nodiratime,commit=15

There are also a 4 port and a 2 port Gigabit network card, but these where
not used. Here the output of lspci:

00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:1a.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:1a.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:1a.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:1a.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:1b.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:1b.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:1b.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:1b.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
01:04.0 Mass storage controller: Promise Technology, Inc. PDC40775 (SATA 300 TX2plus) (rev 02)
01:06.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
02:02.0 SCSI storage controller: Adaptec ASC-39320A U320 (rev 10)
02:02.1 SCSI storage controller: Adaptec ASC-39320A U320 (rev 10)
02:03.0 SCSI storage controller: Adaptec ASC-39320A U320 (rev 10)
02:03.1 SCSI storage controller: Adaptec ASC-39320A U320 (rev 10)
03:01.0 PCI bridge: IBM PCI-X to PCI-X Bridge (rev 02)
03:03.0 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
03:03.1 Ethernet controller: Intel Corporation 82546GB Gigabit Ethernet Controller (rev 03)
04:04.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (rev 01)
04:04.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (rev 01)
04:06.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (rev 01)
04:06.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (rev 01)

Holger

