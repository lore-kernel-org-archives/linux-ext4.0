From: Valdis.Kletnieks@vt.edu
Subject: 2.6.33-rc4-mmotm0113 - ext3 throws warning..
Date: Sun, 17 Jan 2010 20:08:05 -0500
Message-ID: <20914.1263776885@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263776885_6729P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger@sun.com>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:45039 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab0ARBIe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jan 2010 20:08:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1263776885_6729P
Content-Type: text/plain; charset=us-ascii

Took a power hit earlier in the day, laptop rode it out, external 500G SUB
drive didn't. Several hours later I finally do something that references
the filesystem on the external drive, and I get:

[312252.610201] EXT3-fs error (device sdb2): ext3_get_inode_loc: unable to read inode block - inode=5964029, block=23855121
[312252.610740] ------------[ cut here ]------------
[312252.610759] WARNING: at fs/buffer.c:1181 mark_buffer_dirty+0x65/0xdd()
[312252.610768] Hardware name: Latitude E6500                  
[312252.610776] Modules linked in: ppp_async sunrpc usb_storage [last unloaded: microcode]
[312252.610808] Pid: 2256, comm: ls Not tainted 2.6.33-rc4-mmotm0113 #1
[312252.610816] Call Trace:
[312252.610836]  [<ffffffff81038ac1>] warn_slowpath_common+0x77/0x8f
[312252.610849]  [<ffffffff81038ae8>] warn_slowpath_null+0xf/0x11
[312252.610862]  [<ffffffff810fdb40>] mark_buffer_dirty+0x65/0xdd
[312252.610875]  [<ffffffff81147997>] ext3_commit_super.clone.0+0x54/0x64
[312252.610889]  [<ffffffff81147a37>] ext3_handle_error+0x90/0xb7
[312252.610902]  [<ffffffff81147dd7>] ext3_error+0x76/0x81
[312252.610918]  [<ffffffff8113e9e4>] __ext3_get_inode_loc+0x261/0x287
[312252.610932]  [<ffffffff8113ea24>] ext3_get_inode_loc+0x1a/0x1c
[312252.610945]  [<ffffffff8113ea4e>] ext3_reserve_inode_write+0x28/0x82
[312252.610958]  [<ffffffff8113eae0>] ext3_mark_inode_dirty+0x38/0x55
[312252.610971]  [<ffffffff8113ec40>] ext3_dirty_inode+0x6a/0x81
[312252.610986]  [<ffffffff810f7b04>] __mark_inode_dirty+0x2f/0x14c
[312252.610999]  [<ffffffff810ede7b>] touch_atime+0x102/0x125
[312252.611014]  [<ffffffff810e902c>] ? filldir+0x0/0xcb
[312252.611027]  [<ffffffff810e9270>] vfs_readdir+0x8a/0xb1
[312252.611040]  [<ffffffff810e9427>] sys_getdents+0xa6/0xf8
[312252.611057]  [<ffffffff810023ab>] system_call_fastpath+0x16/0x1b
[312252.611067] ---[ end trace e506d3eb52cbaab0 ]---
[312252.611138] EXT3-fs (sdb2): error in ext3_reserve_inode_write: IO failure
[312257.701924] journal_bmap: journal block not found at offset 84 on sdb2
[312257.701937] Aborting journal on device sdb2.

It was totally in its rights to abort the journal. The WARNING, not so much?

--==_Exmh_1263776885_6729P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLU7R1cC3lWbTT17ARAo/9AKD/APFreN447NdSdwICSwlaTd7O/QCaAy9a
+yKpPOHu3e17PZjSmaP1I70=
=LtHa
-----END PGP SIGNATURE-----

--==_Exmh_1263776885_6729P--

