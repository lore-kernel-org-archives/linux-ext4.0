Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC442E8E4
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 08:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782982587; cv=none; b=rQ796IgduT1oJbK3wnuyBwzk9bncj/XTKr0DVvmLu8qgwTQ28o3yT8KVGk6pCF3LzeeOPKULmYQrKPNE7QehcZOTt0zASrzvKVyn0xf1NcNI6qy2ExbNCs7DaOxqmCWZrhfV3LQ3JBzGN6I1H84W8p5p03ozGfSbE9vPtkdXwWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782982587; c=relaxed/simple;
	bh=UWNtK3ujegKV6sB5l8a3PP64YQ0hsZ3EVVyjwVlNg5U=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=m0xlnF4+zsyde2/PNA6e/JYDoaVJXG+iMATZIXDonqK8JlDld3xb3DXz1Qf2BcMo36HjWloD270s2Ot4BJ7fSHwi6TU5azN1IsZer8uikyia4by0kx+hjv9Mr7o9Ek2bpkITzETOusGUQ3/1jPJsjMqYHaPwKvRdYSjomxLN8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4grVd02dsPzXKh
	for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 10:37:35 +0200 (CEST)
Message-ID: <e4d95384-849b-45a8-960f-ee6db1f283b2@thelounge.net>
Date: Thu, 2 Jul 2026 10:37:35 +0200
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-ext4@vger.kernel.org
Content-Language: en-US
From: Reindl Harald <h.reindl@thelounge.net>
Subject: WARNING: mm/page_alloc.c:4749 at
 __alloc_pages_slowpath.constprop.0+0x49c/0xb80
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

not sure but that seems to be in the ext4 codepath and happens regulary 
on several virtual machines and over many kernel versions, no of them 
having any swap configured

