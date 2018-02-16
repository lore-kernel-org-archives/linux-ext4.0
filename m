From: Davis Roman <davis.roman84@gmail.com>
Subject: Attempts to use ext4 encryption on kernel 4.1.15 keep resulting in
 kernel crash
Date: Fri, 16 Feb 2018 11:04:32 -0500
Message-ID: <CACfi_Z1Lf+VODomcoS3ekHexTjMueEDjdANmq2CvqTuJd=i-tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43583 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752900AbeBPQEe (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2018 11:04:34 -0500
Received: by mail-qt0-f194.google.com with SMTP id d26so4324132qtk.10
        for <linux-ext4@vger.kernel.org>; Fri, 16 Feb 2018 08:04:34 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I would also like to enable ext4 encryption on our product. We're
using a 4.1.15 kernel.

Our kernel has CONFIG_KEYS and CONFIG_EXT4_ENCRYPTION enabled and I
made sure to have an up to date version of e2fsprogs. We're using
1.43.8.

Unfortunately, I get a kernel panic whenever I try the above steps show below.

Any ideas on what I could do next would be extremely appreciated.

Thank you!

-Davis

root@target:~# uname -r
4.1.15+ga1644c9
root@target:~# e4crypt add_key -S 0x1234
Enter passphrase (echo disabled):
Added key with descriptor [080b217fb3239f3d]
root@target:~# mkdir testfolder
root@target:~# e4crypt set_policy 080b217fb3239f3d testfolder/
Key with descriptor [080b217fb3239f3d] applied to testfolder/.
root@target:~# touch testfolder/test.txt
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = 89f8c000
[00000000] *pgd=19f99831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT SMP ARM
Modules linked in: art(O) gc2145_camera asix usbnet m25p80 ath9k
ath9k_common ath9k_hw ath galcore(O) g_ether usb_f_rndis u_ether
libcomposite configfs
CPU: 0 PID: 2414 Comm: touch Tainted: G O 4.1.15+ga1644c9 #1
Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
task: 89f86ac0 ti: 8978e000 task.ti: 8978e000
PC is at v7_dma_clean_range+0x20/0x38
LR is at __dma_page_cpu_to_dev+0x28/0x94
pc : [<8001f9e8>] lr : [<8001b8b0>] psr: 000f0013
sp : 8978fbb0 ip : 8bb57000 fp : 8001b960
r10: 885f5810 r9 : 00000000 r8 : 899c7c00
r7 : 00000001 r6 : 00000010 r5 : 8cb57000 r4 : 00000000
r3 : 0000001f r2 : 00000020 r1 : 00000010 r0 : 00000000
Flags: nzcv IRQs on FIQs on Mode SVC_32 ISA ARM Segment user
Control: 10c53c7d Table: 19f8c059 DAC: 00000015
Process touch (pid: 2414, stack limit = 0x8978e210)
Stack: (0x8978fbb0 to 0x89790000)
fba0: 8001fa38 00000010 00000000 8cb57000
fbc0: 885f5810 00000000 00000000 8001b9d0 00000000 00000000 80bbb424 8058f33c
fbe0: 00000001 00000000 ffffffff 00000010 8978fc7c 000000d0 8978fc5c 80c661c4
fc00: 8978fc3f 00000000 8978fc5c 899cbf80 899c7c00 88bbf800 885f5810 8978fc7c
fc20: 8768ad34 89f3808e 8978fc5c 8058f740 00000000 802bf780 600f0013 ffffffff
fc40: 8978fce8 899cbf80 899c7c00 00000000 8978fc6c 801b4f50 8026d444 8bc95702
fc60: 0000008e 00000040 19f3808e 8bc44142 00000d34 00000040 1768ad34 00000000
fc80: 00000000 8978fc84 8978fc84 00000000 89f38000 00000000 8768ab40 89f38000
fca0: 80bc9f98 00000001 87ca1e84 8768ab40 8790d1c0 801b5114 0000001c 807c2304
fcc0: 00000001 7865cc54 303a3474 32623038 62663731 39333233 00643366 00040101
fce0: 7f210b08 3d9f23b3 c1628c21 38e4fa62 220a5aee dd6769bf 8602a400 00000001
fd00: 8768ab40 000000ff 00000008 801b5768 96163000 00001000 00000000 80183f24
fd20: 00000000 00000000 00000000 8768ab40 00000001 8790d1c0 00000002 00000000
fd40: 00000000 00000000 8790d1c0 00000001 00000000 00000001 8768ab40 00000001
fd60: 00000001 00000001 00000000 80184304 87ca1e70 00000000 8978fe04 898ba528
fd80: 80c15c84 89768000 87ca1e70 8978fe04 00000000 809a6398 8790d1c0 898ba528
fda0: 0000004b 89740000 8790d1c0 00000000 00000020 00000001 0002cbec 80bb55a0
fdc0: 88001500 80bb66f4 0002cbec 87ca1e58 87ca1e58 87ca1aa0 8768ab40 8978feb0
fde0: 8768ab40 87ca1aa0 87ca1e58 80184628 87ca1af0 87ca1e58 0002cbec 807c21ac
fe00: 87ca1aa0 00000000 00000000 87ca1e58 8978ff74 87ca1aa0 00020941 800f5170
fe20: 8978fef0 8978ff74 87ca1aa0 800f9a7c 88b13000 800f7abc 00000000 00000022
fe40: 898ee3c0 00000000 00000000 00000001 88aad610 87ca1aa0 8768ab40 899cb180
fe60: 01bc60c0 8978ff74 88b13000 898ee3c0 8978fef0 00000000 8978ff74 88b13000
fe80: 8978feb0 00000000 0002cbec 800f9fa0 8978feac 88b13000 00000000 8978ffb0
fea0: 89740000 80000007 76f482ec 00000000 898badc0 89740038 00000054 8001ce58
fec0: 00000000 8978ff74 00000001 ffffff9c 88b13000 8000f604 8978e000 00000000
fee0: 0002cbec 800fb320 00000041 80bbb714 88aad610 87ca1aa0 f0bf2f52 00000008
ff00: 88b1301b 0002cc14 00000000 80009338 8768ab40 00000301 00000004 00000258
ff20: 00000000 00000000 00000000 807c21ac 00000003 80107368 80bb6760 00020941
ff40: 00000000 00020941 ffffff9c 88b13000 00000005 00000003 ffffff9c 88b13000
ff60: 00000005 800ec778 89f86eb8 0046c000 89740000 00020941 897481b6 00000022
ff80: 00000300 00000001 76fc0000 00000941 00000000 7eac4de4 00000005 8000f604
ffa0: 8978e000 8000f480 00000941 00000000 7eac4eee 00020941 000001b6 00000000
ffc0: 00000941 00000000 7eac4de4 00000005 7eac4eee 00000001 0002cc14 0002cbec
ffe0: 76f482ec 7eac4b80 000128bc 76f48340 600e0010 7eac4eee 00000000 00000000
[<8001f9e8>] (v7_dma_clean_range) from [<8001b8b0>]
(__dma_page_cpu_to_dev+0x28/0x94)
[<8001b8b0>] (__dma_page_cpu_to_dev) from [<8001b9d0>]
(arm_dma_map_page+0x70/0x74)
[<8001b9d0>] (arm_dma_map_page) from [<8058f33c>]
(ablkcipher_edesc_alloc.constprop.1+0x180/0x568)
[<8058f33c>] (ablkcipher_edesc_alloc.constprop.1) from [<8058f740>]
(ablkcipher_encrypt+0x1c/0x90)
[<8058f740>] (ablkcipher_encrypt) from [<801b4f50>]
(ext4_derive_key_aes+0x104/0x15c)
[<801b4f50>] (ext4_derive_key_aes) from [<801b5114>]
(ext4_generate_encryption_key+0x16c/0x1bc)
[<801b5114>] (ext4_generate_encryption_key) from [<801b5768>]
(ext4_get_fname_crypto_ctx+0x11c/0x2d4)
[<801b5768>] (ext4_get_fname_crypto_ctx) from [<80183f24>]
(search_dir+0x44/0x16c)
[<80183f24>] (search_dir) from [<80184304>] (ext4_find_entry+0x2b8/0x5a8)
[<80184304>] (ext4_find_entry) from [<80184628>] (ext4_lookup+0x34/0x1d8)
[<80184628>] (ext4_lookup) from [<800f5170>] (lookup_real+0x20/0x4c)
[<800f5170>] (lookup_real) from [<800f9a7c>] (do_last+0x7c8/0xc6c)
[<800f9a7c>] (do_last) from [<800f9fa0>] (path_openat+0x80/0x5d8)
[<800f9fa0>] (path_openat) from [<800fb320>] (do_filp_open+0x2c/0x88)
[<800fb320>] (do_filp_open) from [<800ec778>] (do_sys_open+0x108/0x1cc)
[<800ec778>] (do_sys_open) from [<8000f480>] (ret_fast_syscall+0x0/0x3c)
Code: e1a02312 e2423001 e1c00003 e320f000 (ee070f3a)
---[ end trace 87467e4f88b65a79 ]---
Kernel panic - not syncing: Fatal exception
Rebooting in 1 seconds..
U-Boot 2016.03-develop+g500abb6 (Feb 09 2018 - 16:39:09 -0500)
CPU: Freescale i.MX6SOLO rev1.3 at 792 MHz
Reset cause: POR
Board:
DRAM: 512 MiB
NAND: 0 MiB
MMC: FSL_SDHC: 0, FSL_SDHC: 1
Using default environment
In: serial
Out: serial
Err: serial
facmod value is 1!
Boot Device: EMMC
Net: Board Net Initialization Failed
No ethernet found.
Normal Boot
Hit any key to stop autoboot: 0
