From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 14507] New: kswapd crash, BUG: unable to
 handle kernel NULL pointer dereference at (null)
Date: Fri, 30 Oct 2009 16:19:28 -0700
Message-ID: <20091030161928.f4302714.akpm@linux-foundation.org>
References: <bug-14507-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, yagp@free.fr
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933023AbZJ3XT1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Oct 2009 19:19:27 -0400
In-Reply-To: <bug-14507-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 29 Oct 2009 12:34:19 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14507
> 
>            Summary: kswapd crash, BUG: unable to handle kernel NULL
>                     pointer dereference at (null)

ext3 went splat.

>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 2.6.30.9-90.fc11.x86_64
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@linux-foundation.org
>         ReportedBy: yagp@free.fr
>         Regression: No
> 
> 
> On my Linux 64 bits machine, from time to time, kswapd crashes and sometimes
> the system freeze a little bit after. 
> 
> Precisions: 
> 1) CPU Intel Core i7 920, 12 GB of RAM
> 2) According to memtest86, the RAM is OK (test made during 6 hours). 
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff811b99c7>] bit_spin_lock+0x29/0x49
> PGD 17f9e5067 PUD 2a6d9e067 PMD 0 
> Oops: 0002 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.2/0000:06:00.0/irq
> CPU 5 
> Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
> ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath
> firewire_ohci firewire_core snd_hda_codec_realtek nvidia(P) snd_hda_intel
> crc_itu_t snd_hda_codec snd_hwdep snd_pcm pata_jmicron snd_timer i2c_i801
> sym53c8xx scsi_transport_spi snd soundcore snd_page_alloc iTCO_wdt
> iTCO_vendor_support r8169 mii wmi pcspkr asus_atk0110 hwmon ata_generic
> pata_acpi nouveau drm i2c_algo_bit i2c_core [last unloaded: microcode]
> Pid: 72, comm: kswapd0 Tainted: P    B      2.6.30.9-90.fc11.x86_64 #1 System
> Product Name
> RIP: 0010:[<ffffffff811b99c7>]  [<ffffffff811b99c7>] bit_spin_lock+0x29/0x49
> RSP: 0018:ffff88033ca8f900  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0020000000000009
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000017
> RBP: ffff88033ca8f910 R08: ffffe20002492630 R09: 00000000ffffffd0
> R10: ffff88033ca8fc20 R11: 00000000000027d0 R12: ffffe20002492608
> R13: 0000000000000000 R14: ffff88033c6f1164 R15: ffff8800a6c35000
> FS:  0000000000000000(0000) GS:ffff880032a87000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 000000017f9fc000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process kswapd0 (pid: 72, threadinfo ffff88033ca8e000, task ffff88033d17c500)
> Stack:
> ffff88033ca8f940 00000000abfa2d3c ffff88033ca8f940 ffffffff811b9a14
> ffff8800a6c34f50 00000000abfa2d3c ffff88033ca8f970 ffff88033c6f1000
> ffff88033ca8f9b0 ffffffff811b525c ffff88033ca8f970 ffffe20002492501
> Call Trace:
> [<ffffffff811b9a14>] journal_grab_journal_head+0x2d/0x61
> [<ffffffff811b525c>] journal_try_to_free_buffers+0x58/0x189
> [<ffffffff8117d82c>] ext3_releasepage+0x74/0x93
> [<ffffffff810d09af>] try_to_release_page+0x47/0x64
> [<ffffffff810de710>] shrink_page_list+0x484/0x62a
> [<ffffffff8110f2e5>] ? mem_cgroup_del_lru_list+0x7d/0xa2
> [<ffffffff810df116>] shrink_list+0x2fe/0x674
> [<ffffffff810da1f0>] ? get_dirty_limits+0x36/0x282
> [<ffffffff8104788b>] ? pick_next_task_fair+0xbf/0xe1
> [<ffffffff810df748>] shrink_zone+0x2bc/0x35f
> [<ffffffff810e008e>] kswapd+0x493/0x649
> [<ffffffff810ddf56>] ? isolate_pages_global+0x0/0x222
> [<ffffffff81070663>] ? autoremove_wake_function+0x0/0x5f
> [<ffffffff810dfbfb>] ? kswapd+0x0/0x649
> [<ffffffff81070171>] kthread+0x6d/0xae
> [<ffffffff810528e7>] ? schedule_tail+0x38/0xa3
> [<ffffffff8101310a>] child_rip+0xa/0x20
> [<ffffffff81070104>] ? kthread+0x0/0xae
> [<ffffffff81013100>] ? child_rip+0x0/0x20
> Code: c9 c3 55 48 89 e5 48 83 ec 10 0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00
> 48 89 45 f8 31 c0 eb 0b f3 90 0f a3 3e 19 c0 85 c0 75 f5 <f0> 0f ab 3e 19 c0 85
> c0 75 ed 48 8b 45 f8 65 48 33 04 25 28 00 
> RIP  [<ffffffff811b99c7>] bit_spin_lock+0x29/0x49
> RSP <ffff88033ca8f900>
> CR2: 0000000000000000
> ---[ end trace 69e0d92a3fdf35cd ]---

