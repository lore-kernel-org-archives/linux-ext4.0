From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Fri, 30 Mar 2012 18:23:55 +0300
Message-ID: <1333121035.5440.49.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
	 <1332854998.31549.40.camel@sauron.fi.intel.com>
	 <20120327201401.GF5020@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QXjoI4VFboPKQVU3rqcQ"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13644 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760675Ab2C3PUt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:49 -0400
In-Reply-To: <20120327201401.GF5020@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-QXjoI4VFboPKQVU3rqcQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-03-27 at 22:14 +0200, Jan Kara wrote:
> On Tue 27-03-12 16:29:58, Artem Bityutskiy wrote:
> > On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
> > >   Then we have ext4_mark_super_dirty() call from 4 places - I forgot =
about
> > > these originally... I kind of miss their purpose. Originally they wer=
e used
> > > so that we write total number of free blocks and inodes in the superb=
lock
> > > but when we do not maintain them in the journal mode I don't see a re=
ason
> > > to periodically sync them in no-journal mode. Ted, what is the purpos=
e of
> > > these calls?
> >=20
> > I do not understand what's the fundamental difference between journal
> > and non-journal mode. Why when we do have the journal we do not mark th=
e
> > super-block as dirty in many places (e.g., in 'ext4_file_open()' - if w=
e
> > do have the journal, when do we make sure we save the mount point path
> > change?).
>   We write it at least during ext4_put_super().
>=20
> > May be it has something to do with behaving like the ext2 driver when
> > mounting ext2-formatted media with the the ext4 driver?
>   I'm not really sure about this...
>=20
> > Jan, since Ted did not answer, may be you can figure out the reasons
> > from this commit message, which actually introduced the
> > 'ext4_mark_super_dirty()' function?
>   Anyway, attached are two patches which you can include in your series
> and which should make your cleanups simpler.

I amended the second patch:
-                               ext4_journal_stop(sb);
+                               ext4_journal_stop(sbi->s_sbh);

Extensive testing with xfstests found a problem with these patches:

