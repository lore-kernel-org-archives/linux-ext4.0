From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext4: kernel BUG at fs/ext4/inode.c:2959!
Date: Thu, 09 Oct 2014 14:06:46 +0400
Message-ID: <874mvdblqh.fsf@openvz.org>
References: <54359749.7010208@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37231 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIKGz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 06:06:55 -0400
In-Reply-To: <54359749.7010208@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Sasha Levin <sasha.levin@oracle.com> writes:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
Indeed this is a pure bug.
Race between write and fcntl(F_SETFL) which toggling O_DIRECT.
So even if we started with buffered path we may endup in direct one :)
See my testcase: http://marc.info/?l=linux-ext4&m=141284883914726&w=2
Unfortunately f_flags guarded by filp->f_lock so it looks like we
can not use generic __generic_file_write_iter() and need specific one
which use precached o_direct status.
>
> [  409.233952] kernel BUG at fs/ext4/inode.c:2959!
> [  409.234761] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
> [  409.237192] Dumping ftrace buffer:
> [  409.238424]    (ftrace buffer empty)
> [  409.239664] Modules linked in:
> [  409.240706] CPU: 18 PID: 14016 Comm: trinity-c27 Not tainted 3.17.0-next-20141008-sasha-00051-g78b3c93-dirty #1364
> [  409.242724] task: ffff88032bb00000 ti: ffff8802e78f8000 task.ti: ffff8802e78f8000
> [  409.242724] RIP: ext4_direct_IO (fs/ext4/inode.c:2959 fs/ext4/inode.c:3098)
> [  409.242724] RSP: 0018:ffff8802e78fbb98  EFLAGS: 00010246
> [  409.242724] RAX: ffffda005cf1f7cf RBX: ffff88015f72f2f0 RCX: 0000000000000007
> [  409.242724] RDX: dfffe90000000000 RSI: 1ffff1002e58c5ef RDI: ffff8802e78fbe78
> [  409.242724] RBP: ffff8802e78fbc28 R08: dfffe90000000001 R09: ffff8802e78fbe5f
> [  409.242724] R10: 1ffff1005cf1f7cb R11: 0000000000000001 R12: ffff8802e78fbe60
> [  409.242724] R13: 000000000000000d R14: ffff8802e78fbc60 R15: ffff88015f72f2f0
> [  409.242724] FS:  0000000000798860(0063) GS:ffff880851c00000(0000) knlGS:0000000000000000
> [  409.242724] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  409.242724] CR2: 0000000002bd70f8 CR3: 000000032b542000 CR4: 00000000000006a0
> [  409.242724] Stack:
> [  409.242724]  ffff88017380a1e8 0000000000000000 ffff8802e78fbbf8 ffffffff9937c5ff
> [  409.242724]  ffff88015f72f318 7fffffffffffffff 0000000000000000 ffff8802e78fbe78
> [  409.242724]  ffff88015f72f2f0 0000000000000000 000000000000000d 000000015f72f2f0
> [  409.242724] Call Trace:
> [  409.242724] ? __filemap_fdatawrite_range (mm/filemap.c:288)
> [  409.242724] generic_file_direct_write (mm/filemap.c:2413)
> [  409.242724] __generic_file_write_iter (mm/filemap.c:2595)
> [  409.242724] ext4_file_write_iter (fs/ext4/file.c:176)
> [  409.242724] ? get_parent_ip (kernel/sched/core.c:2606)
> [  409.242724] ? iov_iter_init (mm/iov_iter.c:442)
> [  409.242724] new_sync_write (fs/read_write.c:478)
> [  409.242724] vfs_write (fs/read_write.c:534)
> [  409.242724] SyS_pwrite64 (fs/read_write.c:627 fs/read_write.c:614)
> [  409.242724] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
> [ 409.242724] Code: 00 00 65 8b 04 25 58 cb 00 00 a9 ff ff ff 7f 0f 85 94 fb ff ff e8 c1 cf ff ff f6 c4 02 0f 84 86 fb ff ff e9 5d fd ff ff 0f 1f 00 <0f> 0b e8 c9 4c c9 ff 84 c0 0f 84 85 fc ff ff 48 c7 c7 80 63 58
> All code
> ========
>    0:	00 00                	add    %al,(%rax)
>    2:	65 8b 04 25 58 cb 00 	mov    %gs:0xcb58,%eax
>    9:	00
>    a:	a9 ff ff ff 7f       	test   $0x7fffffff,%eax
>    f:	0f 85 94 fb ff ff    	jne    0xfffffffffffffba9
>   15:	e8 c1 cf ff ff       	callq  0xffffffffffffcfdb
>   1a:	f6 c4 02             	test   $0x2,%ah
>   1d:	0f 84 86 fb ff ff    	je     0xfffffffffffffba9
>   23:	e9 5d fd ff ff       	jmpq   0xfffffffffffffd85
>   28:	0f 1f 00             	nopl   (%rax)
>   2b:*	0f 0b                	ud2    		<-- trapping instruction
>   2d:	e8 c9 4c c9 ff       	callq  0xffffffffffc94cfb
>   32:	84 c0                	test   %al,%al
>   34:	0f 84 85 fc ff ff    	je     0xfffffffffffffcbf
>   3a:	48 c7 c7 80 63 58 00 	mov    $0x586380,%rdi
>
> Code starting with the faulting instruction
> ===========================================
>    0:	0f 0b                	ud2
>    2:	e8 c9 4c c9 ff       	callq  0xffffffffffc94cd0
>    7:	84 c0                	test   %al,%al
>    9:	0f 84 85 fc ff ff    	je     0xfffffffffffffc94
>    f:	48 c7 c7 80 63 58 00 	mov    $0x586380,%rdi
> [  409.242724] RIP ext4_direct_IO (fs/ext4/inode.c:2959 fs/ext4/inode.c:3098)
> [  409.242724]  RSP <ffff8802e78fbb98>
>
> Thanks,
> Sasha
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNl42AAoJEFzOBSYIXfveNjMQAJvnmPLVV8/0Uhi0xEH9zrUe
1ezFw9KUXYk0ZQLAoLeBZHZrUk8ZFukgt2xgMEXl4zfYxX03XrrdG5Ku4R4Vbkg7
JWTK4/tZt0GV3VeJ2jQrnxnPT4mVQqh9dtYAEg/x9PLpcyFAZ5CQSzAKOH29fZZC
FrvrSwrH11h1iVcT13ZYYUGa2DDvggxAGLeakvVVo3v2mkF6kt8uW4fOXi8ynXjU
fgKWL04GjhbeDYSZL08ggjV3vOwU1nPuEy55GpVJQjFXrHVL4OJl/p8SYi+x8wnR
u3ZdLO1rfvTpHOH7Vj50OwYYe2UbcjHQt08QktiAdSirTfv7i0S4eN9RZHEDafBr
+XrpEH9PuAAOjeezlKV+jZQywAAnrhdBSBTNX5RPA7SGfTDgmZwnBse1wguwLDlA
NgE9mMijnLPgFjBd1Fn/SvImf4zZhe0v/U6A58eo7mhPsqcI0gVt69CGFwIpXsgR
i+QvqPpWUtdFvbDa8Cl/jnplerF6EeEP1y01GrmtTtvnE68t/lcbkl2OXzxfZofK
pfo2qKZJ0Iud7ZvoA8G1OJg492d1SFD1W+Kk/Fu7K/ZwXzAraLAxwW0jf75U+ujM
gpfHfWqz8SFN7Qdsb6g/iUY1M0/tVOcXHTs6WuYDDcoUik3CLkJVCnx5c+JXh/jX
EhibDHOx8Tk4gBS/Hp98
=PVMh
-----END PGP SIGNATURE-----
--=-=-=--
