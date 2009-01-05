From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12272] at random rmmod/insmod corrupts filesystem
Date: Mon,  5 Jan 2009 11:52:06 -0800 (PST)
Message-ID: <20090105195206.4B580108040@picon.linux-foundation.org>
References: <bug-12272-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbZAETwi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 14:52:38 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n05Jq64M006229
	for <linux-ext4@vger.kernel.org>; Mon, 5 Jan 2009 11:52:07 -0800
In-Reply-To: <bug-12272-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12272





------- Comment #4 from folkert@vanheusden.com  2009-01-05 11:52 -------
(In reply to comment #1)
> please provide the output of the script and/or post a list of your modules. 

The system starts with the following modules:
ac                      3264  0 
battery                 6272  0 
ipv6                  234724  12 
loop                   12812  0 
snd_intel8x0           26332  0 
snd_ac97_codec         89220  1 snd_intel8x0
i2c_i801                8336  0 
ac97_bus                1728  1 snd_ac97_codec
snd_pcm                63108  2 snd_intel8x0,snd_ac97_codec
i2c_core               20692  1 i2c_i801
snd_timer              18056  1 snd_pcm
snd                    45828  4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
soundcore               6528  1 snd
snd_page_alloc          7400  2 snd_intel8x0,snd_pcm
floppy                 47812  0 
pcspkr                  2432  0 
iTCO_wdt                9668  0 
rng_core                4004  0 
parport_pc             22660  0 
parport                31180  1 parport_pc
shpchp                 25204  0 
pci_hotplug            23680  1 shpchp
container               3488  0 
button                  6096  0 
intel_agp              22844  1 
agpgart                29800  1 intel_agp
evdev                   8416  0 
joydev                  8608  0 
ext3                  106024  6 
jbd                    40820  1 ext3
mbcache                 7268  1 ext3
dm_mirror              15264  0 
dm_log                  8516  1 dm_mirror
dm_snapshot            15140  0 
dm_mod                 46696  16 dm_mirror,dm_log,dm_snapshot
ide_cd_mod             27172  0 
ide_disk               10592  3 
cdrom                  30016  1 ide_cd_mod
piix                    5864  2 
ide_core               84468  3 ide_cd_mod,ide_disk,piix
usbhid                 36000  0 
hid                    33792  1 usbhid
ff_memless              4456  1 usbhid
ata_generic             4676  0 
libata                144480  1 ata_generic
scsi_mod              130412  1 libata
dock                    8368  1 libata
e1000                 104708  0 
ehci_hcd               29132  0 
uhci_hcd               18864  0 
usbcore               120176  4 usbhid,ehci_hcd,uhci_hcd
thermal                15388  0 
processor              33516  1 thermal
fan                     4356  0 
thermal_sys            10760  3 thermal,processor,fan


> do you see any warnings/oopses in dmesg while running it ?

No. After a short while I see the following output:

[  209.038312] attempt to access beyond end of device
[  209.038377] dm-0: rw=0, want=1279882228, limit=565248   
[  209.038458] Buffer I/O error on device dm-0, logical block 639941113
[  209.038525] attempt to access beyond end of device
[  209.038585] dm-0: rw=0, want=5069976612, limit=565248
[  209.038643] Buffer I/O error on device dm-0, logical block 2534988305
[  209.038710] attempt to access beyond end of device
[  209.038763] dm-0: rw=0, want=2559708832, limit=565248
[  209.038816] Buffer I/O error on device dm-0, logical block 1279854415
[  209.038873] attempt to access beyond end of device
[  209.038936] dm-0: rw=0, want=877454918, limit=565248
[  209.038989] Buffer I/O error on device dm-0, logical block 438727458
[  209.039049] attempt to access beyond end of device
[  209.039102] dm-0: rw=0, want=616859760, limit=565248
[  209.039188] attempt to access beyond end of device
[  209.039242] dm-0: rw=0, want=1279882228, limit=565248
[  209.039294] Buffer I/O error on device dm-0, logical block 639941113
[  209.039350] attempt to access beyond end of device
[  209.039403] dm-0: rw=0, want=5069976612, limit=565248
[  209.039465] Buffer I/O error on device dm-0, logical block 2534988305
[  209.039522] attempt to access beyond end of device
[  209.039575] dm-0: rw=0, want=2559708832, limit=565248
[  209.039629] Buffer I/O error on device dm-0, logical block 1279854415
[  209.039694] attempt to access beyond end of device
[  209.039747] dm-0: rw=0, want=877454918, limit=565248
[  209.039799] Buffer I/O error on device dm-0, logical block 438727458
[  209.041515] processor: Unknown symbol thermal_cooling_device_register
[  209.043820] processor: Unknown symbol thermal_cooling_device_unregister
[  209.110502] attempt to access beyond end of device
[  209.110571] dm-0: rw=0, want=1279882228, limit=565248
[  209.110656] Buffer I/O error on device dm-0, logical block 639941113
[  209.110723] attempt to access beyond end of device
[  209.110785] dm-0: rw=0, want=5069976612, limit=565248
[  209.110840] Buffer I/O error on device dm-0, logical block 2534988305
[  209.110908] attempt to access beyond end of device
[  209.110963] dm-0: rw=0, want=2559708832, limit=565248
[  209.111017] attempt to access beyond end of device
[  209.111073] dm-0: rw=0, want=877454918, limit=565248

the modules then loaded are:

floppy                 47812  0 
i2c_i801                8336  0 
snd_intel8x0           26332  0 
button                  6096  0 
dm_snapshot            15140  0 
usbhid                 36000  0 
shpchp                 25204  0 
pci_hotplug            23680  1 shpchp
netconsole              7360  0 
configfs               21944  2 netconsole
ipv6                  234724  12 
snd_ac97_codec         89220  1 snd_intel8x0
ac97_bus                1728  1 snd_ac97_codec
snd_pcm                63108  2 snd_intel8x0,snd_ac97_codec
i2c_core               20692  1 i2c_i801
snd_timer              18056  1 snd_pcm
snd                    45828  4 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
soundcore               6528  1 snd
snd_page_alloc          7400  2 snd_intel8x0,snd_pcm
iTCO_wdt                9668  0 
parport_pc             22660  0 
parport                31180  1 parport_pc
intel_agp              22844  1 
agpgart                29800  1 intel_agp
ext3                  106024  6 
jbd                    40820  1 ext3
mbcache                 7268  1 ext3
dm_mirror              15264  0 
dm_log                  8516  1 dm_mirror
dm_mod                 46696  16 dm_snapshot,dm_mirror,dm_log
ide_disk               10592  3 
piix                    5864  4294967295 
ide_core               84468  2 ide_disk,piix
hid                    33792  1 usbhid
ff_memless              4456  1 usbhid
libata                144480  0 
scsi_mod              130412  1 libata
dock                    8368  1 libata
e1000                 104708  0 
ehci_hcd               29132  0 
uhci_hcd               18864  0 
usbcore               120176  4 usbhid,ehci_hcd,uhci_hcd


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
