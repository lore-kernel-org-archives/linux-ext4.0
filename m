From: "Theodore Ts'o" <tytso@mit.edu>
Subject: ext4 assertion failure from delalllc-ext4-lock-reverse.patch
Date: Tue, 22 Apr 2008 22:58:56 -0400
Message-ID: <E1JoVCC-0002AA-Dt@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:55042 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351AbYDWC70 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 22:59:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I just got a kernel bug in EXT4 using 2.6.25 with the ext4 patch queue.

The oops is here, in ext4_da_get_block_write, and the patch involved is
delalloc-ext4-lock-reverse.patch:

static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
				   struct buffer_head *bh_result, int create)
{
	int ret;
	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
	loff_t disksize = EXT4_I(inode)->i_disksize;
	handle_t *handle = NULL;

	J_ASSERT(handle != NULL || create == 0);
	handle = ext4_journal_current_handle();

Note that checking for handle != NULL *before* calling
ext4_journal_current_handle() seems kinda of pointless, since handle is
guaranteed to be NULL at this point.   But it does mean that we know the
problem has to be caused by create being 0.

Grubbing around fs/mpage.c, it's not hard to find some paths where a
passed in get_blocks() function is called with create==0, so this is
clearly a bug.  ext4_da_get_block_write() needs to be able to gracefully
handle the case where create is set to 0.  

What I did to trigger it was:

mke2fs -O has_journal,extent,flex_bg,uninit_bg -I 256 \
       -E lazy_itable_init=1,test_fs /dev/closure/testresize
mount -t ext4dev /tar/closure/testresize /mnt
cd /mnt
tar xvjf /usr/projects/linux/2.6.25-mm1-broken-out.tar.bz2 

This was a soon-to-be-pushed out e2fsprogs which fixes some bugs in the
lazy_itable_init intialization, but looking at the code, I don't think
the problem had anything to do with that.

