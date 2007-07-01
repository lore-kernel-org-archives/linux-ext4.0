From: Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH] fix error handling in ext3_create_journal
Date: Mon, 2 Jul 2007 00:11:11 +0200
Message-ID: <20070701221111.GA8627@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758631AbXGAWPI@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


---
=46rom: Borislav Petkov <bbpetkov@yahoo.de>

=46ix error handling in ext3_create_journal according to kernel convent=
ions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
--

Index: linux-2.6.22-rc6/fs/ext3/super.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc6/fs/ext3/super.c.orig	2007-07-01 21:12:51.000000000=
 +0200
+++ linux-2.6.22-rc6/fs/ext3/super.c	2007-07-01 21:14:32.000000000 +020=
0
@@ -2075,6 +2075,7 @@
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
=20
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT3-fs: readonly filesystem when trying to "
@@ -2082,13 +2083,15 @@
 		return -EROFS;
 	}
=20
-	if (!(journal =3D ext3_get_journal(sb, journal_inum)))
+	journal =3D ext3_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
=20
 	printk(KERN_INFO "EXT3-fs: creating new journal on inode %u\n",
 	       journal_inum);
=20
-	if (journal_create(journal)) {
+	err =3D journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT3-fs: error creating journal.\n");
 		journal_destroy(journal);
 		return -EIO;
--=20
Regards/Gru=DF,
    Boris.
