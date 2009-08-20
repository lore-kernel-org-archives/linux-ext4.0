From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: 2.6.32-rc6 BUG at mm/slab.c:2869!
Date: Thu, 20 Aug 2009 08:08:16 +0300
Message-ID: <84144f020908192208x453ebbd4gecf52eb47903653d@mail.gmail.com>
References: <20090820015624.GE524@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752101AbZHTFIT@vger.kernel.org>
In-Reply-To: <20090820015624.GE524@hash.localnet>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Bob,

On Thu, Aug 20, 2009 at 4:56 AM, Bob Copeland<me@bobcopeland.com> wrote=
:
> Sorry I don't have a lot to go on here, but thought I'd report it any=
way.
> I was just starting firefox and got the following two stack traces in
> succession. =A0The kernel is based on 894ef820b10d77e2d6d717342fc408b=
dd9825139.
>
> Some kind of memory/filesystem corruption?

Someone is stomping on SLAB internal data structures. Ext4 appears in
both stack traces so I guess we should CC linux-ext4. How easy is it
to reproduce this bug? One option is to try kmemcheck to see if it
catches the problem (see Documentation/kmemcheck.txt for details).

> [ 8904.113230] ------------[ cut here ]------------
> [ 8902.989751] kernel BUG at mm/slab.c:2869!
> [ 8902.989755] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 8902.989762] last sysfs file: /sys/class/rfkill/rfkill0/state
> [ 8902.989765] Modules linked in: fuse af_packet ipt_REJECT xt_tcpudp=
 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_t=
ables acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multi=
path dm_mod kvm_intel kvm uinput arc4 ecb ath5k mac80211 i915 appletouc=
h hid_apple usbhid snd_hda_codec_idt ath drm ohci1394 snd_hda_intel cfg=
80211 snd_hda_codec i2c_algo_bit ieee1394 snd_pcm video processor rfkil=
l ehci_hcd sky2 snd_timer snd snd_page_alloc backlight uhci_hcd joydev =
sg ac battery thermal button output applesmc sr_mod cdrom input_polldev=
 evdev unix [last unloaded: scsi_wait_scan]
