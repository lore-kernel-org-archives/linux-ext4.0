From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: kernel BUG at fs/buffer.c:3102! (nbd disc.)
Date: Wed, 3 May 2017 11:27:59 +0200
Message-ID: <CAGmahrRy2A2SRFGjObwUcVe3gOnsj0qj3cpADesxbf3ASTKD6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38605 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751491AbdECJ2B (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 3 May 2017 05:28:01 -0400
Received: by mail-wm0-f53.google.com with SMTP id r190so50493790wme.1
        for <linux-ext4@vger.kernel.org>; Wed, 03 May 2017 02:28:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. used ext4 via nbd and the client died on me because of a silly
mistake. Got something in dmesg. Not sure if this is even a "real" bug
or just sort of expected to happen in this scenario or not but I
figure i would post it anyway.


kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75645184
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75645439
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75645694
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75645949
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75646204
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75646459
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75646714
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75646969
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75647224
kernel: block nbd0: Attempted send on invalid socket
kernel: blk_update_request: I/O error, dev nbd0, sector 75647232
kernel: Aborting journal on device nbd0-8.
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/buffer.c:3102!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP
kernel: Modules linked in: ext4 jbd2 fscrypto mbcache
cpufreq_conservative msr ccp_crypto twofish_generic twofish_avx_x86_64
twofish_x86_64_3way twofish_x86_64 twofish_common serpent_av
x_x86_64 serpent_sse2_x86_64 xts serpent_generic lrw gf128mul
ablk_helper cbc algif_skcipher af_alg nbd cfg80211 edac_mce_amd
edac_core kvm_amd kvm btusb btrtl irqbypass btbcm btintel
crct10dif_pclmul ghash_cl
mulni_intel bluetooth pcbc uvcvideo acer_wmi videobuf2_vmalloc
sparse_keymap videobuf2_memops videobuf2_v4l2 videobuf2_core
aesni_intel aes_x86_64 rfkill videodev snd_hda_codec_realtek
crypto_simd media snd_hda_codec_generic glue_helper joydev
snd_hda_codec_hdmi crc16 mousedev fam15h_power input_leds cryptd
amdgpu k10temp pcspkr snd_hda_intel rtsx_pci_ms snd_hda_codec memstick
snd_hda_core evdev snd_hwdep
kernel:  snd_pcm ccp mac_hid shpchp snd_timer snd sp5100_tco battery
ac i2c_piix4 soundcore rng_core acpi_cpufreq tpm_tis tpm_tis_core tpm
sch_fq_codel ip_tables x_tables overlay squashfs loop isofs
hid_multitouch usbhid hid sr_mod sd_mod cdrom uas usb_storage
rtsx_pci_sdmmc serio_raw atkbd libps2 ahci libahci radeon crc32_pclmul
crc32c_intel i2c_algo_bit libata drm_kms_helper sdhci_pci sysc
opyarea sysfillrect sdhci sysimgblt fb_sys_fops mmc_core xhci_pci
led_class ehci_pci xhci_hcd ehci_hcd r8169 scsi_mod ttm usbcore
usb_common mii rtsx_pci drm wmi i8042 serio fjes video button [last
unloaded: cpuid]
kernel: CPU: 3 PID: 1759 Comm: jbd2/nbd0-8 Tainted: G        W
4.10.13-1-ARCH #1
kernel: Hardware name: Acer Aspire E5-521/Larne, BIOS V1.03 01/06/2015
kernel: task: ffff88010e7f5580 task.stack: ffffc9000077c000
kernel: RIP: 0010:submit_bh_wbc+0x16f/0x180
kernel: RSP: 0018:ffffc9000077fc10 EFLAGS: 00010246
kernel: RAX: 0000000004000005 RBX: ffff88007e3ca3a8 RCX: 0000000000000000
kernel: RDX: ffff88007e3ca3a8 RSI: 0000000000020000 RDI: 0000000000000001
kernel: RBP: ffffc9000077fc40 R08: 0000000000000000 R09: 000000000000035d
kernel: R10: 0000000000000008 R11: 0000000000000001 R12: ffff88009a28b024
kernel: R13: ffff88009a28b000 R14: 0000000000020000 R15: ffff8800a96be000
kernel: FS:  0000000000000000(0000) GS:ffff88011ed80000(0000)
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 0000000000dcacc0 CR3: 000000010a33a000 CR4: 00000000000406e0
kernel: Call Trace:
kernel:  submit_bh+0x13/0x20
kernel:  jbd2_write_superblock+0xa5/0x1e0 [jbd2]
kernel:  jbd2_journal_update_sb_errno+0x3f/0x50 [jbd2]
kernel:  __journal_abort_soft+0x3d/0x60 [jbd2]
kernel:  jbd2_journal_abort+0xe/0x10 [jbd2]
kernel:  jbd2_journal_commit_transaction+0x1538/0x1980 [jbd2]
kernel:  ? dequeue_task_fair+0x71e/0xb10
kernel:  ? try_to_del_timer_sync+0x5a/0x80
kernel:  kjournald2+0xca/0x260 [jbd2]
kernel:  ? wake_atomic_t_function+0x60/0x60
kernel:  kthread+0x109/0x140
kernel:  ? commit_timeout+0x10/0x10 [jbd2]
kernel:  ? kthread_create_on_node+0x60/0x60
kernel:  ? SyS_exit_group+0x14/0x20
kernel:  ret_from_fork+0x2c/0x40
kernel: Code: f7 41 89 7c 24 14 4c 89 e7 e8 4e 1d 09 00 48 83 c4 08 31
c0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f0 80 62 01 f7 e9 03 ff ff ff 0f
0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 1f 80 00 00 00 00 0f 1f 44 00
kernel: RIP: submit_bh_wbc+0x16f/0x180 RSP: ffffc9000077fc10
kernel: ---[ end trace 89577b20ba3191d4 ]---
