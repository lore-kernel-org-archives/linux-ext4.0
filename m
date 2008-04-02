From: Valdis.Kletnieks@vt.edu
Subject: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Wed, 02 Apr 2008 15:12:49 -0400
Message-ID: <6495.1207163569@turing-police.cc.vt.edu>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1207163569_3351P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33500 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYDBTNm (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 15:13:42 -0400
In-Reply-To: Your message of "Tue, 01 Apr 2008 21:32:14 PDT."
             <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1207163569_3351P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/

(Yes, I know the kernel is tainted.  Hopefully the traceback will make
enough sense that it won't matter.  I think I cc'd most everybody who is
listed in MAINTAINERS or had a non-trivial jbd, quota, or ext3 patch in the broken-out/)

So I was running a 'yum update' on my laptop, walked away to ask a cow-orker
a question, and came back to find it had BUG'ed twice...  Amazingly
enough, although it died in ext3 code, it apparently only nuked whatever
filesystem it was handling, as syslog was still able to log the gory details
into a file in /var. Given that a kernel rpm was the one it failed on, the
I/O was almost certainly on either / or /boot - both ext3. / is mounted
with quotas, /boot isn't, so I'm betting on /

Apr  2 13:48:07 turing-police yum: Updated: texlive-texmf-latex-2007-18.fc9.noarch
Apr  2 13:48:08 turing-police yum: Updated: 1:openoffice.org-xsltfilter-2.4.0-12.4.fc9.x86_64
Apr  2 13:48:09 turing-police yum: Updated: 1:openoffice.org-javafilter-2.4.0-12.4.fc9.x86_64
Apr  2 13:48:12 turing-police yum: Updated: kernel-headers-2.6.25-0.185.rc7.git6.fc9.x86_64

(here, it started updating kernel-2.6.25-0.185.rc7.git6 and died while I wasn't looking)

[34895.379293] ------------[ cut here ]------------
[34895.379299] kernel BUG at fs/jbd/transaction.c:275!
[34895.379302] invalid opcode: 0000 [1] PREEMPT SMP 
[34895.379306] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
[34895.379309] CPU 0 
[34895.379311] Modules linked in: gspca(U) compat_ioctl32 videodev v4l1_compat irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp vmnet(P)(U) vmmon(P)(U) nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 pcmcia ecb iwl3945 yenta_socket nvidia(P)(U) iTCO_wdt firmware_class iTCO_vendor_support rsrc_nonstatic mac80211 video watchdog_core thermal ohci1394 pcmcia_core output ieee1394 watchdog_dev processor intel_agp snd_hda_intel(U) battery bay button ac cfg80211 [last unloaded: microcode]
[34895.379371] Pid: 24617, comm: yum Tainted: P          2.6.25-rc8-mm1 #3
[34895.379373] RIP: 0010:[<ffffffff80300ba7>]  [<ffffffff80300ba7>] journal_start+0x57/0xef
[34895.379381] RSP: 0018:ffff81000cc49918  EFLAGS: 00010202
[34895.379383] RAX: 0000000000000001 RBX: ffff81007f6bbf00 RCX: ffff8100347db970
[34895.379386] RDX: ffff8100347b7d00 RSI: 0000000000000001 RDI: ffffffff806f3530
[34895.379388] RBP: ffff81000cc49938 R08: 8000000000000000 R09: ffff8100347dbeb8
[34895.379390] R10: 0000000000000004 R11: ffff8100347d9b58 R12: ffff81007e67d400
[34895.379393] R13: 0000000000000012 R14: ffff81000cc499d8 R15: 0000000000000080
[34895.379396] FS:  00007fe4468356f0(0000) GS:ffffffff8073f000(0000) knlGS:0000000000000000
[34895.379398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34895.379401] CR2: 00007f9921d00000 CR3: 000000000cdc3000 CR4: 00000000000006e0
[34895.379403] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[34895.379405] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[34895.379408] Process yum (pid: 24617, threadinfo ffff81000cc48000, task ffff81000cc7c580)
[34895.379410] Stack:  0000000000000292 ffff8100347dbd30 ffff8100347dbd30 ffff8100347dbd30
[34895.379417]  ffff81000cc49948 ffffffff802f9659 ffff81000cc49978 ffffffff802f9912
[34895.379422]  ffff8100347dbd30 ffff8100347dbd30 ffff8100347dbd30 0000000000000004
[34895.379427] Call Trace:
[34895.379433]  [<ffffffff802f9659>] ext3_journal_start_sb+0x4a/0x4c
[34895.379437]  [<ffffffff802f9912>] ext3_dquot_drop+0x37/0x81
[34895.379443]  [<ffffffff802aa757>] clear_inode+0xe1/0x153
[34895.379448]  [<ffffffff802aa86f>] dispose_list+0x43/0xf8
[34895.379453]  [<ffffffff802aaaec>] shrink_icache_memory+0x1c8/0x1fe
[34895.379459]  [<ffffffff8027a231>] shrink_slab+0x111/0x1cf
[34895.379466]  [<ffffffff8027ae60>] try_to_free_pages+0x26d/0x35e
[34895.379473]  [<ffffffff80278e67>] ? isolate_pages_global+0x0/0x34
[34895.379479]  [<ffffffff8027537b>] __alloc_pages_internal+0x297/0x421
[34895.379488]  [<ffffffff8027551b>] __alloc_pages+0xb/0xd
[34895.379493]  [<ffffffff802920e3>] cache_alloc_refill+0x2d3/0x533
[34895.379499]  [<ffffffff80555548>] ? _spin_unlock+0x38/0x43
[34895.379505]  [<ffffffff80291dd0>] kmem_cache_alloc+0x5d/0x9d
[34895.379512]  [<ffffffff8033af82>] selinux_inode_alloc_security+0x31/0x8a
[34895.379517]  [<ffffffff80331f47>] security_inode_alloc+0x1c/0x1e
[34895.379521]  [<ffffffff802aa4f2>] alloc_inode+0xe1/0x1da
[34895.379526]  [<ffffffff802aa60c>] new_inode+0x21/0x8b
[34895.379531]  [<ffffffff802ed5f7>] ext3_new_inode+0x55/0xa2a
[34895.379539]  [<ffffffff80300c07>] ? journal_start+0xb7/0xef
[34895.379545]  [<ffffffff802f48c8>] ext3_mkdir+0xc7/0x2e6
[34895.379551]  [<ffffffff8029eb02>] vfs_mkdir+0xe6/0x17b
[34895.379556]  [<ffffffff802a1305>] sys_mkdirat+0xf3/0x149
[34895.379566]  [<ffffffff80213511>] ? syscall_trace_enter+0xa4/0xa9
[34895.379571]  [<ffffffff802a136e>] sys_mkdir+0x13/0x15
[34895.379574]  [<ffffffff8020c3c2>] tracesys+0xd5/0xda
[34895.379581] 
[34895.379582] 
[34895.379583] Code: 00 0f 84 b1 00 00 00 48 89 c3 48 85 c0 74 28 48 8b 00 31 f6 48 39 38 48 c7 c7 30 35 6f 80 40 0f 95 c6 e8 00 a5 07 00 85 c0 74 04 <0f> 0b eb fe ff 43 0c e9 81 00 00 00 48 8b 3d fe dc 50 00 be 50 
[34895.379621] RIP  [<ffffffff80300ba7>] journal_start+0x57/0xef
[34895.379624]  RSP <ffff81000cc49918>
[34895.382684] ---[ end trace 210b9a92878f99d6 ]---
[34895.411910] ------------[ cut here ]------------
[34895.411916] kernel BUG at fs/jbd/transaction.c:275!
[34895.411919] invalid opcode: 0000 [2] PREEMPT SMP 
[34895.411923] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
[34895.411926] CPU 1 
[34895.411928] Modules linked in: gspca(U) compat_ioctl32 videodev v4l1_compat irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp vmnet(P)(U) vmmon(P)(U) nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 pcmcia ecb iwl3945 yenta_socket nvidia(P)(U) iTCO_wdt firmware_class iTCO_vendor_support rsrc_nonstatic mac80211 video watchdog_core thermal ohci1394 pcmcia_core output ieee1394 watchdog_dev processor intel_agp snd_hda_intel(U) battery bay button ac cfg80211 [last unloaded: microcode]
[34895.411988] Pid: 24617, comm: yum Tainted: P      D   2.6.25-rc8-mm1 #3
[34895.411990] RIP: 0010:[<ffffffff80300ba7>]  [<ffffffff80300ba7>] journal_start+0x57/0xef
[34895.411998] RSP: 0000:ffff81000cc491c8  EFLAGS: 00010202
[34895.412001] RAX: 0000000000000001 RBX: ffff81007f6bbf00 RCX: 0000000000000001
[34895.412003] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff806f3530
[34895.412005] RBP: ffff81000cc491e8 R08: 0000000000000003 R09: ffff81000cc49638
[34895.412008] R10: 0000000000000002 R11: 0000001000000000 R12: ffff81007e642000
[34895.412010] R13: 0000000000000002 R14: 0000000000f93280 R15: ffff81007de17400
[34895.412013] FS:  00007fe4468356f0(0000) GS:ffff81007f84d840(0000) knlGS:0000000000000000
[34895.412016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34895.412018] CR2: 00007f9921d00000 CR3: 000000007dea4000 CR4: 00000000000006e0
[34895.412020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[34895.412023] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[34895.412025] Process yum (pid: 24617, threadinfo ffff81000cc48000, task ffff81000cc7c580)
[34895.412027] Stack:  ffff81000cc49228 ffff810075ce8cf0 ffff81007f6bbf00 ffff810075ce8cf0
[34895.412034]  ffff81000cc491f8 ffffffff802f9659 ffff81000cc49228 ffffffff802ef105
[34895.412039]  ffff81000cc49218 ffff810075ce8cf0 0000000000000001 ffff81007de019c0
[34895.412044] Call Trace:
[34895.412051]  [<ffffffff802f9659>] ext3_journal_start_sb+0x4a/0x4c
[34895.412055]  [<ffffffff802ef105>] ext3_dirty_inode+0x31/0x97
[34895.412062]  [<ffffffff802b5d92>] __mark_inode_dirty+0x33/0x199
[34895.412069]  [<ffffffff802a9d3e>] file_update_time+0xbd/0x101
[34895.412077]  [<ffffffff80271164>] __generic_file_aio_write_nolock+0x31a/0x463
[34895.412081]  [<ffffffff8036ede9>] ? number+0x113/0x216
[34895.412088]  [<ffffffff80273dff>] ? free_pages_bulk+0x1fe/0x254
[34895.412095]  [<ffffffff80271325>] generic_file_aio_write+0x78/0xd4
[34895.412101]  [<ffffffff802ed1a3>] ext3_file_write+0x1e/0x9f
[34895.412106]  [<ffffffff802950a9>] do_sync_write+0xe7/0x12d
[34895.412110]  [<ffffffff80335fd7>] ? avc_has_perm+0x4e/0x60
[34895.412119]  [<ffffffff80245c3e>] ? autoremove_wake_function+0x0/0x38
[34895.412125]  [<ffffffff80555548>] ? _spin_unlock+0x38/0x43
[34895.412129]  [<ffffffff80373c26>] ? __list_add+0x62/0x9a
[34895.412134]  [<ffffffff80555479>] ? _spin_unlock_irqrestore+0x3a/0x45
[34895.412138]  [<ffffffff8023b4f8>] ? __mod_timer+0xe6/0xf8
[34895.412143]  [<ffffffff8024a874>] ? getnstimeofday+0x90/0x9e
[34895.412149]  [<ffffffff80259b77>] do_acct_process+0x539/0x572
[34895.412154]  [<ffffffff80373c26>] ? __list_add+0x62/0x9a
[34895.412167]  [<ffffffff80259c1f>] acct_process+0x6f/0x7c
[34895.412173]  [<ffffffff80235a1d>] do_exit+0x38c/0x90b
[34895.412179]  [<ffffffff80555dcd>] oops_begin+0x0/0x90
[34895.412185]  [<ffffffff8020ddb2>] die+0x5d/0x66
[34895.412190]  [<ffffffff80556326>] do_trap+0x110/0x11f
[34895.412195]  [<ffffffff8020e486>] do_invalid_op+0x93/0x9c
[34895.412199]  [<ffffffff80300ba7>] ? journal_start+0x57/0xef
[34895.412203]  [<ffffffff80277a7b>] ? release_pages+0x197/0x1a9
[34895.412209]  [<ffffffff802ff1fb>] ? journal_try_to_free_buffers+0x1f4/0x201
[34895.412213]  [<ffffffff80555839>] error_exit+0x0/0x51
[34895.412221]  [<ffffffff80300ba7>] ? journal_start+0x57/0xef
[34895.412225]  [<ffffffff80300ba3>] ? journal_start+0x53/0xef
[34895.412230]  [<ffffffff802f9659>] ? ext3_journal_start_sb+0x4a/0x4c
[34895.412234]  [<ffffffff802f9912>] ? ext3_dquot_drop+0x37/0x81
[34895.412239]  [<ffffffff802aa757>] ? clear_inode+0xe1/0x153
[34895.412243]  [<ffffffff802aa86f>] ? dispose_list+0x43/0xf8
[34895.412248]  [<ffffffff802aaaec>] ? shrink_icache_memory+0x1c8/0x1fe
[34895.412255]  [<ffffffff8027a231>] ? shrink_slab+0x111/0x1cf
[34895.412261]  [<ffffffff8027ae60>] ? try_to_free_pages+0x26d/0x35e
[34895.412268]  [<ffffffff80278e67>] ? isolate_pages_global+0x0/0x34
[34895.412274]  [<ffffffff8027537b>] ? __alloc_pages_internal+0x297/0x421
[34895.412282]  [<ffffffff8027551b>] ? __alloc_pages+0xb/0xd
[34895.412287]  [<ffffffff802920e3>] ? cache_alloc_refill+0x2d3/0x533
[34895.412291]  [<ffffffff80555548>] ? _spin_unlock+0x38/0x43
[34895.412298]  [<ffffffff80291dd0>] ? kmem_cache_alloc+0x5d/0x9d
[34895.412304]  [<ffffffff8033af82>] ? selinux_inode_alloc_security+0x31/0x8a
[34895.412309]  [<ffffffff80331f47>] ? security_inode_alloc+0x1c/0x1e
[34895.412313]  [<ffffffff802aa4f2>] ? alloc_inode+0xe1/0x1da
[34895.412318]  [<ffffffff802aa60c>] ? new_inode+0x21/0x8b
[34895.412323]  [<ffffffff802ed5f7>] ? ext3_new_inode+0x55/0xa2a
[34895.412332]  [<ffffffff80300c07>] ? journal_start+0xb7/0xef
[34895.412337]  [<ffffffff802f48c8>] ? ext3_mkdir+0xc7/0x2e6
[34895.412344]  [<ffffffff8029eb02>] ? vfs_mkdir+0xe6/0x17b
[34895.412348]  [<ffffffff802a1305>] ? sys_mkdirat+0xf3/0x149
[34895.412358]  [<ffffffff80213511>] ? syscall_trace_enter+0xa4/0xa9
[34895.412363]  [<ffffffff802a136e>] ? sys_mkdir+0x13/0x15
[34895.412367]  [<ffffffff8020c3c2>] ? tracesys+0xd5/0xda
[34895.412373] 
[34895.412374] 
[34895.412375] Code: 00 0f 84 b1 00 00 00 48 89 c3 48 85 c0 74 28 48 8b 00 31 f6 48 39 38 48 c7 c7 30 35 6f 80 40 0f 95 c6 e8 00 a5 07 00 85 c0 74 04 <0f> 0b eb fe ff 43 0c e9 81 00 00 00 48 8b 3d fe dc 50 00 be 50 
[34895.412413] RIP  [<ffffffff80300ba7>] journal_start+0x57/0xef
[34895.412417]  RSP <ffff81000cc491c8>
[34895.412425] ---[ end trace 210b9a92878f99d6 ]---
[34895.412428] Fixing recursive fault but reboot is needed!


--==_Exmh_1207163569_3351P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH89qxcC3lWbTT17ARAqCAAKCQXi2KflD4mZiUYw6bXGM506/EjACfaBh3
wtI0DHLvjJwQ6uN7o1YmWAU=
=aLzU
-----END PGP SIGNATURE-----

--==_Exmh_1207163569_3351P--
