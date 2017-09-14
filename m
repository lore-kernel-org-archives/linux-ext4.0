From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: inconsistent lock state in jbd2_trans_will_send_data_barrier
Date: Thu, 14 Sep 2017 17:09:49 -0400
Message-ID: <20170914210949.g4haruzjnmsicnmb@thunk.org>
References: <CACbyUSoP1zouetuKE9o5yHjNPMDbdz7hHg8ej-9wLs-EyhF2=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>
To: GeneBlue <geneblue.mail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACbyUSoP1zouetuKE9o5yHjNPMDbdz7hHg8ej-9wLs-EyhF2=w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 14, 2017 at 07:56:16PM +0800, GeneBlue wrote:
> Hi:
>   ext4_fill_super+0x8670/0xa720 fs/ext4/super.c:4005
>   mount_bdev+0x2d7/0x390 fs/super.c:1119
>   ext4_mount+0x34/0x40 fs/ext4/super.c:5683
>   mount_fs+0x9d/0x2d0 fs/super.c:1222
>   vfs_kern_mount+0x7a/0x3f0 fs/namespace.c:977
>   do_new_mount fs/namespace.c:2454 [inline]
>   do_mount+0x3d6/0x2710 fs/namespace.c:2776
>   SYSC_mount fs/namespace.c:2992 [inline]
>   SyS_mount+0xab/0x120 fs/namespace.c:2969
>   do_mount_root init/do_mounts.c:366 [inline]
>   mount_block_root+0x3a2/0x5ec init/do_mounts.c:396
>   mount_root+0x1b5/0x1e5 init/do_mounts.c:541
>   prepare_namespace+0x18f/0x1cc init/do_mounts.c:600
>   kernel_init_freeable+0x52d/0x54b init/main.c:1075
>   kernel_init+0x13/0x170 init/main.c:984
>   ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:425

What kernel version, what did you do to provoke this (do you have a
clean repro), etc.?

					- Ted
