From: Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH] ext4: fix error handling in ext4_create_journal
Date: Wed, 4 Jul 2007 21:30:24 +0200
Message-ID: <20070704193024.GA6802@gollum.tnic>
References: <20070701221111.GA8627@gollum.tnic> <20070703152543.e58ad39a.akpm@linux-foundation.org>
Reply-To: bbpetkov@yahoo.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp111.plus.mail.re1.yahoo.com ([69.147.102.74]:20508 "HELO
	smtp111.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756453AbXGDTak (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 15:30:40 -0400
Content-Disposition: inline
In-Reply-To: <20070703152543.e58ad39a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 03, 2007 at 03:25:43PM -0700, Andrew Morton wrote:

> Please prepare the equivalent patch for ext4.  Without that, it'd pro=
bably
> be better to avoid applying the ext3 patch: there are advantages to k=
eeping
> the two in sync where possible.

Hi Andrew,

   here you go. By the way, this one is with generated diffstat. Do you=
 prefer
   it that way or is a diffstat for a patch touching a single file too =
much?

-----
=46rom: Borislav Petkov <bbpetkov@yahoo.de>

=46ix error handling in ext4_create_journal according to kernel convent=
ions.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

---
 linux-2.6.22-rc7/fs/ext4/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.22-rc7/fs/ext4/super.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22-rc7/fs/ext4/super.c.orig	2007-07-04 21:18:24.000000000=
 +0200
+++ linux-2.6.22-rc7/fs/ext4/super.c	2007-07-04 21:19:46.000000000 +020=
0
@@ -2150,6 +2150,7 @@
 			       unsigned int journal_inum)
 {
 	journal_t *journal;
+	int err;
=20
 	if (sb->s_flags & MS_RDONLY) {
 		printk(KERN_ERR "EXT4-fs: readonly filesystem when trying to "
@@ -2157,13 +2158,15 @@
 		return -EROFS;
 	}
=20
-	if (!(journal =3D ext4_get_journal(sb, journal_inum)))
+	journal =3D ext4_get_journal(sb, journal_inum);
+	if (!journal)
 		return -EINVAL;
=20
 	printk(KERN_INFO "EXT4-fs: creating new journal on inode %u\n",
 	       journal_inum);
=20
-	if (jbd2_journal_create(journal)) {
+	err =3D jbd2_journal_create(journal);
+	if (err) {
 		printk(KERN_ERR "EXT4-fs: error creating journal.\n");
 		jbd2_journal_destroy(journal);
 		return -EIO;
--=20
Regards/Gru=DF,
    Boris.