       	   	      	     	       	   - Ted


[31984.048001] kernel BUG at fs/ext4/inode.c:1418!
[31984.048007] invalid opcode: 0000 [#1] SMP 
[31984.048016] Modules linked in: ext4dev jbd2 crc16 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore cpufreq_stats tun af_packet e1000e i915 drm l2cap bluetooth tpm_tis tpm tpm_bios nfsd lockd auth_rpcgss sunrpc exportfs uinput autofs4 sbs sbshc container wmi acpi_cpufreq loop pcmcia serio_raw yenta_socket psmouse rsrc_nonstatic pcmcia_core pcspkr iTCO_wdt iTCO_vendor_support shpchp pci_hotplug battery bay video output button intel_agp thinkpad_acpi led_class nvram evdev ext3 jbd mbcache sg sd_mod ide_pci_generic piix ide_core ata_piix ahci ata_generic libata scsi_mod dock dm_mirror dm_snapshot dm_mod thermal processor fan fuse
[31984.048187] 
[31984.048193] Pid: 23334, comm: pdflush Not tainted (2.6.25-01370-g5bf3fcb #3)
[31984.048201] EIP: 0060:[<f90c79de>] EFLAGS: 00010202 CPU: 1
[31984.048232] EIP is at ext4_da_get_block_write+0x21/0x17d [ext4dev]
[31984.048239] EAX: ec4e4830 EBX: e7087e24 ECX: 0000000c EDX: 00001000
[31984.048245] ESI: e7087e70 EDI: 00000000 EBP: e7087d98 ESP: e7087d70
[31984.048251]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[31984.048258] Process pdflush (pid: 23334, ti=e7087000 task=e7c70000 task.ti=e7087000)
[31984.048264] Stack: 00000000 00000000 ec4e4830 c0141c76 00000000 00000001 00000001 e7087e70 
[31984.048283]        e7087e70 00000000 e7087e68 c01a7672 e7087e24 00000001 e7087e70 e7087e74 
[31984.048302]        00001000 00000000 00000000 00000001 00000000 e7087dd4 c0169402 e7087e14 
[31984.048321] Call Trace:
[31984.048332]  [<c0141c76>] ? mark_held_locks+0x41/0x5c
[31984.048358]  [<c01a7672>] ? mpage_da_map_blocks+0x9a/0x364
[31984.048381]  [<c0169402>] ? drain_cpu_pagevecs+0x33/0x93
[31984.048399]  [<c01696a2>] ? __pagevec_release+0x18/0x21
[31984.048413]  [<c0167c7c>] ? write_cache_pages+0x20a/0x289
[31984.048423]  [<c01a89db>] ? __mpage_da_writepage+0x0/0x105
[31984.048445]  [<f9020ffe>] ? jbd2_journal_start+0xce/0xf0 [jbd2]
[31984.048484]  [<c01a835f>] ? mpage_da_writepages+0x6e/0x7e
[31984.048502]  [<f9021013>] ? jbd2_journal_start+0xe3/0xf0 [jbd2]
[31984.048525]  [<f9020ffe>] ? jbd2_journal_start+0xce/0xf0 [jbd2]
[31984.048549]  [<f90c79bd>] ? ext4_da_get_block_write+0x0/0x17d [ext4dev]
[31984.048587]  [<f90c7bae>] ? ext4_da_writepages+0x74/0xb0 [ext4dev]
[31984.048623]  [<f90c7b3a>] ? ext4_da_writepages+0x0/0xb0 [ext4dev]
[31984.048658]  [<c0167d45>] ? do_writepages+0x23/0x34
[31984.048672]  [<c019d752>] ? __writeback_single_inode+0x12a/0x260
[31984.048692]  [<f8890098>] ? dm_any_congested+0x32/0x39 [dm_mod]
[31984.048722]  [<c019dbe7>] ? sync_sb_inodes+0x18d/0x24d
[31984.048740]  [<c019de75>] ? writeback_inodes+0x70/0xbd
[31984.048751]  [<c01688c5>] ? pdflush+0x0/0x1a1
[31984.048764]  [<c01684b8>] ? background_writeout+0x73/0x9e
[31984.048788]  [<c01689d1>] ? pdflush+0x10c/0x1a1
[31984.048799]  [<c0168445>] ? background_writeout+0x0/0x9e
[31984.048815]  [<c0136dba>] ? kthread+0x3b/0x61
[31984.048827]  [<c0136d7f>] ? kthread+0x0/0x61
[31984.048839]  [<c01056df>] ? kernel_thread_helper+0x7/0x10
[31984.048856]  =======================
[31984.048860] Code: 8d 65 f4 89 d8 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c 8b 5d 08 83 7d 0c 00 89 45 e0 89 55 d8 89 4d dc 8b 53 14 8b 48 64 74 04 <0f> 0b eb fe 64 a1 00 f0 43 c0 8b 80 48 11 00 00 d3 ea 6a 00 6a 
[31984.048967] EIP: [<f90c79de>] ext4_da_get_block_write+0x21/0x17d [ext4dev] SS:ESP 0068:e7087d70
[31984.049122] ---[ end trace d43117b107a26f28 ]---
[37551.739575] ------------[ cut here ]------------
[37551.739575] kernel BUG at fs/ext4/inode.c:1418!
[37551.739575] invalid opcode: 0000 [#2] SMP 
[37551.739575] Modules linked in: ext4dev jbd2 crc16 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore cpufreq_stats tun af_packet e1000e i915 drm l2cap bluetooth tpm_tis tpm tpm_bios nfsd lockd auth_rpcgss sunrpc exportfs uinput autofs4 sbs sbshc container wmi acpi_cpufreq loop pcmcia serio_raw yenta_socket psmouse rsrc_nonstatic pcmcia_core pcspkr iTCO_wdt iTCO_vendor_support shpchp pci_hotplug battery bay video output button intel_agp thinkpad_acpi led_class nvram evdev ext3 jbd mbcache sg sd_mod ide_pci_generic piix ide_core ata_piix ahci ata_generic libata scsi_mod dock dm_mirror dm_snapshot dm_mod thermal processor fan fuse
[37551.739575] 
[37551.739575] Pid: 7425, comm: sync Tainted: G      D  (2.6.25-01370-g5bf3fcb #3)
[37551.739575] EIP: 0060:[<f90c79de>] EFLAGS: 00010202 CPU: 0
[37551.739575] EIP is at ext4_da_get_block_write+0x21/0x17d [ext4dev]
[37551.739575] EAX: ec4e4bd0 EBX: e658de0c ECX: 0000000c EDX: 00001000
[37551.739575] ESI: e658de58 EDI: 0000dbe7 EBP: e658dd80 ESP: e658dd58
[37551.739575]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[37551.739575] Process sync (pid: 7425, ti=e658d000 task=cc166000 task.ti=e658d000)
[37551.739575] Stack: 00000000 00000000 ec4e4bd0 00000000 ec4e4d1c 00000046 00000046 e658de58 
[37551.739575]        e658de58 0000dbe7 e658de50 c01a7672 e658de0c 00000001 e658de58 e658de5c 
[37551.739575]        00001000 00000000 00000000 e658de3c e658ddfc 00000000 e658ddc8 c0169038 
[37551.739575] Call Trace:
[37551.739575]  [<c01a7672>] ? mpage_da_map_blocks+0x9a/0x364
[37551.739575]  [<c0169038>] ? pagevec_lookup_tag+0x1c/0x25
[37551.739575]  [<c0167cb5>] ? write_cache_pages+0x243/0x289
[37551.739575]  [<c01a89db>] ? __mpage_da_writepage+0x0/0x105
[37551.739575]  [<c02db8c5>] ? _spin_unlock+0x1d/0x20
[37551.739575]  [<c01a835f>] ? mpage_da_writepages+0x6e/0x7e
[37551.739575]  [<f9021013>] ? jbd2_journal_start+0xe3/0xf0 [jbd2]
[37551.739575]  [<f9020ffe>] ? jbd2_journal_start+0xce/0xf0 [jbd2]
[37551.739575]  [<f90c79bd>] ? ext4_da_get_block_write+0x0/0x17d [ext4dev]
[37551.739575]  [<f90c7bae>] ? ext4_da_writepages+0x74/0xb0 [ext4dev]
[37551.739575]  [<f90c7b3a>] ? ext4_da_writepages+0x0/0xb0 [ext4dev]
[37551.739575]  [<c0167d45>] ? do_writepages+0x23/0x34
[37551.739575]  [<c019d752>] ? __writeback_single_inode+0x12a/0x260
[37551.739575]  [<c019dbe7>] ? sync_sb_inodes+0x18d/0x24d
[37551.739575]  [<c019dd2b>] ? sync_inodes_sb+0x84/0x96
[37551.739575]  [<c019dd93>] ? __sync_inodes+0x56/0x9c
[37551.739575]  [<c019dded>] ? sync_inodes+0x14/0x2c
[37551.739575]  [<c01a031b>] ? do_sync+0x14/0x5a
[37551.739576]  [<c01a036e>] ? sys_sync+0xd/0x13
[37551.739576]  [<c01049a0>] ? sysenter_past_esp+0x6d/0xc5
[37551.739576]  =======================
[37551.739576] Code: 8d 65 f4 89 d8 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c 8b 5d 08 83 7d 0c 00 89 45 e0 89 55 d8 89 4d dc 8b 53 14 8b 48 64 74 04 <0f> 0b eb fe 64 a1 00 f0 43 c0 8b 80 48 11 00 00 d3 ea 6a 00 6a 
[37551.739576] EIP: [<f90c79de>] ext4_da_get_block_write+0x21/0x17d [ext4dev] SS:ESP 0068:e658dd58
[37551.739576] ---[ end trace d43117b107a26f28 ]---
