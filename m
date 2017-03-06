From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: 4.11-rc1 acpi stomping ext4 slabs
Date: Mon, 6 Mar 2017 22:31:00 +0200
Message-ID: <86f1c7af-0d74-f1fd-e1fb-cc2302824e27@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: rjw@rjwysocki.net, tytso@mit.edu,
        LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, 

Booting 4.11-rc1 with kasan enabled and "slub_debug=F" produces the following errors:

[    7.070797] ==================================================================
[    7.071724] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff88006bc2b0ae
[    7.071724] Read of size 20 by task systemd/1
[    7.071724] CPU: 1 PID: 1 Comm: systemd Not tainted 4.11.0-rc1-nbor #150
[    7.071724] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    7.071724] Call Trace:
[    7.071724]  dump_stack+0x85/0xc9
[    7.071724]  kasan_object_err+0x2c/0x90
[    7.071724]  kasan_report+0x285/0x510
[    7.071724]  check_memory_region+0x137/0x160
[    7.071724]  kasan_check_read+0x11/0x20
[    7.071724]  filldir+0xc3/0x160
[    7.071724]  call_filldir+0x88/0x140
[    7.071724]  ext4_readdir+0x757/0x920
[    7.071724]  ? iterate_dir+0x49/0x190
[    7.071724]  iterate_dir+0x7d/0x190
[    7.071724]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
[    7.071724]  SyS_getdents+0xac/0x170
[    7.071724]  ? filldir64+0x170/0x170
[    7.071724]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    7.071724] RIP: 0033:0x7fa37ca2dd3b
[    7.071724] RSP: 002b:00007ffc63daf400 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
[    7.071724] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fa37ca2dd3b
[    7.071724] RDX: 0000000000008000 RSI: 0000560b369e4a10 RDI: 0000000000000004
[    7.071724] RBP: 00007fa37cd29b20 R08: 00007fa37cd29bd8 R09: 0000000000000000
[    7.071724] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
[    7.071724] R13: 00007fa37cd29b78 R14: 000000000000270f R15: 00007fa37cd29b78
[    7.071724] Object at ffff88006bc2b080, in cache kmalloc-96 size: 96
[    7.071724] Allocated:
[    7.071724] PID = 1
[    7.071724]  save_stack_trace+0x1b/0x20
[    7.071724]  kasan_kmalloc.part.4+0x64/0xf0
[    7.071724]  kasan_kmalloc+0x85/0xb0
[    7.071724]  __kmalloc+0x12b/0x320
[    7.071724]  ext4_htree_store_dirent+0x3e/0x120
[    7.071724]  htree_dirblock_to_tree+0xb9/0x1a0
[    7.071724]  ext4_htree_fill_tree+0xa3/0x310
[    7.071724]  ext4_readdir+0x6a9/0x920
[    7.071724]  iterate_dir+0x7d/0x190
[    7.071724]  SyS_getdents+0xac/0x170
[    7.071724]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    7.071724] Freed:
[    7.071724] PID = 1
[    7.071724]  save_stack_trace+0x1b/0x20
[    7.071724]  kasan_slab_free+0xbe/0x190
[    7.071724]  kfree+0xff/0x2f0
[    7.071724]  acpi_ut_evaluate_object+0x18e/0x19d
[    7.071724]  acpi_ut_execute_STA+0x26/0x53
[    7.071724]  acpi_ns_get_device_callback+0x73/0x163
[    7.071724]  acpi_ns_walk_namespace+0xc0/0x17a
[    7.071724]  acpi_get_devices+0x66/0x7d
[    7.071724]  pnpacpi_init+0x52/0x74
[    7.071724]  do_one_initcall+0x51/0x1b0
[    7.071724]  kernel_init_freeable+0x20a/0x2a1
[    7.071724]  kernel_init+0xe/0x100
[    7.071724]  ret_from_fork+0x31/0x40
[    7.071724] Memory state around the buggy address:
[    7.071724]  ffff88006bc2af80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    7.071724]  ffff88006bc2b000: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[    7.071724] >ffff88006bc2b080: 00 00 00 00 00 00 00 00 05 fc fc fc fc fc fc fc
[    7.071724]                                            ^
[    7.071724]  ffff88006bc2b100: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
[    7.071724]  ffff88006bc2b180: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc

