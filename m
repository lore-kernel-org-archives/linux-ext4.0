From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 05 Jan 2009 02:19:55 +0100
Message-ID: <4961603B.5020505@ph.tum.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030307040701080609040205"
Cc: tytso@mit.edu
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:39551 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbZAEBlh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 20:41:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030307040701080609040205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I came across a null pointer dereference when mounting an intentionally 
corrupted filesystem (cf. debug.dmesg).  In my opinion, the problem lies 
in ext4_fill_super(), where truncation may occur on setting the integer 
db_count, which results in too little memory being allocated for 
sbi->s_group_desc.  The attached patch (against 2.6.28) fixes this by 
changing the type of db_count to unsigned long.  I also took the 
opportunity to make the check against sign extension in calculation of 
db_count more strict, so that it now excludes cases in which db_count 
comes out as zero.

Comments are welcome!

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>

--------------030307040701080609040205
Content-Type: text/x-diff;
 name="null_deref.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="null_deref.patch"

--- linux-2.6.28-orig/fs/ext4/super.c	2008-12-25 00:26:37.000000000 +0100
+++ linux-2.6.28/fs/ext4/super.c	2009-01-05 01:38:23.000000000 +0100
@@ -1873,7 +1873,7 @@
 	char *cp;
 	int ret = -EINVAL;
 	int blocksize;
-	int db_count;
+	unsigned long db_count;
 	int i;
 	int needs_recovery, has_huge_files;
 	__le32 features;
@@ -2145,9 +2145,11 @@
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-	/* ensure blocks_count calculation below doesn't sign-extend */
-	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
-	    le32_to_cpu(es->s_first_data_block) + 1) {
+	/*
+	 * ensure blocks_count calculation below doesn't sign-extend
+	 * and after do_div() still blocks_count > 0
+	 */
+	if (ext4_blocks_count(es) < le32_to_cpu(es->s_first_data_block) + 1) {
 		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
 		       "first data block %u, blocks per group %lu\n",
 			ext4_blocks_count(es),

--------------030307040701080609040205
Content-Type: text/plain;
 name="debug.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug.dmesg"

[ 1381.571583] kobject: 'crc16' (ffffffffa001e7d0): kobject_add_internal: parent: 'module', set: 'module'
[ 1381.571854] kobject: 'holders' (ffff88007e46c940): kobject_add_internal: parent: 'crc16', set: '<NULL>'
[ 1381.571867] kobject: 'crc16' (ffffffffa001e7d0): kobject_uevent_env
[ 1381.571874] kobject: 'crc16' (ffffffffa001e7d0): fill_kobj_path: path = '/module/crc16'
[ 1381.571929] kobject: 'notes' (ffff88007a4a1fc0): kobject_add_internal: parent: 'crc16', set: '<NULL>'
[ 1381.656692] kobject: 'jbd2' (ffffffffa04f5550): kobject_add_internal: parent: 'module', set: 'module'
[ 1381.661578] kobject: 'holders' (ffff880077547e00): kobject_add_internal: parent: 'jbd2', set: '<NULL>'
[ 1381.661592] kobject: 'jbd2' (ffffffffa04f5550): kobject_uevent_env
[ 1381.661598] kobject: 'jbd2' (ffffffffa04f5550): fill_kobj_path: path = '/module/jbd2'
[ 1381.661680] kobject: 'notes' (ffff880077547200): kobject_add_internal: parent: 'jbd2', set: '<NULL>'
[ 1381.677700] kobject: 'ext4' (ffffffffa0531a50): kobject_add_internal: parent: 'module', set: 'module'
[ 1381.685726] kobject: 'holders' (ffff880077547640): kobject_add_internal: parent: 'ext4', set: '<NULL>'
[ 1381.685742] kobject: 'ext4' (ffffffffa0531a50): kobject_uevent_env
[ 1381.685748] kobject: 'ext4' (ffffffffa0531a50): fill_kobj_path: path = '/module/ext4'
[ 1381.685825] kobject: 'notes' (ffff880077547fc0): kobject_add_internal: parent: 'ext4', set: '<NULL>'
[ 1381.704772] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 1381.704778] IP: [<ffffffffa04f8689>] ext4_get_group_desc+0xc9/0x120 [ext4]
[ 1381.704798] PGD 7202d067 PUD 7e408067 PMD 0 
[ 1381.704803] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1381.704810] last sysfs file: /sys/devices/pci0000:00/0000:00:02.0/usb2/idVendor
[ 1381.704813] CPU 1 
[ 1381.704815] Modules linked in: ext4 jbd2 crc16 binfmt_misc battery ppdev lp ipv6 powernow_k8 cpufreq_userspace cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc loop snd_usb_audio snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_usb_lib snd_hwdep snd_seq_dummy arc4 ecb snd_seq_oss psmouse ath5k snd_seq_midi pcspkr serio_raw mac80211 snd_rawmidi led_class k8temp cfg80211 snd_seq_midi_event snd_seq snd_timer snd_seq_device parport_pc parport snd i2c_nforce2 button soundcore i2c_core evdev ext3 jbd mbcache sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mirror dm_region_hash dm_log dm_snapshot dm_mod sd_mod ide_cd_mod cdrom ide_pci_generic sata_nv amd74xx ide_core floppy ata_generic ohci1394 ieee1394 forcedeth libata sc
 si_mod ohci_hcd ehci_hcd thermal processor fan thermal_sys
