From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: nbd client disconnect kernel BUG at fs/buffer.c:3099!
Date: Fri, 15 Sep 2017 15:02:33 +0200
Message-ID: <CAGmahrS5o8F4HZgNOsarJgMWBV-G87YexWb2fkDgTZP_USpMOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:57149 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdIONCg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Sep 2017 09:02:36 -0400
Received: by mail-lf0-f42.google.com with SMTP id a18so2329767lfl.13
        for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2017 06:02:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Disconnected nbd client prior to unmounting the fs. got some fallout,
not sure if relevant or not. this is on 4.12.12

[ 5428.076938] block nbd0: NBD_DISCONNECT
[ 5441.025920] ------------[ cut here ]------------
[ 5441.025922] kernel BUG at fs/buffer.c:3099!
[ 5441.025924] invalid opcode: 0000 [#1] PREEMPT SMP
[ 5441.025937] Modules linked in: nbd sha256_ssse3 sha256_generic hmac
drbg ansi_cprng seqiv xfrm4_mode_transport chacha20_x86_64
chacha20_generic poly1305_x86_64 poly1305_generic chacha20poly1305
xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key
xfrm_algo nft_limit nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nf_log_ipv6 nf_log_ipv4 nf_log_common nf_conntrack_ipv6
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_conntrack
nft_log nft_counter nft_meta nft_set_bitmap nft_set_hash
nft_set_rbtree nf_tables_netdev nf_tables_inet nf_tables_ipv6
nf_tables_ipv4 cls_u32 sch_htb af_packet x86_pkg_temp_thermal
intel_powerclamp kvm_intel vhost_net tun snd_hda_codec_hdmi vhost tap
kvm snd_hda_codec_realtek input_leds snd_hda_codec_generic bcache
led_class snd_hda_intel snd_hda_codec
[ 5441.026052]  intel_cstate intel_uncore snd_hwdep efi_pstore
snd_hda_core mei_me intel_rapl_perf snd_pcm efivars mei tpm_crb
efivarfs algif_skcipher af_alg crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcspkr shpchp fan thermal battery acpi_pad tpm_tis
tpm_tis_core tpm vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio
[ 5441.026104] CPU: 0 PID: 17032 Comm: umount Not tainted 4.12.12-1-ph #1
[ 5441.026116] Hardware name: Gigabyte Technology Co., Ltd.
Z170X-UD3/Z170X-UD3-CF, BIOS F22 03/06/2017
[ 5441.026132] task: ffff8cb231daa640 task.stack: ffff9daf866f0000
[ 5441.026145] RIP: 0010:submit_bh_wbc.isra.16+0x110/0x120
[ 5441.026155] RSP: 0018:ffff9daf866f3d88 EFLAGS: 00010246
[ 5441.026165] RAX: 0000000004000005 RBX: ffff8cb1fe7e50d0 RCX: dead000000000200
[ 5441.026178] RDX: ffff8cb1fe7e50d0 RSI: 0000000000000800 RDI: 0000000000000001
[ 5441.026194] RBP: ffff8cb259475000 R08: ffff8cb259475088 R09: 0000000000000284
[ 5441.026211] R10: ffffffff98c03e98 R11: 0000000000000182 R12: 0000000000000800
[ 5441.026225] R13: ffff8cb104b02000 R14: ffff8cb2b9b7c340 R15: 0000000000000000
[ 5441.026238] FS:  00007f7c9b68e780(0000) GS:ffff8cb2cec00000(0000)
knlGS:0000000000000000
[ 5441.026252] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5441.026263] CR2: 000055cafe179018 CR3: 000000010059c000 CR4: 00000000003406f0
[ 5441.026276] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5441.026288] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5441.026301] Call Trace:
[ 5441.026310]  ? jbd2_write_superblock+0x89/0x130
[ 5441.026320]  ? jbd2_mark_journal_empty+0x5a/0x90
[ 5441.026330]  ? jbd2_journal_destroy+0x25b/0x290
[ 5441.026340]  ? wake_up_bit+0x20/0x20
[ 5441.026349]  ? ext4_put_super+0x58/0x360
[ 5441.026358]  ? generic_shutdown_super+0x5f/0x110
[ 5441.026369]  ? kill_block_super+0x1c/0x50
[ 5441.026378]  ? deactivate_locked_super+0x34/0x60
[ 5441.026387]  ? cleanup_mnt+0x36/0x70
[ 5441.026396]  ? task_work_run+0x6b/0x80
[ 5441.026405]  ? exit_to_usermode_loop+0x72/0x80
[ 5441.026414]  ? do_syscall_64+0x92/0xa0
[ 5441.026424]  ? entry_SYSCALL64_slow_path+0x25/0x25
[ 5441.026433] Code: 80 cc 20 80 e6 80 0f 45 e8 44 09 ed 41 89 6c 24
14 e8 15 cd 17 00 5b 31 c0 5d 41 5c 41 5d c3 f0 80 62 01 f7 e9 4e ff
ff ff 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 44 00 00 41 57 41
56 49
[ 5441.026475] RIP: submit_bh_wbc.isra.16+0x110/0x120 RSP: ffff9daf866f3d88
[ 5441.030155] ---[ end trace 957fc5174e168e0c ]---
[ 5442.570759] BUG: unable to handle kernel paging request at fffffffef680e030
[ 5442.570778] IP: 0xfffffffef68ea74d
[ 5442.570787] PGD 171c09067
[ 5442.570787] P4D 171c09067
[ 5442.570794] PUD 0
[ 5442.570813] Oops: 0002 [#2] PREEMPT SMP
[ 5442.570822] Modules linked in: nbd sha256_ssse3 sha256_generic hmac
drbg ansi_cprng seqiv xfrm4_mode_transport chacha20_x86_64
chacha20_generic poly1305_x86_64 poly1305_generic chacha20poly1305
xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key
xfrm_algo nft_limit nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nf_log_ipv6 nf_log_ipv4 nf_log_common nf_conntrack_ipv6
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_conntrack
nft_log nft_counter nft_meta nft_set_bitmap nft_set_hash
nft_set_rbtree nf_tables_netdev nf_tables_inet nf_tables_ipv6
nf_tables_ipv4 cls_u32 sch_htb af_packet x86_pkg_temp_thermal
intel_powerclamp kvm_intel vhost_net tun snd_hda_codec_hdmi vhost tap
kvm snd_hda_codec_realtek input_leds snd_hda_codec_generic bcache
led_class snd_hda_intel snd_hda_codec
[ 5442.570939]  intel_cstate intel_uncore snd_hwdep efi_pstore
snd_hda_core mei_me intel_rapl_perf snd_pcm efivars mei tpm_crb
efivarfs algif_skcipher af_alg crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcspkr shpchp fan thermal battery acpi_pad tpm_tis
tpm_tis_core tpm vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio
[ 5442.570991] CPU: 0 PID: 11541 Comm: kworker/0:0 Tainted: G      D
      4.12.12-1-ph #1
[ 5442.571005] Hardware name: Gigabyte Technology Co., Ltd.
Z170X-UD3/Z170X-UD3-CF, BIOS F22 03/06/2017
[ 5442.571024] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5442.571036] task: ffff8cb2b63b9980 task.stack: ffff9daf85dd4000
[ 5442.571054] RIP: 0010:0xfffffffef68ea74d
[ 5442.571063] RSP: 0018:ffff9daf85dd7c10 EFLAGS: 00010202
[ 5442.571081] RAX: 0000000000000020 RBX: fffffffef680e018 RCX: c000000000000001
[ 5442.571096] RDX: 000000000007ffa8 RSI: ffff9daf85dd7dc8 RDI: ffff8cb23d0a7400
[ 5442.571109] RBP: 0000000000000400 R08: 0000000000000020 R09: 0000000000000000
[ 5442.571122] R10: ffff9daf85dd7dff R11: 0000000000000000 R12: ffff9daf85dd7dd0
[ 5442.572110] R13: ffff8cb23d0a7400 R14: ffff9daf85dd7dd0 R15: 0000000000000202
[ 5442.573084] FS:  0000000000000000(0000) GS:ffff8cb2cec00000(0000)
knlGS:0000000000000000
[ 5442.574053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5442.574997] CR2: fffffffef68ea74d CR3: 0000000171c08000 CR4: 00000000003406f0
[ 5442.575938] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5442.576868] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 5442.577785] Call Trace:
[ 5442.578690]  ? efi_call+0x58/0x90
[ 5442.579571]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5442.580425]  ? efivar_init+0x112/0x390
[ 5442.581258]  ? efivar_init+0x112/0x390
[ 5442.582061]  ? efivar_release+0x10/0x10 [efivars]
[ 5442.582839]  ? up+0xd/0x50
[ 5442.583620]  ? efivar_entry_add+0x49/0x80
[ 5442.584389]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5442.585155]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5442.585913]  ? process_one_work+0x153/0x2e0
[ 5442.586670]  ? worker_thread+0x45/0x380
[ 5442.587427]  ? __schedule+0x18b/0x5c0
[ 5442.588182]  ? process_one_work+0x2e0/0x2e0
[ 5442.588923]  ? kthread+0x10e/0x130
[ 5442.589672]  ? kthread_create_on_node+0x60/0x60
[ 5442.590409]  ? ret_from_fork+0x22/0x30
[ 5442.591152] Code:  Bad RIP value.
[ 5442.591880] RIP: 0xfffffffef68ea74d RSP: ffff9daf85dd7c10
[ 5442.592620] CR2: fffffffef680e030
[ 5442.593346] ---[ end trace 957fc5174e168e0d ]---
[ 5442.593916] BUG: scheduling while atomic: kworker/0:0/11541/0x00000003
[ 5442.593916] Modules linked in: nbd sha256_ssse3 sha256_generic hmac
drbg ansi_cprng seqiv xfrm4_mode_transport chacha20_x86_64
chacha20_generic poly1305_x86_64 poly1305_generic chacha20poly1305
xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key
xfrm_algo nft_limit nft_reject_inet nf_reject_ipv4 nf_reject_ipv6
nft_reject nf_log_ipv6 nf_log_ipv4 nf_log_common nf_conntrack_ipv6
nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_conntrack
nft_log nft_counter nft_meta nft_set_bitmap nft_set_hash
nft_set_rbtree nf_tables_netdev nf_tables_inet nf_tables_ipv6
nf_tables_ipv4 cls_u32 sch_htb af_packet x86_pkg_temp_thermal
intel_powerclamp kvm_intel vhost_net tun snd_hda_codec_hdmi vhost tap
kvm snd_hda_codec_realtek input_leds snd_hda_codec_generic bcache
led_class snd_hda_intel snd_hda_codec
[ 5442.593932]  intel_cstate intel_uncore snd_hwdep efi_pstore
snd_hda_core mei_me intel_rapl_perf snd_pcm efivars mei tpm_crb
efivarfs algif_skcipher af_alg crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel pcspkr shpchp fan thermal battery acpi_pad tpm_tis
tpm_tis_core tpm vfio_pci irqbypass vfio_virqfd vfio_iommu_type1 vfio
[ 5442.593941] CPU: 0 PID: 11541 Comm: kworker/0:0 Tainted: G      D
      4.12.12-1-ph #1