[Tue Jun 30 15:21:03 2026] ------------[ cut here ]------------
[Tue Jun 30 15:21:03 2026] WARNING: mm/page_alloc.c:4749 at 
__alloc_pages_slowpath.constprop.0+0x49c/0xb80, CPU#1: kswapd0/51
[Tue Jun 30 15:21:03 2026] Modules linked in: ipt_REJECT nf_reject_ipv4 
xt_iprange xt_multiport xt_conntrack nf_conntrack nf_defrag_ipv6 
nf_defrag_ipv4 nft_compat nf_tables vmxnet3 ptp_vmw nfnetlink 
ghash_clmulni_intel vmw_pvscsi
[Tue Jun 30 15:21:03 2026] CPU: 1 UID: 0 PID: 51 Comm: kswapd0 Not 
tainted 7.0.14-100.fc43.x86_64 #1 PREEMPT(lazy)
[Tue Jun 30 15:21:03 2026] Hardware name: VMware, Inc. VMware Virtual 
Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
[Tue Jun 30 15:21:03 2026] RIP: 
0010:__alloc_pages_slowpath.constprop.0+0x49c/0xb80
[Tue Jun 30 15:21:03 2026] Code: c7 44 24 18 01 00 00 00 85 c0 0f 84 e3 
fb ff ff 65 48 8b 05 0e 5d 2f 03 c7 44 24 30 00 80 00 00 f6 40 2d 08 0f 
84 c9 fb ff ff <0f> 0b e9 c2 fb ff ff 65 48 8b 05 ed 5c 2f 03 f6 40 2d 
02 0f 84 34
[Tue Jun 30 15:21:03 2026] RSP: 0018:ffffce7540663600 EFLAGS: 00010202
[Tue Jun 30 15:21:03 2026] RAX: ffff8a1a03a90000 RBX: 0000000000148c48 
RCX: 0000000000000400
[Tue Jun 30 15:21:03 2026] RDX: ffffce75406636d0 RSI: 0000000000000000 
RDI: 0000000000148c48
[Tue Jun 30 15:21:03 2026] RBP: 0000000000000000 R08: 0000000000000881 
R09: 0000000000000000
[Tue Jun 30 15:21:03 2026] R10: 0000000000000000 R11: ffff8a1a9ffd5280 
R12: 0000000000000000
[Tue Jun 30 15:21:03 2026] R13: ffffce75406636d0 R14: 0000000000000000 
R15: 0000000000148c48
[Tue Jun 30 15:21:03 2026] FS:  0000000000000000(0000) 
GS:ffff8a1af0aa0000(0000) knlGS:0000000000000000
[Tue Jun 30 15:21:03 2026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Tue Jun 30 15:21:03 2026] CR2: 00007f22dfc52358 CR3: 0000000008244006 
CR4: 00000000007706f0
[Tue Jun 30 15:21:03 2026] PKRU: 55555554
[Tue Jun 30 15:21:03 2026] Call Trace:
[Tue Jun 30 15:21:03 2026]  <TASK>
[Tue Jun 30 15:21:03 2026]  ? update_load_avg+0x73/0x240
[Tue Jun 30 15:21:03 2026]  ? get_page_from_freelist+0x33e/0x720
[Tue Jun 30 15:21:03 2026]  __alloc_frozen_pages_noprof+0x31a/0x360
[Tue Jun 30 15:21:03 2026]  alloc_pages_mpol+0x86/0x190
[Tue Jun 30 15:21:03 2026]  folio_alloc_noprof+0x5e/0xf0
[Tue Jun 30 15:21:03 2026]  __filemap_get_folio_mpol+0x1ee/0x330
[Tue Jun 30 15:21:03 2026]  __getblk_slow+0x80/0x200
[Tue Jun 30 15:21:03 2026]  __ext4_get_inode_loc+0x155/0x510
[Tue Jun 30 15:21:03 2026]  ? ext4_get_inode_loc+0x3f/0xa0
[Tue Jun 30 15:21:03 2026]  ? start_this_handle+0x151/0x4f0
[Tue Jun 30 15:21:03 2026]  ext4_get_inode_loc+0x3f/0xa0
[Tue Jun 30 15:21:03 2026]  ext4_reserve_inode_write+0x4d/0x100
[Tue Jun 30 15:21:03 2026]  __ext4_mark_inode_dirty+0x72/0x250
[Tue Jun 30 15:21:03 2026]  ext4_dirty_inode+0x5b/0x80
[Tue Jun 30 15:21:03 2026]  __mark_inode_dirty+0x63/0x3f0
[Tue Jun 30 15:21:03 2026]  sync_lazytime+0x11e/0x140
[Tue Jun 30 15:21:03 2026]  iput+0x4e/0x210
[Tue Jun 30 15:21:03 2026]  ? dentry_unlink_inode+0x8b/0x110
[Tue Jun 30 15:21:03 2026]  __dentry_kill+0x6b/0x190
[Tue Jun 30 15:21:03 2026]  shrink_dentry_list+0x68/0xe0
[Tue Jun 30 15:21:03 2026]  prune_dcache_sb+0x59/0x80
[Tue Jun 30 15:21:03 2026]  super_cache_scan+0x129/0x1e0
[Tue Jun 30 15:21:03 2026]  do_shrink_slab+0x147/0x3e0
[Tue Jun 30 15:21:03 2026]  shrink_slab_memcg+0x181/0x270
[Tue Jun 30 15:21:03 2026]  shrink_one+0xd9/0x1a0
[Tue Jun 30 15:21:03 2026]  shrink_many+0x152/0x2d0
[Tue Jun 30 15:21:03 2026]  shrink_node+0x4a5/0x570
[Tue Jun 30 15:21:03 2026]  ? lru_gen_age_node+0x64/0x220
[Tue Jun 30 15:21:03 2026]  balance_pgdat+0x30d/0x920
[Tue Jun 30 15:21:03 2026]  kswapd+0xe3/0x180
[Tue Jun 30 15:21:03 2026]  ? __pfx_kswapd+0x10/0x10
[Tue Jun 30 15:21:03 2026]  kthread+0xe3/0x120
[Tue Jun 30 15:21:03 2026]  ? __pfx_kthread+0x10/0x10
[Tue Jun 30 15:21:03 2026]  ret_from_fork+0x1a1/0x270
[Tue Jun 30 15:21:03 2026]  ? __pfx_kthread+0x10/0x10
[Tue Jun 30 15:21:03 2026]  ret_from_fork_asm+0x1a/0x30
[Tue Jun 30 15:21:03 2026]  </TASK>
[Tue Jun 30 15:21:03 2026] ---[ end trace 0000000000000000 ]---
