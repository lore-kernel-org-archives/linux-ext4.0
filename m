From: Sasha Levin <sasha.levin@oracle.com>
Subject: ext4: kernel BUG at fs/ext4/inode.c:2959!
Date: Wed, 08 Oct 2014 15:58:01 -0400
Message-ID: <54359749.7010208@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[  409.233952] kernel BUG at fs/ext4/inode.c:2959!
[  409.234761] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
[  409.237192] Dumping ftrace buffer:
[  409.238424]    (ftrace buffer empty)
[  409.239664] Modules linked in:
[  409.240706] CPU: 18 PID: 14016 Comm: trinity-c27 Not tainted 3.17.0-next-20141008-sasha-00051-g78b3c93-dirty #1364
[  409.242724] task: ffff88032bb00000 ti: ffff8802e78f8000 task.ti: ffff8802e78f8000
[  409.242724] RIP: ext4_direct_IO (fs/ext4/inode.c:2959 fs/ext4/inode.c:3098)
[  409.242724] RSP: 0018:ffff8802e78fbb98  EFLAGS: 00010246
[  409.242724] RAX: ffffda005cf1f7cf RBX: ffff88015f72f2f0 RCX: 0000000000000007
[  409.242724] RDX: dfffe90000000000 RSI: 1ffff1002e58c5ef RDI: ffff8802e78fbe78
[  409.242724] RBP: ffff8802e78fbc28 R08: dfffe90000000001 R09: ffff8802e78fbe5f
[  409.242724] R10: 1ffff1005cf1f7cb R11: 0000000000000001 R12: ffff8802e78fbe60
[  409.242724] R13: 000000000000000d R14: ffff8802e78fbc60 R15: ffff88015f72f2f0
[  409.242724] FS:  0000000000798860(0063) GS:ffff880851c00000(0000) knlGS:0000000000000000
[  409.242724] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  409.242724] CR2: 0000000002bd70f8 CR3: 000000032b542000 CR4: 00000000000006a0
[  409.242724] Stack:
[  409.242724]  ffff88017380a1e8 0000000000000000 ffff8802e78fbbf8 ffffffff9937c5ff
[  409.242724]  ffff88015f72f318 7fffffffffffffff 0000000000000000 ffff8802e78fbe78
[  409.242724]  ffff88015f72f2f0 0000000000000000 000000000000000d 000000015f72f2f0
[  409.242724] Call Trace:
[  409.242724] ? __filemap_fdatawrite_range (mm/filemap.c:288)
[  409.242724] generic_file_direct_write (mm/filemap.c:2413)
[  409.242724] __generic_file_write_iter (mm/filemap.c:2595)
[  409.242724] ext4_file_write_iter (fs/ext4/file.c:176)
[  409.242724] ? get_parent_ip (kernel/sched/core.c:2606)
[  409.242724] ? iov_iter_init (mm/iov_iter.c:442)
[  409.242724] new_sync_write (fs/read_write.c:478)
[  409.242724] vfs_write (fs/read_write.c:534)
[  409.242724] SyS_pwrite64 (fs/read_write.c:627 fs/read_write.c:614)
[  409.242724] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
[ 409.242724] Code: 00 00 65 8b 04 25 58 cb 00 00 a9 ff ff ff 7f 0f 85 94 fb ff ff e8 c1 cf ff ff f6 c4 02 0f 84 86 fb ff ff e9 5d fd ff ff 0f 1f 00 <0f> 0b e8 c9 4c c9 ff 84 c0 0f 84 85 fc ff ff 48 c7 c7 80 63 58
All code
========
   0:	00 00                	add    %al,(%rax)
   2:	65 8b 04 25 58 cb 00 	mov    %gs:0xcb58,%eax
   9:	00
   a:	a9 ff ff ff 7f       	test   $0x7fffffff,%eax
   f:	0f 85 94 fb ff ff    	jne    0xfffffffffffffba9
  15:	e8 c1 cf ff ff       	callq  0xffffffffffffcfdb
  1a:	f6 c4 02             	test   $0x2,%ah
  1d:	0f 84 86 fb ff ff    	je     0xfffffffffffffba9
  23:	e9 5d fd ff ff       	jmpq   0xfffffffffffffd85
  28:	0f 1f 00             	nopl   (%rax)
  2b:*	0f 0b                	ud2    		<-- trapping instruction
  2d:	e8 c9 4c c9 ff       	callq  0xffffffffffc94cfb
  32:	84 c0                	test   %al,%al
  34:	0f 84 85 fc ff ff    	je     0xfffffffffffffcbf
  3a:	48 c7 c7 80 63 58 00 	mov    $0x586380,%rdi

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	e8 c9 4c c9 ff       	callq  0xffffffffffc94cd0
   7:	84 c0                	test   %al,%al
   9:	0f 84 85 fc ff ff    	je     0xfffffffffffffc94
   f:	48 c7 c7 80 63 58 00 	mov    $0x586380,%rdi
[  409.242724] RIP ext4_direct_IO (fs/ext4/inode.c:2959 fs/ext4/inode.c:3098)
[  409.242724]  RSP <ffff8802e78fbb98>

Thanks,
Sasha
