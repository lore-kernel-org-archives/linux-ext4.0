From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: OOPs in ext4 - linux 3.17
Date: Thu, 18 Sep 2014 15:24:20 +0400
Message-ID: <8761gltbmj.fsf@openvz.org>
References: <CAOkSjBjEG+U7v+7stOSKNCsLy3ed2ZQdmTGZyEaFZxNrXbsCjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37357 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbaIRLYZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Sep 2014 07:24:25 -0400
Received: by mail-lb0-f172.google.com with SMTP id p9so282706lbv.31
        for <linux-ext4@vger.kernel.org>; Thu, 18 Sep 2014 04:24:23 -0700 (PDT)
In-Reply-To: <CAOkSjBjEG+U7v+7stOSKNCsLy3ed2ZQdmTGZyEaFZxNrXbsCjA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=

On Thu, 18 Sep 2014 12:12:45 +0200, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> Hi there!
> 
> I remember I reported a similar OOPs some time ago.
> 
> This is what I'm having now, while compiling a new kernel.
> Is a VM, with the ext4 over a LVS volume from the virtualization server (kvm).
Error is pretty obvious.
EIO provokes journal abort, jbd2_journal_dirty_metadata return -EROFS
non zero error code provokes this WARN_ON
if (ext4_handle_valid(handle)) {
   err = jbd2_journal_dirty_metadata(handle, bh);
   /* Errors can only happen if there is a bug */
   if (WARN_ON_ONCE(err)) {
This code was introduced by Jack@ here (91aa11fae1cf8c2)
So this WARN_ON is false positive.
IMHO we can interpret aborted journal as special but valid case.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=skip_aborted_journal.patch

ext4: fix over-defensive complain after journal abort


diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 0074e0d..3445035 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -256,8 +256,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 	set_buffer_prio(bh);
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		/* Errors can only happen if there is a bug */
-		if (WARN_ON_ONCE(err)) {
+		/* Errors can only happen due to aborted journal or a nasty bug */
+		if (!is_handle_aborted(handle) && WARN_ON_ONCE(err)) {
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
 			if (inode == NULL) {

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


>=20
> [60051.240797] EXT4-fs error (device vda1):
> ext4_mb_generate_buddy:757: group 50, block bitmap and bg descriptor
> inconsistent: 13481 vs 13480 free clusters
> [60051.241510] Aborting journal on device vda1-8.
> [60051.243504] EXT4-fs (vda1): Remounting filesystem read-only
> [60051.244557] ------------[ cut here ]------------
> [60051.244634] WARNING: CPU: 5 PID: 17238 at fs/ext4/ext4_jbd2.c:260
> __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]()
> [60051.244636] Modules linked in: nft_hash nft_rbtree nfsd auth_rpcgss
> oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_pcm snd_timer
> snd psmouse soundcore parport_pc serio_raw pcspkr parport microcode
> evdev i2c_piix4 virtio_balloon processor thermal_sys button ext4 crc16
> jbd2 mbcache sg sr_mod cdrom ata_generic virtio_blk virtio_net floppy
> uhci_hcd ata_piix ehci_hcd libata scsi_mod usbcore virtio_pci
> virtio_ring virtio usb_common
> [60051.244680] CPU: 5 PID: 17238 Comm: collect2 Not tainted 3.17.0-rc4+ #5
> [60051.244682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [60051.244685]  0000000000000000 0000000000000009 ffffffff813e058e
> 0000000000000000
> [60051.244689]  ffffffff8103c2a6 ffff88005b752e00 ffffffffa01349c2
> ffff880022e39090
> [60051.244693]  ffff880022e39090 ffff880056f801a8 00000000ffffffe2
> 0000000000000000
> [60051.244732] Call Trace:
> [60051.244796]  [<ffffffff813e058e>] ? dump_stack+0x41/0x51
> [60051.245197]  [<ffffffff8103c2a6>] ? warn_slowpath_common+0x78/0x90
> [60051.245212]  [<ffffffffa01349c2>] ?
> __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]
> [60051.245224]  [<ffffffffa01349c2>] ?
> __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]
> [60051.245235]  [<ffffffffa0115f3d>] ? ext4_dirty_inode+0x21/0x52 [ext4]
> [60051.245244]  [<ffffffffa0115f1c>] ? ext4_evict_inode+0x2d7/0x2d7 [ext4]
> [60051.245259]  [<ffffffffa013afa6>] ? ext4_free_blocks+0x6c6/0x778 [ext4]
> [60051.245277]  [<ffffffffa01001a4>] ?
> jbd2_journal_put_journal_head+0x17/0x109 [jbd2]
> [60051.245473]  [<ffffffffa0131a23>] ? ext4_ext_remove_space+0x660/0xbd8 =
[ext4]
> [60051.245487]  [<ffffffffa01405a9>] ? __es_remove_extent+0x1ee/0x291 [ex=
t4]
> [60051.245500]  [<ffffffffa013319f>] ? ext4_ext_truncate+0x7a/0x9e [ext4]
> [60051.245509]  [<ffffffffa0113f0b>] ? ext4_truncate+0x1d0/0x2ba [ext4]
> [60051.245520]  [<ffffffffa0115e09>] ? ext4_evict_inode+0x1c4/0x2d7 [ext4]
> [60051.245546]  [<ffffffff8112a8b0>] ? evict+0xa3/0x147
> [60051.245552]  [<ffffffff81121971>] ? do_unlinkat+0x124/0x1c0
> [60051.245567]  [<ffffffff810f507f>] ? vm_munmap+0x46/0x55
> [60051.245581]  [<ffffffff813e4c12>] ? system_call_fastpath+0x16/0x1b
> [60051.245584] ---[ end trace 8d5a92036c653e2a ]---
> [60051.245588] EXT4: jbd2_journal_dirty_metadata failed: handle type 5
> started at line 244, credits 29/29, errcode -30
> [60051.246133] EXT4: jbd2_journal_dirty_metadata failed: handle type 5
> started at line 244, credits 29/29, errcode -30<2>[60051.246827]
> EXT4-fs error (device vda1) in ext4_free_blocks:4889: Journal has
> aborted
> [60051.247680] EXT4-fs error (device vda1) in
> ext4_reserve_inode_write:4757: Journal has aborted
> [60051.248615] EXT4-fs error (device vda1) in
> ext4_reserve_inode_write:4757: Journal has aborted
> [60051.249387] EXT4-fs error (device vda1) in
> ext4_ext_remove_space:3020: Journal has aborted
> [60051.250150] EXT4-fs error (device vda1) in ext4_ext_truncate:4664:
> Journal has aborted
> [60051.250904] EXT4-fs error (device vda1) in
> ext4_reserve_inode_write:4757: Journal has aborted
> [60051.251655] EXT4-fs error (device vda1) in ext4_truncate:3664:
> Journal has aborted
> [60051.252822] EXT4-fs error (device vda1) in
> ext4_reserve_inode_write:4757: Journal has aborted
> [60051.254288] EXT4-fs error (device vda1) in ext4_orphan_del:2720:
> Journal has aborted
>=20
>=20
> Please, CC, I'm not in the list.
> --=20
> Arturo Borrero Gonz=C3=A1lez
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=--