[23500.238579] ------------[ cut here ]------------
[23500.238720] kernel BUG at fs/buffer.c:2871!
[23500.238842] invalid opcode: 0000 [#1] SMP=20
[23500.239279] CPU 11=20
[23500.239338] Modules linked in: [last unloaded: scsi_wait_scan]
[23500.239442]=20
[23500.239442] Pid: 15799, comm: fsstress Not tainted 3.3.0+ #43 Bochs Boch=
s
[23500.239442] RIP: 0010:[<ffffffff811a9add>]  [<ffffffff811a9add>] submit_=
bh+0x10d/0x120
[23500.239442] RSP: 0018:ffff880273a41b58  EFLAGS: 00010202
[23500.239442] RAX: 000000000004d025 RBX: ffff8802469e5a90 RCX: 00000000000=
00000
[23500.239442] RDX: ffff880273a41fd8 RSI: ffff8802469e5a90 RDI: 00000000000=
00211
[23500.239442] RBP: ffff880273a41b78 R08: ffff880409645d80 R09: 00000000000=
00001
[23500.239442] R10: 0000000000000001 R11: ffff880178439000 R12: 00000000000=
00211
[23500.239442] R13: ffff880273a41c34 R14: ffff8804059b7000 R15: ffff880273a=
41fd8
[23500.239442] FS:  00007fc8731e7700(0000) GS:ffff88041fd60000(0000) knlGS:=
0000000000000000
[23500.239442] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[23500.239442] CR2: 00007fc873082008 CR3: 000000012456a000 CR4: 00000000000=
006e0
[23500.239442] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[23500.239442] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[23500.239442] Process fsstress (pid: 15799, threadinfo ffff880273a40000, t=
ask ffff880150dd8000)
[23500.239442] Stack:
[23500.239442]  ffff8804059b7000 ffff8802469e5a90 0000000000000211 ffff8802=
73a41c34
[23500.239442]  ffff880273a41b98 ffffffff811ab59d 0000000000000002 ffff8804=
059b7128
[23500.239442]  ffff880273a41bf8 ffffffff8123be1d 0000000091827364 ffff8801=
0e9a7e30
[23500.239442] Call Trace:
[23500.239442]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[23500.239442]  [<ffffffff8123be1d>] __flush_batch+0x4d/0xa0
[23500.239442]  [<ffffffff8123c605>] jbd2_log_do_checkpoint+0xf5/0x4f0
[23500.239442]  [<ffffffff8123ca89>] __jbd2_log_wait_for_space+0x89/0x190
[23500.239442]  [<ffffffff81237a98>] start_this_handle+0x3a8/0x4e0
[23500.239442]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[23500.239442]  [<ffffffff81237c93>] jbd2__journal_start+0xc3/0x100
[23500.239442]  [<ffffffff81237ce3>] jbd2_journal_start+0x13/0x20
[23500.239442]  [<ffffffff8121743f>] ext4_journal_start_sb+0x7f/0x1d0
[23500.239442]  [<ffffffff81224a24>] ? ext4_fallocate+0x1a4/0x530
[23500.239442]  [<ffffffff811f64c5>] ? ext4_meta_trans_blocks+0xa5/0xb0
[23500.239442]  [<ffffffff81224a24>] ext4_fallocate+0x1a4/0x530
[23500.239442]  [<ffffffff8117a092>] do_fallocate+0xf2/0x160
[23500.239442]  [<ffffffff8117a14b>] sys_fallocate+0x4b/0x70
[23500.239442]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[23500.239442] Code: ee 44 89 e7 e8 35 1f 0f 00 49 8b 5d 18 4c 89 ef e8 19 =
4e 00 00 48 83 c4 08 c1 e3 18 c1 fb 1f 83 e3 a1 89 d8 5b 41 5c 41 5d 5d c3 =
<0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 0f 1f 84 00 00 00 00 00 55 48=20
[23500.239442] RIP  [<ffffffff811a9add>] submit_bh+0x10d/0x120
[23500.239442]  RSP <ffff880273a41b58>
[23500.261657] ---[ end trace 3db7a7a7ae953551 ]---
[23500.262131] ------------[ cut here ]------------
[23500.262577] WARNING: at kernel/exit.c:897 do_exit+0x55/0x870()
[23500.263070] Hardware name: Bochs
[23500.263467] Modules linked in: [last unloaded: scsi_wait_scan]
[23500.264129] Pid: 15799, comm: fsstress Tainted: G      D      3.3.0+ #43
[23500.264623] Call Trace:
[23500.265066]  [<ffffffff810572bf>] warn_slowpath_common+0x7f/0xc0
[23500.265542]  [<ffffffff8105731a>] warn_slowpath_null+0x1a/0x20
[23500.266034]  [<ffffffff8105b1c5>] do_exit+0x55/0x870
[23500.266482]  [<ffffffff81058f6c>] ? kmsg_dump+0x5c/0xf0
[23500.266932]  [<ffffffff815dfeac>] oops_end+0xac/0xf0
[23500.267418]  [<ffffffff81017928>] die+0x58/0x90
[23500.267852]  [<ffffffff815df7a4>] do_trap+0xc4/0x170
[23500.268343]  [<ffffffff81014fa5>] do_invalid_op+0x95/0xb0
[23500.268803]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[23500.269344]  [<ffffffff81299db4>] ? drive_stat_acct+0x114/0x190
[23500.269825]  [<ffffffff8129ec36>] ? blk_queue_bio+0x106/0x400
[23500.270324]  [<ffffffff815e7f9b>] invalid_op+0x1b/0x20
[23500.270778]  [<ffffffff811a9add>] ? submit_bh+0x10d/0x120
[23500.271263]  [<ffffffff811a9ac7>] ? submit_bh+0xf7/0x120
[23500.271723]  [<ffffffff811ab59d>] write_dirty_buffer+0x4d/0x80
[23500.272217]  [<ffffffff8123be1d>] __flush_batch+0x4d/0xa0
[23500.272675]  [<ffffffff8123c605>] jbd2_log_do_checkpoint+0xf5/0x4f0
[23500.273226]  [<ffffffff8123ca89>] __jbd2_log_wait_for_space+0x89/0x190
[23500.273714]  [<ffffffff81237a98>] start_this_handle+0x3a8/0x4e0
[23500.274213]  [<ffffffff810799e0>] ? remove_wait_queue+0x50/0x50
[23500.274686]  [<ffffffff81237c93>] jbd2__journal_start+0xc3/0x100
[23500.275193]  [<ffffffff81237ce3>] jbd2_journal_start+0x13/0x20
[23500.275664]  [<ffffffff8121743f>] ext4_journal_start_sb+0x7f/0x1d0
[23500.276166]  [<ffffffff81224a24>] ? ext4_fallocate+0x1a4/0x530
[23500.276638]  [<ffffffff811f64c5>] ? ext4_meta_trans_blocks+0xa5/0xb0
[23500.277186]  [<ffffffff81224a24>] ext4_fallocate+0x1a4/0x530
[23500.277654]  [<ffffffff8117a092>] do_fallocate+0xf2/0x160
[23500.278164]  [<ffffffff8117a14b>] sys_fallocate+0x4b/0x70
[23500.278624]  [<ffffffff815e6d69>] system_call_fastpath+0x16/0x1b
[23500.279124] ---[ end trace 3db7a7a7ae953552 ]---

--=20
Best Regards,
Artem Bityutskiy

--=-QXjoI4VFboPKQVU3rqcQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPddALAAoJECmIfjd9wqK0W2MQAMYn6VsrqnOUOFZ9W6peZSQB
wif5b7LiB3wFMGG6188+Vv5KJcuTS6jhKOFwCMUg0QmbGX5th2uc58kmB5elix6p
jlKtvVhB5MQU3c8yhJvkPR+yDT14quHoi1AWq4KJeQuAzyQyFfS1ANtQJOGxfZS2
JceFavsHb3rlyAoUyQduGdMn9nD2blaSwWciie4RFTYESghjZoP/9Nxl8UDE5lr7
Tfs7gU5hjsOrDDsUXe6XcynCb6lQxZKI6bW5ahM4f6ku/GW2hm+wipieTYFWJlfw
4BjiD91AYae6kOX0SLv9Mt+I/twYQTBDcIi3U/U2/ygYgp14QqsIZaqyPcbgwNM3
JL0+WY+/H8U/g2a84/y99xymUO18fzd+m20ncfsKdy0IdHAlx7ncX4PxEiP8Zh3f
g1o3QiDCiJUY2XpKGehJgpqAqrc49Ld37WKUWurtoofPWgd4JBvlxX5M5gWgoceJ
R2SMtk1HIs67ZLCWjOjrZqGDUJQa+yLSYYXxXJ08ahuil8NiVAP7mOisoDiNMviK
P3lnO6R8wqzXwtdzQ3lMaKK7HkuU49a0QVm3M8xgPSggUPu0Xf+niG36wc1fmbEh
P4e6KIm+AK3FjEav8VHVzKZ74yam7O5lF9SQzOpXsrlIWn7G84+ty85MHisp+u+6
o7bSDtRQxf5GxBnz3+hX
=8pmQ
-----END PGP SIGNATURE-----

--=-QXjoI4VFboPKQVU3rqcQ--

