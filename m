From: Peter Hurley <peter@hurleysoftware.com>
Subject: [next-20130204] hard LOCKUP on cpu 5, 3, 4, 2
Date: Tue, 12 Feb 2013 23:45:53 -0500
Message-ID: <1360730753.3642.38.camel@thor.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-NY5aU+eJCWIEyIW5QKQb"
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, Alasdair Kergon <agk@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-NY5aU+eJCWIEyIW5QKQb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Got this message log (excerpted below) while building a kernel on
next-20130204.

The build was taking place on an ext4 fs which is device-mapped on
stripped fakeraid.

[I have no idea what gvfs was doing.]

Besides the obvious hard lockups in the fs, the IPIs failed to trigger
stack dumps for any of the other CPUs [thus +cc x86]. I'm building the
NMI selftest in now.

[ 2635.021602] ------------[ cut here ]------------
[ 2635.021602] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:245 watchdog_overflow_callback+0x9f/0xd0()
[ 2635.021602] Hardware name: Precision WorkStation T5400  
[ 2635.021602] Watchdog detected hard LOCKUP on cpu 5
[ 2635.021602] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_device snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_page_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh lpc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_dj dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 nouveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit[ 2656.019995] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2656.020000] 	5: (0 ticks this GP) idle=cfd/140000000000001/0 last_accelerate: e84a/fccd, nonlazy_posted: 0, ..
[ 2656.020000] 	(detected by 1, t=5252 jiffies, g=99488, c=99487, q=215)
[ 2656.020000] sending NMI to all CPUs:
[ 2656.020036] NMI backtrace for cpu 2
[ 2656.020053] CPU 2 
[ 2656.020060] Pid: 3116, comm: gvfs-afc-volume Tainted: G        W    3.8.0-next-20130204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkStation T5400  /0RW203
[ 2656.020065] RIP: 0010:[<ffffffff8104554d>]  [<ffffffff8104554d>] __ticket_spin_lock+0x1d/0x30
[ 2656.020076] RSP: 0018:ffff8802a0989c28  EFLAGS: 00000297
[ 2656.020080] RAX: 0000000000000042 RBX: 0000000000010e10 RCX: ffff8802a0989db8
[ 2656.020083] RDX: 0000000000000043 RSI: 0000000000000000 RDI: ffff8802afc90e10
[ 2656.020085] RBP: ffff8802a0989c28 R08: 0000000000000000 R09: 8d8d9adfc58cdaff
[ 2656.020088] R10: 8080808080808080 R11: 0000000000000000 R12: ffff8800b88cb020
[ 2656.020090] R13: 0000000000000041 R14: 00000000ffffff9c R15: ffff8802a0989db8
[ 2656.020093] FS:  00007faef9388700(0000) GS:ffff8802afc80000(0000) knlGS:0000000000000000
[ 2656.020096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2656.020099] CR2: 00002aaaab01d8c0 CR3: 0000000285a32000 CR4: 00000000000007e0
[ 2656.020102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2656.020104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2656.020107] Process gvfs-afc-volume (pid: 3116, threadinfo ffff8802a0988000, task ffff8802a0f64530)
[ 2656.020109] Stack:
[ 2656.020112]  ffff8802a0989c48 ffffffff810895f5 ffff8802a0989c58 ffff8802a0989db8
[ 2656.020120]  ffff8802a0989ca8 ffffffff811a17d5 ffff8802a0989c88 0000000000008b97
[ 2656.020128]  ffff8802a0989cb8 ffffffff81098929 ffff8802a0989c88 ffff8802a0989db8
[ 2656.020136] Call Trace:
[ 2656.020144]  [<ffffffff810895f5>] lg_local_lock+0x35/0x40
[ 2656.020151]  [<ffffffff811a17d5>] path_init+0x205/0x430
[ 2656.020156]  [<ffffffff81098929>] ? update_curr+0x99/0x1a0
[ 2656.020160]  [<ffffffff811a1a33>] path_lookupat+0x33/0x760
[ 2656.020166]  [<ffffffff8101dd29>] ? sched_clock+0x9/0x10
[ 2656.020170]  [<ffffffff811a2194>] filename_lookup+0x34/0xc0
[ 2656.020175]  [<ffffffff811a505e>] user_path_at_empty+0x8e/0x110
[ 2656.020181]  [<ffffffff816f14b2>] ? _raw_spin_lock_irqsave+0x42/0x60
[ 2656.020186]  [<ffffffff81084c50>] ? lock_hrtimer_base.isra.21+0x30/0x60
[ 2656.020190]  [<ffffffff81085055>] ? hrtimer_try_to_cancel+0x55/0x120
[ 2656.020194]  [<ffffffff811a50f1>] user_path_at+0x11/0x20
[ 2656.020198]  [<ffffffff8119a502>] vfs_fstatat+0x52/0xb0
[ 2656.020203]  [<ffffffff8119a59b>] vfs_stat+0x1b/0x20
[ 2656.020206]  [<ffffffff8119a7da>] sys_newstat+0x1a/0x40
[ 2656.020210]  [<ffffffff810856b4>] ? hrtimer_start_range_ns+0x14/0x20
[ 2656.020214]  [<ffffffff81085f16>] ? sys_nanosleep+0x66/0x80
[ 2656.020219]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
[ 2656.020222] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 b8 00 01 00 00 48

<snipped - full log attached>


--=-NY5aU+eJCWIEyIW5QKQb
Content-Disposition: attachment; filename="hard_lockup.next-20130204+pcipatch.log"
Content-Type: text/x-log; name="hard_lockup.next-20130204+pcipatch.log"; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ 2635.021602] ------------[ cut here ]------------
[ 2635.021602] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:2=
45 watchdog_overflow_callback+0x9f/0xd0()
[ 2635.021602] Hardware name: Precision WorkStation T5400 =20
[ 2635.021602] Watchdog detected hard LOCKUP on cpu 5
[ 2635.021602] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit[ 2656.019995]=
 INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2656.020000] 	5: (0 ticks this GP) idle=3Dcfd/140000000000001/0 last_acce=
lerate: e84a/fccd, nonlazy_posted: 0, ..
[ 2656.020000] 	(detected by 1, t=3D5252 jiffies, g=3D99488, c=3D99487, q=
=3D215)
[ 2656.020000] sending NMI to all CPUs:
[ 2656.020036] NMI backtrace for cpu 2
[ 2656.020053] CPU 2=20
[ 2656.020060] Pid: 3116, comm: gvfs-afc-volume Tainted: G        W    3.8.=
0-next-20130204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkSt=
ation T5400  /0RW203
[ 2656.020065] RIP: 0010:[<ffffffff8104554d>]  [<ffffffff8104554d>] __ticke=
t_spin_lock+0x1d/0x30
[ 2656.020076] RSP: 0018:ffff8802a0989c28  EFLAGS: 00000297
[ 2656.020080] RAX: 0000000000000042 RBX: 0000000000010e10 RCX: ffff8802a09=
89db8
[ 2656.020083] RDX: 0000000000000043 RSI: 0000000000000000 RDI: ffff8802afc=
90e10
[ 2656.020085] RBP: ffff8802a0989c28 R08: 0000000000000000 R09: 8d8d9adfc58=
cdaff
[ 2656.020088] R10: 8080808080808080 R11: 0000000000000000 R12: ffff8800b88=
cb020
[ 2656.020090] R13: 0000000000000041 R14: 00000000ffffff9c R15: ffff8802a09=
89db8
[ 2656.020093] FS:  00007faef9388700(0000) GS:ffff8802afc80000(0000) knlGS:=
0000000000000000
[ 2656.020096] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2656.020099] CR2: 00002aaaab01d8c0 CR3: 0000000285a32000 CR4: 00000000000=
007e0
[ 2656.020102] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2656.020104] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2656.020107] Process gvfs-afc-volume (pid: 3116, threadinfo ffff8802a0988=
000, task ffff8802a0f64530)
[ 2656.020109] Stack:
[ 2656.020112]  ffff8802a0989c48 ffffffff810895f5 ffff8802a0989c58 ffff8802=
a0989db8
[ 2656.020120]  ffff8802a0989ca8 ffffffff811a17d5 ffff8802a0989c88 00000000=
00008b97
[ 2656.020128]  ffff8802a0989cb8 ffffffff81098929 ffff8802a0989c88 ffff8802=
a0989db8
[ 2656.020136] Call Trace:
[ 2656.020144]  [<ffffffff810895f5>] lg_local_lock+0x35/0x40
[ 2656.020151]  [<ffffffff811a17d5>] path_init+0x205/0x430
[ 2656.020156]  [<ffffffff81098929>] ? update_curr+0x99/0x1a0
[ 2656.020160]  [<ffffffff811a1a33>] path_lookupat+0x33/0x760
[ 2656.020166]  [<ffffffff8101dd29>] ? sched_clock+0x9/0x10
[ 2656.020170]  [<ffffffff811a2194>] filename_lookup+0x34/0xc0
[ 2656.020175]  [<ffffffff811a505e>] user_path_at_empty+0x8e/0x110
[ 2656.020181]  [<ffffffff816f14b2>] ? _raw_spin_lock_irqsave+0x42/0x60
[ 2656.020186]  [<ffffffff81084c50>] ? lock_hrtimer_base.isra.21+0x30/0x60
[ 2656.020190]  [<ffffffff81085055>] ? hrtimer_try_to_cancel+0x55/0x120
[ 2656.020194]  [<ffffffff811a50f1>] user_path_at+0x11/0x20
[ 2656.020198]  [<ffffffff8119a502>] vfs_fstatat+0x52/0xb0
[ 2656.020203]  [<ffffffff8119a59b>] vfs_stat+0x1b/0x20
[ 2656.020206]  [<ffffffff8119a7da>] sys_newstat+0x1a/0x40
[ 2656.020210]  [<ffffffff810856b4>] ? hrtimer_start_range_ns+0x14/0x20
[ 2656.020214]  [<ffffffff81085f16>] ? sys_nanosleep+0x66/0x80
[ 2656.020219]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
[ 2656.020222] Code: ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 b8 00 01 =
00 00 48 [ 2641.492007] ------------[ cut here ]------------
[ 2641.492007] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:2=
45 watchdog_overflow_callback+0x9f/0xd0()
[ 2641.492007] Hardware name: Precision WorkStation T5400 =20
[ 2641.492007] Watchdog detected hard LOCKUP on cpu 3
[ 2641.492007] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit[ 2680.235996]=
 BUG: soft lockup - CPU#1 stuck for 23s! [multiload-apple:3138]