Not killing the VM instantly produces a continuous stream of kasan errors. Most of them 
are identical to the one above, however there was one which was different: 

[    5.846193] ==================================================================
[    5.846787] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff88006c783eae
[    5.847177] Read of size 22 by task systemd/1
[    5.847177] CPU: 3 PID: 1 Comm: systemd Tainted: G    B           4.11.0-rc1-nbor #150
[    5.847177] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    5.847177] Call Trace:
[    5.847177]  dump_stack+0x85/0xc9
[    5.847177]  kasan_object_err+0x2c/0x90
[    5.847177]  kasan_report+0x285/0x510
[    5.847177]  check_memory_region+0x137/0x160
[    5.847177]  kasan_check_read+0x11/0x20
[    5.847177]  filldir+0xc3/0x160
[    5.847177]  call_filldir+0x88/0x140
[    5.847177]  ext4_readdir+0x757/0x920
[    5.847177]  ? iterate_dir+0x49/0x190
[    5.847177]  iterate_dir+0x7d/0x190
[    5.847177]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
[    5.847177]  SyS_getdents+0xac/0x170
[    5.847177]  ? filldir64+0x170/0x170
[    5.847177]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    5.847177] RIP: 0033:0x7f9dbd4e1d3b
[    5.847177] RSP: 002b:00007ffee6b51a60 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
[    5.847177] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f9dbd4e1d3b
[    5.847177] RDX: 0000000000008000 RSI: 000055c046802a10 RDI: 0000000000000004
[    5.847177] RBP: 00007f9dbd7ddb20 R08: 00007f9dbd7ddbd8 R09: 0000000000000000
[    5.847177] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
[    5.847177] R13: 00007f9dbd7ddb78 R14: 000000000000270f R15: 00007f9dbd7ddb78
[    5.847177] Object at ffff88006c783e80, in cache kmalloc-96 size: 96
[    5.847177] Allocated:
[    5.847177] PID = 1
[    5.847177]  save_stack_trace+0x1b/0x20
[    5.847177]  kasan_kmalloc.part.4+0x64/0xf0
[    5.847177]  kasan_kmalloc+0x85/0xb0
[    5.847177]  __kmalloc+0x12b/0x320
[    5.847177]  ext4_htree_store_dirent+0x3e/0x120
[    5.847177]  htree_dirblock_to_tree+0xb9/0x1a0
[    5.847177]  ext4_htree_fill_tree+0xa3/0x310
[    5.847177]  ext4_readdir+0x6a9/0x920
[    5.847177]  iterate_dir+0x7d/0x190
[    5.847177]  SyS_getdents+0xac/0x170
[    5.847177]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    5.847177] Freed:
[    5.847177] PID = 1
[    5.847177]  save_stack_trace+0x1b/0x20
[    5.847177]  kasan_slab_free+0xbe/0x190
[    5.847177]  kfree+0xff/0x2f0
[    5.847177]  krealloc+0xac/0xc0
[    5.847177]  create_trace_option_files+0x127/0x270
[    5.847177]  __update_tracer_options+0x2c/0x40
[    5.847177]  tracer_init_tracefs+0x1a4/0x1b7
[    5.847177]  do_one_initcall+0x51/0x1b0
[    5.847177]  kernel_init_freeable+0x20a/0x2a1
[    5.847177]  kernel_init+0xe/0x100
[    5.847177]  ret_from_fork+0x31/0x40
[    5.847177] Memory state around the buggy address:

So the free path is different. 

On a different boot with slab_debug options omitted e.g. no debugging enabled for SLUB
I got:

