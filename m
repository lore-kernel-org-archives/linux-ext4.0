From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] ext4: don't BUG when truncating encrypted inodes on the
 orphan list
Date: Sun, 12 Feb 2017 09:38:20 +0100
Message-ID: <CAOMGZ=FGDTY2p0r4G30=nGvCKVMG6n-JZfcREsys6Xa1Oiz9bg@mail.gmail.com>
References: <20170211031942.11783-1-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36155 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdBLIiX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 12 Feb 2017 03:38:23 -0500
Received: by mail-wr0-f194.google.com with SMTP id k90so19640337wrc.3
        for <linux-ext4@vger.kernel.org>; Sun, 12 Feb 2017 00:38:22 -0800 (PST)
In-Reply-To: <20170211031942.11783-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11 February 2017 at 04:19, Theodore Ts'o <tytso@mit.edu> wrote:
> Fix a BUG when the kernel tries to mount a file system constructed as
> follows:
>
> echo foo > foo.txt
> mke2fs -Fq -t ext4 -O encrypt foo.img 100
> debugfs -w foo.img << EOF
> write foo.txt a
> set_inode_field a i_flags 0x80800
> set_super_value s_last_orphan 12
> quit
> EOF
>
> root@kvm-xfstests:~# mount -o loop foo.img /mnt
> [  160.238770] ------------[ cut here ]------------
> [  160.240106] kernel BUG at /usr/projects/linux/ext4/fs/ext4/inode.c:3874!
> [  160.240106] invalid opcode: 0000 [#1] SMP
> [  160.240106] Modules linked in:
> [  160.240106] CPU: 0 PID: 2547 Comm: mount Tainted: G        W       4.10.0-rc3-00034-gcdd33b941b67 #227
> [  160.240106] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.1-1 04/01/2014
> [  160.240106] task: f4518000 task.stack: f47b6000
> [  160.240106] EIP: ext4_block_zero_page_range+0x1a7/0x2b4
> [  160.240106] EFLAGS: 00010246 CPU: 0
> [  160.240106] EAX: 00000001 EBX: f7be4b50 ECX: f47b7dc0 EDX: 00000007
> [  160.240106] ESI: f43b05a8 EDI: f43babec EBP: f47b7dd0 ESP: f47b7dac
> [  160.240106]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  160.240106] CR0: 80050033 CR2: bfd85b08 CR3: 34a00680 CR4: 000006f0
> [  160.240106] Call Trace:
> [  160.240106]  ext4_truncate+0x1e9/0x3e5
> [  160.240106]  ext4_fill_super+0x286f/0x2b1e
> [  160.240106]  ? set_blocksize+0x2e/0x7e
> [  160.240106]  mount_bdev+0x114/0x15f
> [  160.240106]  ext4_mount+0x15/0x17
> [  160.240106]  ? ext4_calculate_overhead+0x39d/0x39d
> [  160.240106]  mount_fs+0x58/0x115
> [  160.240106]  vfs_kern_mount+0x4b/0xae
> [  160.240106]  do_mount+0x671/0x8c3
> [  160.240106]  ? _copy_from_user+0x70/0x83
> [  160.240106]  ? strndup_user+0x31/0x46
> [  160.240106]  SyS_mount+0x57/0x7b
> [  160.240106]  do_int80_syscall_32+0x4f/0x61
> [  160.240106]  entry_INT80_32+0x2f/0x2f
> [  160.240106] EIP: 0xb76b919e
> [  160.240106] EFLAGS: 00000246 CPU: 0
> [  160.240106] EAX: ffffffda EBX: 08053838 ECX: 08052188 EDX: 080537e8
> [  160.240106] ESI: c0ed0000 EDI: 00000000 EBP: 080537e8 ESP: bfa13660
> [  160.240106]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
> [  160.240106] Code: 59 8b 00 a8 01 0f 84 09 01 00 00 8b 07 66 25 00 f0 66 3d 00 80 75 61 89 f8 e8 3e e2 ff ff 84 c0 74 56 83 bf 48 02 00 00 00 75 02 <0f> 0b 81 7d e8 00 10 00 00 74 02 0f 0b 8b 43 04 8b 53 08 31 c9
> [  160.240106] EIP: ext4_block_zero_page_range+0x1a7/0x2b4 SS:ESP: 0068:f47b7dac
> [  160.317241] ---[ end trace d6a773a375c810a5 ]---
>
> The problem is that when the kernel tries to truncate an inode in
> ext4_truncate(), it tries to clear any on-disk data beyond i_size.
> Without the encryption key, it can't do that, and so it triggers a
> BUG.
>
> E2fsck does *not* provide this service, and in practice most file
> systems have their orphan list processed by e2fsck, so to avoid
> crashing, this patch skips this step if we don't have access to the
> encryption key (which is the case when processing the orphan list; in
> all other cases, we will have the encryption key, or the kernel
> wouldn't have allowed the file to be opened).
>
> An open question is whether the fact that e2fsck isn't clearing the
> bytes beyond i_size causing problems --- and if we've lived with it
> not doing it for so long, can we drop this from the kernel replay of
> the orphan list in all cases (not just when we don't have the key for
> encrypted inodes).
>
> Addresses-Google-Bug: #35209576
>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---

You may consider adding a Reported-by: and/or a link to the previous discussion:

https://patchwork.ozlabs.org/patch/648817/

Thanks,


Vegard