[ 2680.235998] BUG: soft lockup - CPU#0 stuck for 23s! [accounts-daemon:213=
5]
[ 2680.236000] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state[ 2680.236002] Modules=
 linked in: ext2 ip6table_filter ip6_tables ebtable_nat ebtables nf_conntra=
ck_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable=
_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc bnep rfc=
omm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_se=
q joydev snd_timer coretemp btusb kvm_intel snd_seq_device snd psmouse soun=
dcore ppdev bluetooth parport_pc kvm i5400_edac snd_page_alloc edac_core ma=
c_hid i5k_amb dm_multipath parport gpio_ich scsi_dh lpc_ich shpchp serio_ra=
w dcdbas microcode netconsole configfs hid_logitech_dj dm_mirror dm_region_=
hash dm_log hid_generic usbhid hid usb_storage tg3 nouveau e1000e ptp ttm p=
ps_core drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi[ 2680.255997]=
 BUG: soft lockup - CPU#2 stuck for 23s! [gvfs-afc-volume:3116]
[ 2680.256001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2680.355996] BUG: soft lockup - CPU#7 stuck f=
or 23s! [Xorg:1775]
[ 2680.356002] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2650.852002] ------------[ cut here ]--------=
----
[ 2650.852002] WARNING: at /home/peter/src/kernels/next/kernel/watchdog.c:2=
45 watchdog_overflow_callback+0x9f/0xd0()
[ 2650.852002] Hardware name: Precision WorkStation T5400 =20
[ 2650.852002] Watchdog detected hard LOCKUP on cpu 4
[ 2650.852002] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit[ 2708.235996]=
 BUG: soft lockup - CPU#1 stuck for 23s! [multiload-apple:3138]
[ 2708.235999] BUG: soft lockup - CPU#0 stuck for 23s! [accounts-daemon:213=
5]
[ 2708.236000] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack[ 2708.23=
6000] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_nat ebtabl=
es nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHE=
CKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp=
 llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi=
_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_device snd=
 psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_page_alloc=
 edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh lpc_ich sh=
pchp serio_raw dcdbas microcode netconsole configfs hid_logitech_dj dm_mirr=
or dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 nouveau e10=
00e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi[=
 2708.255996] BUG: soft lockup - CPU#2 stuck for 23s! [gvfs-afc-volume:3116=
]
[ 2708.256002] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2708.355996] BUG: soft lockup - CPU#7 stuck f=
or 22s! [Xorg:1775]
[ 2708.356002] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2715.746173] SysRq : This sysrq operation is =
disabled.
[ 2719.039996] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 2719.040002] 	5: (0 ticks this GP) idle=3Dcfd/140000000000001/0 last_acce=
lerate: e84a/3a58, nonlazy_posted: 0, ..
[ 2719.040002] 	(detected by 2, t=3D21007 jiffies, g=3D99488, c=3D99487, q=
=3D215)
[ 2719.040002] sending NMI to all CPUs:
[ 2719.040002] NMI backtrace for cpu 2
[ 2719.040002] CPU 2=20
[ 2719.040002] Pid: 3116, comm: gvfs-afc-volume Tainted: G        W    3.8.=
0-next-20130204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkSt=
ation T5400  /0RW203
[ 2719.040002] RIP: 0010:[<ffffffff81352445>]  [<ffffffff81352445>] delay_t=
sc+0x5/0xf0
[ 2719.040002] RSP: 0018:ffff8802afc83d90  EFLAGS: 00000813
[ 2719.040002] RAX: 000000006c0cd300 RBX: 0000000000002710 RCX: 00000000013=
06f38
[ 2719.040002] RDX: 000000000025c00a RSI: 0000000000000002 RDI: 00000000002=
5c00b
[ 2719.040002] RBP: ffff8802afc83d98 R08: 0000000000000000 R09: 00000000000=
0083c
[ 2719.040002] R10: 0000000000010001 R11: 0000000000000000 R12: 00000000000=
00002
[ 2719.040002] R13: ffffffff81c3d400 R14: ffff8802afc8edc0 R15: 00000000000=
000d7
[ 2719.040002] FS:  00007faef9388700(0000) GS:ffff8802afc80000(0000) knlGS:=
0000000000000000
[ 2719.040002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2719.040002] CR2: 00002aaaab01d8c0 CR3: 0000000285a32000 CR4: 00000000000=
007e0
[ 2719.040002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2719.040002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2719.040002] Process gvfs-afc-volume (pid: 3116, threadinfo ffff8802a0988=
000, task ffff8802a0f64530)
[ 2719.040002] Stack:
[ 2719.040002]  ffffffff813523bc ffff8802afc83db8 ffffffff8103abb2 00000000=
00000000
[ 2719.040002]  ffffffff81c3d400 ffff8802afc83e38 ffffffff810faef2 00000000=
0000520f
[ 2719.040002]  00000000000184a0 000000000001849f ffffffff81c3d508 00000000=
00000082
[ 2719.040002] Call Trace:
[ 2719.040002]  <IRQ>=20
[ 2719.040002]  [<ffffffff813523bc>] ? __const_udelay+0x2c/0x30
[ 2719.040002]  [<ffffffff8103abb2>] arch_trigger_all_cpu_backtrace+0x62/0x=
80
[ 2719.040002]  [<ffffffff810faef2>] rcu_check_callbacks+0x6f2/0x760
[ 2719.040002]  [<ffffffff8106a278>] update_process_times+0x48/0x80
[ 2719.040002]  [<ffffffff810b78fe>] tick_sched_handle.isra.8+0x2e/0x70
[ 2719.040002]  [<ffffffff810b7aac>] tick_sched_timer+0x4c/0x80
[ 2719.040002]  [<ffffffff81084e07>] __run_hrtimer+0x77/0x270
[ 2719.040002]  [<ffffffff810b7a60>] ? tick_sched_do_timer+0x50/0x50
[ 2719.040002]  [<ffffffff8108589f>] hrtimer_interrupt+0xff/0x240
[ 2719.040002]  [<ffffffff816facf6>] smp_apic_timer_interrupt+0x66/0x98
[ 2719.040002]  [<ffffffff816f9c5d>] apic_timer_interrupt+0x6d/0x80
[ 2719.040002]  <EOI>=20
[ 2719.040002]  [<ffffffff8104554f>] ? __ticket_spin_lock+0x1f/0x30
[ 2719.040002]  [<ffffffff810895f5>] lg_local_lock+0x35/0x40
[ 2719.040002]  [<ffffffff811a17d5>] path_init+0x205/0x430
[ 2719.040002]  [<ffffffff81098929>] ? update_curr+0x99/0x1a0
[ 2719.040002]  [<ffffffff811a1a33>] path_lookupat+0x33/0x760
[ 2719.040002]  [<ffffffff8101dd29>] ? sched_clock+0x9/0x10
[ 2719.040002]  [<ffffffff811a2194>] filename_lookup+0x34/0xc0
[ 2719.040002]  [<ffffffff811a505e>] user_path_at_empty+0x8e/0x110
[ 2719.040002]  [<ffffffff816f14b2>] ? _raw_spin_lock_irqsave+0x42/0x60
[ 2719.040002]  [<ffffffff81084c50>] ? lock_hrtimer_base.isra.21+0x30/0x60
[ 2719.040002]  [<ffffffff81085055>] ? hrtimer_try_to_cancel+0x55/0x120
[ 2719.040002]  [<ffffffff811a50f1>] user_path_at+0x11/0x20
[ 2719.040002]  [<ffffffff8119a502>] vfs_fstatat+0x52/0xb0
[ 2719.040002]  [<ffffffff8119a59b>] vfs_stat+0x1b/0x20
[ 2719.040002]  [<ffffffff8119a7da>] sys_newstat+0x1a/0x40
[ 2719.040002]  [<ffffffff810856b4>] ? hrtimer_start_range_ns+0x14/0x20
[ 2719.040002]  [<ffffffff81085f16>] ? sys_nanosleep+0x66/0x80
[ 2719.040002]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
[ 2719.040002] Code: 06 48 89 [ 2720.268175] SysRq : This sysrq operation i=
s disabled.
[ 2744.235996] BUG: soft lockup - CPU#1 stuck for 22s! [multiload-apple:313=
8]
[ 2744.235999] BUG: soft lockup - CPU#0 stuck for 22s! [accounts-daemon:213=
5]
[ 2744.236000] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT[ 2744.236001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable=
_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_RE=
JECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables=
 bridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi s=
nd_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq=
_device snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd=
_page_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh=
 lpc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech=
_dj dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 =
nouveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_oh=
ci mxm_wmi[ 2744.255996] BUG: soft lockup - CPU#2 stuck for 22s! [gvfs-afc-=
volume:3116]
[ 2744.256001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2744.355996] BUG: soft lockup - CPU#7 stuck f=
or 22s! [Xorg:1775]
[ 2744.356002] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2772.235995] BUG: soft lockup - CPU#1 stuck f=
or 22s! [multiload-apple:3138]
[ 2772.235999] BUG: soft lockup - CPU#0 stuck for 22s! [accounts-daemon:213=
5]
[ 2772.236001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at[ 2772.236001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable=
_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_RE=
JECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables=
 bridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi s=
nd_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq=
_device snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd=
_page_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh=
 lpc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech=
_dj dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 =
nouveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_oh=
ci mxm_wmi[ 2772.255997] BUG: soft lockup - CPU#2 stuck for 22s! [gvfs-afc-=
volume:3116]
[ 2772.256001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2772.355996] BUG: soft lockup - CPU#7 stuck f=
or 22s! [Xorg:1775]
[ 2772.356001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2782.059996] INFO: rcu_preempt detected stall=
s on CPUs/tasks:
[ 2782.060001] 	5: (0 ticks this GP) idle=3Dcfd/140000000000001/0 last_acce=
lerate: e84a/77e3, nonlazy_posted: 0, ..
[ 2782.060001] 	(detected by 2, t=3D36762 jiffies, g=3D99488, c=3D99487, q=
=3D216)
[ 2782.060001] sending NMI to all CPUs:
[ 2782.060001] NMI backtrace for cpu 2
[ 2782.060001] CPU 2=20
[ 2782.060001] Pid: 3116, comm: gvfs-afc-volume Tainted: G        W    3.8.=
0-next-20130204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkSt=
ation T5400  /0RW203
[ 2782.060001] RIP: 0010:[<ffffffff81352445>]  [<ffffffff81352445>] delay_t=
sc+0x5/0xf0
[ 2782.060001] RSP: 0018:ffff8802afc83d90  EFLAGS: 00000813
[ 2782.060001] RAX: 000000006c0cd300 RBX: 0000000000002710 RCX: 00000000013=
06f38
[ 2782.060001] RDX: 000000000025c00a RSI: 0000000000000002 RDI: 00000000002=
5c00b
[ 2782.060001] RBP: ffff8802afc83d98 R08: 0000000000000000 R09: 00000000000=
00c2d
[ 2782.060001] R10: 0000000000010001 R11: 0000000000000000 R12: 00000000000=
00002
[ 2782.060001] R13: ffffffff81c3d400 R14: ffff8802afc8edc0 R15: 00000000000=
000d8
[ 2782.060001] FS:  00007faef9388700(0000) GS:ffff8802afc80000(0000) knlGS:=
0000000000000000
[ 2782.060001] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2782.060001] CR2: 00002aaaab01d8c0 CR3: 0000000285a32000 CR4: 00000000000=
007e0
[ 2782.060001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2782.060001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2782.060001] Process gvfs-afc-volume (pid: 3116, threadinfo ffff8802a0988=
000, task ffff8802a0f64530)
[ 2782.060001] Stack:
[ 2782.060001]  ffffffff813523bc ffff8802afc83db8 ffffffff8103abb2 00000000=
00000000
[ 2782.060001]  ffffffff81c3d400 ffff8802afc83e38 ffffffff810faef2 00000000=
00008f9a
[ 2782.060001]  00000000000184a0 000000000001849f ffffffff81c3d508 00000000=
00000082
[ 2782.060001] Call Trace:
[ 2782.060001]  <IRQ>=20
[ 2782.060001]  [<ffffffff813523bc>] ? __const_udelay+0x2c/0x30
[ 2782.060001]  [<ffffffff8103abb2>] arch_trigger_all_cpu_backtrace+0x62/0x=
80
[ 2782.060001]  [<ffffffff810faef2>] rcu_check_callbacks+0x6f2/0x760
[ 2782.060001]  [<ffffffff8106a278>] update_process_times+0x48/0x80
[ 2782.060001]  [<ffffffff810b78fe>] tick_sched_handle.isra.8+0x2e/0x70
[ 2782.060001]  [<ffffffff810b7aac>] tick_sched_timer+0x4c/0x80
[ 2782.060001]  [<ffffffff81084e07>] __run_hrtimer+0x77/0x270
[ 2782.060001]  [<ffffffff810b7a60>] ? tick_sched_do_timer+0x50/0x50
[ 2782.060001]  [<ffffffff8108589f>] hrtimer_interrupt+0xff/0x240
[ 2782.060001]  [<ffffffff816facf6>] smp_apic_timer_interrupt+0x66/0x98
[ 2782.060001]  [<ffffffff816f9c5d>] apic_timer_interrupt+0x6d/0x80
[ 2782.060001]  <EOI>=20
[ 2782.060001]  [<ffffffff8104554a>] ? __ticket_spin_lock+0x1a/0x30
[ 2782.060001]  [<ffffffff810895f5>] lg_local_lock+0x35/0x40
[ 2782.060001]  [<ffffffff811a17d5>] path_init+0x205/0x430
[ 2782.060001]  [<ffffffff81098929>] ? update_curr+0x99/0x1a0
[ 2782.060001]  [<ffffffff811a1a33>] path_lookupat+0x33/0x760
[ 2782.060001]  [<ffffffff8101dd29>] ? sched_clock+0x9/0x10
[ 2782.060001]  [<ffffffff811a2194>] filename_lookup+0x34/0xc0
[ 2782.060001]  [<ffffffff811a505e>] user_path_at_empty+0x8e/0x110
[ 2782.060001]  [<ffffffff816f14b2>] ? _raw_spin_lock_irqsave+0x42/0x60
[ 2782.060001]  [<ffffffff81084c50>] ? lock_hrtimer_base.isra.21+0x30/0x60
[ 2782.060001]  [<ffffffff81085055>] ? hrtimer_try_to_cancel+0x55/0x120
[ 2782.060001]  [<ffffffff811a50f1>] user_path_at+0x11/0x20
[ 2782.060001]  [<ffffffff8119a502>] vfs_fstatat+0x52/0xb0
[ 2782.060001]  [<ffffffff8119a59b>] vfs_stat+0x1b/0x20
[ 2782.060001]  [<ffffffff8119a7da>] sys_newstat+0x1a/0x40
[ 2782.060001]  [<ffffffff810856b4>] ? hrtimer_start_range_ns+0x14/0x20
[ 2782.060001]  [<ffffffff81085f16>] ? sys_nanosleep+0x66/0x80
[ 2782.060001]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
[ 2782.060001] Code: 06 48 89 [ 2808.235996] BUG: soft lockup - CPU#1 stuck=
 for 22s! [multiload-apple:3138]
