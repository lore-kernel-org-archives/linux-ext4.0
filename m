Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3426227BB9
	for <linux-ext4@vger.kernel.org>; Tue,  7 Jul 2026 23:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783468291; cv=pass; b=aozrH+xTB1747Zuc9xDCbJLwbzAYBInqKtok5dUCyS0IIbzrgcQYepxVTJGqHRoIjIexzQPYz+RorYZQuV0sUlAdlzmrVsLs/iKedIV9hAtdrUKsk03dvY26ZpfpaRsIKHjyztyo2zSB2uTfJfRrVMgXeKbaGRDYndNf8pMVEMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783468291; c=relaxed/simple;
	bh=fCdKrt6S52Rs+o5Li+xODoASMkI82WdBePlDaUxEWt8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=X0uLsQ3Iu/Dmbz4NGxHra9CBVAZY9I9SUnRo7eRgiYp6RK/XWoEXhlCDbC5CEcg8GjaG2XrrdfkbcIKD6OMLhMWm20vXC7RJeifyAWH1Dnus7t1CX/aCXz+CH3ma4lUeS0OKNulz2gxqTEj8H/DFnKMOmd9jRe0ImunSwW3uG+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qEgCVH33; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEgCVH33"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15c7c07a57so6271466b.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jul 2026 16:51:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783468288; cv=none;
        d=google.com; s=arc-20260327;
        b=PO2M1XopE5tBPv0HG1MhWfk8M0jCl8RI8KVfrIL9rg064pgrDJhzKLdSVPY2husAO5
         D9s5SUjHtXvrr8JlxsgFbJMt00/6yBbwO4LzibdneexTvVLaqZP6Kx76EF2o9o+o5jNu
         rMdKUZV9oKURlzaY3MS5xcgY0juaXInlPLmG51AUA71hqejpjYhxMBuqSj0sV5OvbBUB
         E7oYPocmP2GJjE5QnbKvKKeqzSIlS0RT++IGIkO5obTu3EmoxGtG81wcnz9F8Jex0o1s
         +mnWc6ZkJJc3s4caUCiF+monmPLIQPuYHo5TRis6cteJ2fJwAh77su5fMip/oefHnUf2
         e7uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        fh=wsh9FgNtVGEreILu8+IRF48LvlgVzo4OVCbdcaZr2VU=;
        b=Zn2zso92QCzv9S/MC37vaE8srI2FuD3vrjlvPVhpJkH7nC2/momjzwqFJH2FqJXdfp
         hlvQIy11pwmlWo1zOq0SSrK+1+hLHjFp/8mBs1dyExNgT2fbWPmoHPzoin7WobEgRE1b
         M8Qc30neC+iMmBrQA2tflwcN6J0orJn7AkNZKRGwoxqVDrmwgrZB+KbYdDyU9wt4UdGj
         SOrxPa4dAtLwERmmAUPqcXU9NFPgKlkamigpoPMdmplulBdPrlvZVhq90V+TBjkWuZez
         vyPIv1RgPFPDMyfuJMqVRz7CXHuxvaTam1xLK/ZfDLH24uZm9IxQ0z3be3BaetDJZY2i
         VnEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783468288; x=1784073088; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        b=qEgCVH33qivamHjJCSeoG9LGqhcg3k6uG6ECz19Tqyz3tUCKdO7FOQSU9MHEsLqhGI
         Tf27CayvCtgpyqYa5LJAjGMdnmxCjnOzN6CosyO6HE3H663UwJ4Zo79bkiWXrKKmMuJD
         ZG83vdVrZVuTCmYeMIomm//Tfy2XcOhfqNCsiPmPpbZhn7690wSIJNFrOsDVNjwsSAYo
         bCSTQFo+w48R9dCuZdJFxAqp6ZZy1MYh5cdTREu9Lf4wKSXRdwTRjylsUsbkc2IdPRJG
         uiQvf9fsrzp7XGiMQ5FPpUfZzg9mK3tRclTihHoGvWJMszl32jxaq6iI25a7J3p6V/gC
         lHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783468288; x=1784073088;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VzQA9Ii47wk5w4/oRPeKvCpxuH7rTBYjW89AULLteQM=;
        b=G7Ad9JquyBOoZCsTwnFqBWW6jbIMefafG1J4daPA0/KV/GvvxHubmACV/ethma4xx9
         VE/SxFi+Hl5s6Gvac6B+5UCl6yqTl1d+fjFLjdW3wQOdnT7/RFPH5a4IO55Mi9IoeftZ
         NWB61uigkgI3m152OWJpGF6aFrqT2UFaKe07t8uB4fEUSFaik2wgH1wRf2l3LdqOtAzP
         9DHuoyPak8c14NxBggPtU4Vh83C/1i7jHaC0dIDcy4rLiIWERpQZcc1INBWcpztDh6mz
         G4PxGl43rT/u51hm5GHlRhIMDNHYYK7Ur9tt1dLrMNXIwnmllEtbNpXabD/hS4xdjTn0
         Ms9Q==
