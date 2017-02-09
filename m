From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194511] filesystem slow down
Date: Thu, 09 Feb 2017 11:20:29 +0000
Message-ID: <bug-194511-13602-JgTGDzKCpn@https.bugzilla.kernel.org/>
References: <bug-194511-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbdBILUc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 9 Feb 2017 06:20:32 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id DD4E42034E
        for <linux-ext4@vger.kernel.org>; Thu,  9 Feb 2017 11:20:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 9AD6E20125
        for <linux-ext4@vger.kernel.org>; Thu,  9 Feb 2017 11:20:29 +0000 (UTC)
In-Reply-To: <bug-194511-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=194511

--- Comment #2 from Dieter Ferdinand <dieter.ferdinand@gmx.de> ---
Created attachment 254681
  --> https://bugzilla.kernel.org/attachment.cgi?id=254681&action=edit
kernel configuration

hello,
i can send you only my configuration of the kernel at the moment and some infos
about my hardware because i can't restart the other server at the moment.

i have a big problem with such bugs: they will find me all and this is not the
first time, that i have a bug which don't have any other user.
sample: bug in capi-driver which used by asterisk. much time later the
programms warn to use this driver. the time i send informartion of this bug i
get only as response, that all works fine.

i try to send you all information of the other system, next time i start it.
but i don't know which kernel the system use at this time because i send the
provider a mail to change to the last 3.xxx kernel to solve the problem.

goodby

00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] RS780 Host Bridge
00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780 PCI to PCI bridge
(ext gfx port 0)
00:04.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI to PCI
bridge (PCIE port 0)
00:09.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI to PCI
bridge (PCIE port 4)
00:0a.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] RS780/RS880 PCI to PCI
bridge (PCIE port 5)
00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1
Controller
00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.1 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0 USB OHCI1
Controller
00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 SMBus Controller
(rev 3c)
00:14.1 IDE interface: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
IDE Controller
00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 Azalia
(Intel HDA)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0
LPC host controller
00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD/ATI] SBx00 PCI to PCI
Bridge
00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD/ATI]
SB7x0/SB8x0/SB9x0 USB OHCI2 Controller
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 0
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 1
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 2
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 3
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 4
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h Processor
Function 5
01:00.0 VGA compatible controller: NVIDIA Corporation GT218 [GeForce 210] (rev
a2)
01:00.1 Audio device: NVIDIA Corporation High Definition Audio Controller (rev
a1)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 06)
03:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE Controller
(rev 03)
03:00.1 IDE interface: JMicron Technology Corp. JMB363 SATA/IDE Controller (rev
03)
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411
PCI Express Gigabit Ethernet Controller (rev 01)
05:05.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid]
Serial ATA Controller (rev 02)
05:06.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
05:06.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
05:07.0 Serial controller: MosChip Semiconductor Technology Ltd. PCI 9835
Multi-I/O Controller (rev 01)


2 00 00 00 WDC WD20EFRX-68E Rev: 0A82 ATA Direct-Access                    
4 00 00 00 WDC WD20EFRX-68A Rev: 0A80 ATA Direct-Access                    
7 00 00 00 WDC WD30EFRX-68A Rev: 0A80 ATA Direct-Access                    
13 00 00 00 WDC WD30EFRX-68E Rev: 0A82 ATA Direct-Access                    
16 00 01 00 DVD-ROM SD-R5002 Rev: 1030 TOSHIBA CD-ROM                           
19 00 00 00 External USB 3.0 Rev: 5438 TOSHIBA Direct-Access                    
18 00 00 00 External USB 3.0 Rev: 5438 TOSHIBA Direct-Access                    
6 00 00 00 WDC WD30EFRX-68E Rev: 0A82 ATA Direct-Access                    
11 00 00 00 ST3000VN000-1H41 Rev: SC42 ATA Direct-Access

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