[ 5442.593942] Hardware name: Gigabyte Technology Co., Ltd.
Z170X-UD3/Z170X-UD3-CF, BIOS F22 03/06/2017
[ 5442.593944] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5442.593944] Call Trace:
[ 5442.593946]  ? dump_stack+0x46/0x64
[ 5442.593947]  ? __schedule_bug+0x47/0x60
[ 5442.593949]  ? __schedule+0x4b2/0x5c0
[ 5442.593950]  ? schedule+0x34/0x80
[ 5442.593952]  ? schedule_timeout+0x203/0x2c0
[ 5442.593953]  ? __down_interruptible+0x9e/0x110
[ 5442.593954]  ? soft_cursor+0x150/0x220
[ 5442.593955]  ? __down_interruptible+0x9e/0x110
[ 5442.593956]  ? down_interruptible+0x3d/0x50
[ 5442.593957]  ? down_interruptible+0x3d/0x50
[ 5442.593958]  ? efivar_entry_set_safe+0x12c/0x1d0
[ 5442.593959]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5442.593960]  ? efi_pstore_write+0x83/0x120 [efi_pstore]
[ 5442.593961]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5442.593962]  ? pstore_dump+0x160/0x310
[ 5442.593963]  ? vprintk_emit+0x255/0x2b0
[ 5442.593965]  ? kmsg_dump+0x96/0xc0
[ 5442.593966]  ? oops_end+0x5b/0xb0
[ 5442.593967]  ? no_context+0x150/0x3c0
[ 5442.593968]  ? page_fault+0x22/0x30
[ 5442.593969]  ? efi_call+0x58/0x90
[ 5442.593971]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5442.593972]  ? efivar_init+0x112/0x390
[ 5442.593973]  ? efivar_init+0x112/0x390
[ 5442.593974]  ? efivar_release+0x10/0x10 [efivars]
[ 5442.593974]  ? up+0xd/0x50
[ 5442.593975]  ? efivar_entry_add+0x49/0x80
[ 5442.593976]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5442.593977]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5442.593978]  ? process_one_work+0x153/0x2e0
[ 5442.593979]  ? worker_thread+0x45/0x380
[ 5442.593980]  ? __schedule+0x18b/0x5c0
[ 5442.593981]  ? process_one_work+0x2e0/0x2e0
[ 5442.593982]  ? kthread+0x10e/0x130
[ 5442.593983]  ? kthread_create_on_node+0x60/0x60
[ 5442.593984]  ? ret_from_fork+0x22/0x30
[ 5502.571791] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 5502.571802] Tasks blocked on level-0 rcu_node (CPUs 0-3): P11541
[ 5502.571807] (detected by 2, t=60002 jiffies, g=134953, c=134952, q=16723)
[ 5502.571815] kworker/0:0     S    0 11541      2 0x00000080
[ 5502.571831] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5502.571835] Call Trace:
[ 5502.571846]  ? __schedule+0x183/0x5c0
[ 5502.571851]  ? schedule+0x34/0x80
[ 5502.571857]  ? schedule_timeout+0x203/0x2c0
[ 5502.571864]  ? __down_interruptible+0x9e/0x110
[ 5502.571873]  ? soft_cursor+0x150/0x220
[ 5502.571878]  ? __down_interruptible+0x9e/0x110
[ 5502.571884]  ? down_interruptible+0x3d/0x50
[ 5502.571887]  ? down_interruptible+0x3d/0x50
[ 5502.571894]  ? efivar_entry_set_safe+0x12c/0x1d0
[ 5502.571901]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5502.571906]  ? efi_pstore_write+0x83/0x120 [efi_pstore]
[ 5502.571910]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5502.571916]  ? pstore_dump+0x160/0x310
[ 5502.571922]  ? vprintk_emit+0x255/0x2b0
[ 5502.571929]  ? kmsg_dump+0x96/0xc0
[ 5502.571936]  ? oops_end+0x5b/0xb0
[ 5502.571941]  ? no_context+0x150/0x3c0
[ 5502.571946]  ? page_fault+0x22/0x30
[ 5502.571953]  ? efi_call+0x58/0x90
[ 5502.571962]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5502.571968]  ? efivar_init+0x112/0x390
[ 5502.571973]  ? efivar_init+0x112/0x390
[ 5502.571978]  ? efivar_release+0x10/0x10 [efivars]
[ 5502.571982]  ? up+0xd/0x50
[ 5502.571987]  ? efivar_entry_add+0x49/0x80
[ 5502.571993]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5502.571997]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5502.572004]  ? process_one_work+0x153/0x2e0
[ 5502.572010]  ? worker_thread+0x45/0x380
[ 5502.572015]  ? __schedule+0x18b/0x5c0
[ 5502.572020]  ? process_one_work+0x2e0/0x2e0
[ 5502.572025]  ? kthread+0x10e/0x130
[ 5502.572029]  ? kthread_create_on_node+0x60/0x60
[ 5502.572033]  ? ret_from_fork+0x22/0x30
[ 5502.572037] kworker/0:0     S    0 11541      2 0x00000080
[ 5502.572045] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5502.572048] Call Trace:
[ 5502.572054]  ? __schedule+0x183/0x5c0
[ 5502.572059]  ? schedule+0x34/0x80
[ 5502.572064]  ? schedule_timeout+0x203/0x2c0
[ 5502.572071]  ? __down_interruptible+0x9e/0x110
[ 5502.572074]  ? soft_cursor+0x150/0x220
[ 5502.572080]  ? __down_interruptible+0x9e/0x110
[ 5502.572084]  ? down_interruptible+0x3d/0x50
[ 5502.572087]  ? down_interruptible+0x3d/0x50
[ 5502.572093]  ? efivar_entry_set_safe+0x12c/0x1d0
[ 5502.572098]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5502.572103]  ? efi_pstore_write+0x83/0x120 [efi_pstore]
[ 5502.572107]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5502.572112]  ? pstore_dump+0x160/0x310
[ 5502.572118]  ? vprintk_emit+0x255/0x2b0
[ 5502.572124]  ? kmsg_dump+0x96/0xc0
[ 5502.572129]  ? oops_end+0x5b/0xb0
[ 5502.572133]  ? no_context+0x150/0x3c0
[ 5502.572138]  ? page_fault+0x22/0x30
[ 5502.572144]  ? efi_call+0x58/0x90
[ 5502.572151]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5502.572157]  ? efivar_init+0x112/0x390
[ 5502.572162]  ? efivar_init+0x112/0x390
[ 5502.572167]  ? efivar_release+0x10/0x10 [efivars]
[ 5502.572171]  ? up+0xd/0x50
[ 5502.572176]  ? efivar_entry_add+0x49/0x80
[ 5502.572181]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5502.572186]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5502.572191]  ? process_one_work+0x153/0x2e0
[ 5502.572197]  ? worker_thread+0x45/0x380
[ 5502.572201]  ? __schedule+0x18b/0x5c0
[ 5502.572207]  ? process_one_work+0x2e0/0x2e0
[ 5502.572211]  ? kthread+0x10e/0x130
[ 5502.572215]  ? kthread_create_on_node+0x60/0x60
[ 5502.572219]  ? ret_from_fork+0x22/0x30
[ 5682.575898] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 5682.575906] Tasks blocked on level-0 rcu_node (CPUs 0-3): P11541
[ 5682.575910] (detected by 1, t=240007 jiffies, g=134953, c=134952, q=23042)
[ 5682.575916] kworker/0:0     S    0 11541      2 0x00000080
[ 5682.575929] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5682.575932] Call Trace:
[ 5682.575941]  ? __schedule+0x183/0x5c0
[ 5682.575945]  ? schedule+0x34/0x80
[ 5682.575950]  ? schedule_timeout+0x203/0x2c0
[ 5682.575956]  ? __down_interruptible+0x9e/0x110
[ 5682.575960]  ? soft_cursor+0x150/0x220
[ 5682.575964]  ? __down_interruptible+0x9e/0x110
[ 5682.575969]  ? down_interruptible+0x3d/0x50
[ 5682.575971]  ? down_interruptible+0x3d/0x50
[ 5682.575977]  ? efivar_entry_set_safe+0x12c/0x1d0
[ 5682.575983]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5682.575987]  ? efi_pstore_write+0x83/0x120 [efi_pstore]
[ 5682.575990]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5682.575995]  ? pstore_dump+0x160/0x310
[ 5682.576000]  ? vprintk_emit+0x255/0x2b0
[ 5682.576005]  ? kmsg_dump+0x96/0xc0
[ 5682.576010]  ? oops_end+0x5b/0xb0
[ 5682.576015]  ? no_context+0x150/0x3c0
[ 5682.576019]  ? page_fault+0x22/0x30
[ 5682.576025]  ? efi_call+0x58/0x90
[ 5682.576031]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5682.576036]  ? efivar_init+0x112/0x390
[ 5682.576040]  ? efivar_init+0x112/0x390
[ 5682.576044]  ? efivar_release+0x10/0x10 [efivars]
[ 5682.576047]  ? up+0xd/0x50
[ 5682.576051]  ? efivar_entry_add+0x49/0x80
[ 5682.576056]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5682.576060]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5682.576065]  ? process_one_work+0x153/0x2e0
[ 5682.576070]  ? worker_thread+0x45/0x380
[ 5682.576074]  ? __schedule+0x18b/0x5c0
[ 5682.576078]  ? process_one_work+0x2e0/0x2e0
[ 5682.576081]  ? kthread+0x10e/0x130
[ 5682.576085]  ? kthread_create_on_node+0x60/0x60
[ 5682.576088]  ? ret_from_fork+0x22/0x30
[ 5682.576091] kworker/0:0     S    0 11541      2 0x00000080
[ 5682.576098] Workqueue: events efivar_update_sysfs_entries [efivars]
[ 5682.576100] Call Trace:
[ 5682.576105]  ? __schedule+0x183/0x5c0
[ 5682.576109]  ? schedule+0x34/0x80
[ 5682.576113]  ? schedule_timeout+0x203/0x2c0
[ 5682.576118]  ? __down_interruptible+0x9e/0x110
[ 5682.576121]  ? soft_cursor+0x150/0x220
[ 5682.576125]  ? __down_interruptible+0x9e/0x110
[ 5682.576128]  ? down_interruptible+0x3d/0x50
[ 5682.576131]  ? down_interruptible+0x3d/0x50
[ 5682.576136]  ? efivar_entry_set_safe+0x12c/0x1d0
[ 5682.576140]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5682.576143]  ? efi_pstore_write+0x83/0x120 [efi_pstore]
[ 5682.576147]  ? efi_pstore_write+0xe3/0x120 [efi_pstore]
[ 5682.576151]  ? pstore_dump+0x160/0x310
[ 5682.576155]  ? vprintk_emit+0x255/0x2b0
[ 5682.576161]  ? kmsg_dump+0x96/0xc0
[ 5682.576165]  ? oops_end+0x5b/0xb0
[ 5682.576168]  ? no_context+0x150/0x3c0
[ 5682.576172]  ? page_fault+0x22/0x30
[ 5682.576177]  ? efi_call+0x58/0x90
[ 5682.576183]  ? virt_efi_get_next_variable+0xd7/0x210
[ 5682.576187]  ? efivar_init+0x112/0x390
[ 5682.576191]  ? efivar_init+0x112/0x390
[ 5682.576195]  ? efivar_release+0x10/0x10 [efivars]
[ 5682.576198]  ? up+0xd/0x50
[ 5682.576202]  ? efivar_entry_add+0x49/0x80
[ 5682.576206]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5682.576210]  ? efivar_update_sysfs_entries+0x1f/0x50 [efivars]
[ 5682.576214]  ? process_one_work+0x153/0x2e0
[ 5682.576219]  ? worker_thread+0x45/0x380
[ 5682.576222]  ? __schedule+0x18b/0x5c0
[ 5682.576227]  ? process_one_work+0x2e0/0x2e0
[ 5682.576230]  ? kthread+0x10e/0x130
[ 5682.576233]  ? kthread_create_on_node+0x60/0x60
[ 5682.576236]  ? ret_from_fork+0x22/0x30
