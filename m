From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 17:04:39 +0530
Message-ID: <46F1094F.1080906@linux.vnet.ibm.com>
References: <46F06C7B.20308@linux.vnet.ibm.com> <1190203577.14472.25.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
	cmm@us.ibm.com
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57182 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbXISLfO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 07:35:14 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8JBZA38027011
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 21:35:10 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8JBci0H290740
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 21:38:44 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8JCYqOZ028253
	for <linux-ext4@vger.kernel.org>; Wed, 19 Sep 2007 22:34:53 +1000
In-Reply-To: <1190203577.14472.25.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Valerie Clement wrote:
> Hi Avantika,
> I ran some tests with the uninit_groups feature enabled and got error=
 messages
> when running e2fsck on my ext4 partition. e2fsck complains of an "inv=
alid=20
> unused inodes count" in some group descriptors.
> These errors occur when checking groups which have only one inode in =
use. The=20
> "free inodes" count has been decremented by one in these groups but n=
ot the=20
> "unused inodes" count.
>=20
> The following patch fixes the problem.
>=20
> Andreas, could you check if my patch is correct?
> Thanks a lot,
>   Val=E9rie
>=20
> Index: linux-2.6.23-rc6/fs/ext4/ialloc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.23-rc6.orig/fs/ext4/ialloc.c	2007-09-19 11:31:01.000000=
000 +0200
> +++ linux-2.6.23-rc6/fs/ext4/ialloc.c	2007-09-19 11:31:41.000000000 +=
0200
> @@ -633,13 +633,10 @@ got:
>  	/* If we didn't allocate from within the initialized part of the in=
ode
>  	 * table then we need to initialize up to this inode. */
>  	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)=
) {
> -		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> +		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
>  			gdp->bg_flags &=3D cpu_to_le16(~EXT4_BG_INODE_UNINIT);
> -			free =3D EXT4_INODES_PER_GROUP(sb);
> -		} else {
> -			free =3D EXT4_INODES_PER_GROUP(sb) -
> +		free =3D EXT4_INODES_PER_GROUP(sb) -
>  				le16_to_cpu(gdp->bg_itable_unused);
> -		}
>=20
>

the variable free is confusingly named here. It is not the free inode c=
ount.
rather it indicate the last used relative inode number in the group. Ho=
w about
the below ?

-aneesh

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 4250c02..cfe2e09 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -633,17 +633,21 @@ got:
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
-				le16_to_cpu(gdp->bg_itable_unused);
-		}
=20
-		if (ino > free)
+		/*
+		 * Check the relative inode number against the last used
+		 * relative inode number in this group. if it is greater
+		 * we need to  update the bg_itable_unused count
+		 *
+		 */
+		if (ino > (EXT4_INODES_PER_GROUP(sb) -
+					le16_to_cpu(gdp->bg_itable_unused))) {
+
 			gdp->bg_itable_unused =3D
 				cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
+		}
 	}
=20
 	gdp->bg_free_inodes_count =3D
