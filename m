From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Fri, 25 Apr 2008 17:30:51 +0200
Message-ID: <200804251730.52811.rjw@sisk.pl>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <alpine.LFD.1.10.0804241633040.2779@woody.linux-foundation.org> <481189E2.9050005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:35916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbYDYPaV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 11:30:21 -0400
In-Reply-To: <481189E2.9050005@gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Friday, 25 of April 2008, Jiri Slaby wrote:
> On 04/25/2008 01:45 AM, Linus Torvalds wrote:
> > On Fri, 25 Apr 2008, Jiri Slaby wrote:
> >> Not really. I have no idea what triggers it. Seems like suspend is some kind
> >> of catalyzer not working every time.
> > 
> > I don't think suspend/resume is sufficient, because I've tried to 
> > reproduce it here (and I tried your test program too) on my macmini, and 
> > it's not happening. So there almost certainly something else too required 
> > to trigger it.
> > 
> > Btw, how do you suspend/resume? That matters, because I've been testing 
> > just the normal
> > 
> > 	echo mem > /sys/power/state
> > 
> > and with a kernel where everything is compiled-in. But if you use the GUI 
> > suspend, on a common distro, I think that one ends up doing a whole lot 
> > more, including doing things like unloading and reloading modules, and for 
> > all we know the problem is not about suspend itself, but about the things 
> > going on around it.
> 
> pm-suspend without suspend package -- i.e. it writes mem > state, but does some 
> processing before and after that. However no module loads or removes.
> 
> Particualry I have
>          hibernate|suspend)
>                  service autofs stop >/dev/null
>                  service vmware stop >/dev/null
>                  ;;
>          thaw|resume)
>                  service autofs start >/dev/null
>                  ;;
> 
> While vmware is not running, autofs is.
> 
> The rest of scripts is from
> http://download.opensuse.org/distribution/SL-OSS-factory/inst-source/suse/x86_64/pm-utils-0.99.3.20070618-49.x86_64.rpm
> 
> [I see now that suse added autofs stopping to their scripts too.]
> Not using networkmanager.
> Nothing in any pm confs, no VIDEO s3 quirks, no unload modules.
> No bluetooth, no pcmcia, no batteries, no cpufreq, no backlight. -- It's desktop.
> /proc/acpi/fan/*/state doesn't exist
> 
> The probably only done handling is hwclock.
> lrwxrwxrwx 1 root root 0 Apr 25 02:44 /sys/class/rtc/rtc0/device/driver -> 
> ../../../bus/pnp/drivers/rtc_cmos
> 
> > Jiri, Zdenek, Rafael, could you try to compare hardware with each other 
> > and see if there is some pattern there?
> 
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller 
> (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express 
> Integrated Graphics Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31 Express 
> MEI Controller (rev 02)
> 00:03.1 Communication controller: Intel Corporation 82G33/G31/P35/P31 Express 
> MEI Controller (rev 02)
> 00:03.2 IDE interface: Intel Corporation 82G33/G31/P35/P31 Express PT IDER 
> Controller (rev 02)
> 00:03.3 Serial controller: Intel Corporation 82G33/G31/P35/P31 Express Serial KT 
> Controller (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network 
> Connection (rev 02)
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #5 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #6 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
> Controller #2 (rev 02)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller 
> (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 
> (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 3 
> (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI 
> Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI 
> Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 ISA bridge: Intel Corporation Device 2910 (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port 
> SATA AHCI Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
> 00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) 
> Thermal Subsystem (rev 02)
> 02:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI 
> Bridge (rev 03)
> 03:00.0 FireWire (IEEE 1394): Texas Instruments XIO2200(A) IEEE-1394a-2000 
> Controller (PHY/Link) (rev 01)
> 04:00.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 
> Multiprotocol MAC/baseband processor (rev 01)

Well, my machine is based on Athlon 64 X2 with an ATI chipset.

The only two common things it has with your machine is probably that we both use
64-bit kernels and wireless adapters (different ones, for that matter).

I do use NetworkManager, BTW.

Well, one thing that suspend does and which is not done routinely is CPU
hotplugging.  Could you please check if you are able to provoke the symptoms
to appear by offlining-onlining CPU1?

Thanks,
Rafael
