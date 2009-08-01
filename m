From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
Date: Sat, 1 Aug 2009 00:54:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.0908010046430.5831@bogon.housecafe.de>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com> <200907280021.26320.rjw@sisk.pl> <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752488AbZHAHz1@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 30 Jul 2009 at 00:21, David Rientjes wrote:
> These patches have made it to Linus' tree, so this issue is resolved.

I've pulled Linus' tree yesterday, booted, all fine - just now it was the 
first time I saw a similar WARNING on my box (running -rc kernels 
for a few months now), see below.

Is this related to the WARNING in #13666?
I'm pretty sure the kernel already includes the patches you 
mentioned, "git show" said "b592972493c38665efd7d429a01b23fcb21e331a". 
Also, I just pulled again and mm/ was not touched any more.

Or maybe this is related to ext4 stuff? (I just mounted an ext4 partition 
when this WARNING happened). Full dmesg & .config:
   http://nerdbynature.de/bits/2.6.31-rc4/

Thanks,
Christian.

[69973.604263] ------------[ cut here ]------------
[69973.604340] WARNING: at mm/page_alloc.c:1749 __alloc_pages_nodemask+0x4c4/0x5a0()
[69973.604422] Hardware name: Lenovo          
[69973.604468] Modules linked in: fuse acpi_cpufreq nfsd lockd nfs_acl auth_rpcgss sunrpc lm75 hwmon b43 usb_storage usb_libusual mac80211 cfg80211 uhci_hcd tg3 ssb ehci_hcd usbcore libphy nls_base
[69973.604727] Pid: 15026, comm: mount Not tainted 2.6.31-rc4 #1
[69973.604781] Call Trace:
[69973.604831]  [<c1036dda>] ? warn_slowpath_common+0x7a/0xc0
[69973.604891]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
[69973.604952]  [<c1036e40>] ? warn_slowpath_null+0x20/0x40
[69973.605072]  [<c1076be4>] ? __alloc_pages_nodemask+0x4c4/0x5a0
[69973.605152]  [<c106dc72>] ? delayacct_end+0xa2/0xd0
[69973.605212]  [<c10c6617>] ? __find_get_block+0xa7/0x180
[69973.605271]  [<c1076d41>] ? __get_free_pages+0x21/0x60
[69973.605330]  [<c11f02bd>] ? match_number+0x3d/0xc0
[69973.605387]  [<c1129512>] ? parse_options+0xe2/0x5d0
[69973.605444]  [<c135116b>] ? out_of_line_wait_on_bit+0xbb/0xf0
[69973.605506]  [<c10c6ff8>] ? __wait_on_buffer+0x28/0x50
[69973.605564]  [<c112b5b7>] ? ext4_fill_super+0x457/0x2670
[69973.605622]  [<c11ee136>] ? vsnprintf+0x516/0x820
[69973.605679]  [<c11e7f1d>] ? kobject_get+0x1d/0x40
[69973.605738]  [<c10ef5c7>] ? disk_name+0xd7/0xe0
[69973.605795]  [<c10a37ca>] ? get_sb_bdev+0x15a/0x1a0
[69973.605851]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
[69973.605909]  [<c112822d>] ? ext4_get_sb+0x2d/0x50
[69973.605963]  [<c112b160>] ? ext4_fill_super+0x0/0x2670
[69973.606020]  [<c10a24f8>] ? vfs_kern_mount+0x58/0xd0
[69973.606078]  [<c10a2606>] ? do_kern_mount+0x56/0x120
[69973.606135]  [<c10bb2da>] ? do_mount+0x23a/0x750
[69973.606191]  [<c10b91c1>] ? copy_mount_options+0x61/0x160
[69973.606249]  [<c10bb88f>] ? sys_mount+0x9f/0x100
[69973.606306]  [<c1003304>] ? syscall_call+0x7/0xb
[69973.606360] ---[ end trace 28ff7a9c4fbb8a1a ]---



-- 
BOFH excuse #376:

Budget cuts forced us to sell all the power cords for the servers.