[ 1381.704903] Pid: 9868, comm: mount Not tainted 2.6.28-tn1-dbg #3
[ 1381.704906] RIP: 0010:[<ffffffffa04f8689>]  [<ffffffffa04f8689>] ext4_get_group_desc+0xc9/0x120 [ext4]
[ 1381.704919] RSP: 0000:ffff88007a41bc08  EFLAGS: 00010296
[ 1381.704922] RAX: 0000000000000010 RBX: 0000000000000000 RCX: 0000000000000000
[ 1381.704925] RDX: ffff880080bc4000 RSI: 0000000000000001 RDI: 0000000000000001
[ 1381.704927] RBP: ffff88007a41bc38 R08: 0000000000000002 R09: 0000000000000000
[ 1381.704930] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880077555000
[ 1381.704932] R13: ffff880079c42000 R14: 0000000000000000 R15: 0000000000000000
[ 1381.704936] FS:  00007f11107fc7c0(0000) GS:ffff88007fb94b40(0000) knlGS:00000000f7e116b0
[ 1381.704939] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1381.704941] CR2: 0000000000000010 CR3: 0000000079476000 CR4: 00000000000006e0
[ 1381.704944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1381.704947] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1381.704950] Process mount (pid: 9868, threadinfo ffff88007a41a000, task ffff8800720bb0c0)
[ 1381.704952] Stack:
[ 1381.704954]  0000000000000000 0000000000000001 0000000000002041 ffff880077555000
[ 1381.704960]  ffff880077555000 ffff880079c42000 ffff88007a41bd68 ffffffffa050b92a
[ 1381.704966]  ffff88007a41bd28 ffffffff803991b9 0000003000000020 000000007a41bd38
[ 1381.704973] Call Trace:
[ 1381.704975]  [<ffffffffa050b92a>] ext4_fill_super+0xc5a/0x2110 [ext4]
[ 1381.704989]  [<ffffffff803991b9>] ? snprintf+0x59/0x60
[ 1381.704996]  [<ffffffff80271f05>] ? mark_held_locks+0x65/0xc0
[ 1381.705001]  [<ffffffff80265614>] ? up+0x34/0x50
[ 1381.705005]  [<ffffffff80272161>] ? trace_hardirqs_on_caller+0x131/0x190
[ 1381.705010]  [<ffffffff802e2b72>] get_sb_bdev+0x162/0x190
[ 1381.705015]  [<ffffffffa050acd0>] ? ext4_fill_super+0x0/0x2110 [ext4]
[ 1381.705028]  [<ffffffff802b4522>] ? kstrdup+0x52/0x70
[ 1381.705034]  [<ffffffffa0507943>] ext4_get_sb+0x13/0x20 [ext4]
[ 1381.705047]  [<ffffffff802e21e9>] vfs_kern_mount+0x79/0x170
[ 1381.705053]  [<ffffffff802e234e>] do_kern_mount+0x4e/0x110
[ 1381.705058]  [<ffffffff802faaa6>] do_mount+0x676/0x8b0
[ 1381.705063]  [<ffffffff802fad98>] sys_mount+0xb8/0xf0
[ 1381.705067]  [<ffffffff80506fe6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1381.705072]  [<ffffffff8020c50a>] system_call_fastpath+0x16/0x1b
[ 1381.705077] Code: 52 a0 48 89 45 d0 31 c0 e8 d1 ba 00 e0 49 8b 54 24 68 31 c0 4c 89 f9 4c 89 e6 48 c7 c7 b0 24 52 a0 e8 b8 ba 00 e0 49 8b 44 24 68 <4a> 8b 14 f8 48 85 d2 74 24 49 8b 85 78 04 00 00 48 8b 00 48 0f 
[ 1381.705130] RIP  [<ffffffffa04f8689>] ext4_get_group_desc+0xc9/0x120 [ext4]
[ 1381.705130]  RSP <ffff88007a41bc08>
[ 1381.705130] CR2: 0000000000000010
[ 1381.705976] ---[ end trace 6048071769394822 ]---

--------------030307040701080609040205--
