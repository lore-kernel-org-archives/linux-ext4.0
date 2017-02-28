From: Nix <nix@esperi.org.uk>
Subject: repeatable inline-data oops (and fs corruption) caused by msync() of shared writable mmap (with recipe)
Date: Tue, 28 Feb 2017 22:22:25 +0000
Message-ID: <87y3wqc5we.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-ext4@vger.kernel.org,
        Linux FS Mailing List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I first spotted this -- or it spotted me -- back in the v4.7.x days. It
is still present in v4.10.

Here's a replication recipe, given a reasonable rootfs with a compiler
on it, and assuming a blank virtio disk on /dev/vdb:

bash-4.4# mke2fs -t ext4 -O inline_data /dev/vdb
# using stock /etc/mke2fs.conf from e2fsprogs master

bash-4.4# mount /dev/vdb /mnt/boom
bash-4.4# cat > boom.c
# derived from dovecot's configure script

#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
int main() {
  /* return 0 if we're signed */
  int f = open("conftest.mmap", O_RDWR|O_CREAT|O_TRUNC, 0600);
  void *mem;
  if (f == -1) {
    perror("open()");
    return 1;
  }
  unlink("conftest.mmap");

  write(f, "1", 2);
  mem = mmap(NULL, 2, PROT_READ|PROT_WRITE, MAP_SHARED, f, 0);
  if (mem == MAP_FAILED) {
    perror("mmap()");
    return 1;
  }
  strcpy(mem, "2");
  msync(mem, 2, MS_SYNC);
  lseek(f, 0, SEEK_SET);
  write(f, "3", 2);

  return strcmp(mem, "3") == 0 ? 0 : 1;
}
bash-4.4# gcc -O2 -o boom boom.c
bash-4.4# ./boom
[  205.652124] ------------[ cut here ]------------
[  205.653692] kernel BUG at fs/ext4/inode.c:2696!
[  205.655174] invalid opcode: 0000 [#1] SMP
[  205.656527] Modules linked in:
[  205.657675] CPU: 1 PID: 151 Comm: boom Not tainted 4.10.0-00006-g7f691c7bbef7-dirty #22
[  205.660319] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.1-0-g8891697-prebuilt.qemu-project.org 04/01/2014
[  205.661496] task: ffff88013a325040 task.stack: ffffc90000328000
[  205.661496] RIP: 0010:ext4_writepages+0xb30/0xcf0
[  205.661496] RSP: 0018:ffffc9000032bcb8 EFLAGS: 00010287
[  205.661496] RAX: 0000028410000000 RBX: ffff880139c820c0 RCX: 0000000000000800
[  205.661496] RDX: 0000000000a82000 RSI: 0000000000000001 RDI: ffff88013a3d4000
[  205.661496] RBP: ffffc9000032bde0 R08: 0000000000000800 R09: ffff880139c820c0
[  205.661496] R10: ffff880139c820c0 R11: 0000000000000000 R12: ffff880139cae898
[  205.661496] R13: ffff880139caea00 R14: ffff88013a3d7800 R15: ffffc9000032be00
[  205.661496] FS:  00007fc55a32e700(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
[  205.661496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  205.661496] CR2: 00007fc55a37d000 CR3: 0000000139546000 CR4: 00000000000006e0
[  205.661496] Call Trace:
[  205.661496]  ? __block_write_begin_int+0x2f2/0x5c0
[  205.661496]  ? ext4_inode_attach_jinode.part.16+0xa0/0xa0
[  205.661496]  ? __set_page_dirty_buffers+0x25/0xc0
[  205.661496]  ? ext4_set_page_dirty+0x49/0xa0
[  205.661496]  ? set_page_dirty+0x5b/0xb0
[  205.661496]  ? block_page_mkwrite+0xc2/0x100
[  205.661496]  ? ext4_page_mkwrite+0xe0/0x4c0
[  205.661496]  do_writepages+0x1e/0x30
[  205.661496]  __filemap_fdatawrite_range+0x71/0x90
[  205.661496]  filemap_write_and_wait_range+0x2a/0x70
[  205.661496]  ext4_sync_file+0xf4/0x390
[  205.661496]  vfs_fsync_range+0x49/0xa0
[  205.661496]  ? find_vma+0x1b/0x70
[  205.661496]  SyS_msync+0x182/0x200
[  205.661496]  entry_SYSCALL_64_fastpath+0x13/0x94
[  205.661496] RIP: 0033:0x7fc559ea2710
[  205.661496] RSP: 002b:00007ffec1f76c08 EFLAGS: 00000246 ORIG_RAX: 000000000000001a
[  205.661496] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc559ea2710
[  205.661496] RDX: 0000000000000004 RSI: 0000000000000002 RDI: 00007fc55a37d000
[  205.661496] RBP: 00007fc55a37d000 R08: 0000000000000003 R09: 0000000000000000
[  205.661496] R10: 0000000000000305 R11: 0000000000000246 R12: 00000000004006a0
[  205.661496] R13: 00007ffec1f76d00 R14: 0000000000000000 R15: 0000000000000000
[  205.661496] Code: 8b 44 24 18 48 c7 c1 38 ea 9e 81 ba a8 09 00 00 48 c7 c6 40 eb 83 81 48 8b 78 28 4c 8b 40 40 e8 37 97 01 00 44 8b 54 24 08 eb ac <0f> 0b 4c 8b 74 24 28 31 db 4c 8b 6c 24 20 4c 8b 7c 24 40 41 f6
[  205.661496] RIP: ext4_writepages+0xb30/0xcf0 RSP: ffffc9000032bcb8
[  205.730074] ---[ end trace f8ac10159c3827e3 ]---

./boom is (obviously) now stuck in D state, so the filesystem is not
umountable (except lazily). Further writing to the filesystem in this
state can corrupt it so badly that fsck can't make head or tail of it,
though debugfs can still find hints that it was probably an ext4
filesystem once upon a time.

-- 
NULL && (void)