[    5.586620] ==================================================================
[    5.587445] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff880000141aae
[    5.587584] Read of size 20 by task systemd/1
[    5.587584] CPU: 0 PID: 1 Comm: systemd Not tainted 4.11.0-rc1-nbor #148
[    5.587584] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
[    5.587584] Call Trace:
[    5.587584]  dump_stack+0x85/0xc9
[    5.587584]  kasan_object_err+0x2c/0x90
[    5.587584]  kasan_report+0x285/0x510
[    5.587584]  check_memory_region+0x137/0x160
[    5.587584]  kasan_check_read+0x11/0x20
[    5.587584]  filldir+0xc3/0x160
[    5.587584]  call_filldir+0x88/0x140
[    5.587584]  ext4_readdir+0x757/0x920
[    5.587584]  ? iterate_dir+0x49/0x190
[    5.587584]  iterate_dir+0x7d/0x190
[    5.587584]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
[    5.587584]  SyS_getdents+0xac/0x170
[    5.587584]  ? filldir64+0x170/0x170
[    5.587584]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    5.587584] RIP: 0033:0x7f71af785d3b
[    5.587584] RSP: 002b:00007ffeeda83390 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
[    5.587584] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f71af785d3b
[    5.587584] RDX: 0000000000008000 RSI: 0000561e6483ba10 RDI: 0000000000000004
[    5.587584] RBP: 00007f71afa81b20 R08: 00007f71afa81bd8 R09: 0000000000000000
[    5.587584] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
[    5.587584] R13: 00007f71afa81b78 R14: 000000000000270f R15: 00007f71afa81b78
[    5.587584] Object at ffff880000141a80, in cache kmalloc-96 size: 96
[    5.587584] Allocated:
[    5.587584] PID = 1
[    5.587584]  save_stack_trace+0x1b/0x20
[    5.587584]  kasan_kmalloc.part.4+0x64/0xf0
[    5.587584]  kasan_kmalloc+0x85/0xb0
[    5.587584]  __kmalloc+0x12b/0x320
[    5.587584]  ext4_htree_store_dirent+0x3e/0x120
[    5.587584]  htree_dirblock_to_tree+0xb9/0x1a0
[    5.587584]  ext4_htree_fill_tree+0xa3/0x310
[    5.587584]  ext4_readdir+0x6a9/0x920
[    5.587584]  iterate_dir+0x7d/0x190
[    5.587584]  SyS_getdents+0xac/0x170
[    5.587584]  entry_SYSCALL_64_fastpath+0x23/0xc6
[    5.587584] Freed:
[    5.587584] PID = 1
[    5.587584]  save_stack_trace+0x1b/0x20
[    5.587584]  kasan_slab_free+0xbe/0x190
[    5.587584]  kfree+0xff/0x2f0
[    5.587584]  acpi_evaluate_object+0x26c/0x27e
[    5.587584]  acpi_evaluate_integer+0x34/0x53
[    5.587584]  acpi_get_node+0x2b/0x51
[    5.587584]  pci_acpi_scan_root+0x2e/0x1d0
[    5.587584]  acpi_pci_root_add+0x264/0x34b
[    5.587584]  acpi_bus_attach+0xb6/0x15c
[    5.587584]  acpi_bus_attach+0x123/0x15c
[    5.587584]  acpi_bus_attach+0x123/0x15c
[    5.587584]  acpi_bus_scan+0x5b/0x6b
[    5.587584]  acpi_scan_init+0xcd/0x211
[    5.587584]  acpi_init+0x2e0/0x309
[    5.587584]  do_one_initcall+0x51/0x1b0
[    5.587584]  kernel_init_freeable+0x20a/0x2a1
[    5.587584]  kernel_init+0xe/0x100
[    5.587584]  ret_from_fork+0x31/0x40
[    5.587584] Memory state around the buggy address:
[    5.587584]  ffff880000141980: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
[    5.587584]  ffff880000141a00: 00 00 00 00 00 00 00 00 00 03 fc fc fc fc fc fc
[    5.587584] >ffff880000141a80: 00 00 00 00 00 00 00 00 05 fc fc fc fc fc fc fc
[    5.587584]                                            ^
[    5.587584]  ffff880000141b00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
[    5.587584]  ffff880000141b80: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc

I'm not sure if this is an ext4 or ACPI problem. 


