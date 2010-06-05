From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16122] 2.6.35-rc1: WARNING at fs/fs-writeback.c:1142
 __mark_inode_dirty+0x103/0x170
Date: Sat, 5 Jun 2010 03:13:55 GMT
Message-ID: <201006050313.o553DtBU020787@demeter.kernel.org>
References: <bug-16122-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:53184 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0FEDN4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jun 2010 23:13:56 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o553Dtd7020798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 5 Jun 2010 03:13:55 GMT
In-Reply-To: <bug-16122-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16122





--- Comment #4 from Larry Finger <Larry.Finger@lwfinger.net>  2010-06-05 03:13:49 ---
I do not think openSUSE 11.3 M7 uses a loop on boot. The dmesg output indicates
that device-mapper was initialized 17 secs before the WARNING; however, I'm not
using it. I will blacklist the DM modules and see if I still get the WARNING.

The demesg output just prior to the WARNING is

   11.996365] ssb: Sonics Silicon Backplane found on PCI device 0000:04:00.0
[   12.148321] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   12.148661] hda: MWDMA2 mode selected
[   12.149177] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   12.150932] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
[   12.150948] HDA Intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 20
(level, low) -> IRQ 20
[   12.150953] hda_intel: Disable MSI for Nvidia chipset
[   12.151034] HDA Intel 0000:00:07.0: setting latency timer to 64
[   12.290805] cfg80211: Calling CRDA to update world regulatory domain
[   12.301154] cfg80211: World regulatory domain updated:
[   12.301159]     (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
[   12.301163]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.301166]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.301169]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   12.301171]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.301174]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   12.878617] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[   12.924045] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
[   12.924063] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062,
Revision 2
[   13.064213] ide-cd driver 5.00
[   13.067134] ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB
Cache
[   13.067143] Uniform CD-ROM driver Revision: 3.20
[   13.080677] phy0: Selected rate control algorithm 'minstrel'
[   13.084263] Registered led device: b43-phy0::tx
[   13.084435] Registered led device: b43-phy0::rx
[   13.084603] Registered led device: b43-phy0::radio
[   13.086455] Broadcom 43xx driver loaded [ Features: PMNLS, Firmware-ID: FW13
]
[   13.275196] Adding 2104448k swap on /dev/sda5.  Priority:-1 extents:1
across:2104448k 
[   13.885398] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised:
dm-devel@redhat.com
[   30.302902] ------------[ cut here ]------------
[   30.302912] WARNING: at fs/fs-writeback.c:1142
__mark_inode_dirty+0x103/0x170()

This boot was using the 2.6.35-rc1 kernel from Linville's wireless-testing
tree.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
