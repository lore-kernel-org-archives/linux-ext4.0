From: Stefan Priebe <s.priebe@profihost.ag>
Subject: Re: Call trace in ext4_es_lru_add on 3.10 stable
Date: Mon, 22 Sep 2014 08:56:23 +0200
Message-ID: <541FC817.7030401@profihost.ag>
References: <541AD93A.70203@profihost.ag> <20140918192131.GD19520@thunk.org> <541B32A1.3080706@profihost.ag> <20140918194311.GE19520@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"p.herz@profihost.ag >> Philipp Herz - Profihost AG"
	<p.herz@profihost.ag>, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:51508 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbaIVG4Y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2014 02:56:24 -0400
In-Reply-To: <20140918194311.GE19520@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Am 18.09.2014 21:43, schrieb Theodore Ts'o:
> On Thu, Sep 18, 2014 at 09:29:37PM +0200, Stefan Priebe wrote:
>>
>> Sorry but whole output is:
>> 2014-09-18 02:30:34     0000000000000000 ffff881021663b20 ffff881021663b08
>> ffffffffa02d66b3
> 		...
>
> That's not the whole message; you just weren't able to capture it all.
> How are you capturing these messages, by the way?  Serial console?

Sorry this was an incomplete copy and paste by me.

Here is the complete output:
[1578544.839610] BUG: soft lockup - CPU#7 stuck for 22s! [mysqld:29281]
[1578544.893450] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack xt_tcpudp xt_owner mpt2sas raid_class ipt_REJECT 
xt_multiport iptable_filter ip_tables x_tables cpufreq_userspace 
cpufreq_powersave cpufreq_conservative cpufreq_ondemand 8021q garp ext4 
crc16 jbd2 mbcache ext2 k8temp ehci_pci mperf coretemp kvm_intel kvm 
crc32_pclmul ehci_hcd ghash_clmulni_intel sb_edac edac_core usbcore 
i2c_i801 microcode usb_common button netconsole sg sd_mod igb 
i2c_algo_bit isci i2c_core libsas ahci ptp libahci scsi_transport_sas 
megaraid_sas pps_core
[1578545.192373] CPU: 7 PID: 29281 Comm: mysqld Tainted: G        W 
3.10.53+85-ph #1
[1578545.254369] Hardware name: Supermicro 
X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SRE/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 1.0a 
03/06/2012
[1578545.317333] task: ffff880d5bab9900 ti: ffff880048da4000 task.ti: 
ffff880048da4000
[1578545.380284] RIP: 0010:[<ffffffff81553cb2>]  [<ffffffff81553cb2>] 
_raw_spin_lock+0x22/0x30
[1578545.444138] RSP: 0000:ffff880048da5878  EFLAGS: 00000297
[1578545.507802] RAX: 000000000000f53c RBX: ffffffffa0372a69 RCX: 
000000008802cc10
[1578545.571007] RDX: 000000000000f53d RSI: 0000000000000000 RDI: 
ffff8810265a6440
[1578545.632916] RBP: ffff880048da5878 R08: 1038000000000000 R09: 
0ab3417d081c0000
[1578545.694103] R10: 0000000000000005 R11: dead000000100100 R12: 
ffffffff812ba03b
[1578545.755009] R13: ffff880048da57e8 R14: ffffffff810fa58c R15: 
ffff880048da58a8
[1578545.815734] FS:  00007f55e0d1e700(0000) GS:ffff88107fdc0000(0000) 
knlGS:0000000000000000
[1578545.877485] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[1578545.939121] CR2: 00007f5505000000 CR3: 0000001024ba0000 CR4: 
00000000000407e0
[1578546.001641] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[1578546.064081] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[1578546.125544] Stack:
[1578546.186027]  ffff880048da5898 ffffffffa0373350 ffff880ab3417c70 
ffff880ab3417c70
[1578546.248189]  ffff880048da58b8 ffffffffa03548b5 ffff880ab3417db8 
ffff880ab3417db8
[1578546.310187]  ffff880048da58d8 ffffffffa033cf43 ffff880ab3417c70 
ffff880ab3417d70
[1578546.371830] Call Trace:
[1578546.432274]  [<ffffffffa0373350>] ext4_es_lru_del+0x30/0x80 [ext4]
[1578546.493276]  [<ffffffffa03548b5>] ext4_clear_inode+0x45/0x90 [ext4]
[1578546.554093]  [<ffffffffa033cf43>] ext4_evict_inode+0x83/0x4d0 [ext4]
[1578546.614444]  [<ffffffff81169ef0>] evict+0xb0/0x1b0
[1578546.673944]  [<ffffffff8116a031>] dispose_list+0x41/0x50
[1578546.733061]  [<ffffffff8116ae23>] prune_icache_sb+0x183/0x340
[1578546.792425]  [<ffffffff81154c7b>] prune_super+0x17b/0x1b0
[1578546.851603]  [<ffffffff810fd0f1>] shrink_slab+0x151/0x2e0
[1578546.910609]  [<ffffffff8110dd22>] ? compact_zone+0x32/0x430
[1578546.969573]  [<ffffffff810ffc55>] do_try_to_free_pages+0x405/0x540
[1578547.028754]  [<ffffffff810fffc8>] try_to_free_pages+0xf8/0x180
[1578547.087924]  [<ffffffff810f5d63>] __alloc_pages_nodemask+0x553/0x900
[1578547.147165]  [<ffffffff81131a05>] alloc_pages_vma+0xa5/0x150
[1578547.206584]  [<ffffffff811445a4>] 
do_huge_pmd_anonymous_page+0x174/0x3d0
[1578547.265245]  [<ffffffff8111c568>] ? change_protection+0x5b8/0x670
[1578547.322947]  [<ffffffff81114a22>] handle_mm_fault+0x292/0x340
[1578547.379690]  [<ffffffff81032b68>] __do_page_fault+0x168/0x460
[1578547.434929]  [<ffffffff8111c777>] ? mprotect_fixup+0x157/0x280
[1578547.488655]  [<ffffffff8111851b>] ? remove_vma+0x5b/0x70
[1578547.541197]  [<ffffffff81032e9e>] do_page_fault+0xe/0x10
[1578547.594037]  [<ffffffff81554242>] page_fault+0x22/0x30

> It this reproducible?   Can you try a newer kernel?

I'm seeing this on various systems doing rsync backups to an ext4 
partition. I can't try a newer kernel. But i also don't have exact steps 
to reproduce. It just happens sometimes.

Greets,
Stefan