X-Gm-Message-State: AOJu0Yyh5uNrVP9dEky5/Yf2AfE26AOYni7fZcQKf4exjyhbMk3ihDu1
	/A0NAQiWL/YocPqfjxXuGnmJRtR5JQerbptx50tKBGwjQagMbGdKzNFy8APRG8zLiamNXDUKf/x
	su4qe7mYBI0XGITPc4nGNwPwa3LB98uIJh3SaIlQ=
X-Gm-Gg: AfdE7ckx4rZqv9Y8JRnuNNm/tbpCQNE41tihRw33bxd7JxkCFIHFFSmppTFRl5mAwYo
	JLKel/WvJvgMfj0FGFMBVKNhyJYSO3Yq6u5fjoxCwShk4o9vS2VUk+QjDr1hii7Pz6CA6pTzgYA
	8c7DK7PQlCuGc8Rr8phT/NnQKpgOsf86QOXZB0AsFQnBU0/32m69kFrzxw3f+jmjVRSJt31SBTd
	fjKsmIV1LrC9kFQau/E+ASzQ7RilrbqgvFKW3UuHGt49crTK/xy2KTBo8mS20SGATz3Zmd7YfsM
	r/Lt5RiE0juOSk3i3GmhCsN/iDB78w==
X-Received: by 2002:a17:907:2684:b0:c12:cacc:92c6 with SMTP id
 a640c23a62f3a-c15ce229e98mr8955866b.59.1783468287980; Tue, 07 Jul 2026
 16:51:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Michael Hicklen <michael.s.hicklen@gmail.com>
Date: Tue, 7 Jul 2026 18:51:14 -0500
X-Gm-Features: AVVi8Cc5vz3H8zTEQzKttdRKWMwXk_BxE5Jc1EkFsEUUga8KWImXFXYEqUovpuw
Message-ID: <CALhAV-Bzbe5BtGsH=tdd9KBK+53w3Nwy8drWcAkAeq=UyoH4xA@mail.gmail.com>
Subject: kernel NULL pointer dereference in drain_obj_stock during ext4 e4defrag
To: linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, hannes@cmpxchg.org, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"

Kernel: 7.1.2-arch3-1
Arch: x86_64
Hardware: MSI MS-7C95 / PRO B550M-VC WIFI
CPU: AMD (kvm_amd loaded)

Workload:

4 concurrent e4defrag processes operating on 4 separate ext4
filesystems on 4 separate HDDs.

The crash happens during memory reclaim while ext4_move_extents() is running.

First oops:

BUG: kernel NULL pointer dereference, address: 0000000000000676
#PF: supervisor read access in kernel mode

RIP: drain_obj_stock+0x175/0x310

Call trace:

__refill_obj_stock
__memcg_slab_free_hook
kmem_cache_free
free_buffer_head
try_to_free_buffers
shrink_folio_list
evict_folios
try_to_shrink_lruvec
shrink_node
do_try_to_free_pages
try_to_free_pages
__alloc_pages_slowpath
folio_alloc_noprof
__filemap_get_folio_mpol
mext_move_extent
ext4_move_extents
__ext4_ioctl
__x64_sys_ioctl
do_syscall_64

After the initial oops, the kernel also reports:

exited with irqs disabled
exited with preempt_count 1

followed by recursive faults and an eventual hard reboot requirement.

I have not yet reproduced this on a vanilla kernel.

dmesg:

