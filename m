From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 lazytime: ctime of some files changed
Date: Thu, 14 May 2015 18:20:44 -0400
Message-ID: <20150514222044.GA3901@thunk.org>
References: <55531AE3.7030704@web.de>
 <mivtkj$fhi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37304 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030242AbbENWUq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2015 18:20:46 -0400
Content-Disposition: inline
In-Reply-To: <mivtkj$fhi$1@ger.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 13, 2015 at 06:20:35PM +0200, J=F6rg-Volker Peetz wrote:
>=20
> Thereafter, the two emacs package files again had a wrong mtime (whic=
h by the
> way shows when I start emacs).
>=20
> Could this be due to the lazytime mount option?

I think I found the problem.  My bad.  Can you verify that this solves
the problem for you?

=46rom 8f4d855839179f410fa910a26eb81d646d628f26 Mon Sep 17 00:00:00 200=
1
=46rom: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 14 May 2015 18:19:01 -0400
Subject: [PATCH] ext4: fix lazytime optimization

We had a fencepost error in the lazytime optimization which means that
timestamp would get written to the wrong inode.

Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55b187c..0554b0b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4345,7 +4345,7 @@ static void ext4_update_other_inodes_time(struct =
super_block *sb,
 	int inode_size =3D EXT4_INODE_SIZE(sb);
=20
 	oi.orig_ino =3D orig_ino;
-	ino =3D orig_ino & ~(inodes_per_block - 1);
+	ino =3D (orig_ino & ~(inodes_per_block - 1)) + 1;
 	for (i =3D 0; i < inodes_per_block; i++, ino++, buf +=3D inode_size) =
{
 		if (ino =3D=3D orig_ino)
 			continue;
--=20
2.3.0

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
