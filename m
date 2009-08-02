From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Sun, 2 Aug 2009 13:18:57 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908021314030.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com> <200907280021.26320.rjw@sisk.pl> <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
 <alpine.DEB.2.01.0908010046430.5831@bogon.housecafe.de> <alpine.DEB.2.00.0908010231560.1019@chino.kir.corp.google.com> <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZHBUS7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Aug 2009 16:18:59 -0400
In-Reply-To: <alpine.DEB.2.01.0908011427270.5831@bogon.housecafe.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hm,

looks like this *is* reproducible. After a reboot, mounting the very 
same ext4 filesystem triggers this WARNING again:

[  165.000603] ------------[ cut here ]------------
[  165.000726] WARNING: at mm/page_alloc.c:1749 __alloc_pages_nodemask+0x4c4/0x5a0()
[  165.000853] Hardware name: Lenovo          
[  165.000944] Modules linked in: fuse acpi_cpufreq nfsd lockd nfs_acl auth_rpcgss sunrpc lm75 hwmon b43 usb_storage usb_libusual mac80211 cfg80211 uhci_hcd ehci_hcd tg3 ssb usbcore libphy nls_base
[  165.002297] Pid: 2789, comm: mount Not tainted 2.6.31-rc4 #1
[  165.002397] Call Trace:
[  165.002494]  [<c1036dda>] ? warn_slowpath_common+0x7a/0xc0
[  165.002601]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
[  165.002708]  [<c1036e40>] ? warn_slowpath_null+0x20/0x40
[  165.002812]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
[  165.002921]  [<c106dc72>] ? delayacct_end+0xa2/0xd0
[  165.003027]  [<c1076d41>] ? __get_free_pages+0x21/0x60
[  165.003132]  [<c11f02bd>] ? match_number+0x3d/0xc0
[  165.003235]  [<c1129512>] ? parse_options+0xe2/0x5d0
[  165.003340]  [<c135116b>] ? out_of_line_wait_on_bit+0xbb/0xf0
[  165.003449]  [<c10c6ff8>] ? __wait_on_buffer+0x28/0x50
[  165.003552]  [<c112b5b7>] ? ext4_fill_super+0x457/0x2670
[  165.003657]  [<c11ee136>] ? vsnprintf+0x516/0x820
[  165.003759]  [<c11e7f1d>] ? kobject_get+0x1d/0x40
[  165.003865]  [<c10ef5c7>] ? disk_name+0xd7/0xe0
[  165.003967]  [<c10a37ca>] ? get_sb_bdev+0x15a/0x1a0
[  165.004107]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
[  165.004216]  [<c112822d>] ? ext4_get_sb+0x2d/0x50
[  165.004315]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
[  165.004419]  [<c10a24f8>] ? vfs_kern_mount+0x58/0xd0
[  165.004522]  [<c10a2606>] ? do_kern_mount+0x56/0x120
[  165.004625]  [<c10bb2da>] ? do_mount+0x23a/0x750
[  165.004727]  [<c10b91c1>] ? copy_mount_options+0x61/0x160
[  165.004831]  [<c10bb88f>] ? sys_mount+0x9f/0x100
[  165.004934]  [<c1003304>] ? syscall_call+0x7/0xb
[  165.005044] ---[ end trace d2227ca6268a916a ]---
[  165.287930] EXT4-fs (dm-7): barriers enabled

The whole dmesg and proc/meminfo is at:
http://nerdbynature.de/bits/2.6.31-rc4/

Note: "dm-7" is a dm-crypt device, backed by an external disk which is 
connected via USB. The filesystem itself seems fine however, nothing 
unusual except this warning so far...

Christian.
-- 
BOFH excuse #174:

Backbone adjustment
