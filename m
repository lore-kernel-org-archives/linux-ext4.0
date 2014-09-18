From: Jan Kara <jack@suse.cz>
Subject: Re: OOPs in ext4 - linux 3.17
Date: Thu, 18 Sep 2014 16:43:54 +0200
Message-ID: <20140918144354.GA30996@quack.suse.cz>
References: <CAOkSjBjEG+U7v+7stOSKNCsLy3ed2ZQdmTGZyEaFZxNrXbsCjA@mail.gmail.com>
 <8761gltbmj.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbaIROn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 10:43:57 -0400
Content-Disposition: inline
In-Reply-To: <8761gltbmj.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 18-09-14 15:24:20, Dmitry Monakhov wrote:
> On Thu, 18 Sep 2014 12:12:45 +0200, Arturo Borrero Gonzalez <arturo.b=
orrero.glez@gmail.com> wrote:
> > Hi there!
> >=20
> > I remember I reported a similar OOPs some time ago.
> >=20
> > This is what I'm having now, while compiling a new kernel.
> > Is a VM, with the ext4 over a LVS volume from the virtualization se=
rver (kvm).
> Error is pretty obvious.
> EIO provokes journal abort, jbd2_journal_dirty_metadata return -EROFS
> non zero error code provokes this WARN_ON
> if (ext4_handle_valid(handle)) {
>    err =3D jbd2_journal_dirty_metadata(handle, bh);
>    /* Errors can only happen if there is a bug */
>    if (WARN_ON_ONCE(err)) {
> This code was introduced by Jack@ here (91aa11fae1cf8c2)
> So this WARN_ON is false positive.
> IMHO we can interpret aborted journal as special but valid case.

> ext4: fix over-defensive complain after journal abort
  Oh, right. Thanks for fixing this. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

>=20
>=20
> diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> index 0074e0d..3445035 100644
> --- a/fs/ext4/ext4_jbd2.c
> +++ b/fs/ext4/ext4_jbd2.c
> @@ -256,8 +256,8 @@ int __ext4_handle_dirty_metadata(const char *wher=
e, unsigned int line,
>  	set_buffer_prio(bh);
>  	if (ext4_handle_valid(handle)) {
>  		err =3D jbd2_journal_dirty_metadata(handle, bh);
> -		/* Errors can only happen if there is a bug */
> -		if (WARN_ON_ONCE(err)) {
> +		/* Errors can only happen due to aborted journal or a nasty bug */
> +		if (!is_handle_aborted(handle) && WARN_ON_ONCE(err)) {
>  			ext4_journal_abort_handle(where, line, __func__, bh,
>  						  handle, err);
>  			if (inode =3D=3D NULL) {

>=20
> >=20
> > [60051.240797] EXT4-fs error (device vda1):
> > ext4_mb_generate_buddy:757: group 50, block bitmap and bg descripto=
r
> > inconsistent: 13481 vs 13480 free clusters
> > [60051.241510] Aborting journal on device vda1-8.
> > [60051.243504] EXT4-fs (vda1): Remounting filesystem read-only
> > [60051.244557] ------------[ cut here ]------------
> > [60051.244634] WARNING: CPU: 5 PID: 17238 at fs/ext4/ext4_jbd2.c:26=
0
> > __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]()
> > [60051.244636] Modules linked in: nft_hash nft_rbtree nfsd auth_rpc=
gss
> > oid_registry nfs_acl nfs lockd fscache sunrpc loop snd_pcm snd_time=
r
> > snd psmouse soundcore parport_pc serio_raw pcspkr parport microcode
> > evdev i2c_piix4 virtio_balloon processor thermal_sys button ext4 cr=
c16
> > jbd2 mbcache sg sr_mod cdrom ata_generic virtio_blk virtio_net flop=
py
> > uhci_hcd ata_piix ehci_hcd libata scsi_mod usbcore virtio_pci
> > virtio_ring virtio usb_common
> > [60051.244680] CPU: 5 PID: 17238 Comm: collect2 Not tainted 3.17.0-=
rc4+ #5
> > [60051.244682] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> > [60051.244685]  0000000000000000 0000000000000009 ffffffff813e058e
> > 0000000000000000
> > [60051.244689]  ffffffff8103c2a6 ffff88005b752e00 ffffffffa01349c2
> > ffff880022e39090
> > [60051.244693]  ffff880022e39090 ffff880056f801a8 00000000ffffffe2
> > 0000000000000000
> > [60051.244732] Call Trace:
> > [60051.244796]  [<ffffffff813e058e>] ? dump_stack+0x41/0x51
> > [60051.245197]  [<ffffffff8103c2a6>] ? warn_slowpath_common+0x78/0x=
90
> > [60051.245212]  [<ffffffffa01349c2>] ?
> > __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]
> > [60051.245224]  [<ffffffffa01349c2>] ?
> > __ext4_handle_dirty_metadata+0x5c/0x1b7 [ext4]
> > [60051.245235]  [<ffffffffa0115f3d>] ? ext4_dirty_inode+0x21/0x52 [=
ext4]
> > [60051.245244]  [<ffffffffa0115f1c>] ? ext4_evict_inode+0x2d7/0x2d7=
 [ext4]
> > [60051.245259]  [<ffffffffa013afa6>] ? ext4_free_blocks+0x6c6/0x778=
 [ext4]
> > [60051.245277]  [<ffffffffa01001a4>] ?
> > jbd2_journal_put_journal_head+0x17/0x109 [jbd2]
> > [60051.245473]  [<ffffffffa0131a23>] ? ext4_ext_remove_space+0x660/=
0xbd8 [ext4]
> > [60051.245487]  [<ffffffffa01405a9>] ? __es_remove_extent+0x1ee/0x2=
91 [ext4]
> > [60051.245500]  [<ffffffffa013319f>] ? ext4_ext_truncate+0x7a/0x9e =
[ext4]
> > [60051.245509]  [<ffffffffa0113f0b>] ? ext4_truncate+0x1d0/0x2ba [e=
xt4]
> > [60051.245520]  [<ffffffffa0115e09>] ? ext4_evict_inode+0x1c4/0x2d7=
 [ext4]
> > [60051.245546]  [<ffffffff8112a8b0>] ? evict+0xa3/0x147
> > [60051.245552]  [<ffffffff81121971>] ? do_unlinkat+0x124/0x1c0
> > [60051.245567]  [<ffffffff810f507f>] ? vm_munmap+0x46/0x55
> > [60051.245581]  [<ffffffff813e4c12>] ? system_call_fastpath+0x16/0x=
1b
> > [60051.245584] ---[ end trace 8d5a92036c653e2a ]---
> > [60051.245588] EXT4: jbd2_journal_dirty_metadata failed: handle typ=
e 5
> > started at line 244, credits 29/29, errcode -30
> > [60051.246133] EXT4: jbd2_journal_dirty_metadata failed: handle typ=
e 5
> > started at line 244, credits 29/29, errcode -30<2>[60051.246827]
> > EXT4-fs error (device vda1) in ext4_free_blocks:4889: Journal has
> > aborted
> > [60051.247680] EXT4-fs error (device vda1) in
> > ext4_reserve_inode_write:4757: Journal has aborted
> > [60051.248615] EXT4-fs error (device vda1) in
> > ext4_reserve_inode_write:4757: Journal has aborted
> > [60051.249387] EXT4-fs error (device vda1) in
> > ext4_ext_remove_space:3020: Journal has aborted
> > [60051.250150] EXT4-fs error (device vda1) in ext4_ext_truncate:466=
4:
> > Journal has aborted
> > [60051.250904] EXT4-fs error (device vda1) in
> > ext4_reserve_inode_write:4757: Journal has aborted
> > [60051.251655] EXT4-fs error (device vda1) in ext4_truncate:3664:
> > Journal has aborted
> > [60051.252822] EXT4-fs error (device vda1) in
> > ext4_reserve_inode_write:4757: Journal has aborted
> > [60051.254288] EXT4-fs error (device vda1) in ext4_orphan_del:2720:
> > Journal has aborted
> >=20
> >=20
> > Please, CC, I'm not in the list.
> > --=20
> > Arturo Borrero Gonz=E1lez
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext=
4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
