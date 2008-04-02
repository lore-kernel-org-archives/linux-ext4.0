From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
Date: Wed, 2 Apr 2008 12:30:30 -0700
Message-ID: <20080402123030.67b18bb6.akpm@linux-foundation.org>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org>
	<6495.1207163569@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, jack@suse.cz, jbacik@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Valdis.Kletnieks@vt.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754966AbYDBTbI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Apr 2008 15:31:08 -0400
In-Reply-To: <6495.1207163569@turing-police.cc.vt.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 02 Apr 2008 15:12:49 -0400
Valdis.Kletnieks@vt.edu wrote:

> On Tue, 01 Apr 2008 21:32:14 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> 
> (Yes, I know the kernel is tainted.  Hopefully the traceback will make
> enough sense that it won't matter.  I think I cc'd most everybody who is
> listed in MAINTAINERS or had a non-trivial jbd, quota, or ext3 patch in the broken-out/)
> 
> So I was running a 'yum update' on my laptop, walked away to ask a cow-orker
> a question, and came back to find it had BUG'ed twice...  Amazingly
> enough, although it died in ext3 code, it apparently only nuked whatever
> filesystem it was handling, as syslog was still able to log the gory details
> into a file in /var. Given that a kernel rpm was the one it failed on, the
> I/O was almost certainly on either / or /boot - both ext3. / is mounted
> with quotas, /boot isn't, so I'm betting on /
> 
> Apr  2 13:48:07 turing-police yum: Updated: texlive-texmf-latex-2007-18.fc9.noarch
> Apr  2 13:48:08 turing-police yum: Updated: 1:openoffice.org-xsltfilter-2.4.0-12.4.fc9.x86_64
> Apr  2 13:48:09 turing-police yum: Updated: 1:openoffice.org-javafilter-2.4.0-12.4.fc9.x86_64
> Apr  2 13:48:12 turing-police yum: Updated: kernel-headers-2.6.25-0.185.rc7.git6.fc9.x86_64
> 
> (here, it started updating kernel-2.6.25-0.185.rc7.git6 and died while I wasn't looking)
> 
> [34895.379293] ------------[ cut here ]------------
> [34895.379299] kernel BUG at fs/jbd/transaction.c:275!
> [34895.379302] invalid opcode: 0000 [1] PREEMPT SMP 
> [34895.379306] last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
> [34895.379309] CPU 0 
> [34895.379311] Modules linked in: gspca(U) compat_ioctl32 videodev v4l1_compat irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt coretemp vmnet(P)(U) vmmon(P)(U) nf_conntrack_ftp xt_pkttype ipt_REJECT ipt_osf nf_conntrack_ipv4 xt_ipisforif ipt_recent ipt_LOG xt_u32 iptable_filter ip_tables xt_tcpudp nf_conntrack_ipv6 xt_state nf_conntrack ip6t_LOG xt_limit ip6table_filter ip6_tables x_tables sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 pcmcia ecb iwl3945 yenta_socket nvidia(P)(U) iTCO_wdt firmware_class iTCO_vendor_support rsrc_nonstatic mac80211 video watchdog_core thermal ohci1394 pcmcia_core output ieee1394 watchdog_dev processor intel_agp snd_hda_intel(U) battery bay button ac cfg80211 [last unloaded: microcode]
> [34895.379371] Pid: 24617, comm: yum Tainted: P          2.6.25-rc8-mm1 #3
> [34895.379373] RIP: 0010:[<ffffffff80300ba7>]  [<ffffffff80300ba7>] journal_start+0x57/0xef
> [34895.379381] RSP: 0018:ffff81000cc49918  EFLAGS: 00010202
> [34895.379383] RAX: 0000000000000001 RBX: ffff81007f6bbf00 RCX: ffff8100347db970
> [34895.379386] RDX: ffff8100347b7d00 RSI: 0000000000000001 RDI: ffffffff806f3530
> [34895.379388] RBP: ffff81000cc49938 R08: 8000000000000000 R09: ffff8100347dbeb8
> [34895.379390] R10: 0000000000000004 R11: ffff8100347d9b58 R12: ffff81007e67d400
> [34895.379393] R13: 0000000000000012 R14: ffff81000cc499d8 R15: 0000000000000080
> [34895.379396] FS:  00007fe4468356f0(0000) GS:ffffffff8073f000(0000) knlGS:0000000000000000
> [34895.379398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [34895.379401] CR2: 00007f9921d00000 CR3: 000000000cdc3000 CR4: 00000000000006e0
> [34895.379403] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [34895.379405] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
> [34895.379408] Process yum (pid: 24617, threadinfo ffff81000cc48000, task ffff81000cc7c580)
> [34895.379410] Stack:  0000000000000292 ffff8100347dbd30 ffff8100347dbd30 ffff8100347dbd30
> [34895.379417]  ffff81000cc49948 ffffffff802f9659 ffff81000cc49978 ffffffff802f9912
> [34895.379422]  ffff8100347dbd30 ffff8100347dbd30 ffff8100347dbd30 0000000000000004
> [34895.379427] Call Trace:
> [34895.379433]  [<ffffffff802f9659>] ext3_journal_start_sb+0x4a/0x4c
> [34895.379437]  [<ffffffff802f9912>] ext3_dquot_drop+0x37/0x81
> [34895.379443]  [<ffffffff802aa757>] clear_inode+0xe1/0x153
> [34895.379448]  [<ffffffff802aa86f>] dispose_list+0x43/0xf8
> [34895.379453]  [<ffffffff802aaaec>] shrink_icache_memory+0x1c8/0x1fe
> [34895.379459]  [<ffffffff8027a231>] shrink_slab+0x111/0x1cf
> [34895.379466]  [<ffffffff8027ae60>] try_to_free_pages+0x26d/0x35e
> [34895.379473]  [<ffffffff80278e67>] ? isolate_pages_global+0x0/0x34
> [34895.379479]  [<ffffffff8027537b>] __alloc_pages_internal+0x297/0x421
> [34895.379488]  [<ffffffff8027551b>] __alloc_pages+0xb/0xd
> [34895.379493]  [<ffffffff802920e3>] cache_alloc_refill+0x2d3/0x533
> [34895.379499]  [<ffffffff80555548>] ? _spin_unlock+0x38/0x43
> [34895.379505]  [<ffffffff80291dd0>] kmem_cache_alloc+0x5d/0x9d
> [34895.379512]  [<ffffffff8033af82>] selinux_inode_alloc_security+0x31/0x8a
> [34895.379517]  [<ffffffff80331f47>] security_inode_alloc+0x1c/0x1e
> [34895.379521]  [<ffffffff802aa4f2>] alloc_inode+0xe1/0x1da
> [34895.379526]  [<ffffffff802aa60c>] new_inode+0x21/0x8b
> [34895.379531]  [<ffffffff802ed5f7>] ext3_new_inode+0x55/0xa2a
> [34895.379539]  [<ffffffff80300c07>] ? journal_start+0xb7/0xef
> [34895.379545]  [<ffffffff802f48c8>] ext3_mkdir+0xc7/0x2e6
> [34895.379551]  [<ffffffff8029eb02>] vfs_mkdir+0xe6/0x17b
> [34895.379556]  [<ffffffff802a1305>] sys_mkdirat+0xf3/0x149
> [34895.379566]  [<ffffffff80213511>] ? syscall_trace_enter+0xa4/0xa9
> [34895.379571]  [<ffffffff802a136e>] sys_mkdir+0x13/0x15
> [34895.379574]  [<ffffffff8020c3c2>] tracesys+0xd5/0xda
> [34895.379581] 

The backtrace tells it all - we were inside a transaction for filesystem A,
went into page reclaim, reclaimed an inode for filesystem B and then
DQUOT_DROP() tried to start a transaction on filesystem B.  JBD doesn't
like cross-fs nested transactions (it'll corrupt task_struct.journal_info,
and will cause ab/ba deadlocks).  So it went BUG.

Presumably something in the quota updates in -mm caused this.
