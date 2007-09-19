From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 14:06:17 +0200
Message-ID: <1190203577.14472.25.camel@ext1.frec.bull.fr>
References: <46F06C7B.20308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
	cmm@us.ibm.com
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50672 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXISJo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 05:44:58 -0400
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Avantika,
I ran some tests with the uninit_groups feature enabled and got error m=
essages
when running e2fsck on my ext4 partition. e2fsck complains of an "inval=
id=20
unused inodes count" in some group descriptors.
These errors occur when checking groups which have only one inode in us=
e. The=20
"free inodes" count has been decremented by one in these groups but not=
 the=20
"unused inodes" count.

The following patch fixes the problem.

Andreas, could you check if my patch is correct?
Thanks a lot,
  Val=E9rie

Index: linux-2.6.23-rc6/fs/ext4/ialloc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.23-rc6.orig/fs/ext4/ialloc.c	2007-09-19 11:31:01.00000000=
0 +0200
+++ linux-2.6.23-rc6/fs/ext4/ialloc.c	2007-09-19 11:31:41.000000000 +02=
00
@@ -633,13 +633,10 @@ got:
 	/* If we didn't allocate from within the initialized part of the inod=
e
 	 * table then we need to initialize up to this inode. */
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) =
{
-		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
 			gdp->bg_flags &=3D cpu_to_le16(~EXT4_BG_INODE_UNINIT);
-			free =3D EXT4_INODES_PER_GROUP(sb);
-		} else {
-			free =3D EXT4_INODES_PER_GROUP(sb) -
+		free =3D EXT4_INODES_PER_GROUP(sb) -
 				le16_to_cpu(gdp->bg_itable_unused);
-		}
=20
 		if (ino > free)
 			gdp->bg_itable_unused =3D
