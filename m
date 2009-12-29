From: "Ben Castricum" <mail0912@bencastricum.nl>
Subject: Kernel BUG 2.6.33-rc2
Date: Tue, 29 Dec 2009 08:08:02 +0100
Message-ID: <B1CA7293D55045EF86492E734D43A1E0@seven>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
To: <linux-kernel@vger.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bencastricum.nl ([213.84.203.196]:43602 "EHLO
	bencastricum.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZL2HNj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 02:13:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I just seem to be hitting this bug since I upgraded to Slack 13 and started 
using EXT4 yesterday. The file copy is between 2 EXT4 filesytems. I can 
trigger this bug pretty reliable. After the bug occurs, systems seems to be 
unusable and needs a reboot.

my .config can be found at http://www.bencastricum.nl/.config (when the 
system hasn't crashed)

I appreciate any suggestions.

Ben

------------[ cut here ]------------
Kernel BUG at b01b70cd [verbose debug info unavailable]
invalid opcode: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.3/i2c-0/0-002e/cpu0_vid
Modules linked in: af_packet ipt_MASQUERADE ipt_REJECT ipt_LOG xt_recent 
xt_tcpudp xt_state iptable_filter nf_conntrack_ftp iptable_nat ip_tables 
nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 dm_mod lm85 
hwmon_vid hwmon cdc_acm snd_intel8x0 snd_ac97_codec uhci_hcd ac97_bus 
snd_pcm 8250_pnp tg3 8250 snd_timer firmware_class serial_core ehci_hcd snd 
8139too soundcore usbcore libphy mii i2c_i801 snd_page_alloc sr_mod psmouse 
nls_base cdrom sg

Pid: 8035, comm: cp Not tainted 2.6.33-rc2 #340 085Ch/HP d530 SFF(PL110ES)
EIP: 0060:[<b01b70cd>] EFLAGS: 00010297 CPU: 0
EIP is at ext4_get_blocks+0x1e0/0x398
EAX: 00000001 EBX: 00000004 ECX: cf5af6d0 EDX: f6d19090
ESI: 00000002 EDI: cf5af6d0 EBP: b780fc44 ESP: b780fc0c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cp (pid: 8035, ti=b780f000 task=b78cc800 task.ti=b780f000)
Stack:
 f6b32e80 0000000f cf5af748 cf5af738 00000001 e3001100 b780fcf5 f6bef800
<0> 00000001 000001d9 00000040 00000040 0000000a b780fcf4 b780fd38 b01b761b
<0> 0000010c 00000000 00000040 b780fcf4 0000000d b780fc88 b01e81db b780fea0
Call Trace:
 [<b01b761b>] ? mpage_da_map_blocks+0xa2/0x71e
 [<b01e81db>] ? radix_tree_tag_set+0x55/0xa8
 [<b0159219>] ? __set_page_dirty_nobuffers+0xd1/0xdd
 [<b0153c03>] ? unlock_page+0x3e/0x41
 [<b01b6329>] ? ext4_writepage+0xeb/0x2a1
 [<b01e7e0d>] ? __lookup_tag+0x8d/0xe7
 [<b01e7edd>] ? radix_tree_gang_lookup_tag_slot+0x76/0x95
 [<b01536b2>] ? find_get_pages_tag+0x2b/0xdd
 [<b01b833b>] ? mpage_add_bh_to_extent+0x9d/0xb7
 [<b01b8462>] ? __mpage_da_writepage+0x10d/0x153
 [<b015884d>] ? write_cache_pages+0x158/0x214
 [<b01b8355>] ? __mpage_da_writepage+0x0/0x153
 [<b01b80e7>] ? ext4_da_writepages+0x450/0x607
 [<b011cf02>] ? __wake_up+0x31/0x3b
 [<b01d1551>] ? jbd2_journal_stop+0x22d/0x238
 [<b01d226d>] ? jbd2_journal_start+0x8c/0xb7
 [<b01bcedb>] ? ext4_orphan_del+0x16f/0x185
 [<b01b7c97>] ? ext4_da_writepages+0x0/0x607
 [<b015894c>] ? do_writepages+0x1c/0x28
 [<b015454c>] ? __filemap_fdatawrite_range+0x59/0x65
 [<b0154f95>] ? filemap_flush+0x15/0x17
 [<b01b6506>] ? ext4_alloc_da_blocks+0x27/0x29
 [<b01b1e48>] ? ext4_release_file+0x1c/0x85
 [<b0175f5a>] ? __fput+0xca/0x150
 [<b0175ff9>] ? fput+0x19/0x1b
 [<b0173964>] ? filp_close+0x48/0x52
 [<b01739d6>] ? sys_close+0x68/0x9f
 [<b02e0a7d>] ? syscall_call+0x7/0xb
Code: e8 52 ee ff ff 89 c3 8b 87 14 02 00 00 39 c3 76 04 0f 0b eb fe 29 d8 
89 45 e8 75 04 31 f6 eb 4d 8b b7 18 02 00 00 39 75 e8 7d 04 <0f> 0b eb fe 29 
75 e8 8b 45 e8 99 f7 d8 83 d2 00 f7 da 89 45 c8
EIP: [<b01b70cd>] ext4_get_blocks+0x1e0/0x398 SS:ESP 0068:b780fc0c
---[ end trace 95d6264240212785 ]---
------------[ cut here ]------------

