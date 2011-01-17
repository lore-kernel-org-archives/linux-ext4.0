From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH] ext4: Fix overflow of metadata block reservation counter
Date: Mon, 17 Jan 2011 17:29:42 +0900
Message-ID: <4D33FDF6.5040700@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010609020900030602070800"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41897 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab1AQIaK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Jan 2011 03:30:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010609020900030602070800
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

The metadata block reservation counter overflows with data write
on ext4 (indirect block map) when its disk space is almost full.
This overflow triggers following BUG_ON.

Jan 14 09:36:48 TNESG9423 kernel: ------------[ cut here ]------------
Jan 14 09:36:48 TNESG9423 kernel: kernel BUG at fs/ext4/inode.c:2170!
Jan 14 09:36:48 TNESG9423 kernel: invalid opcode: 0000 [#1] SMP
Jan 14 09:36:48 TNESG9423 kernel: last sysfs file: /sys/kernel/mm/ksm/run
Jan 14 09:36:48 TNESG9423 kernel: CPU 0
Jan 14 09:36:48 TNESG9423 kernel: Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT bridge stp llc autofs4 sunrpc p4_clockmod freq_table speedstep_lib ipv6 xt_physdev iptable_filter ip_tables nls_utf8 dm_mirror dm_region_hash dm_log dm_mod kvm_intel
kvm uinput ppdev parport_pc parport sg pcspkr i2c_i801 iTCO_wdt iTCO_vendor_support snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore
snd_page_alloc e1000e ext3 jbd sd_mod crc_t10dif sr_mod cdrom pata_via pata_acpi ata_generic ata_piix i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: mperf]
Jan 14 09:36:48 TNESG9423 kernel:
Jan 14 09:36:48 TNESG9423 kernel: Pid: 937, comm: flush-8:0 Not tainted 2.6.37 #1 MS-7264BLM/PC-MJ18ABZR4
Jan 14 09:36:48 TNESG9423 kernel: RIP: 0010:[<ffffffff811c5298>]  [<ffffffff811c5298>] ext4_da_block_invalidatepages+0x168/0x180
Jan 14 09:36:48 TNESG9423 kernel: RSP: 0018:ffff88007613f780  EFLAGS: 00010246
Jan 14 09:36:48 TNESG9423 kernel: RAX: 0010000000000024 RBX: 0000000000008cf2 RCX: 000000000000000e
Jan 14 09:36:48 TNESG9423 kernel: RDX: 000000000000000e RSI: 0000000000000001 RDI: ffffea0000a70d30
Jan 14 09:36:48 TNESG9423 kernel: RBP: ffff88007613f850 R08: 0000000000000001 R09: 0000000000000002
Jan 14 09:36:48 TNESG9423 kernel: R10: ffffea0000a70d38 R11: ffff880035f01b58 R12: ffff88007613f7a0
Jan 14 09:36:48 TNESG9423 kernel: R13: ffff880065eecd68 R14: ffff88007613f7b8 R15: ffffea0000a70a58
Jan 14 09:36:48 TNESG9423 kernel: FS:  0000000000000000(0000) GS:ffff88007f400000(0000) knlGS:0000000000000000
Jan 14 09:36:48 TNESG9423 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jan 14 09:36:48 TNESG9423 kernel: CR2: 0000003680ae1560 CR3: 000000004da45000 CR4: 00000000000006f0
Jan 14 09:36:48 TNESG9423 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 14 09:36:48 TNESG9423 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 14 09:36:48 TNESG9423 kernel: Process flush-8:0 (pid: 937, threadinfo ffff88007613e000, task ffff8800371b54e0)
Jan 14 09:36:48 TNESG9423 kernel: Stack:
Jan 14 09:36:48 TNESG9423 kernel: ffff88007613f7e0 ffffffff814ee3d6 0000000000000008 0000000e7613f7f0
Jan 14 09:36:48 TNESG9423 kernel: 000000000000000e 000000003741a4b9 ffffea0000a70a58 ffffea0000a70a90
Jan 14 09:36:48 TNESG9423 kernel: ffffea0000a70ac8 ffffea0000a70b00 ffffea0000a70b38 ffffea0000a70b70
Jan 14 09:36:48 TNESG9423 kernel: Call Trace:
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff814ee3d6>] ? printk+0x41/0x43
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811c9fe4>] mpage_da_map_and_submit+0x274/0x470
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811ca24d>] mpage_add_bh_to_extent+0x6d/0xf0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811ca5a0>] write_cache_pages_da+0x2d0/0x4a0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811caa4c>] ext4_da_writepages+0x2dc/0x650
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81105321>] do_writepages+0x21/0x40
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810fb55b>] __filemap_fdatawrite_range+0x5b/0x60
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810fb833>] filemap_fdatawrite_range+0x13/0x20
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811fb6ce>] jbd2_journal_begin_ordered_truncate+0x8e/0xb0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811cd02b>] ext4_evict_inode+0x23b/0x3b0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81167477>] evict+0x27/0xc0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81167a4b>] iput+0x1bb/0x2a0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811734a4>] writeback_sb_inodes+0x104/0x180
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81173cfd>] writeback_inodes_wb+0x9d/0x160
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8117404b>] wb_writeback+0x28b/0x400
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810714cc>] ? lock_timer_base+0x3c/0x70
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81072092>] ? del_timer_sync+0x22/0x30
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81174257>] wb_do_writeback+0x97/0x1e0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81174452>] bdi_writeback_thread+0xb2/0x270
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811743a0>] ? bdi_writeback_thread+0x0/0x270
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff811743a0>] ? bdi_writeback_thread+0x0/0x270
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff81083356>] kthread+0x96/0xa0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8100ce84>] kernel_thread_helper+0x4/0x10
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff810832c0>] ? kthread+0x0/0xa0
Jan 14 09:36:48 TNESG9423 kernel: [<ffffffff8100ce80>] ? kernel_thread_helper+0x0/0x10
Jan 14 09:36:48 TNESG9423 kernel: Code: a8 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c9 c3 0f 1f 40 00 4c 89 e7 48 89 95 40 ff ff ff e8 01 1b f4 ff 48 8b 95 40 ff ff ff eb c9 <0f> 0b eb fe 0f 0b 66 90 eb fc
66 66 66 66 66 2e 0f 1f 84 00 00
Jan 14 09:36:48 TNESG9423 kernel: RIP  [<ffffffff811c5298>] ext4_da_block_invalidatepages+0x168/0x180
Jan 14 09:36:48 TNESG9423 kernel: RSP <ffff88007613f780>
Jan 14 09:36:48 TNESG9423 kernel: ---[ end trace 0496eaed3b9ec629 ]---