BUG: kernel NULL pointer dereference, address: 0000000000000676
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 0 P4D 0
SMP NOPTI
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:drain_obj_stock+0x175/0x310
Code: 02 48 8b 84 f0 70 06 00 00 48 83 c0 40 48 3b 88 20 06 00 00 0f
85 29 01 00 00 48 8b 40 c0 48 63 89 80 a4 02 00 be 05 00 00 00 <48> 8b
bc c8 70 06 00 00 e8 ee e4 ff ff e8 d9 22 ce ff 8b 53 1c c7
RSP: 0018:ffffd02f86007168 EFLAGS: 00010292
RAX: 0000000000000006 RBX: ffff8ade5ddf4880 RCX: 0000000000000000
RDX: ffffffffffffff90 RSI: 0000000000000005 RDI: ffff8ade5ddf4880
RBP: ffff8ad31b54f5c0 R08: ffff8ad4ff0b1c00 R09: ffffffff97424af2
R10: fffff33ed3692f00 R11: ffff8acf8030f800 R12: ffff8ad31b54e5c0
R13: fffff33ed3692f00 R14: ffff8acf8030f800 R15: ffffd02f86007230
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? srso_alias_return_thunk+0x5/0xfbef5
 __refill_obj_stock+0x36/0x100
 __memcg_slab_free_hook+0xea/0x1b0
 kmem_cache_free+0x284/0x470
 ? free_buffer_head+0x22/0x70
 ? srso_alias_return_thunk+0x5/0xfbef5
 free_buffer_head+0x22/0x70
 try_to_free_buffers+0x9e/0x110
 shrink_folio_list+0xa99/0xfd0
 evict_folios+0x30c/0x7d0
 try_to_shrink_lruvec+0x16c/0x270
 shrink_one+0xcf/0x210
 shrink_node+0xa90/0xcc0
 do_try_to_free_pages+0xac/0x490
 try_to_free_pages+0xfb/0x240
 ? srso_alias_return_thunk+0x5/0xfbef5
 __alloc_pages_slowpath.constprop.0+0x837/0x1170
 __alloc_frozen_pages_noprof+0x31e/0x380
 alloc_pages_mpol+0xb2/0x160
 folio_alloc_noprof+0x54/0xa0
 __filemap_get_folio_mpol+0x17c/0x320
 mext_move_extent+0x1e0/0xcf0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __check_block_validity.constprop.0+0x3d/0x90
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ext4_map_blocks+0x2a3/0x3a0
 ext4_move_extents+0x3b2/0x4e0
 __ext4_ioctl+0x1633/0x1c40
 ? __memcg_slab_free_hook+0x153/0x1b0
 ? kmem_cache_free+0x284/0x470
 ? vms_complete_munmap_vmas+0x179/0x230
 ? vm_area_free+0x24/0xd0
 ? srso_alias_return_thunk+0x5/0xfbef5
 __x64_sys_ioctl+0xb9/0x100
 do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? __vm_munmap+0x133/0x200
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ksys_mmap_pgoff+0x168/0x200
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? ksys_write+0x7b/0x110
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0xaa/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? do_syscall_64+0x5f/0x660
 ? srso_alias_return_thunk+0x5/0xfbef5
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f6aaad17b9d
Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00
00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2
3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CR2: 0000000000000676
---[ end trace 0000000000000000 ]---
RIP: 0010:__refill_obj_stock+0xdd/0x100
Code: f0 01 47 18 c1 eb 0c 89 de 75 b8 48 8b 1c 24 4c 8b 64 24 10 48
83 c4 18 e9 1b 94 98 ff e8 4b 87 cd ff 49 8b 04 24 a8 03 75 0e <65> 48
ff 00 e8 9a 12 ce ff e9 57 ff ff ff 49 8b 44 24 08 f0 48 83
RSP: 0018:ffffd02f85a77a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000070 RCX: fffff02f7f841e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8acf8ad35340
RBP: ffff8ade5de74880 R08: ffffffffffffffff R09: 0000000000000000
R10: fffff33ef5e616c0 R11: ffff8acf8030f800 R12: ffff8acfa2586e00
R13: fffff33ef5e616c0 R14: ffff8acf8030f800 R15: ffffd02f85a77a98
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
exited with irqs disabled
exited with preempt_count 1
------------[ cut here ]------------
tsk->plug
WARNING: kernel/exit.c:903 at do_exit+0x8ee/0xba0, CPU#7: e4defrag/3310
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:do_exit+0x8ee/0xba0
Code: 83 b0 0d 00 00 e9 5a fd ff ff 48 8b bb 70 0b 00 00 31 f6 e8 14
e0 ff ff e9 0d fd ff ff 48 89 df e8 07 6b 17 00 e9 d8 f8 ff ff <0f> 0b
e9 66 f7 ff ff 48 8d 54 24 08 b9 04 00 00 00 31 c0 48 89 d7
RSP: 0018:ffffd02f86007ee0 EFLAGS: 00010286
RAX: 0000000000000282 RBX: ffff8acf81281bc0 RCX: 000000000000270f
RDX: 0000000080000000 RSI: 0000000000002710 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000009 R09: ffff8acf81281bc0
R10: ffffd02f86007de8 R11: ffffd02f86007de0 R12: 0000000000000009
R13: 0000000000000000 R14: ffff8acf81281bc0 R15: 0000000000000000
FS:  00007f6aaaf63780(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000676 CR3: 0000000662da2000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? srso_alias_return_thunk+0x5/0xfbef5
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f6aaad17b9d
Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00
00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2
3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
---[ end trace 0000000000000000 ]---
BUG: unable to handle page fault for address: ffffffffffff0a00
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD aea25067 P4D aea25067 PUD aea27067 PMD 0
SMP NOPTI
CPU: 7 UID: 0 PID: 3310 Comm: e4defrag Tainted: G      D W
7.1.2-arch3-1 #1 PREEMPT(full)
914ec70c9fc54a99dc91d290948a1dd1bb226c49
Tainted: [D]=DIE, [W]=WARN
Hardware name: Micro-Star International Co., Ltd. MS-7C95/PRO B550M-VC
WIFI (MS-7C95), BIOS H.D0 03/21/2025
RIP: 0010:blk_mq_submit_bio+0x80/0x9f0
Code: e6 00 08 06 00 83 fe 01 45 19 f6 41 83 c6 01 89 4c 24 0c 4d 85
e4 0f 84 30 07 00 00 49 8b 6c 24 10 48 85 ed 0f 84 9e 03 00 00 <4c> 3b
6d 00 0f 85 94 03 00 00 48 8b 4d 10 0f b7 b1 fc 00 00 00 39
RSP: 0018:ffffd02f860078a0 EFLAGS: 00010286
RAX: 0000000000000001 RBX: ffff8ad4fb23e600 RCX: 0000000000000000
RDX: 0000000000003000 RSI: ffff8acf81281bc0 RDI: ffff8ad4fb23e600
RBP: ffffffffffff0a00 R08: 00000003a3812000 R09: 0000000000000008
R10: 0000000000001000 R11: ffff8acf8a8e43c0 R12: ffffd02f86007630
R13: ffff8acf893a2f88 R14: 0000000000000001 R15: 0000000000000540
FS:  0000000000000000(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffff0a00 CR3: 00000000aea22000 CR4: 0000000000f50ef0
PKRU: 55555554
Call Trace:
 <TASK>
 ? xas_load+0xd/0xb0
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? filemap_get_entry+0xd5/0x130
 __submit_bio+0xbd/0x260
 ? find_get_block_common+0x369/0x450
 submit_bio_noacct_nocheck+0x2b2/0x390
 ? submit_bh_wbc+0x15b/0x1d0
 ext4_read_block_bitmap_nowait+0x43d/0x6d0
 ext4_mb_init_cache+0x130/0x6f0
 ? __filemap_get_folio_mpol+0x1b4/0x320
 ext4_mb_init_group+0x173/0x390
 ext4_mb_load_buddy_gfp+0x3aa/0x450
 ? srso_alias_return_thunk+0x5/0xfbef5
 ext4_free_blocks+0x3e0/0xaf0
 ? jbd2_write_access_granted+0x67/0x90
 ext4_ext_remove_space+0xabf/0x1480
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? srso_alias_return_thunk+0x5/0xfbef5
 ? ext4_es_remove_extent+0xed/0x1e0
 ext4_ext_truncate+0xa4/0xd0
 ext4_truncate+0x33f/0x4a0
 ? __ext4_journal_start_sb+0x42/0x1b0
 ext4_evict_inode+0x297/0x7a0
 evict+0x13e/0x2b0
 __dentry_kill+0x79/0x1e0
 ? srso_alias_return_thunk+0x5/0xfbef5
 finish_dput+0x23/0xc0
 __fput+0x146/0x2d0
 task_work_run+0x66/0xa0
 ? srso_alias_return_thunk+0x5/0xfbef5
 do_exit+0x304/0xba0
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f6aaad17b9d
Code: Unable to access opcode bytes at 0x7f6aaad17b73.
RSP: 002b:00007ffdf0e0f0a0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f6aaad17b9d
RDX: 00007ffdf0e0f190 RSI: 00000000c028660f RDI: 0000000000000007
RBP: 00007ffdf0e0f0f0 R08: 0000000000017000 R09: 00007f6aaae12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000017000000
R13: 00005620cd1d5690 R14: 0000000000001000 R15: 00007f6a93c00000
 </TASK>
Modules linked in: xt_connmark xt_conntrack xt_MASQUERADE xt_tcpudp
xt_mark nft_compat x_tables nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 tun nf_tables nfnetlink vfat fat amd_atl
intel_rapl_msr intel_rapl_common snd_hda_codec_alc662
snd_hda_codec_realtek_lib snd_hda_codec_generic mt7921e
snd_hda_codec_atihdmi mt7921_common snd_hda_codec_hdmi mt792x_lib
btusb snd_hda_intel mt76_connac_lib kvm_amd btmtk mt76 snd_hda_codec
mac80211 snd_hda_core btrtl btbcm snd_intel_dspcfg kvm r8169 btintel
snd_intel_sdw_acpi jc42 snd_hwdep realtek irqbypass phy_package
cfg80211 bluetooth snd_pcm ee1004 aesni_intel mdio_devres gf128mul
sp5100_tco rfkill snd_timer rapl libphy wmi_bmof libarc4 i2c_piix4
aead snd pcspkr mdio_bus k10temp ccp i2c_smbus joydev soundcore
gpio_amdpt gpio_generic mac_hid dm_mod amdgpu drm_buddy amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme drm_display_helper video nvme_core
cec nvme_keyring nvme_auth wmi
CR2: ffffffffffff0a00
---[ end trace 0000000000000000 ]---
RIP: 0010:__refill_obj_stock+0xdd/0x100
Code: f0 01 47 18 c1 eb 0c 89 de 75 b8 48 8b 1c 24 4c 8b 64 24 10 48
83 c4 18 e9 1b 94 98 ff e8 4b 87 cd ff 49 8b 04 24 a8 03 75 0e <65> 48
ff 00 e8 9a 12 ce ff e9 57 ff ff ff 49 8b 44 24 08 f0 48 83
RSP: 0018:ffffd02f85a77a10 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000070 RCX: fffff02f7f841e00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8acf8ad35340
RBP: ffff8ade5de74880 R08: ffffffffffffffff R09: 0000000000000000
R10: fffff33ef5e616c0 R11: ffff8acf8030f800 R12: ffff8acfa2586e00
R13: fffff33ef5e616c0 R14: ffff8acf8030f800 R15: ffffd02f85a77a98
FS:  0000000000000000(0000) GS:ffff8adec3d11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffff0a00 CR3: 00000000aea22000 CR4: 0000000000f50ef0
PKRU: 55555554
exited with irqs disabled
Fixing recursive fault but reboot is needed!
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu:         Tasks blocked on level-0 rcu_node (CPUs 0-15): P2709/1:b..l
rcu:         (detected by 2, t=600017 jiffies, g=884049, q=129532 ncpus=16)
task:e4defrag        state:D stack:0     pid:2709  tgid:2709
ppid:2614   task_flags:0x44010c flags:0x00080801
Call Trace:
 <TASK>
 __schedule+0x457/0x1870
 ? free_pcppages_bulk+0x1b6/0x2f0
 schedule+0x27/0xd0
 io_schedule+0x46/0x70
 folio_wait_bit_common+0x15d/0x350
 ? __pfx_wake_page_function+0x10/0x10
 truncate_inode_pages_range+0x43b/0x4a0
 ext4_evict_inode+0x156/0x7a0
 evict+0x13e/0x2b0
 __dentry_kill+0x79/0x1e0
 ? srso_alias_return_thunk+0x5/0xfbef5
 finish_dput+0x23/0xc0
 __fput+0x146/0x2d0
 task_work_run+0x66/0xa0
 ? srso_alias_return_thunk+0x5/0xfbef5
 do_exit+0x304/0xba0
 make_task_dead+0x8d/0x90
 rewind_stack_and_make_dead+0x16/0x20
RIP: 0033:0x7f8d52d17b9d
RSP: 002b:00007ffd9e2287d0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f8d52d17b9d
RDX: 00007ffd9e2288c0 RSI: 00000000c028660f RDI: 0000000000000006
RBP: 00007ffd9e228820 R08: 0000000000078000 R09: 00007f8d52e12ac0
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000078000000
R13: 0000559d58184890 R14: 0000000000001000 R15: 00007f8cdac00000
 </TASK>