[ 2808.235999] BUG: soft lockup - CPU#0 stuck for 22s! [accounts-daemon:213=
5]
[ 2808.236000] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM[ 2808.236002] Modules linked in: ext2 ip6table_filter ip6_ta=
bles ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conn=
track ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tab=
les x_tables bridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi s=
nd_rawmidi snd_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_i=
ntel snd_seq_device snd psmouse soundcore ppdev bluetooth parport_pc kvm i5=
400_edac snd_page_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio=
_ich scsi_dh lpc_ich shpchp serio_raw dcdbas microcode netconsole configfs =
hid_logitech_dj dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_=
storage tg3 nouveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit=
 firewire_ohci mxm_wmi[ 2808.255997] BUG: soft lockup - CPU#2 stuck for 22s=
! [gvfs-afc-volume:3116]
[ 2808.256001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2808.355996] BUG: soft lockup - CPU#7 stuck f=
or 22s! [Xorg:1775]
[ 2808.356001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2836.235996] BUG: soft lockup - CPU#1 stuck f=
or 22s! [multiload-apple:3138]
[ 2836.235998] BUG: soft lockup - CPU#0 stuck for 22s! [accounts-daemon:213=
5]
[ 2836.235999] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables[ 2836.2360=
01] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_nat ebtables=
 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECK=
SUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp l=
lc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_e=
vent snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_device snd p=
smouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_page_alloc e=
dac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh lpc_ich shpc=
hp serio_raw dcdbas microcode netconsole configfs hid_logitech_dj dm_mirror=
 dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 nouveau e1000=
e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci mxm_wmi[ 2=
836.255996] BUG: soft lockup - CPU#2 stuck for 22s! [gvfs-afc-volume:3116]
[ 2836.256001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2836.355996] BUG: soft lockup - CPU#7 stuck f=
or 22s! [Xorg:1775]
[ 2836.356001] Modules linked in: ext2 ip6table_filter ip6_tables ebtable_n=
at ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJE=
CT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables b=
ridge stp llc bnep rfcomm lp snd_ctxfi snd_pcm snd_seq_midi snd_rawmidi snd=
_seq_midi_event snd_seq joydev snd_timer coretemp btusb kvm_intel snd_seq_d=
evice snd psmouse soundcore ppdev bluetooth parport_pc kvm i5400_edac snd_p=
age_alloc edac_core mac_hid i5k_amb dm_multipath parport gpio_ich scsi_dh l=
pc_ich shpchp serio_raw dcdbas microcode netconsole configfs hid_logitech_d=
j dm_mirror dm_region_hash dm_log hid_generic usbhid hid usb_storage tg3 no=
uveau e1000e ptp ttm pps_core drm_kms_helper drm i2c_algo_bit firewire_ohci=
 mxm_wmi video firewire_core[ 2845.079995] INFO: rcu_preempt detected stall=
s on CPUs/tasks:
[ 2845.080002] 	5: (0 ticks this GP) idle=3Dcfd/140000000000001/0 last_acce=
lerate: e84a/b56e, nonlazy_posted: 0, ..
[ 2845.080002] 	(detected by 1, t=3D52517 jiffies, g=3D99488, c=3D99487, q=
=3D226)
[ 2845.080002] sending NMI to all CPUs:
[ 2786.384306] NMI backtrace for cpu 5
[ 2786.384306] CPU 5=20
[ 2786.384306] Pid: 28303, comm: sh Tainted: G        W    3.8.0-next-20130=
204+pcipatch-xeon #20130204+pcipatch Dell Inc. Precision WorkStation T5400 =
 /0RW203