To fix this, I referred to the patch which is for data blocks
reservation counter (commit: ef627929781c98113e6ae93f159dd3c12a884ad8)
and made a following patch which prints metadata block inconsistency
and corrects it.
My patch is trial, if you have better idea, feel free to fix this bug.

# You can reproduce this problem with attached programs.
# In my environment, this occurs in 1 minute.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/inode.c |   10 ++++++++++
 1 file changed, 10 insertions(+)
diff -Nrup -X linux-2.6.37-org/Documentation/dontdiff linux-2.6.37-org/fs/ext4/inode.c linux-2.6.37/fs/ext4/inode.c
--- linux-2.6.37-org/fs/ext4/inode.c	2011-01-17 15:47:59.000000000 +0900
+++ linux-2.6.37/fs/ext4/inode.c	2011-01-17 15:52:25.000000000 +0900
@@ -1127,6 +1127,16 @@ void ext4_da_update_reserve_space(struct
 		used = ei->i_reserved_data_blocks;
 	}

+	if (unlikely(ei->i_allocated_meta_blocks >
+			ei->i_reserved_meta_blocks)) {
+		ext4_msg(inode->i_sb, KERN_NOTICE, "%s: ino %lu, "
+			"meta blocks %d with only %d reserved meta blocks\n",
+			__func__, inode->i_ino, ei->i_allocated_meta_blocks,
+			ei->i_reserved_meta_blocks);
+		WARN_ON(1);
+		ei->i_allocated_meta_blocks = ei->i_reserved_meta_blocks;
+	}
+
 	/* Update per-inode reservations */
 	ei->i_reserved_data_blocks -= used;
 	ei->i_reserved_meta_blocks -= ei->i_allocated_meta_blocks;

