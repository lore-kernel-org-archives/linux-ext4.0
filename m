From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH 1/1] ext4: fix hole punch failure when depth is greater
 than 0
Date: Tue, 12 Jun 2012 11:17:32 +0530
Message-ID: <CAOiN93nGE+z5-0=f-Ghq+xb+y4XCA10LnxmMoA7wJsP4YQciUQ@mail.gmail.com>
References: <1338727489-16867-1-git-send-email-ashish.sangwan2@gmail.com>
	<20120608025219.GA28527@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Ted Ts'o" <tytso@mit.edu>,
	Ashish Sangwan <ashishsangwan2@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54369 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2FLFrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2012 01:47:32 -0400
In-Reply-To: <20120608025219.GA28527@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

Thanks for checking the patch.
The reason for the crash is the "again" tag at the end of function
ext4_ext_remove_space() which restarts the truncate operation.
Setting path =3D NULL here, before doing truncate again solves the prob=
lem.
out:
 	ext4_ext_drop_refs(path);
 	kfree(path);
+	path =3D NULL;   <=3D Required fix
 	if (err =3D=3D -EAGAIN)
 		goto again;

We will again submit proper patch for it.

On Fri, Jun 8, 2012 at 8:22 AM, Ted Ts'o <tytso@mit.edu> wrote:
> I tried applying this patch, and it causes fsstress to die in xfstest=
s
> #13. =A0I took a quick look, but the truncate/punch codepaths are one=
 of
> the more obscure parts of ext4, and it's not obvious what causing the
> null dereference, which at first glance looks like is coming from
> path->b_bh->b_data.
>
> Also, please note that commit descriptions should be wrapped around
> 70-72 columns, so that "git log" is reasonable to look at on 80 colum=
n
> terminals.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
>
> 013 =A0 =A0 [ =A0 62.356981] BUG: unable to handle kernel NULL pointe=
r dereference at 00000019
> [ =A0 62.357880] IP: [<c029413f>] __ext4_ext_dirty+0x1c/0x52
> [ =A0 62.358836] *pdpt =3D 00000000352d2001 *pde =3D 0000000000000000
> [ =A0 62.359528] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [ =A0 62.360046] Modules linked in:
> [ =A0 62.360046]
> [ =A0 62.360046] Pid: 7178, comm: fsstress Not tainted 3.5.0-rc1-0000=
3-g69e292a-dirty #123 Bochs Bochs
> [ =A0 62.360046] EIP: 0060:[<c029413f>] EFLAGS: 00010202 CPU: 0
> [ =A0 62.360046] EIP is at __ext4_ext_dirty+0x1c/0x52
> [ =A0 62.360046] EAX: 00000001 EBX: 000009c9 ECX: f603b948 EDX: 00000=
9c9
> [ =A0 62.360046] ESI: c07234c4 EDI: f6bc05a0 EBP: efd7ddd4 ESP: efd7d=
dc4
> [ =A0 62.360046] =A0DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [ =A0 62.360046] CR0: 8005003b CR2: 00000019 CR3: 352d1000 CR4: 00000=
6f0
> [ =A0 62.360046] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000=
000
> [ =A0 62.360046] DR6: ffff0ff0 DR7: 00000400
> [ =A0 62.360046] Process fsstress (pid: 7178, ti=3Defd7c000 task=3Df6=
9214b0 task.ti=3Defd7c000)
> [ =A0 62.360046] Stack:
> [ =A0 62.360046] =A0f627f1ec 00000050 f627f1ec 00000007 efd7de8c c029=
62b9 f627f2e0 f6bc05a0
> [ =A0 62.360046] =A000000008 ffffffff ffffffff 80504000 f603b948 f62f=
1150 00000000 00000fe3
> [ =A0 62.360046] =A000010c15 00000000 f603b948 c071edb4 f5da6000 0000=
0001 f627f1ec 00000012
> [ =A0 62.360046] Call Trace:
> [ =A0 62.360046] =A0[<c02962b9>] ext4_ext_remove_space+0x6c2/0xaeb
> [ =A0 62.360046] =A0[<c0278998>] ? ext4_reserve_inode_write+0x38/0x6a
> [ =A0 62.360046] =A0[<c0296bd3>] ext4_ext_truncate+0x127/0x199
> [ =A0 62.360046] =A0[<c027a165>] ext4_truncate+0x7d/0xac
> [ =A0 62.360046] =A0[<c027a483>] ext4_setattr+0x2ef/0x377
> [ =A0 62.360046] =A0[<c0222636>] notify_change+0x1a6/0x27a
> [ =A0 62.360046] =A0[<c020e69d>] do_truncate+0x69/0x82
> [ =A0 62.360046] =A0[<c035094b>] ? security_inode_permission+0x1c/0x2=
2
> [ =A0 62.360046] =A0[<c020e8f7>] do_sys_truncate+0x12f/0x135
> [ =A0 62.360046] =A0[<c020e913>] sys_truncate64+0x16/0x18
> [ =A0 62.360046] =A0[<c06ec7c5>] syscall_call+0x7/0xb
> [ =A0 62.360046] =A0[<c06e0000>] ? pci_acpi_scan_root+0x12a/0x258
> [ =A0 62.360046] Code: 89 d1 ba 8b 00 00 00 e8 3b 4e 00 00 5a c9 c3 5=
5 89 e5 57 56 53 83 ec 04 3e 8d 74 26 00 8b 7d 0c 89 c6 89 d3 8b 47 18 =
85 c0 74 24 <8b> 50 18 8b 45 08 89 4d f0 e8 6d ff ff ff 8b 4d f0 89 da =
89 f0
> [ =A0 62.360046] EIP: [<c029413f>] __ext4_ext_dirty+0x1c/0x52 SS:ESP =
0068:efd7ddc4
> [ =A0 62.360046] CR2: 0000000000000019
> [ =A0 62.395961] ---[ end trace d13d52b79a9cd4d5 ]---
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