[ 2786.384306] RIP: 0010:[<ffffffff8104554d>]  [<ffffffff8104554d>] __ticke=
t_spin_lock+0x1d/0x30
[ 2786.384306] RSP: 0018:ffff8802afd43b90  EFLAGS: 00000097
[ 2786.384306] RAX: 0000000000000055 RBX: ffffffff81c05384 RCX: ffff88029f5=
2b800
[ 2786.384306] RDX: 0000000000000056 RSI: 0000000000000105 RDI: ffffffff81c=
05384
[ 2786.384306] RBP: ffff8802afd43b90 R08: 0000000000000000 R09: 00000000000=
00001
[ 2786.384306] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802afd=
43c48
[ 2786.384306] R13: 0000000000000080 R14: ffff88029f530240 R15: ffff88029f5=
fd8f8
[ 2786.384306] FS:  00002aaaaaaf4600(0000) GS:ffff8802afd40000(0000) knlGS:=
0000000000000000
[ 2786.384306] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2786.384306] CR2: 00000000012699c8 CR3: 00000000b892d000 CR4: 00000000000=
007e0
[ 2786.384306] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 2786.384306] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[ 2786.384306] Process sh (pid: 28303, threadinfo ffff8800b893a000, task ff=
ff88029f835c40)
[ 2786.384306] Stack:
[ 2786.384306]  ffff8802afd43bb0 ffffffff816f14f3 ffff88019aafc578 ffff8802=
a2c34540
[ 2786.384306]  ffff8802afd43be0 ffffffff811aa98e ffff8802afd43bf0 ffff8802=
afd43c48
[ 2786.384306]  0000000000000080 000000010008e84a ffff8802afd43c00 ffffffff=
810cd6e6
[ 2786.384306] Call Trace:
[ 2786.384306]  <IRQ>=20
[ 2786.384306]  [<ffffffff816f14f3>] _raw_spin_lock+0x23/0x30
[ 2786.384306]  [<ffffffff811aa98e>] dentry_path_raw+0x2e/0x70
[ 2786.384306]  [<ffffffff810cd6e6>] cgroup_path+0x26/0x60
[ 2786.384306]  [<ffffffff813432bf>] cfq_completed_request+0x7f/0x800
[ 2786.384306]  [<ffffffff8157c8ca>] ? clone_endio+0x7a/0xb0
[ 2786.384306]  [<ffffffff816f113c>] ? _raw_spin_unlock_irqrestore+0x2c/0x5=
0
[ 2786.384306]  [<ffffffff81456ae1>] ? mix_pool_bytes.constprop.20+0x61/0xf=
0
[ 2786.384306]  [<ffffffff8131c192>] elv_completed_request+0x62/0x70
[ 2786.384306]  [<ffffffff81320297>] __blk_put_request+0x37/0x160
[ 2786.384306]  [<ffffffff8131c5fa>] ? part_round_stats+0x5a/0x70
[ 2786.384306]  [<ffffffff813204b1>] blk_finish_request+0xf1/0x2c0
[ 2786.384306]  [<ffffffff81322592>] blk_end_bidi_request+0x52/0x80
[ 2786.384306]  [<ffffffff81322600>] blk_end_request+0x10/0x20
[ 2786.384306]  [<ffffffff814b1c1b>] scsi_io_completion+0xfb/0x6c0
[ 2786.384306]  [<ffffffff810455e9>] ? default_spin_lock_flags+0x9/0x10
[ 2786.384306]  [<ffffffff814a7bbd>] scsi_finish_command+0xbd/0x120
[ 2786.384306]  [<ffffffff814b1a2e>] scsi_softirq_done+0x13e/0x150
[ 2786.384306]  [<ffffffff81329113>] blk_done_softirq+0x83/0xa0
[ 2786.384306]  [<ffffffff81060607>] __do_softirq+0xe7/0x290
[ 2786.384306]  [<ffffffff81060bc9>] ? raise_softirq_irqoff+0x9/0x30
[ 2786.384306]  [<ffffffff816fa39c>] call_softirq+0x1c/0x30
[ 2786.384306]  [<ffffffff81018385>] do_softirq+0x75/0xb0
[ 2786.384306]  [<ffffffff8106091d>] irq_exit+0xad/0xc0
[ 2786.384306]  [<ffffffff81038d25>] smp_call_function_single_interrupt+0x3=
5/0x40
[ 2786.384306]  [<ffffffff816f9e5d>] call_function_single_interrupt+0x6d/0x=
80
[ 2786.384306]  <EOI>=20
[ 2786.384306]  [<ffffffff8104553e>] ? __ticket_spin_lock+0xe/0x30
[ 2786.384306]  [<ffffffff816f14f3>] _raw_spin_lock+0x23/0x30
[ 2786.384306]  [<ffffffff811aa1bc>] prepend_path+0x6c/0x1f0
[ 2786.384306]  [<ffffffff811adcf8>] sys_getcwd+0xf8/0x1e0
[ 2786.384306]  [<ffffffff816f9059>] system_call_fastpath+0x16/0x1b
[ 2786.384306] Code: ff 66=20