--------------010609020900030602070800
Content-Type: application/x-shellscript;
 name="metadata_blocks_overflow.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="metadata_blocks_overflow.sh"

IyEvYmluL2Jhc2gNCg0KREVWPSAgICAgICAgICAgIyBkZXZpZGUgZS5nLiAvZGV2L3NkYTgN
Ck1QPSAgICAgICAgICAgICMgbW91bnQgcG9pbnQNClRVU0VSPSAgICAgICAgICMgcmVndWxh
ciB1c2VyIGZvciB0ZXN0DQppPTANCm1rZTJmcyAtdCBleHQ0IC1PIF5leHRlbnRzIC1iIDQw
OTYgJERFViA+IC9kZXYvbnVsbCA5NTBNIDI+JjENCm1vdW50IC10IGV4dDQgJERFViAkTVAN
CmRkIGlmPS9kZXYvemVybyBvZj0kTVAvZmlsbF9ibGsgYnM9MU0gY291bnQ9Nzc1ID4gL2Rl
di9udWxsIDI+JjENCmNobW9kIDc3NyAkTVANCg0KZWNobyAidGVzdCBzdGFydCINCndoaWxl
IFsgJGkgLWxlIDUwIF07DQpkbw0KCWVjaG8gIndyaXRlICRpIg0KCXN1ZG8gLXUgJFRVU0VS
IC4vZnNfd3JpdGUgLVMgMSAtRCAtbiAxNiAgLXMgMjA5NzE1MjAgJE1QL2R1bW15ezEuLjE2
fQ0KCWVjaG8gIm13cml0ZSAkaSINCglzdWRvIC11ICRUVVNFUiAuL2ZzX3dyaXRlIC1NIC1u
IDEgLXMgMzE0NTcyODAwICRNUC9kdW1teTENCgkoKGkrKykpDQpkb25lDQp1bW91bnQgJE1Q
DQo=
--------------010609020900030602070800
Content-Type: text/plain;
 name="fs_write.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="fs_write.c"

