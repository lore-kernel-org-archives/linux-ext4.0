From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: Race condition in ext4 (was Re: 4.11-rc1 acpi stomping ext4 slabs)
Date: Tue, 7 Mar 2017 16:33:44 +0200
Message-ID: <1018b7d9-2566-c0f2-bef7-8274617facd6@gmail.com>
References: <86f1c7af-0d74-f1fd-e1fb-cc2302824e27@gmail.com>
 <CAJZ5v0h47dTwpOPJfzyM41YaS8u3es83wh7xtJ3fxn1cKbuELA@mail.gmail.com>
 <507b9b64-798b-d542-8169-17738c405aad@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <507b9b64-798b-d542-8169-17738c405aad@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On  7.03.2017 11:38, Nikolay Borisov wrote:
> 
> 
> On  7.03.2017 00:35, Rafael J. Wysocki wrote:
>> On Mon, Mar 6, 2017 at 9:31 PM, Nikolay Borisov
>> <n.borisov.lkml@gmail.com> wrote:
>>> Hello,
>>>
>>> Booting 4.11-rc1 with kasan enabled and "slub_debug=F" produces the following errors:
>>>
>>> [    7.070797] ==================================================================
>>> [    7.071724] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff88006bc2b0ae
>>> [    7.071724] Read of size 20 by task systemd/1
>>> [    7.071724] CPU: 1 PID: 1 Comm: systemd Not tainted 4.11.0-rc1-nbor #150
>>> [    7.071724] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>>> [    7.071724] Call Trace:
>>> [    7.071724]  dump_stack+0x85/0xc9
>>> [    7.071724]  kasan_object_err+0x2c/0x90
>>> [    7.071724]  kasan_report+0x285/0x510
>>> [    7.071724]  check_memory_region+0x137/0x160
>>> [    7.071724]  kasan_check_read+0x11/0x20
>>> [    7.071724]  filldir+0xc3/0x160
>>> [    7.071724]  call_filldir+0x88/0x140
>>> [    7.071724]  ext4_readdir+0x757/0x920
>>> [    7.071724]  ? iterate_dir+0x49/0x190
>>> [    7.071724]  iterate_dir+0x7d/0x190
>>> [    7.071724]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
>>> [    7.071724]  SyS_getdents+0xac/0x170
>>> [    7.071724]  ? filldir64+0x170/0x170
>>> [    7.071724]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    7.071724] RIP: 0033:0x7fa37ca2dd3b
>>> [    7.071724] RSP: 002b:00007ffc63daf400 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
>>> [    7.071724] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fa37ca2dd3b
>>> [    7.071724] RDX: 0000000000008000 RSI: 0000560b369e4a10 RDI: 0000000000000004
>>> [    7.071724] RBP: 00007fa37cd29b20 R08: 00007fa37cd29bd8 R09: 0000000000000000
>>> [    7.071724] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
>>> [    7.071724] R13: 00007fa37cd29b78 R14: 000000000000270f R15: 00007fa37cd29b78
>>> [    7.071724] Object at ffff88006bc2b080, in cache kmalloc-96 size: 96
>>> [    7.071724] Allocated:
>>> [    7.071724] PID = 1
>>> [    7.071724]  save_stack_trace+0x1b/0x20
>>> [    7.071724]  kasan_kmalloc.part.4+0x64/0xf0
>>> [    7.071724]  kasan_kmalloc+0x85/0xb0
>>> [    7.071724]  __kmalloc+0x12b/0x320
>>> [    7.071724]  ext4_htree_store_dirent+0x3e/0x120
>>> [    7.071724]  htree_dirblock_to_tree+0xb9/0x1a0
>>> [    7.071724]  ext4_htree_fill_tree+0xa3/0x310
>>> [    7.071724]  ext4_readdir+0x6a9/0x920
>>> [    7.071724]  iterate_dir+0x7d/0x190
>>> [    7.071724]  SyS_getdents+0xac/0x170
>>> [    7.071724]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    7.071724] Freed:
>>> [    7.071724] PID = 1
>>> [    7.071724]  save_stack_trace+0x1b/0x20
>>> [    7.071724]  kasan_slab_free+0xbe/0x190
>>> [    7.071724]  kfree+0xff/0x2f0
>>> [    7.071724]  acpi_ut_evaluate_object+0x18e/0x19d
>>> [    7.071724]  acpi_ut_execute_STA+0x26/0x53
>>> [    7.071724]  acpi_ns_get_device_callback+0x73/0x163
>>> [    7.071724]  acpi_ns_walk_namespace+0xc0/0x17a
>>> [    7.071724]  acpi_get_devices+0x66/0x7d
>>> [    7.071724]  pnpacpi_init+0x52/0x74
>>> [    7.071724]  do_one_initcall+0x51/0x1b0
>>> [    7.071724]  kernel_init_freeable+0x20a/0x2a1
>>> [    7.071724]  kernel_init+0xe/0x100
>>> [    7.071724]  ret_from_fork+0x31/0x40
>>> [    7.071724] Memory state around the buggy address:
>>> [    7.071724]  ffff88006bc2af80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> [    7.071724]  ffff88006bc2b000: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>>> [    7.071724] >ffff88006bc2b080: 00 00 00 00 00 00 00 00 05 fc fc fc fc fc fc fc
>>> [    7.071724]                                            ^
>>> [    7.071724]  ffff88006bc2b100: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
>>> [    7.071724]  ffff88006bc2b180: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>>>
>>> Not killing the VM instantly produces a continuous stream of kasan errors. Most of them
>>> are identical to the one above, however there was one which was different:
>>>
>>> [    5.846193] ==================================================================
>>> [    5.846787] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff88006c783eae
>>> [    5.847177] Read of size 22 by task systemd/1
>>> [    5.847177] CPU: 3 PID: 1 Comm: systemd Tainted: G    B           4.11.0-rc1-nbor #150
>>> [    5.847177] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>>> [    5.847177] Call Trace:
>>> [    5.847177]  dump_stack+0x85/0xc9
>>> [    5.847177]  kasan_object_err+0x2c/0x90
>>> [    5.847177]  kasan_report+0x285/0x510
>>> [    5.847177]  check_memory_region+0x137/0x160
>>> [    5.847177]  kasan_check_read+0x11/0x20
>>> [    5.847177]  filldir+0xc3/0x160
>>> [    5.847177]  call_filldir+0x88/0x140
>>> [    5.847177]  ext4_readdir+0x757/0x920
>>> [    5.847177]  ? iterate_dir+0x49/0x190
>>> [    5.847177]  iterate_dir+0x7d/0x190
>>> [    5.847177]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
>>> [    5.847177]  SyS_getdents+0xac/0x170
>>> [    5.847177]  ? filldir64+0x170/0x170
>>> [    5.847177]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    5.847177] RIP: 0033:0x7f9dbd4e1d3b
>>> [    5.847177] RSP: 002b:00007ffee6b51a60 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
>>> [    5.847177] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f9dbd4e1d3b
>>> [    5.847177] RDX: 0000000000008000 RSI: 000055c046802a10 RDI: 0000000000000004
>>> [    5.847177] RBP: 00007f9dbd7ddb20 R08: 00007f9dbd7ddbd8 R09: 0000000000000000
>>> [    5.847177] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
>>> [    5.847177] R13: 00007f9dbd7ddb78 R14: 000000000000270f R15: 00007f9dbd7ddb78
>>> [    5.847177] Object at ffff88006c783e80, in cache kmalloc-96 size: 96
>>> [    5.847177] Allocated:
>>> [    5.847177] PID = 1
>>> [    5.847177]  save_stack_trace+0x1b/0x20
>>> [    5.847177]  kasan_kmalloc.part.4+0x64/0xf0
>>> [    5.847177]  kasan_kmalloc+0x85/0xb0
>>> [    5.847177]  __kmalloc+0x12b/0x320
>>> [    5.847177]  ext4_htree_store_dirent+0x3e/0x120
>>> [    5.847177]  htree_dirblock_to_tree+0xb9/0x1a0
>>> [    5.847177]  ext4_htree_fill_tree+0xa3/0x310
>>> [    5.847177]  ext4_readdir+0x6a9/0x920
>>> [    5.847177]  iterate_dir+0x7d/0x190
>>> [    5.847177]  SyS_getdents+0xac/0x170
>>> [    5.847177]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    5.847177] Freed:
>>> [    5.847177] PID = 1
>>> [    5.847177]  save_stack_trace+0x1b/0x20
>>> [    5.847177]  kasan_slab_free+0xbe/0x190
>>> [    5.847177]  kfree+0xff/0x2f0
>>> [    5.847177]  krealloc+0xac/0xc0
>>> [    5.847177]  create_trace_option_files+0x127/0x270
>>> [    5.847177]  __update_tracer_options+0x2c/0x40
>>> [    5.847177]  tracer_init_tracefs+0x1a4/0x1b7
>>> [    5.847177]  do_one_initcall+0x51/0x1b0
>>> [    5.847177]  kernel_init_freeable+0x20a/0x2a1
>>> [    5.847177]  kernel_init+0xe/0x100
>>> [    5.847177]  ret_from_fork+0x31/0x40
>>> [    5.847177] Memory state around the buggy address:
>>>
>>> So the free path is different.
>>>
>>> On a different boot with slab_debug options omitted e.g. no debugging enabled for SLUB
>>> I got:
>>>
>>> [    5.586620] ==================================================================
>>> [    5.587445] BUG: KASAN: slab-out-of-bounds in filldir+0xc3/0x160 at addr ffff880000141aae
>>> [    5.587584] Read of size 20 by task systemd/1
>>> [    5.587584] CPU: 0 PID: 1 Comm: systemd Not tainted 4.11.0-rc1-nbor #148
>>> [    5.587584] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>>> [    5.587584] Call Trace:
>>> [    5.587584]  dump_stack+0x85/0xc9
>>> [    5.587584]  kasan_object_err+0x2c/0x90
>>> [    5.587584]  kasan_report+0x285/0x510
>>> [    5.587584]  check_memory_region+0x137/0x160
>>> [    5.587584]  kasan_check_read+0x11/0x20
>>> [    5.587584]  filldir+0xc3/0x160
>>> [    5.587584]  call_filldir+0x88/0x140
>>> [    5.587584]  ext4_readdir+0x757/0x920
>>> [    5.587584]  ? iterate_dir+0x49/0x190
>>> [    5.587584]  iterate_dir+0x7d/0x190
>>> [    5.587584]  ? entry_SYSCALL_64_fastpath+0x5/0xc6
>>> [    5.587584]  SyS_getdents+0xac/0x170
>>> [    5.587584]  ? filldir64+0x170/0x170
>>> [    5.587584]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    5.587584] RIP: 0033:0x7f71af785d3b
>>> [    5.587584] RSP: 002b:00007ffeeda83390 EFLAGS: 00000206 ORIG_RAX: 000000000000004e
>>> [    5.587584] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007f71af785d3b
>>> [    5.587584] RDX: 0000000000008000 RSI: 0000561e6483ba10 RDI: 0000000000000004
>>> [    5.587584] RBP: 00007f71afa81b20 R08: 00007f71afa81bd8 R09: 0000000000000000
>>> [    5.587584] R10: 000000000000008f R11: 0000000000000206 R12: 0000000000008041
>>> [    5.587584] R13: 00007f71afa81b78 R14: 000000000000270f R15: 00007f71afa81b78
>>> [    5.587584] Object at ffff880000141a80, in cache kmalloc-96 size: 96
>>> [    5.587584] Allocated:
>>> [    5.587584] PID = 1
>>> [    5.587584]  save_stack_trace+0x1b/0x20
>>> [    5.587584]  kasan_kmalloc.part.4+0x64/0xf0
>>> [    5.587584]  kasan_kmalloc+0x85/0xb0
>>> [    5.587584]  __kmalloc+0x12b/0x320
>>> [    5.587584]  ext4_htree_store_dirent+0x3e/0x120
>>> [    5.587584]  htree_dirblock_to_tree+0xb9/0x1a0
>>> [    5.587584]  ext4_htree_fill_tree+0xa3/0x310
>>> [    5.587584]  ext4_readdir+0x6a9/0x920
>>> [    5.587584]  iterate_dir+0x7d/0x190
>>> [    5.587584]  SyS_getdents+0xac/0x170
>>> [    5.587584]  entry_SYSCALL_64_fastpath+0x23/0xc6
>>> [    5.587584] Freed:
>>> [    5.587584] PID = 1
>>> [    5.587584]  save_stack_trace+0x1b/0x20
>>> [    5.587584]  kasan_slab_free+0xbe/0x190
>>> [    5.587584]  kfree+0xff/0x2f0
>>> [    5.587584]  acpi_evaluate_object+0x26c/0x27e
>>> [    5.587584]  acpi_evaluate_integer+0x34/0x53
>>> [    5.587584]  acpi_get_node+0x2b/0x51
>>> [    5.587584]  pci_acpi_scan_root+0x2e/0x1d0
>>> [    5.587584]  acpi_pci_root_add+0x264/0x34b
>>> [    5.587584]  acpi_bus_attach+0xb6/0x15c
>>> [    5.587584]  acpi_bus_attach+0x123/0x15c
>>> [    5.587584]  acpi_bus_attach+0x123/0x15c
>>> [    5.587584]  acpi_bus_scan+0x5b/0x6b
>>> [    5.587584]  acpi_scan_init+0xcd/0x211
>>> [    5.587584]  acpi_init+0x2e0/0x309
>>> [    5.587584]  do_one_initcall+0x51/0x1b0
>>> [    5.587584]  kernel_init_freeable+0x20a/0x2a1
>>> [    5.587584]  kernel_init+0xe/0x100
>>> [    5.587584]  ret_from_fork+0x31/0x40
>>> [    5.587584] Memory state around the buggy address:
>>> [    5.587584]  ffff880000141980: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>>> [    5.587584]  ffff880000141a00: 00 00 00 00 00 00 00 00 00 03 fc fc fc fc fc fc
>>> [    5.587584] >ffff880000141a80: 00 00 00 00 00 00 00 00 05 fc fc fc fc fc fc fc
>>> [    5.587584]                                            ^
>>> [    5.587584]  ffff880000141b00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>>> [    5.587584]  ffff880000141b80: 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc
>>>
>>> I'm not sure if this is an ext4 or ACPI problem.
>>
>> If this is a new bug, you can look for the first bad commit using git-bisect.
> 
> So apparently this is an ext4 bug, since I managed to bisected it all the way to 1771c6e1a567ea0 
> ("x86/kasan: instrument user memory access API"). So the first bad kernel is 4.7 and ACPI is not to blame . 
> 
> [EXT4 people might want to start looking from here]
> 
> There the splat looks like : 
> 
> [   17.003256] ==================================================================
> [   17.004185] BUG: KASAN: slab-out-of-bounds in filldir+0xc8/0x170 at addr ffff88006a22560e
> [   17.005177] Read of size 20 by task systemd/1
> [   17.005708] =============================================================================
> [   17.006688] BUG kmalloc-96 (Not tainted): kasan: bad access detected
> [   17.007464] -----------------------------------------------------------------------------
> [   17.007464] 
> [   17.008584] Disabling lock debugging due to kernel taint
> [   17.009202] INFO: Allocated in ext4_htree_store_dirent+0x3e/0x120 age=0 cpu=2 pid=1
> [   17.010080] 	___slab_alloc+0x636/0x6a0
> [   17.010514] 	__slab_alloc+0x4f/0x86
> [   17.010927] 	__kmalloc+0x27a/0x340
> [   17.011318] 	ext4_htree_store_dirent+0x3e/0x120
> [   17.011796] 	htree_dirblock_to_tree+0x16a/0x190
> [   17.012270] 	ext4_htree_fill_tree+0xaa/0x310
> [   17.012735] 	ext4_readdir+0x698/0x950
> [   17.013117] 	iterate_dir+0x7d/0x190
> [   17.013485] 	SyS_getdents+0x91/0x120
> [   17.013873] 	entry_SYSCALL_64_fastpath+0x23/0xc1
> [   17.014360] INFO: Freed in ext4_ext_map_blocks+0x7f9/0x23e0 age=1 cpu=2 pid=1
> [   17.015110] 	__slab_free+0x31b/0x440
> [   17.015489] 	kfree+0x27f/0x2d0
> [   17.015820] 	ext4_ext_map_blocks+0x7f9/0x23e0
> [   17.016283] 	ext4_map_blocks+0x3b4/0x5b0
> [   17.016699] 	ext4_getblk+0x54/0x1a0
> [   17.017066] 	ext4_bread+0x13/0x90
> [   17.017412] 	__ext4_read_dirblock+0x3f/0x380
> [   17.017861] 	htree_dirblock_to_tree+0x48/0x190
> [   17.018324] 	ext4_htree_fill_tree+0xaa/0x310
> [   17.018776] 	ext4_readdir+0x698/0x950
> [   17.019176] 	iterate_dir+0x7d/0x190
> [   17.019551] 	SyS_getdents+0x91/0x120
> [   17.019932] 	entry_SYSCALL_64_fastpath+0x23/0xc1
> [   17.020431] INFO: Slab 0xffffea0001a88900 objects=20 used=17 fp=0xffff88006a224e10 flags=0x4080
> [   17.021348] INFO: Object 0xffff88006a2255e0 @offset=5600 fp=0x45b282a2484c60d4
> [   17.021348] 
> [   17.022264] Bytes b4 ffff88006a2255d0: 02 00 00 00 01 00 00 00 c9 ac fb ff 00 00 00 00  ................
> [   17.023272] Object ffff88006a2255e0: d4 60 4c 48 a2 82 b2 45 18 8a 82 6a 00 88 ff ff  .`LH...E...j....
> [   17.024252] Object ffff88006a2255f0: 38 51 22 6a 00 88 ff ff 88 8b 82 6a 00 88 ff ff  8Q"j.......j....
> [   17.025166] Object ffff88006a225600: 00 00 00 00 00 00 00 00 28 03 08 00 14 01 66 62  ........(.....fb
> [   17.026129] Object ffff88006a225610: 64 65 76 2d 62 6c 61 63 6b 6c 69 73 74 2e 63 6f  dev-blacklist.co
> [   17.027156] Object ffff88006a225620: 6e 66 00 00 00 00 00 00 00 00 00 00 00 00 00 00  nf..............
> [   17.028202] Object ffff88006a225630: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [   17.029186] CPU: 2 PID: 1 Comm: systemd Tainted: G    B           4.7.0-nbor #171
> [   17.029972] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   17.030959]  0000000000000000 ffff88006cd97c58 ffffffff8146bd4c ffff8800000946c0
> [   17.031776]  ffff88006a2255e0 ffff88006cd97c88 ffffffff81198d96 ffff8800000946c0
> [   17.032597]  ffffea0001a88900 ffff88006a2255e0 0000000000000000 ffff88006cd97cb0
> [   17.033425] Call Trace:
> [   17.033700]  [<ffffffff8146bd4c>] dump_stack+0x85/0xc9
> [   17.034246]  [<ffffffff81198d96>] print_trailer+0x116/0x190
> [   17.034840]  [<ffffffff811992c1>] object_err+0x41/0x50
> [   17.035390]  [<ffffffff811a0a42>] kasan_report+0x282/0x530
> [   17.035966]  [<ffffffff8119ffa7>] check_memory_region+0x137/0x160
> [   17.036594]  [<ffffffff811a0041>] kasan_check_read+0x11/0x20
> [   17.037181]  [<ffffffff811ccc08>] filldir+0xc8/0x170 <---  if (copy_to_user(dirent->d_name, name, namlen))
> [   17.037687]  [<ffffffff8124af38>] call_filldir+0x88/0x140
> [   17.038244]  [<ffffffff8124b934>] ext4_readdir+0x714/0x950
> [   17.038813]  [<ffffffff811cccf9>] ? iterate_dir+0x49/0x190
> [   17.039399]  [<ffffffff811ccd2d>] iterate_dir+0x7d/0x190
> [   17.039909]  [<ffffffff811ccf71>] SyS_getdents+0x91/0x120
> [   17.040428]  [<ffffffff811ccb40>] ? filldir64+0x180/0x180
> [   17.040977]  [<ffffffff816d7d80>] entry_SYSCALL_64_fastpath+0x23/0xc1
> [   17.041652] Memory state around the buggy address:
> [   17.042136]  ffff88006a225500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   17.042924]  ffff88006a225580: fc fc fc fc fc fc fc fc fc fc fc fc 00 00 00 00
> [   17.043652] >ffff88006a225600: 00 00 00 00 05 fc fc fc fc fc fc fc fc fc fc fc
> [   17.044382]                                ^
> [   17.044814]  ffff88006a225680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [   17.045559]  ffff88006a225700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc 00 00
> [   17.046308] ==================================================================
> 
> 
> So the buffer containing the dentry name as received from ext4_htree_fill is actually 
> freed. 
> 

So this is some sort of a race condition. The problem disappeared as
soon as I added the following line:
pr_info("%s:freeing %p\n", __func__, path);
right after the ext4_ext_drop_refs(path); call in out2: label.