--=-NY5aU+eJCWIEyIW5QKQb
Content-Disposition: attachment; filename="hard_lock_dmesg.log"
Content-Type: text/x-log; name="hard_lock_dmesg.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-next-20130204+pcipatch-xeon (root@thor) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #20130204+pcipatch SMP PREEMPT Tue Feb 12 19:51:22 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next-20130204+pcipatch-xeon root=UUID=6eaaabbc-c0ba-4c86-b781-a4169f7d0417 ro apparmor=0 debug ignore_loglevel
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000096fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfe0abff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe0ac00-0x00000000cfe5cbff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfe5cc00-0x00000000cfe5ebff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfe5ec00-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000002afffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x2b0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DBFFF write-protect
[    0.000000]   DC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 2000000000 write-back
[    0.000000]   1 base 00CFF00000 mask 3FFFF00000 uncachable
[    0.000000]   2 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   3 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   4 base 1FF0000000 mask 3FF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfe0a max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
[    0.000000] Base memory trampoline at [ffff880000091000] 91000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01f6a000, 0x01f6afff] PGTABLE
[    0.000000] BRK [0x01f6b000, 0x01f6bfff] PGTABLE
[    0.000000] BRK [0x01f6c000, 0x01f6cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x2afe00000-0x2afffffff]
[    0.000000]  [mem 0x2afe00000-0x2afffffff] page 2M
[    0.000000] BRK [0x01f6d000, 0x01f6dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x2ac000000-0x2afdfffff]
[    0.000000]  [mem 0x2ac000000-0x2afdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x280000000-0x2abffffff]
[    0.000000]  [mem 0x280000000-0x2abffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfe09fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfe09fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x27fffffff]
[    0.000000]  [mem 0x100000000-0x27fffffff] page 2M
[    0.000000] BRK [0x01f6e000, 0x01f6efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x36082000-0x37038fff]
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcd4e 00074 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fce7e 000F4 (v03 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff65bca 03A12 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000cfe0ac00 00040
[    0.000000] ACPI: SSDT 00000000fff696fd 000AC (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fcf72 000AA (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd01c 00028 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd044 00096 (v32 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd0da 0003E (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd118 00038 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd374 00032 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000000fd3a6 000C8 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd150 00176 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x00000002afffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x2afffffff]
[    0.000000]   NODE_DATA [mem 0x2afff4000-0x2afff6fff]
[    0.000000]  [ffffea0000000000-ffffea000abfffff] PMD -> [ffff8802a5600000-ffff8802af5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x2afffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00096fff]
[    0.000000]   node   0: [mem 0x00100000-0xcfe09fff]
[    0.000000]   node   0: [mem 0x100000000-0x2afffffff]
[    0.000000] On node 0 totalpages: 2620817
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3975 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13241 pages used for memmap
[    0.000000]   DMA32 zone: 847370 pages, LIFO batch:31
[    0.000000]   Normal zone: 27648 pages used for memmap
[    0.000000]   Normal zone: 1769472 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec88000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: 0000000000097000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfe0a000 - 00000000cfe0b000
[    0.000000] PM: Registered nosave memory: 00000000cfe0b000 - 00000000cfe5c000
[    0.000000] PM: Registered nosave memory: 00000000cfe5c000 - 00000000cfe5d000
[    0.000000] PM: Registered nosave memory: 00000000cfe5d000 - 00000000cfe5e000
[    0.000000] PM: Registered nosave memory: 00000000cfe5e000 - 00000000cfe5f000
[    0.000000] PM: Registered nosave memory: 00000000cfe5f000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fe000000
[    0.000000] PM: Registered nosave memory: 00000000fe000000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8802afc00000 s85568 r8192 d20928 u262144
[    0.000000] pcpu-alloc: s85568 r8192 d20928 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2579858
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next-20130204+pcipatch-xeon root=UUID=6eaaabbc-c0ba-4c86-b781-a4169f7d0417 ro apparmor=0 debug ignore_loglevel
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 10220264k/11272192k available (7155k kernel code, 788924k absent, 263004k reserved, 6116k data, 1160k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:1560 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2493.927 MHz processor
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4987.85 BogoMIPS (lpj=9975708)
[    0.004013] pid_max: default: 32768 minimum: 301
[    0.004045] Security Framework initialized
[    0.004062] AppArmor: AppArmor disabled by boot time parameter
[    0.005174] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.014596] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.018587] Mount-cache hash table entries: 256
[    0.018845] Initializing cgroup subsys cpuacct
[    0.018851] Initializing cgroup subsys devices
[    0.018855] Initializing cgroup subsys freezer
[    0.018859] Initializing cgroup subsys blkio
[    0.018863] Initializing cgroup subsys perf_event
[    0.018896] CPU: Physical Processor ID: 0
[    0.018900] CPU: Processor Core ID: 0
[    0.018904] mce: CPU supports 6 MCE banks
[    0.018914] CPU0: Thermal monitoring enabled (TM2)
[    0.018920] process: using mwait in idle threads
[    0.018928] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
[    0.018928] Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32
[    0.018928] tlb_flushall_shift: -1
[    0.019020] Freeing SMP alternatives: 24k freed
[    0.020283] ACPI: Core revision 20130117
[    0.060781] ACPI: All ACPI Tables successfully acquired
[    0.061294] ftrace: allocating 26163 entries in 103 pages
[    0.068101] dmar: Host address width 38
[    0.068108] dmar: DRHD base: 0x000000fe710000 flags: 0x0
[    0.068120] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.068126] dmar: DRHD base: 0x000000fe714000 flags: 0x0
[    0.068134] dmar: IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.068139] dmar: DRHD base: 0x000000fe719000 flags: 0x0
[    0.068147] dmar: IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.068153] dmar: DRHD base: 0x000000fe718000 flags: 0x1
[    0.068161] dmar: IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.068166] dmar: RMRR base: 0x000000cfe61000 end: 0x000000cfe6ffff
[    0.072350] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.112048] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz (fam: 06, model: 17, stepping: 06)
[    0.116000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.116000] ... version:                2
[    0.116000] ... bit width:              40
[    0.116000] ... generic registers:      2
[    0.116000] ... value mask:             000000ffffffffff
[    0.116000] ... max period:             000000007fffffff
[    0.116000] ... fixed-purpose events:   3
[    0.116000] ... event mask:             0000000700000003
[    0.236205] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.144068] smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
[    0.356016] Brought up 8 CPUs
[    0.356034] smpboot: Total of 8 processors activated (39901.63 BogoMIPS)
[    0.360232] devtmpfs: initialized
[    0.361816] EVM: security.selinux
[    0.361821] EVM: security.SMACK64
[    0.361824] EVM: security.capability
[    0.361845] PM: Registering ACPI NVS region [mem 0xcfe0ac00-0xcfe5cbff] (335872 bytes)
[    0.361845] reboot: BIOS series board detected. Selecting Dell Precision T5400-method for reboots.
[    0.364571] regulator-dummy: no parameters
[    0.364609] RTC time: 21:10:15, date: 02/12/13
[    0.364663] NET: Registered protocol family 16
[    0.364844] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.364850] ACPI: bus type pci registered
[    0.364919] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.364927] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.385523] PCI: Using configuration type 1 for base access
[    0.386718] bio: create slab <bio-0> at 0
[    0.386718] ACPI: Added _OSI(Module Device)
[    0.386718] ACPI: Added _OSI(Processor Device)
[    0.386718] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.386718] ACPI: Added _OSI(Processor Aggregator Device)
[    0.386718] ACPI: EC: Look up EC in DSDT
[    0.403064] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.417143] ACPI: Interpreter enabled
[    0.417150] ACPI: (supports S0 S1ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.417169]  S3 S4 S5)
[    0.417180] ACPI: Using IOAPIC for interrupt routing
[    0.417242] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.532037] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.532056] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.532064] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.564070] PCI host bridge to bus 0000:00
[    0.564078] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.564084] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.564096] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.564102] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.564107] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000effff]
[    0.564112] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.564117] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfe000000]
[    0.564122] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdfffffff]
[    0.564127] pci_bus 0000:00: root bus resource [mem 0xff980800-0xff980bff]
[    0.564132] pci_bus 0000:00: root bus resource [mem 0xff97c000-0xff97ffff]
[    0.564137] pci_bus 0000:00: root bus resource [mem 0xfed20000-0xfed9ffff]
[    0.564155] pci 0000:00:00.0: [8086:4001] type 00 class 0x060000
[    0.564207] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.564412] pci 0000:00:01.0: [8086:4021] type 01 class 0x060400
[    0.564463] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.564515] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.564559] pci 0000:00:05.0: [8086:4025] type 01 class 0x060400
[    0.564609] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.564687] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.564730] pci 0000:00:09.0: [8086:4029] type 01 class 0x060400
[    0.564780] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.564889] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.564930] pci 0000:00:10.0: [8086:4030] type 00 class 0x060000
[    0.564930] pci 0000:00:10.1: [8086:4030] type 00 class 0x060000
[    0.564930] pci 0000:00:10.2: [8086:4030] type 00 class 0x060000
[    0.564930] pci 0000:00:10.3: [8086:4030] type 00 class 0x060000
[    0.564930] pci 0000:00:10.4: [8086:4030] type 00 class 0x060000
[    0.564930] pci 0000:00:11.0: [8086:4031] type 00 class 0x060000
[    0.565058] pci 0000:00:15.0: [8086:4035] type 00 class 0x060000
[    0.565270] pci 0000:00:15.1: [8086:4035] type 00 class 0x060000
[    0.565478] pci 0000:00:16.0: [8086:4036] type 00 class 0x060000
[    0.565680] pci 0000:00:16.1: [8086:4036] type 00 class 0x060000
[    0.565902] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.565974] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.566112] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.566157] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.566200] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.566380] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.566419] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.566462] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.566644] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.566681] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.566723] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.566913] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.566949] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[    0.566992] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.567177] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.567223] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.567245] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
[    0.567330] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.567529] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.567733] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.567771] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.568046] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.568062] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.568074] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.568086] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.568098] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.568110] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.568323] pci 0000:00:1f.2: [8086:2682] type 00 class 0x010400
[    0.568342] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.568353] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.568363] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.568374] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.568385] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfedf]
[    0.568396] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9703ff]
[    0.568434] pci 0000:00:1f.2: PME# supported from D3hot
[    0.568632] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.568685] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.568957] pci 0000:01:00.0: [11c1:5901] type 00 class 0x0c0010
[    0.568981] pci 0000:01:00.0: reg 10: [mem 0xfbeff000-0xfbefffff 64bit]
[    0.569078] pci 0000:01:00.0: supports D1 D2
[    0.569082] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.576017] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.576027] pci 0000:00:01.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.576105] pci 0000:02:00.0: [10de:040e] type 00 class 0x030000
[    0.576128] pci 0000:02:00.0: reg 10: [mem 0xfa000000-0xfaffffff]
[    0.576142] pci 0000:02:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.576157] pci 0000:02:00.0: reg 1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.576167] pci 0000:02:00.0: reg 24: [io  0xdc80-0xdcff]
[    0.576178] pci 0000:02:00.0: reg 30: [mem 0xfbd00000-0xfbd1ffff pref]
[    0.584012] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.584020] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.584028] pci 0000:00:05.0:   bridge window [mem 0xf8000000-0xfbdfffff]
[    0.584038] pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.584417] pci 0000:03:00.0: [8086:3500] type 01 class 0x060400
[    0.587443] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.587983] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.588366] pci 0000:03:00.3: [8086:350c] type 01 class 0x060400
[    0.590336] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    0.590765] pci 0000:03:00.3: System wakeup disabled by ACPI
[    0.600009] pci 0000:00:09.0: PCI bridge to [bus 03-07]
[    0.600017] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.600025] pci 0000:00:09.0:   bridge window [mem 0xf7c00000-0xf7ffffff]
[    0.601732] pci 0000:04:00.0: [8086:3510] type 01 class 0x060400
[    0.605054] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.605686] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.606063] pci 0000:04:01.0: [8086:3514] type 01 class 0x060400
[    0.609462] pci 0000:04:01.0: PME# supported from D0 D3hot D3cold
[    0.610075] pci 0000:04:01.0: System wakeup disabled by ACPI
[    0.611479] pci 0000:03:00.0: PCI bridge to [bus 04-06]
[    0.611571] pci 0000:03:00.0:   bridge window [io  0xc000-0xcfff]
[    0.611662] pci 0000:03:00.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.613559] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.616184] pci 0000:06:00.0: [8086:10d3] type 00 class 0x020000
[    0.616642] pci 0000:06:00.0: reg 10: [mem 0xf7d60000-0xf7d7ffff]
[    0.616962] pci 0000:06:00.0: reg 14: [mem 0xf7d80000-0xf7dfffff]
[    0.617283] pci 0000:06:00.0: reg 18: [io  0xcce0-0xccff]
[    0.617604] pci 0000:06:00.0: reg 1c: [mem 0xf7d5c000-0xf7d5ffff]
[    0.618567] pci 0000:06:00.0: reg 30: [mem 0xf7e00000-0xf7e3ffff pref]
[    0.620458] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.621421] pci 0000:04:01.0: PCI bridge to [bus 06]
[    0.621511] pci 0000:04:01.0:   bridge window [io  0xc000-0xcfff]
[    0.621603] pci 0000:04:01.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.623759] pci 0000:07:06.0: [11c1:5811] type 00 class 0x0c0010
[    0.624367] pci 0000:07:06.0: reg 10: [mem 0xf7cff000-0xf7cfffff]
[    0.627300] pci 0000:07:06.0: supports D1 D2
[    0.627305] pci 0000:07:06.0: PME# supported from D0 D1 D2 D3hot
[    0.628688] pci 0000:03:00.3: PCI bridge to [bus 07]
[    0.628779] pci 0000:03:00.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.629314] pci 0000:08:00.0: [14e4:167a] type 00 class 0x020000
[    0.629340] pci 0000:08:00.0: reg 10: [mem 0xf7bf0000-0xf7bfffff 64bit]
[    0.629475] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    0.636016] pci 0000:00:1c.0: PCI bridge to [bus 08]
[    0.636027] pci 0000:00:1c.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.636093] pci 0000:09:02.0: [1102:0005] type 00 class 0x040100
[    0.636132] pci 0000:09:02.0: reg 10: [io  0xbce0-0xbcff]
[    0.636149] pci 0000:09:02.0: reg 14: [mem 0xf7800000-0xf79fffff 64bit]
[    0.636166] pci 0000:09:02.0: reg 1c: [mem 0xf0000000-0xf3ffffff 64bit]
[    0.636223] pci 0000:09:02.0: supports D1 D2
[    0.636289] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    0.636297] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.636304] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7afffff]
[    0.636313] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.636319] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.636326] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.636332] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.636338] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.636345] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfe000000] (subtractive decode)
[    0.636351] pci 0000:00:1e.0:   bridge window [mem 0xcff00000-0xdfffffff] (subtractive decode)
[    0.636358] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.636364] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.636370] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.636392] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.668174] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    0.668578] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.668982] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.669391] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.669795] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.670198] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.670600] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.671002] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.671188] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.671198] acpi root: \_SB_.PCI0 notify handler is installed
[    0.671227] Found 1 acpi root devices
[    0.671319] ACPI: No dock devices found.
[    0.672032] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.672041] vgaarb: loaded
[    0.672045] vgaarb: bridge control possible 0000:02:00.0
[    0.672249] SCSI subsystem initialized
[    0.672254] ACPI: bus type scsi registered
[    0.672269] libata version 3.00 loaded.
[    0.672269] ACPI: bus type usb registered
[    0.672269] usbcore: registered new interface driver usbfs
[    0.672269] usbcore: registered new interface driver hub
[    0.672269] usbcore: registered new device driver usb
[    0.672269] PCI: Using ACPI for IRQ routing
[    0.677906] PCI: pci_cache_line_size set to 64 bytes
[    0.678173] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9703ff]
[    0.678445] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.678450] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.678455] e820: reserve RAM buffer [mem 0x00097000-0x0009ffff]
[    0.678460] e820: reserve RAM buffer [mem 0xcfe0ac00-0xcfffffff]
[    0.678561] NetLabel: Initializing
[    0.678565] NetLabel:  domain hash size = 128
[    0.678569] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.678583] NetLabel:  unlabeled traffic allowed by default
[    0.678601] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.678601] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.678601] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.688047] Switching to clocksource hpet
[    0.696456] pnp: PnP ACPI init
[    0.696482] ACPI: bus type pnp registered
[    0.699379] system 00:00: [io  0x0800-0x085f] has been reserved
[    0.699385] system 00:00: [io  0x0c00-0x0c7f] has been reserved
[    0.699390] system 00:00: [io  0x0860-0x08ff] has been reserved
[    0.699398] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.699519] pnp 00:01: [dma 4]
[    0.699545] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.699669] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.699784] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.699901] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.709330] pnp 00:05: [dma 0 disabled]
[    0.709826] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.712801] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.715760] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.722962] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.722972] pnp: PnP ACPI: found 9 devices
[    0.722976] ACPI: ACPI bus type pnp unregistered
[    0.731793] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
[    0.731801] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 08] add_size 200000
[    0.731819] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.731826] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.731836] pci 0000:00:1c.0: BAR 15: assigned [mem 0xfbf00000-0xfc0fffff 64bit pref]
[    0.731843] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.731849] pci 0000:00:1f.2: BAR 5: assigned [mem 0xfc100000-0xfc1003ff]
[    0.731857] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.731864] pci 0000:00:01.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.731872] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.731877] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.731883] pci 0000:00:05.0:   bridge window [mem 0xf8000000-0xfbdfffff]
[    0.731889] pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.731898] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.732288] pci 0000:04:01.0: PCI bridge to [bus 06]
[    0.732334] pci 0000:04:01.0:   bridge window [io  0xc000-0xcfff]
[    0.732472] pci 0000:04:01.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.732747] pci 0000:03:00.0: PCI bridge to [bus 04-06]
[    0.732792] pci 0000:03:00.0:   bridge window [io  0xc000-0xcfff]
[    0.732930] pci 0000:03:00.0:   bridge window [mem 0xf7d00000-0xf7efffff]
[    0.733205] pci 0000:03:00.3: PCI bridge to [bus 07]
[    0.733297] pci 0000:03:00.3:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.733480] pci 0000:00:09.0: PCI bridge to [bus 03-07]
[    0.733485] pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
[    0.733491] pci 0000:00:09.0:   bridge window [mem 0xf7c00000-0xf7ffffff]
[    0.733499] pci 0000:00:1c.0: PCI bridge to [bus 08]
[    0.733505] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.733512] pci 0000:00:1c.0:   bridge window [mem 0xf7b00000-0xf7bfffff]
[    0.733518] pci 0000:00:1c.0:   bridge window [mem 0xfbf00000-0xfc0fffff 64bit pref]
[    0.733528] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    0.733533] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.733540] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7afffff]
[    0.733555] pci 0000:00:01.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.733776] pci 0000:00:05.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.733968] pci 0000:00:09.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.734205] pci 0000:03:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    0.734434] pci 0000:04:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4._PRT]
[    0.734663] pci 0000:04:01.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4._PRT]
[    0.734940] pci 0000:00:1c.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.735133] pci 0000:00:1e.0: setting latency timer to 64
[    0.735140] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.735145] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.735149] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.735154] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    0.735159] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    0.735164] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfe000000]
[    0.735169] pci_bus 0000:00: resource 10 [mem 0xcff00000-0xdfffffff]
[    0.735174] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    0.735179] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.735183] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.735189] pci_bus 0000:01: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.735194] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.735198] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbdfffff]
[    0.735203] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.735209] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.735214] pci_bus 0000:03: resource 1 [mem 0xf7c00000-0xf7ffffff]
[    0.735219] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.735223] pci_bus 0000:04: resource 1 [mem 0xf7d00000-0xf7efffff]
[    0.735228] pci_bus 0000:06: resource 0 [io  0xc000-0xcfff]
[    0.735233] pci_bus 0000:06: resource 1 [mem 0xf7d00000-0xf7efffff]
[    0.735238] pci_bus 0000:07: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.735243] pci_bus 0000:08: resource 0 [io  0x1000-0x1fff]
[    0.735248] pci_bus 0000:08: resource 1 [mem 0xf7b00000-0xf7bfffff]
[    0.735252] pci_bus 0000:08: resource 2 [mem 0xfbf00000-0xfc0fffff 64bit pref]
[    0.735258] pci_bus 0000:09: resource 0 [io  0xb000-0xbfff]
[    0.735262] pci_bus 0000:09: resource 1 [mem 0xf0000000-0xf7afffff]
[    0.735267] pci_bus 0000:09: resource 4 [io  0x0000-0x0cf7]
[    0.735271] pci_bus 0000:09: resource 5 [io  0x0d00-0xffff]
[    0.735276] pci_bus 0000:09: resource 6 [mem 0x000a0000-0x000bffff]
[    0.735280] pci_bus 0000:09: resource 7 [mem 0x000c0000-0x000effff]
[    0.735285] pci_bus 0000:09: resource 8 [mem 0x000f0000-0x000fffff]
[    0.735289] pci_bus 0000:09: resource 9 [mem 0xf0000000-0xfe000000]
[    0.735294] pci_bus 0000:09: resource 10 [mem 0xcff00000-0xdfffffff]
[    0.735299] pci_bus 0000:09: resource 11 [mem 0xff980800-0xff980bff]
[    0.735303] pci_bus 0000:09: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.735308] pci_bus 0000:09: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.735342] NET: Registered protocol family 2
[    0.735671] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    0.736667] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.737127] TCP: Hash tables configured (established 131072 bind 65536)
[    0.737182] TCP: reno registered
[    0.737208] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.737346] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.737544] NET: Registered protocol family 1
[    0.737594] pci 0000:00:1d.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.737829] pci 0000:00:1d.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.738019] pci 0000:00:1d.1: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.738223] pci 0000:00:1d.1: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.738411] pci 0000:00:1d.2: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.738614] pci 0000:00:1d.2: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.738802] pci 0000:00:1d.3: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.739005] pci 0000:00:1d.3: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.739193] pci 0000:00:1d.7: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.739404] pci 0000:00:1d.7: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.739592] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.739620] pci 0000:02:00.0: Boot video device
[    0.739861] PCI: CLS 64 bytes, default 64
[    0.739922] Trying to unpack rootfs image as initramfs...
[    1.045906] Freeing initrd memory: 16092k freed
[    1.051846] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.051862] software IO TLB [mem 0xcbe0a000-0xcfe0a000] (64MB) mapped at [ffff8800cbe0a000-ffff8800cfe09fff]
[    1.051931] Simple Boot Flag at 0x7a set to 0x80
[    1.052510] audit: initializing netlink socket (disabled)
[    1.052529] type=2000 audit(1360703415.052:1): initialized
[    1.074072] bounce pool size: 64 pages
[    1.074090] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.076272] VFS: Disk quotas dquot_6.5.2
[    1.076337] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.076897] fuse init (API version 7.21)
[    1.077010] msgmni has been set to 19992
[    1.077687] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    1.077749] io scheduler noop registered
[    1.077755] io scheduler deadline registered
[    1.077765] io scheduler cfq registered (default)
[    1.078039] pcieport 0000:00:1c.0: irq 88 for MSI/MSI-X
[    1.082024] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.082046] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.082103] intel_idle: does not run on family 6 model 23
[    1.082178] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.082190] ACPI: Power Button [VBTN]
[    1.082238] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.082245] ACPI: Power Button [PWRF]
[    1.389476] GHES: HEST is not enabled!
[    1.389574] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.409985] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.430416] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.432545] Linux agpgart interface v0.103
[    1.434471] brd: module loaded
[    1.435525] loop: module loaded
[    1.435658] ahci 0000:00:1f.2: version 3.0
[    1.435671] ahci 0000:00:1f.2: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.436027] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x1f impl RAID mode
[    1.436041] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
[    1.436048] ahci 0000:00:1f.2: setting latency timer to 64
[    1.436789] scsi0 : ahci
[    1.436894] scsi1 : ahci
[    1.436975] scsi2 : ahci
[    1.437066] scsi3 : ahci
[    1.437147] scsi4 : ahci
[    1.437236] scsi5 : ahci
[    1.437283] ata1: SATA max UDMA/133 abar m1024@0xfc100000 port 0xfc100100 irq 20
[    1.437290] ata2: SATA max UDMA/133 abar m1024@0xfc100000 port 0xfc100180 irq 20
[    1.437296] ata3: SATA max UDMA/133 abar m1024@0xfc100000 port 0xfc100200 irq 20
[    1.437301] ata4: SATA max UDMA/133 abar m1024@0xfc100000 port 0xfc100280 irq 20
[    1.437307] ata5: SATA max UDMA/133 abar m1024@0xfc100000 port 0xfc100300 irq 20
[    1.437312] ata6: DUMMY
[    1.437353] ata_piix 0000:00:1f.1: version 2.13
[    1.437368] ata_piix 0000:00:1f.1: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.437606] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.437883] scsi6 : ata_piix
[    1.437964] scsi7 : ata_piix
[    1.438009] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.438016] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.438107] ata7: port disabled--ignoring
[    1.438191] ata8: port disabled--ignoring
[    1.438315] libphy: Fixed MDIO Bus: probed
[    1.438344] tun: Universal TUN/TAP device driver, 1.6
[    1.438348] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.438414] PPP generic driver version 2.4.2
[    1.438489] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.438495] ehci-pci: EHCI PCI platform driver
[    1.438515] ehci-pci 0000:00:1d.7: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.438727] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    1.438734] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    1.438743] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.438761] ehci-pci 0000:00:1d.7: debug port 1
[    1.442667] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    1.442684] ehci-pci 0000:00:1d.7: irq 21, io mem 0xff980800
[    1.452026] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.452210] hub 1-0:1.0: USB hub found
[    1.452220] hub 1-0:1.0: 8 ports detected
[    1.452396] ehci-platform: EHCI generic platform driver
[    1.452410] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.452430] uhci_hcd: USB Universal Host Controller Interface driver
[    1.452447] uhci_hcd 0000:00:1d.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.452650] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.452657] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.452669] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.452695] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    1.452840] hub 2-0:1.0: USB hub found
[    1.452849] hub 2-0:1.0: 2 ports detected
[    1.452942] uhci_hcd 0000:00:1d.1: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.453142] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.453149] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.453157] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.453194] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    1.453347] hub 3-0:1.0: USB hub found
[    1.453355] hub 3-0:1.0: 2 ports detected
[    1.453448] uhci_hcd 0000:00:1d.2: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.453650] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.453656] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.453664] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.453698] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    1.453841] hub 4-0:1.0: USB hub found
[    1.453849] hub 4-0:1.0: 2 ports detected
[    1.453943] uhci_hcd 0000:00:1d.3: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.454142] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.454148] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.454156] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.454195] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    1.454333] hub 5-0:1.0: USB hub found
[    1.454341] hub 5-0:1.0: 2 ports detected
[    1.454486] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.457252] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.457334] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.457481] mousedev: PS/2 mouse device common for all mice
[    1.457698] rtc_cmos 00:04: RTC can wake from S4
[    1.457848] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.457876] rtc0: alarms up to one day, 242 bytes nvram, hpet irqs
[    1.457984] device-mapper: uevent: version 1.0.3
[    1.458071] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    1.458086] cpuidle: using governor ladder
[    1.458091] cpuidle: using governor menu
[    1.458096] EFI Variables Facility v0.08 2004-May-17
[    1.458303] ashmem: initialized
[    1.458496] TCP: cubic registered
[    1.458602] NET: Registered protocol family 10
[    1.458799] NET: Registered protocol family 17
[    1.458812] Key type dns_resolver registered
[    1.459220] PM: Hibernation image not present or could not be loaded.
[    1.459239] registered taskstats version 1
[    1.462430] Key type trusted registered
[    1.464372] Key type encrypted registered
[    1.469380]   Magic number: 1:720:196
[    1.469524] rtc_cmos 00:04: setting system clock to 2013-02-12 21:10:16 UTC (1360703416)
[    1.469621] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.469626] EDD information not available.
[    1.756028] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.756061] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.756082] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.756102] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.756125] ata5: SATA link down (SStatus 4 SControl 300)
[    1.756250] ata3.00: ATAPI: PLDS DVD+/-RW DH-16A6S, YD11, max UDMA/100
[    1.756647] ata4.00: ATA-8: ST3250310AS, 3.ADA, max UDMA/133
[    1.756666] ata4.00: 488281250 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.756879] ata2.00: ATA-8: WDC WD1001FALS-00E8B0, 05.00K05, max UDMA/133
[    1.756888] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.756904] ata1.00: ATA-8: WDC WD1001FALS-00E8B0, 05.00K05, max UDMA/133
[    1.756916] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.756948] ata3.00: configured for UDMA/100
[    1.757371] ata4.00: configured for UDMA/133
[    1.757761] ata2.00: configured for UDMA/133
[    1.757794] ata1.00: configured for UDMA/133
[    1.757975] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.758159] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.758218] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.758297] sd 0:0:0:0: [sda] Write Protect is off
[    1.758303] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.758329] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.758370] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 05.0 PQ: 0 ANSI: 5
[    1.758537] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.758544] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.758646] sd 1:0:0:0: [sdb] Write Protect is off
[    1.758664] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.758726] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.759920] scsi 2:0:0:0: CD-ROM            PLDS     DVD+-RW DH-16A6S YD11 PQ: 0 ANSI: 5
[    1.762032]  sdb: unknown partition table
[    1.762257] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.763003] sr0: scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.763013] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.763126] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.763210] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    1.763406] scsi 3:0:0:0: Direct-Access     ATA      ST3250310AS      3.AD PQ: 0 ANSI: 5
[    1.763576] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.763583] sd 3:0:0:0: [sdc] 488281250 512-byte logical blocks: (250 GB/232 GiB)
[    1.763681] sd 3:0:0:0: [sdc] Write Protect is off
[    1.763688] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.763724] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.764023] usb 1-2: new high-speed USB device number 2 using ehci-pci
[    1.764199]  sda: sda1 sda2 < >
[    1.764204] sda: partition table partially beyond EOD, enabling native capacity
[    1.764591]  sda: sda1 sda2 < >
[    1.764596] sda: partition table partially beyond EOD, truncated
[    1.764603] sda: p1 size 2047998267 extends beyond EOD, truncated
[    1.764668] sda: p2 start 2047998454 is beyond EOD, truncated
[    1.764864] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.803592]  sdc: sdc1 sdc2 < sdc5 >
[    1.803927] sd 3:0:0:0: [sdc] Attached SCSI disk
[    1.804860] Freeing unused kernel memory: 1160k freed
[    1.805105] Write protecting the kernel read-only data: 12288k
[    1.807389] Freeing unused kernel memory: 1024k freed
[    1.809327] Freeing unused kernel memory: 852k freed
[    1.829995] udevd[147]: starting version 175
[    1.867098] wmi: Mapper loaded
[    1.868382] firewire_ohci 0000:01:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    1.870416] [drm] Initialized drm 1.1.0 20060810
[    1.871369] pps_core: LinuxPPS API ver. 1 registered
[    1.871381] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.871702] PTP clock support registered
[    1.873147] e1000e: Intel(R) PRO/1000 Network Driver - 2.2.14-k
[    1.873156] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    1.873217] e1000e 0000:06:00.0: Disabling ASPM L0s L1
[    1.873283] e1000e 0000:06:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI4.PCI6._PRT]
[    1.875023] e1000e 0000:06:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.876515] e1000e 0000:06:00.0: irq 89 for MSI/MSI-X
[    1.876530] e1000e 0000:06:00.0: irq 90 for MSI/MSI-X
[    1.876542] e1000e 0000:06:00.0: irq 91 for MSI/MSI-X
[    1.876873] nouveau 0000:02:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    1.877401] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x084e00a2
[    1.877408] nouveau  [  DEVICE][0000:02:00.0] Chipset: G84 (NV84)
[    1.877414] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    1.878796] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    1.882227] tg3.c:v3.129 (January 06, 2013)
[    1.882255] tg3 0000:08:00.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI8._PRT]
[    1.913146] tg3 0000:08:00.0 eth0: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:1e:4f:e4:b6:68
[    1.913162] tg3 0000:08:00.0 eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    1.913170] tg3 0000:08:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.913178] tg3 0000:08:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.924111] firewire_ohci 0000:01:00.0: irq 92 for MSI/MSI-X
[    1.924167] firewire_ohci 0000:01:00.0: added OHCI v1.10 device as card 0, 8 IR + 8 IT contexts, quirks 0x0
[    1.924263] firewire_ohci 0000:07:06.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3.PCI7._PRT]
[    1.930961] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    1.930968] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    1.931073] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    1.931080] nouveau  [   VBIOS][0000:02:00.0] version 60.84.63.00.11
[    1.951106] nouveau  [     PFB][0000:02:00.0] RAM type: DDR2
[    1.951112] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    1.951116] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 1892 tags
[    1.977595] [TTM] Zone  kernel: Available graphics memory: 5119708 kiB
[    1.977602] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.977608] [TTM] Initializing pool allocator
[    1.977616] [TTM] Initializing DMA pool allocator
[    1.977638] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[    1.977646] nouveau  [     DRM] VRAM: 256 MiB
[    1.977651] nouveau  [     DRM] GART: 512 MiB
[    1.977657] nouveau  [     DRM] BIT BIOS found
[    1.977664] nouveau  [     DRM] Bios version 60.84.63.00
[    1.977672] nouveau  [     DRM] TMDS table version 2.0
[    1.977678] nouveau  [     DRM] DCB version 4.0
[    1.977685] nouveau  [     DRM] DCB outp 00: 02000300 00000028
[    1.977692] nouveau  [     DRM] DCB outp 01: 01000302 00000030
[    1.977698] nouveau  [     DRM] DCB outp 02: 04011310 00000028
[    1.977704] nouveau  [     DRM] DCB outp 03: 02011312 00000030
[    1.977710] nouveau  [     DRM] DCB conn 00: 1030
[    1.977717] nouveau  [     DRM] DCB conn 01: 2130
[    1.980405] firewire_ohci 0000:07:06.0: added OHCI v1.0 device as card 1, 8 IR + 8 IT contexts, quirks 0x0
[    1.984137] e1000e 0000:06:00.0 eth1: registered PHC clock
[    1.984161] e1000e 0000:06:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 68:05:ca:0f:c9:c5
[    1.984170] e1000e 0000:06:00.0 eth1: Intel(R) PRO/1000 Network Connection
[    1.984187] e1000e 0000:06:00.0 eth1: MAC: 3, PHY: 8, PBA No: E46981-007
[    1.997469] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.997481] [drm] No driver support for vblank timestamp query.
[    2.021440] nouveau  [     DRM] 2 available performance level(s)
[    2.021448] nouveau  [     DRM] 0: core 208MHz shader 416MHz memory 100MHz voltage 1200mV fanspeed 100%
[    2.021455] nouveau  [     DRM] 1: core 460MHz shader 920MHz memory 400MHz voltage 1200mV fanspeed 100%
[    2.021462] nouveau  [     DRM] c: core 459MHz shader 918MHz memory 399MHz voltage 1200mV
[    2.048025] tsc: Refined TSC clocksource calibration: 2493.749 MHz
[    2.048041] Switching to clocksource tsc
[    2.292647] nouveau  [     DRM] MM: using CRYPT for buffer copies
[    2.359237] nouveau  [     DRM] allocated 1680x1050 fb: 0x60000, bo ffff8802a36e5c00
[    2.359328] fbcon: nouveaufb (fb0) is primary device
[    2.424097] firewire_core 0000:01:00.0: created device fw0: GUID 08144382000041fc, S800
[    2.426625] Console: switching to colour frame buffer device 160x64
[    2.427517] nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
[    2.427527] nouveau 0000:02:00.0: registered panic notifier
[    2.427541] [drm] Initialized nouveau 1.1.0 20120801 for 0000:02:00.0 on minor 0
[    2.480175] firewire_core 0000:07:06.0: created device fw1: GUID 00053d00807ac5b4, S400
[    2.480211] firewire_core 0000:07:06.0: phy config: new root=ffc1, gap_count=5
[    2.490567] Initializing USB Mass Storage driver...
[    2.490722] scsi8 : usb-storage 1-2:1.0
[    2.490817] usbcore: registered new interface driver usb-storage
[    2.490828] USB Mass Storage support registered.
[    2.605285] bio: create slab <bio-1> at 1
[    2.728020] usb 4-1: new low-speed USB device number 2 using uhci_hcd
[    2.960809] usbcore: registered new interface driver usbhid
[    2.960840] usbhid: USB HID core driver
[    3.062894] hid-generic 0003:0764:0501.0001: hiddev0,hidraw0: USB HID v1.10 Device [CPS  CP 1500C] on usb-0000:00:1d.2-1/input0
[    3.140023] usb 4-2: new full-speed USB device number 3 using uhci_hcd
[    3.344891] logitech-djreceiver 0003:046D:C52B.0004: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.2-2/input2
[    3.348233] input: Logitech Unifying Device. Wireless PID:2010 as /devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.2/0003:046D:C52B.0004/input/input2
[    3.348402] logitech-djdevice 0003:046D:C52B.0005: input,hidraw2: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:2010] on usb-0000:00:1d.2-2:1
[    3.350028] input: Logitech Unifying Device. Wireless PID:101b as /devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.2/0003:046D:C52B.0004/input/input3
[    3.350273] logitech-djdevice 0003:046D:C52B.0006: input,hidraw3: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:101b] on usb-0000:00:1d.2-2:2
[    3.488891] EXT4-fs (dm-4): INFO: recovery required on readonly filesystem
[    3.488911] EXT4-fs (dm-4): write access will be enabled during recovery
[    3.491037] scsi 8:0:0:0: Direct-Access     Seagate  FreeAgent Go     100F PQ: 0 ANSI: 4
[    3.491327] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    3.493260] sd 8:0:0:0: [sdd] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    3.494758] sd 8:0:0:0: [sdd] Write Protect is off
[    3.494768] sd 8:0:0:0: [sdd] Mode Sense: 1c 00 00 00
[    3.496257] sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.576019] usb 5-2: new full-speed USB device number 2 using uhci_hcd
[    3.704033]  sdd: sdd1
[    3.715880] sd 8:0:0:0: [sdd] Attached SCSI disk
[    3.755300] hub 5-2:1.0: USB hub found
[    3.757241] hub 5-2:1.0: 3 ports detected
[    4.174266] EXT4-fs (dm-4): recovery complete
[    4.183362] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
[    4.217240] usb 5-2.1: new full-speed USB device number 3 using uhci_hcd
[    4.345539] input: HID 0a5c:4502 as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2.1/5-2.1:1.0/input/input4
[    4.345693] hid-generic 0003:0A5C:4502.0007: input,hidraw4: USB HID v1.11 Keyboard [HID 0a5c:4502] on usb-0000:00:1d.3-2.1/input0
[    4.417245] usb 5-2.2: new full-speed USB device number 4 using uhci_hcd
[    4.546565] input: HID 0a5c:4503 as /devices/pci0000:00/0000:00:1d.3/usb5/5-2/5-2.2/5-2.2:1.0/input/input5
[    4.546740] hid-generic 0003:0A5C:4503.0008: input,hidraw5: USB HID v1.11 Mouse [HID 0a5c:4503] on usb-0000:00:1d.3-2.2/input0
[    4.621244] usb 5-2.3: new full-speed USB device number 5 using uhci_hcd
[    5.416522] init: ureadahead main process (602) terminated with status 5
[    6.100905] Adding 10996456k swap on /dev/mapper/isw_cbdbfhdjad_Raid0p5.  Priority:-1 extents:1 across:10996456k 
[    6.395668] EXT4-fs (dm-4): re-mounted. Opts: errors=remount-ro
[    7.488687] firewire_core 0000:07:06.0: created device fw2: GUID 0800460301c2d69e, S400
[    8.146164] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
[    8.225999] udevd[885]: starting version 175
[    9.531433] netpoll: netconsole: local port 6665
[    9.531454] netpoll: netconsole: local IPv4 address 192.168.1.139
[    9.531462] netpoll: netconsole: interface 'eth1'
[    9.531471] netpoll: netconsole: remote port 30000
[    9.531478] netpoll: netconsole: remote IPv4 address 192.168.1.133
[    9.531486] netpoll: netconsole: remote ethernet address 08:00:46:f4:30:d3
[    9.531496] netpoll: netconsole: device eth1 not up yet, forcing it
[    9.610829] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    9.963081] microcode: CPU0 sig=0x10676, pf=0x40, revision=0x60f
[   10.169200] microcode: CPU1 sig=0x1067a, pf=0x40, revision=0xa0b
[   10.171032] microcode: CPU2 sig=0x10676, pf=0x40, revision=0x60f
[   10.172782] microcode: CPU3 sig=0x1067a, pf=0x40, revision=0xa0b
[   10.174112] microcode: CPU4 sig=0x10676, pf=0x40, revision=0x60f
[   10.175517] microcode: CPU5 sig=0x1067a, pf=0x40, revision=0xa0b
[   10.177079] microcode: CPU6 sig=0x10676, pf=0x40, revision=0x60f
[   10.178650] microcode: CPU7 sig=0x1067a, pf=0x40, revision=0xa0b
[   10.180205] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   10.343013] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   10.391641] intel_rng: Firmware space is locked read-only. If you can't or
[   10.391641] intel_rng: don't want to disable this in firmware setup, and if
[   10.391641] intel_rng: you are certain that your system has a functional
[   10.391641] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   10.511493] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   10.514008] ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts with Region \GLBC 1 (20130117/utaddress-251)
[   10.514033] ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts with Region \SACT 2 (20130117/utaddress-251)
[   10.514048] ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts with Region \SSTS 3 (20130117/utaddress-251)
[   10.514384] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   10.514796] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   10.547284] gpio_ich: ACPI BAR is unavailable, GPI 0 - 15 unavailable
[   10.547731] gpio_ich: GPIO from 206 to 255 on gpio_ich
[   10.586911] device-mapper: multipath: version 1.5.0 loaded
[   10.591014] i5k_amb: probe of i5k_amb.0 failed with error -16
[   10.671378] EDAC MC: Ver: 3.0.0
[   10.682197] EDAC MC0: Giving out device to 'i5400_edac.c' 'I5400': DEV 0000:00:10.0
[   10.682789] EDAC PCI0: Giving out device to module 'i5400_edac' controller 'EDAC PCI controller': DEV '0000:00:10.0' (POLLED)
[   10.709814] parport_pc 00:05: reported by Plug and Play ACPI
[   10.710245] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   10.718659] Bluetooth: Core ver 2.16
[   10.719041] NET: Registered protocol family 31
[   10.719348] Bluetooth: HCI device and connection manager initialized
[   10.719813] Bluetooth: HCI socket layer initialized
[   10.720348] Bluetooth: L2CAP socket layer initialized
[   10.720851] Bluetooth: SCO socket layer initialized
[   10.729350] ppdev: user-space parallel port driver
[   10.856708] usbcore: registered new interface driver btusb
[   11.437053] snd_ctxfi 0000:09:02.0: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI9._PRT]
[   11.846183] lp0: using parport0 (interrupt-driven).
[   11.899734] Bluetooth: RFCOMM TTY layer initialized
[   11.900167] Bluetooth: RFCOMM socket layer initialized
[   11.900477] Bluetooth: RFCOMM ver 1.11
[   12.007093] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   12.007511] Bluetooth: BNEP filters: protocol multicast
[   12.007801] Bluetooth: BNEP socket layer initialized
[   12.816995] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   12.817545] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   12.824076] console [netcon0] enabled
[   12.824440] netconsole: network logging started
[   13.594861] Bridge firewalling registered
[   13.597949] device lan0 entered promiscuous mode
[   13.599461] tg3 0000:08:00.0: irq 93 for MSI/MSI-X
[   13.648070] IPv6: ADDRCONF(NETDEV_UP): lan0: link is not ready
[   13.650983] br0: port 1(lan0) entered forwarding state
[   13.652565] br0: port 1(lan0) entered forwarding state
[   13.775274] init: failsafe main process (1275) killed by TERM signal
[   13.816126] br0: port 1(lan0) entered disabled state

--=-NY5aU+eJCWIEyIW5QKQb--
