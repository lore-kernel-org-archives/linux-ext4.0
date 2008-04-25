From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 09:36:02 +0200
Message-ID: <481189E2.9050005@gmail.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org> <4811090A.9030809@gmail.com> <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org> <48112C74.8000405@gmail.com> <alpine.LFD.1.10.0804241633040.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	paulmck@linux.vnet.ibm.com, David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:14825 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbYDYHgK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 03:36:10 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3486784fgb.17
        for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 00:36:07 -0700 (PDT)
In-Reply-To: <alpine.LFD.1.10.0804241633040.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/25/2008 01:45 AM, Linus Torvalds wrote:
> On Fri, 25 Apr 2008, Jiri Slaby wrote:
>> Not really. I have no idea what triggers it. Seems like suspend is some kind
>> of catalyzer not working every time.
> 
> I don't think suspend/resume is sufficient, because I've tried to 
> reproduce it here (and I tried your test program too) on my macmini, and 
> it's not happening. So there almost certainly something else too required 
> to trigger it.
> 
> Btw, how do you suspend/resume? That matters, because I've been testing 
> just the normal
> 
> 	echo mem > /sys/power/state
> 
> and with a kernel where everything is compiled-in. But if you use the GUI 
> suspend, on a common distro, I think that one ends up doing a whole lot 
> more, including doing things like unloading and reloading modules, and for 
> all we know the problem is not about suspend itself, but about the things 
> going on around it.

pm-suspend without suspend package -- i.e. it writes mem > state, but does some 
processing before and after that. However no module loads or removes.

Particualry I have
         hibernate|suspend)
                 service autofs stop >/dev/null
                 service vmware stop >/dev/null
                 ;;
         thaw|resume)
                 service autofs start >/dev/null
                 ;;

While vmware is not running, autofs is.

The rest of scripts is from
http://download.opensuse.org/distribution/SL-OSS-factory/inst-source/suse/x86_64/pm-utils-0.99.3.20070618-49.x86_64.rpm

[I see now that suse added autofs stopping to their scripts too.]
Not using networkmanager.
Nothing in any pm confs, no VIDEO s3 quirks, no unload modules.
No bluetooth, no pcmcia, no batteries, no cpufreq, no backlight. -- It's desktop.
/proc/acpi/fan/*/state doesn't exist

The probably only done handling is hwclock.
lrwxrwxrwx 1 root root 0 Apr 25 02:44 /sys/class/rtc/rtc0/device/driver -> 
../../../bus/pnp/drivers/rtc_cmos

> Jiri, Zdenek, Rafael, could you try to compare hardware with each other 
> and see if there is some pattern there?

00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller 
(rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
Integrated Graphics Controller (rev 02)
00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31 Express 
MEI Controller (rev 02)
00:03.1 Communication controller: Intel Corporation 82G33/G31/P35/P31 Express 
MEI Controller (rev 02)
00:03.2 IDE interface: Intel Corporation 82G33/G31/P35/P31 Express PT IDER 
Controller (rev 02)
00:03.3 Serial controller: Intel Corporation 82G33/G31/P35/P31 Express Serial KT 
Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network 
Connection (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller 
(rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 
(rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 
(rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation Device 2910 (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port 
SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) 
Thermal Subsystem (rev 02)
02:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI 
Bridge (rev 03)
03:00.0 FireWire (IEEE 1394): Texas Instruments XIO2200(A) IEEE-1394a-2000 
Controller (PHY/Link) (rev 01)
04:00.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 
Multiprotocol MAC/baseband processor (rev 01)

Bus 008 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 007: ID 045e:00f0 Microsoft Corp.
Bus 004 Device 006: ID 0458:004c KYE Systems Corp. (Mouse Systems) Slimstar Pro 
Keyboard
Bus 004 Device 005: ID 04b4:2050 Cypress Semiconductor Corp.
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

core 2 duo, 2gigs of mem, 2 sata II disks, raid0, raid1 (both 0.9), lvm2, ext3 
above all of it.

Modules:
Module                  Size  Used by
tun                    11012  1 	<----- Using vpn!
bitrev                  2240  1 tun
ipv6                  269736  36
arc4                    2432  2
ecb                     3584  2
crypto_blkcipher       18052  1 ecb
cryptomgr               3712  0
crypto_algapi          15872  4 arc4,ecb,crypto_blkcipher,cryptomgr
ath5k                 104640  0
mac80211              140240  1 ath5k
crc32                   4416  2 tun,mac80211
sr_mod                 15748  0
rtc_cmos               10232  0
rtc_core               17220  1 rtc_cmos
floppy                 64488  0
cfg80211               27920  2 ath5k,mac80211
cdrom                  37800  1 sr_mod
ohci1394               31412  0
rtc_lib                 3328  1 rtc_core
ieee1394               90808  1 ohci1394
evdev                  11584  5
usbhid                 49952  0
hid                    73664  1 usbhid
ff_memless              6088  1 usbhid
ehci_hcd               37388  0

> (And btw, the program you used that allocates a hundred meg and tries to 
> find it - I'm assuming you're not paging or anythign like that, ie you're 
> not even close to out-of-memory. If that isn't correct, holler. I'm trying 
> to reproduce this thing).

OOM is too far away:
Swap:      2008084         32    2008052


		Jiri
