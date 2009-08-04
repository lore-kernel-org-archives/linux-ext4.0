From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Tue, 4 Aug 2009 12:44:22 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908041241510.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de> <alpine.DEB.2.01.0908021314030.5831@bogon.housecafe.de> <200908022226.52228.rjw@sisk.pl> <alpine.DEB.2.01.0908021331350.5831@bogon.housecafe.de>
 <alpine.DEB.2.01.0908021348440.5831@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Rientjes <rientjes@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:49934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZHDTol (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Aug 2009 15:44:41 -0400
In-Reply-To: <alpine.DEB.2.01.0908021348440.5831@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 2 Aug 2009 at 13:53, Christian Kujau wrote:
> [  124.683454] ------------[ cut here ]------------
> [  124.683577] WARNING: at mm/page_alloc.c:1749 __alloc_pages_nodemask+0x4c4/0x5a0()

Hm, I just wonder: is this something to worry about? The filesystem itself 
seems fine so far, but I don't want it to get (silently) corrupted with 
each mount because of this warning...

> [  124.683704] Hardware name: Lenovo          
> [  124.683795] Modules linked in: fuse acpi_cpufreq nfsd lockd nfs_acl auth_rpcgss sunrpc lm75 hwmon usb_storage usb_libusual b43 mac80211 uhci_hcd cfg80211 ehci_hcd tg3 usbcore libphy ssb nls_base
> [  124.685187] Pid: 2743, comm: mount Not tainted 2.6.31-rc5 #1
> [  124.685286] Call Trace:
> [  124.685383]  [<c1036dda>] ? warn_slowpath_common+0x7a/0xc0
> [  124.685489]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
> [  124.685596]  [<c1036e40>] ? warn_slowpath_null+0x20/0x40
> [  124.685700]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
> [  124.685808]  [<c106dc72>] ? delayacct_end+0xa2/0xd0
> [  124.685913]  [<c1076d41>] ? __get_free_pages+0x21/0x60
> [  124.686018]  [<c11f02cd>] ? match_number+0x3d/0xc0
> [  124.686122]  [<c1129512>] ? parse_options+0xe2/0x5d0
> [  124.686225]  [<c135118b>] ? out_of_line_wait_on_bit+0xbb/0xf0
> [  124.686334]  [<c10c6ff8>] ? __wait_on_buffer+0x28/0x50
> [  124.686438]  [<c112b5b7>] ? ext4_fill_super+0x457/0x2670
> [  124.686542]  [<c11ee146>] ? vsnprintf+0x516/0x820
> [  124.686646]  [<c11e7f2d>] ? kobject_get+0x1d/0x40
> [  124.686752]  [<c10ef5c7>] ? disk_name+0xd7/0xe0
> [  124.686855]  [<c10a37ca>] ? get_sb_bdev+0x15a/0x1a0
> [  124.686958]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
> [  124.687062]  [<c112822d>] ? ext4_get_sb+0x2d/0x50
> [  124.687162]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
> [  124.687265]  [<c10a24f8>] ? vfs_kern_mount+0x58/0xd0
> [  124.687369]  [<c10a2606>] ? do_kern_mount+0x56/0x120
> [  124.687474]  [<c10bb2da>] ? do_mount+0x23a/0x750
> [  124.687575]  [<c10b91c1>] ? copy_mount_options+0x61/0x160
> [  124.687679]  [<c10bb88f>] ? sys_mount+0x9f/0x100
> [  124.687783]  [<c1003304>] ? syscall_call+0x7/0xb
> [  124.687883] ---[ end trace e312a7d04db27a01 ]---
> [  124.981799] EXT4-fs (dm-8): barriers enabled
> [  125.002226] kjournald2 starting: pid 2744, dev dm-8:8, commit interval 5 seconds
> [  125.003346] EXT4-fs (dm-8): internal journal on dm-8:8
> [  125.003555] EXT4-fs (dm-8): delayed allocation enabled
> [  125.003751] EXT4-fs: file extents enabled
> [  125.343718] EXT4-fs: mballoc enabled
> [  125.343884] EXT4-fs (dm-8): mounted filesystem with ordered data mode
> 
> 
> Full dmesg and config: http://nerdbynature.de/bits/2.6.31-rc5/
> 
> No mount options were passed on the commandline but read from fstab:
> 
> $ grep ext4 /etc/fstab
> /dev/mapper/wdc0    /mnt/disk0 ext4 nosuid,nodev,noexec,noauto,barrier 0 0
> 
> 
> I'm in the process of creating an e2image of this partition, would this 
> help anyone?
> 
> Thanks,
> Christian.

-- 
BOFH excuse #166:

/pub/lunch