> [ 8902.989844]
> [ 8902.989849] Pid: 253, comm: kswapd0 Not tainted (2.6.31-rc6 #179) =
MacBook1,1
> [ 8902.989852] EIP: 0060:[<c10995cc>] EFLAGS: 00010002 CPU: 0
> [ 8902.989860] EIP is at cache_free_debugcheck+0x1a9/0x28a
> [ 8902.989863] EAX: 009d4e2e EBX: 8ee08ec0 ECX: 31286ea0 EDX: 009d4e2=
e
> [ 8902.989867] ESI: d84156c5 EDI: f7034440 EBP: f590fcb0 ESP: f590fc8=
0
> [ 8902.989870] =A0DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [ 8902.989874] Process kswapd0 (pid: 253, ti=3Df590e000 task=3Df72b04=
18 task.ti=3Df590e000)
> [ 8902.989877] Stack:
> [ 8902.989879] =A0f590fc88 c104aac4 00002184 c008f000 c10b8f69 f42058=
80 009d4e2e c008fd60
> [ 8902.989890] <0> c008fd68 f706af30 f7034440 e77e4ea0 f590fccc c1099=
911 c008fd68 00000296
> [ 8902.989901] <0> c008fd68 00000001 e77e4ea0 f590fcd8 c10b8f69 c008f=
d68 f590fcf4 c10b92f3
> [ 8902.989914] Call Trace:
> [ 8902.989920] =A0[<c104aac4>] ? trace_hardirqs_off+0xb/0xd
> [ 8902.989926] =A0[<c10b8f69>] ? free_buffer_head+0x21/0x62
> [ 8902.989931] =A0[<c1099911>] ? kmem_cache_free+0x4c/0xdf
> [ 8902.989936] =A0[<c10b8f69>] ? free_buffer_head+0x21/0x62
> [ 8902.989941] =A0[<c10b92f3>] ? try_to_free_buffers+0x7f/0x8f
> [ 8902.989947] =A0[<c1122f6c>] ? jbd2_journal_try_to_free_buffers+0x1=
37/0x13f
> [ 8902.989953] =A0[<c10fbce2>] ? ext4_releasepage+0x54/0x62
> [ 8902.989959] =A0[<c10784a2>] ? try_to_release_page+0x35/0x44
> [ 8902.989965] =A0[<c10827e1>] ? shrink_page_list+0x4b5/0x657
> [ 8902.989971] =A0[<c1049d9d>] ? put_lock_stats+0xd/0x21
> [ 8902.989976] =A0[<c104b8eb>] ? trace_hardirqs_on+0xb/0xd
> [ 8902.989982] =A0[<c1297839>] ? _spin_unlock_irq+0x32/0x47
> [ 8902.989987] =A0[<c1082bd0>] ? shrink_list+0x24d/0x514
> [ 8902.989993] =A0[<c1007cb3>] ? sched_clock+0x48/0x8d
> [ 8902.990000] =A0[<c1007cb3>] ? sched_clock+0x48/0x8d
> [ 8902.990004] =A0[<c1049d69>] ? get_lock_stats+0x11/0x38
> [ 8902.990009] =A0[<c1049d9d>] ? put_lock_stats+0xd/0x21
> [ 8902.990014] =A0[<c10830a8>] ? shrink_zone+0x211/0x2aa
> [ 8902.990020] =A0[<c1083682>] ? kswapd+0x3e2/0x587
> [ 8902.990021] =A0[<c1081686>] ? isolate_pages_global+0x0/0x18b
> [ 8902.990021] =A0[<c103ca60>] ? autoremove_wake_function+0x0/0x34
> [ 8902.990021] =A0[<c10832a0>] ? kswapd+0x0/0x587
> [ 8902.990021] =A0[<c103c78b>] ? kthread+0x70/0x75
> [ 8902.990021] =A0[<c103c71b>] ? kthread+0x0/0x75
> [ 8902.990021] =A0[<c10034f7>] ? kernel_thread_helper+0x7/0x10
> [ 8902.990021] Code: 0d 8b 47 2c 8b 55 e0 8b 4d ec 89 54 01 fc 8b 4d =
dc 8b 59 0c 8b 4d ec 29 d9 89 c8 f7 67 30 3b 57 38 89 45 e4 89 d0 89 55=
 e8 72 04 <0f> 0b eb fe 8b 4f 2c 0f af ca 8d 14 0b 39 55 ec 74 04 0f 0b=
 eb
> [ 8902.990021] EIP: [<c10995cc>] cache_free_debugcheck+0x1a9/0x28a SS=
:ESP 0068:f590fc80
> [ 8902.990021] ---[ end trace 73f44c391fc78b0a ]---
> [ 8904.113230] ------------[ cut here ]------------
> [ 8904.113250] WARNING: at lib/list_debug.c:51 list_del+0x41/0x60()
> [ 8904.113256] Hardware name: MacBook1,1
> [ 8904.113262] list_del corruption. next->prev should be c03c0000, bu=
t was 8ed88ec8
> [ 8904.113267] Modules linked in: fuse af_packet ipt_REJECT xt_tcpudp=
 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state iptable_filter ip_tables x_t=
ables acpi_cpufreq binfmt_misc dm_mirror dm_region_hash dm_log dm_multi=
path dm_mod kvm_intel kvm uinput arc4 ecb ath5k mac80211 i915 appletouc=
h hid_apple usbhid snd_hda_codec_idt ath drm ohci1394 snd_hda_intel cfg=
80211 snd_hda_codec i2c_algo_bit ieee1394 snd_pcm video processor rfkil=
l ehci_hcd sky2 snd_timer snd snd_page_alloc backlight uhci_hcd joydev =
sg ac battery thermal button output applesmc sr_mod cdrom input_polldev=
 evdev unix [last unloaded: scsi_wait_scan]
> [ 8904.113422] Pid: 6452, comm: firefox Tainted: G =A0 =A0 =A0D =A0 =A0=
2.6.31-rc6 #179
> [ 8904.113425] Call Trace:
> [ 8904.113433] =A0[<c1029a35>] warn_slowpath_common+0x6a/0x81
> [ 8904.113438] =A0[<c1156ff1>] ? list_del+0x41/0x60
> [ 8904.113443] =A0[<c1029a8a>] warn_slowpath_fmt+0x29/0x2c
> [ 8904.113447] =A0[<c1156ff1>] list_del+0x41/0x60
> [ 8904.113453] =A0[<c1099b3f>] free_block+0x7d/0x15a
> [ 8904.113457] =A0[<c10996f2>] ? cache_flusharray+0x45/0xf2
> [ 8904.113462] =A0[<c1099743>] cache_flusharray+0x96/0xf2
> [ 8904.113467] =A0[<c1099933>] kmem_cache_free+0x6e/0xdf
> [ 8904.113473] =A0[<c10b8f69>] free_buffer_head+0x21/0x62
> [ 8904.113477] =A0[<c10b92f3>] try_to_free_buffers+0x7f/0x8f
> [ 8904.113483] =A0[<c1122f6c>] jbd2_journal_try_to_free_buffers+0x137=
/0x13f
> [ 8904.113490] =A0[<c1106acf>] bdev_try_to_free_page+0x4c/0x5a
> [ 8904.113495] =A0[<c1106a83>] ? bdev_try_to_free_page+0x0/0x5a
> [ 8904.113500] =A0[<c10bebd7>] blkdev_releasepage+0x2b/0x36
> [ 8904.113506] =A0[<c10784a2>] try_to_release_page+0x35/0x44
> [ 8904.113512] =A0[<c10827e1>] shrink_page_list+0x4b5/0x657
> [ 8904.113518] =A0[<c104b8eb>] ? trace_hardirqs_on+0xb/0xd
> [ 8904.113524] =A0[<c1297839>] ? _spin_unlock_irq+0x32/0x47
> [ 8904.113529] =A0[<c1082bd0>] shrink_list+0x24d/0x514
> [ 8904.113535] =A0[<c103275f>] ? lock_timer_base+0x26/0x45
> [ 8904.113540] =A0[<c107f258>] ? get_dirty_limits+0x21/0x28a
> [ 8904.113562] =A0[<faaa16af>] ? mmu_shrink+0x1c/0xf4 [kvm]
> [ 8904.113566] =A0[<c104d6fa>] ? print_lock_contention_bug+0x11/0xb2
> [ 8904.113573] =A0[<c10830a8>] shrink_zone+0x211/0x2aa
> [ 8904.113578] =A0[<c1083cd3>] try_to_free_pages+0x1d1/0x2b2
> [ 8904.113583] =A0[<c1081686>] ? isolate_pages_global+0x0/0x18b
> [ 8904.113589] =A0[<c107e254>] __alloc_pages_nodemask+0x2d5/0x457
> [ 8904.113594] =A0[<c108001d>] __do_page_cache_readahead+0x10c/0x1c7
> [ 8904.113599] =A0[<c10800f4>] ra_submit+0x1c/0x21
> [ 8904.113604] =A0[<c1079897>] filemap_fault+0x1c5/0x39e
> [ 8904.113609] =A0[<c108a99e>] __do_fault+0x40/0x363
> [ 8904.113614] =A0[<c1299c10>] ? do_page_fault+0x1da/0x313
> [ 8904.113620] =A0[<c108c3a2>] handle_mm_fault+0x228/0x4ea
> [ 8904.113625] =A0[<c1299c10>] ? do_page_fault+0x1da/0x313
> [ 8904.113630] =A0[<c1299d3a>] do_page_fault+0x304/0x313
> [ 8904.113635] =A0[<c1299a36>] ? do_page_fault+0x0/0x313
> [ 8904.113639] =A0[<c1298133>] error_code+0x6b/0x70
> [ 8904.113644] =A0[<c1299a36>] ? do_page_fault+0x0/0x313
> [ 8904.113648] ---[ end trace 73f44c391fc78b0b ]---
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