I2luY2x1ZGUgPHN0ZGlvLmg+DQojaW5jbHVkZSA8c3RkbGliLmg+DQojaW5jbHVkZSA8dW5p
c3RkLmg+DQojaW5jbHVkZSA8c3RyaW5nLmg+DQojaW5jbHVkZSA8c3lzL2ZpbGUuaD4NCiNp
bmNsdWRlIDxzeXMvbW1hbi5oPg0KI2luY2x1ZGUgPHN5cy91aW8uaD4NCiNpbmNsdWRlIDxz
eXMvd2FpdC5oPg0KI2luY2x1ZGUgPGVycm5vLmg+DQojaW5jbHVkZSA8bWFsbG9jLmg+DQoN
CiNkZWZpbmUJQlVGU0laRQk0MDk2DQojZGVmaW5lIFBBVEhfTUFYIDQwOTYNCiNkZWZpbmUJ
TUlOSU9TSVpFIDQqMTAyNA0KI2RlZmluZQlNQVhJT1NJWkUgNCoxMDI0KjEwMjQNCg0KI2lm
bmRlZiBPX0RJUkVDVA0KI2RlZmluZSBPX0RJUkVDVCAwNDAwMDANCiNlbmRpZg0KDQpzdGF0
aWMgaW50CWJ1ZnNpemUgPSAwOwkJLyogQnVmZmVyc2l6ZS4gRGVmYXVsdCByYW5kb20gKi8N
CnN0YXRpYyBpbnQJYnVmc2l6ZV9yYW5kb20gPSAxOwkvKiBCdWZmZXJzaXplIHJhbmRvbSBm
bGFnLiBEZWZhdWx0IHJhbmRvbSAqLw0Kc3RhdGljIGxvbmcgbG9uZwlmaWxlc2l6ZSA9IDA7
CS8qIFRhcmdldCBmaWxlIHNpemUgKi8NCnN0YXRpYyBsb25nIGxvbmcJdGFyZ2V0X3Jhbmdl
ID0gMDsJLyogVGFyZ2V0IHJhbmdlIHBlciBwcm9jZXNzICovDQpzdGF0aWMgaW50CWZpbGVz
X251bSA9IDA7DQpzdGF0aWMgY2hhcgkqZmlsZW5hbWVzOw0Kc3RhdGljIGludAltbWFwX3dy
aXRlID0gMDsNCnN0YXRpYyBpbnQJb19zeW5jID0gMDsNCnN0YXRpYyBpbnQJb19hc3luYyA9
IDA7DQpzdGF0aWMgaW50CW9fZGlyZWN0ID0gMDsNCg0Kc3RhdGljIHZvaWQgc2V0dXAodm9p
ZCk7DQpzdGF0aWMgdm9pZCBjbGVhbnVwKHZvaWQpOw0KDQp2b2lkIHByZ191c2FnZSgpDQp7
DQoJZnByaW50ZihzdGRlcnIsICJVc2FnZTogZnNfd3JpdGUgWy1TIDB8MV0gWy1EXSBbLW4g
bnVtX3Byb2Nlc3NdXG4iKTsNCglmcHJpbnRmKHN0ZGVyciwgIiAgICAgICAgICAgICAgICAt
cyBmaWxlX3NpemUgZmlsZS4uLlxuIik7DQoJZnByaW50ZihzdGRlcnIsICJcbiIpOw0KCWZw
cmludGYoc3RkZXJyLCAiCQktUwlzeW5jIG1vZGUgKDA6T19BU1lOQyAxOk9fU1lOQylcbiIp
Ow0KCWZwcmludGYoc3RkZXJyLCAiCQktRAlEaXJlY3QgSU9cbiIpOw0KCWZwcmludGYoc3Rk
ZXJyLCAiCQktbglQcm9jZXNzIGNvdW50IChkZWZhdWx0IGlzIDEpXG4iKTsNCglmcHJpbnRm
KHN0ZGVyciwgIgkJLXMJRmlsZSBzaXplXG4iKTsNCglmcHJpbnRmKHN0ZGVyciwgIgkJZmls
ZS4uLglUcmFnZXQgZmlsZVxuIik7DQoNCglleGl0KDEpOw0KfQ0KDQppbnQgcnVudGVzdChp
bnQgZmRfd1tdLCBpbnQgY2hpbGRudW0pDQp7DQoJaW50IG51bSA9IDA7DQoJaW50IGVyciA9
IDA7DQoJbG9uZyBsb25nIG9mZnNldCA9IHRhcmdldF9yYW5nZSAqIGNoaWxkbnVtOw0KCWxv
bmcgbG9uZyAgcmVtYWluID0gdGFyZ2V0X3JhbmdlOw0KCWludCBsZW4gPSBidWZzaXplOw0K
CWludCB3cml0ZV9sZW4gPSAwOw0KCWludCBwc2l6ZSA9IGdldHBhZ2VzaXplKCk7DQoJaW50
IG1heF9wYWdlID0gTUFYSU9TSVpFIC8gcHNpemU7DQoJY2hhciAqYnVmX3c7DQoJdm9pZCAq
cDsNCg0KCWJ1Zl93ID0gKGNoYXIqKW1lbWFsaWduKHBzaXplLCBNQVhJT1NJWkUpOw0KDQoJ
d2hpbGUgKHJlbWFpbiA+IDApIHsNCgkJaWYgKGJ1ZnNpemVfcmFuZG9tID09IDEpIHsNCgkJ
CWxlbiA9IChyYW5kKCkgJSBtYXhfcGFnZSkgKiBwc2l6ZTsNCgkJCWlmICghbGVuKQ0KCQkJ
CWxlbiA9IE1JTklPU0laRTsNCgkJfQ0KCQlpZiAobGVuID4gcmVtYWluKQ0KCQkJbGVuID0g
cmVtYWluOw0KDQoJCWZvciAobnVtID0gMDsgbnVtIDwgZmlsZXNfbnVtIDsgbnVtKyspIHsN
CgkJCW1lbXNldChidWZfdywgY2hpbGRudW0rbnVtLCBsZW4pOw0KCQkJaWYgKCFtbWFwX3dy
aXRlKSB7DQoJCQkJaWYgKGxzZWVrKGZkX3dbbnVtXSwgb2Zmc2V0LCBTRUVLX1NFVCkgPCAw
KSB7DQoJCQkJCWVyciA9IGVycm5vOw0KCQkJCQlnb3RvIG91dDsNCgkJCQl9DQoJCQkJaWYg
KCh3cml0ZV9sZW4gPSB3cml0ZShmZF93W251bV0sIGJ1Zl93LCBsZW4pKSA8IDApIHsNCgkJ
CQkJZXJyID0gZXJybm87DQoJCQkJCWdvdG8gb3V0Ow0KCQkJCX0NCgkJCQlpZiAobGVuICE9
IHdyaXRlX2xlbikNCgkJCQkJZ290byBvdXQ7DQoJCQl9IGVsc2Ugew0KCQkJCXAgPSBtbWFw
KE5VTEwsIGxlbiwgUFJPVF9XUklURSwgTUFQX1NIQVJFRCwNCgkJCQkJCQlmZF93W251bV0s
IG9mZnNldCk7DQoJCQkJaWYgKHAgPT0gTUFQX0ZBSUxFRCkgew0KCQkJCQllcnIgPSBlcnJu
bzsNCgkJCQkJZ290byBvdXQ7DQoJCQkJfQ0KCQkJCW1lbWNweShwLCBidWZfdywgbGVuKTsN
CgkJCQlpZiAobXVubWFwKHAsIGxlbikgPT0gLTEpIHsNCgkJCQkJZXJyID0gZXJybm87DQoJ
CQkJCWdvdG8gb3V0Ow0KCQkJCX0NCgkJCX0NCgkJfQ0KCQlvZmZzZXQgKz0gbGVuOw0KCQly
ZW1haW4gLT0gbGVuOw0KCX0NCg0Kb3V0Og0KCWlmIChlcnIgPT0gRU5PU1BDIHx8IGxlbiAh
PSB3cml0ZV9sZW4pDQoJCWVyciA9IDA7DQoJaWYgKGVyciA+IDApDQoJCWZwcmludGYoc3Rk
ZXJyLCAiJXM7XG4iLCBzdHJlcnJvcihlcnIpKTsNCglmcmVlKGJ1Zl93KTsNCg0KCXJldHVy
biBlcnI7DQp9DQoNCmludCBjaGlsZF9mdW5jdGlvbihpbnQgY2hpbGRudW0pDQp7DQoJaW50
IG51bSwgcmV0ID0gLTE7DQoJaW50IGZkX3dbZmlsZXNfbnVtXTsNCgljaGFyICpmaWxlbmFt
ZTsNCgkNCglmb3IgKG51bSA9IDA7IG51bSA8IGZpbGVzX251bSA7IG51bSsrKSB7DQoJCWZk
X3dbbnVtXSA9IC0xOw0KCX0NCglmb3IgKG51bSA9IDA7IG51bSA8IGZpbGVzX251bSA7IG51
bSsrKSB7DQoJCWZpbGVuYW1lID0gZmlsZW5hbWVzICsgKG51bSpQQVRIX01BWCk7DQoJCWlm
ICgoZmRfd1tudW1dID0gb3BlbihmaWxlbmFtZSwNCgkJCQlPX1JEV1J8b19zeW5jfG9fYXN5
bmN8b19kaXJlY3QpKSA8IDApIHsNCgkJCXByaW50ZigiVElORk86ZmRfdyBvcGVuIGZhaWxl
ZCBmb3IgJXM6ICVzXG4iLGZpbGVuYW1lLCBzdHJlcnJvcihlcnJubykpOw0KCQkJZ290byBv
dXQ7DQoJCX0NCgl9DQoNCglyZXQgPSBydW50ZXN0KGZkX3csIGNoaWxkbnVtKTsNCg0Kb3V0
Og0KCWZvciAobnVtID0gMDsgbnVtIDwgZmlsZXNfbnVtIDsgbnVtKyspIHsNCgkJaWYgKGZk
X3dbbnVtXSAhPSAtMSkNCgkJCWNsb3NlKGZkX3dbbnVtXSk7DQoJfQ0KDQoJZXhpdChyZXQp
Ow0KfQ0KDQpzdGF0aWMgdm9pZCBzZXR1cCh2b2lkKQ0Kew0KCWludCBudW0sIGZkOw0KCWNo
YXIgKmZpbGVuYW1lOw0KDQoJZm9yIChudW0gPSAwOyBudW0gPCBmaWxlc19udW07IG51bSsr
KSB7DQoJCWZpbGVuYW1lID0gZmlsZW5hbWVzICsgKG51bSAqIFBBVEhfTUFYKTsNCgkJaWYg
KChmZCA9IG9wZW4oZmlsZW5hbWUsIE9fQ1JFQVR8T19FWENMfE9fV1JPTkxZfE9fVFJVTkMs
IDA2NjYpKSA8IDApIHsNCgkJCXByaW50ZigiVEJST0ssIENvdWxkbid0IGNyZWF0ZSB0ZXN0
IGZpbGUgJXM6ICVzXG4iLCBmaWxlbmFtZSwgc3RyZXJyb3IoZXJybm8pKTsNCgkJCWNsZWFu
dXAoKTsNCgkJfQ0KDQoJCWlmIChtbWFwX3dyaXRlKSB7DQoJCQlpZiAoZnRydW5jYXRlKGZk
LCBmaWxlc2l6ZSkgPCAwKSB7DQoJCQkJcHJpbnRmKCJUQlJPSzI6IENvdWxkbid0IGNyZWF0
ZSB0ZXN0IGZpbGUgJXM6ICVzXG4iLCBmaWxlbmFtZSwgc3RyZXJyb3IoZXJybm8pKTsNCgkJ
CQljbGVhbnVwKCk7DQoJCQl9DQoJCX0NCgkJY2xvc2UoZmQpOw0KCX0NCn0NCg0Kc3RhdGlj
IHZvaWQgY2xlYW51cCh2b2lkKQ0Kew0KCWludCBudW07DQoJZm9yIChudW0gPSAwOyBudW0g
PCBmaWxlc19udW07IG51bSsrKQ0KCQl1bmxpbmsoZmlsZW5hbWVzICsgKG51bSAqIFBBVEhf
TUFYKSk7DQoJZnJlZShmaWxlbmFtZXMpOw0KCWV4aXQoMSk7DQp9DQoNCmludCBtYWluKGlu
dCBhcmdjLCBjaGFyICphcmd2W10pDQp7DQoJaW50CW51bWNoaWxkID0gMTsJLyogTnVtYmVy
IG9mIGNoaWxkcmVuLiBEZWZhdWx0IDUgKi8NCglpbnQJaSwgbnVtOw0KCWludAllcnIgPSAw
Ow0KCWludAlzeW5jX21vZGUgPSAwOw0KCWludAkqY3BpZDsNCglpbnQgCXN0YXR1czsNCg0K
CXdoaWxlICgoaSA9IGdldG9wdChhcmdjLCBhcmd2LCAiTVM6RG46czoiKSkgIT0gLTEpIHsN
CgkJc3dpdGNoKGkpIHsNCgkJY2FzZSAnTSc6DQoJCQltbWFwX3dyaXRlID0gMTsNCgkJCWJy
ZWFrOw0KCQljYXNlICdTJzoNCgkJCWlmICgoc3luY19tb2RlID0gYXRvaShvcHRhcmcpKSA8
IDApIHsNCgkJCQlmcHJpbnRmKHN0ZGVyciwgInN5bmMgbW9kZSBtdXN0IGJlIDAgb3IgMTtc
biIpOw0KCQkJCXByZ191c2FnZSgpOw0KCQkJfQ0KCQkJc3dpdGNoIChzeW5jX21vZGUpIHsN
CgkJCWNhc2UgMDoNCgkJCQlvX2FzeW5jID0gT19BU1lOQzsNCgkJCQlicmVhazsNCgkJCWNh
c2UgMToNCgkJCQlvX3N5bmMgPSBPX1NZTkM7DQoJCQkJYnJlYWs7DQoJCQlkZWZhdWx0Og0K
CQkJCWZwcmludGYoc3RkZXJyLCAic3luYyBtb2RlIG11c3QgYmUgMCBvciAxO1xuIik7DQoJ
CQkJcHJnX3VzYWdlKCk7DQoJCQl9DQoJCQlicmVhazsNCgkJY2FzZSAnRCc6DQoJCQlvX2Rp
cmVjdCA9IE9fRElSRUNUOw0KCQkJYnJlYWs7DQoJCWNhc2UgJ24nOg0KCQkJaWYgKChudW1j
aGlsZCA9IGF0b2kob3B0YXJnKSkgPD0gMCkgew0KCQkJCWZwcmludGYoc3RkZXJyLCAibm8g
b2YgY2hpbGRyZW4gbXVzdCBiZSA+IDA7XG4iKTsNCgkJCQlwcmdfdXNhZ2UoKTsNCgkJCX0N
CgkJCWJyZWFrOw0KCQljYXNlICdzJzoNCgkJCWZpbGVzaXplID0gYXRvbChvcHRhcmcpOw0K
CQkJaWYgKGZpbGVzaXplIDw9IDApIHsNCgkJCQlmcHJpbnRmKHN0ZGVyciwgImZpbGVzaXpl
IG11c3QgYmUgPiAwO1xuIik7DQoJCQkJcHJnX3VzYWdlKCk7DQoJCQl9DQoJCQlicmVhazsN
CgkJZGVmYXVsdDoNCgkJCXByZ191c2FnZSgpOw0KCQl9DQoJfQ0KDQoJZmlsZXNfbnVtID0g
YXJnYyAtIG9wdGluZDsNCglpZiAoZmlsZXNfbnVtIDw9IDApDQoJCXByZ191c2FnZSgpOw0K
CWlmIChmaWxlc2l6ZSAlIG51bWNoaWxkICE9IDAgfHwgKGZpbGVzaXplIC8gbnVtY2hpbGQp
ICUgQlVGU0laRSAhPSAwKSB7DQoJCWZwcmludGYoc3RkZXJyLCAiZmlsZXNpemUgbXVzdCBi
ZSBtdWx0aXBsZSBvZiA0aypudW1jaGlsZDoiDQoJCQkJImZpbGVzaXplPSVsbGQ7XG4iLCBm
aWxlc2l6ZSk7DQoJCXByZ191c2FnZSgpOw0KCX0NCg0KCWlmICgoZmlsZW5hbWVzID0gKGNo
YXIgKiltYWxsb2MoZmlsZXNfbnVtICogUEFUSF9NQVgpKSA9PSBOVUxMIHx8DQoJICAgIChj
cGlkID0gKGludCAqKW1hbGxvYyhzaXplb2YoaW50KSpudW1jaGlsZCkpID09IE5VTEwpIHsN
CgkJcGVycm9yKCJtYWxsb2MiKTsNCgkJZXhpdCgxKTsNCgl9DQoJZm9yKGkgPSBvcHRpbmQs
IG51bSA9IDAgOyBpIDwgYXJnYzsgaSsrLCBudW0rKykNCgkJc3RyY3B5KChjaGFyICopZmls
ZW5hbWVzICsgKG51bSAqIFBBVEhfTUFYKSwgYXJndltpXSk7DQoJdGFyZ2V0X3JhbmdlID0g
ZmlsZXNpemUgLyBudW1jaGlsZDsNCg0KDQoJc2V0dXAoKTsNCg0KCWZvcihpID0gMDsgaSA8
IG51bWNoaWxkOyBpKyspIHsNCgkJKihjcGlkK2kpID0gZm9yaygpOw0KCQlpZiAoKihjcGlk
K2kpID09IDApDQoJCQljaGlsZF9mdW5jdGlvbihpKTsNCgl9DQoJZm9yKGkgPSAwOyBpIDwg
bnVtY2hpbGQ7IGkrKykgew0KCQl3YWl0cGlkKCooY3BpZCsxKSwgJnN0YXR1cywgMCk7DQoJ
fQ0KDQoJY2xlYW51cCgpOw0KCXJldHVybiBlcnI7DQp9
--------------010609020900030602070800--
