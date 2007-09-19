From: Valerie Clement <valerie.clement@bull.net>
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Date: Wed, 19 Sep 2007 14:01:40 +0200
Message-ID: <46F10FA4.6060902@bull.net>
References: <46F06C7B.20308@linux.vnet.ibm.com> <1190203577.14472.25.camel@ext1.frec.bull.fr> <46F1094F.1080906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>,
	cmm@us.ibm.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:46616 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbXISMBm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Sep 2007 08:01:42 -0400
In-Reply-To: <46F1094F.1080906@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh Kumar K.V wrote:
> the variable free is confusingly named here. It is not the free inode=
=20
> count.
> rather it indicate the last used relative inode number in the group. =
How=20
> about
> the below ?
>=20
> -aneesh

I agree, it's better.
   Val=E9rie

>=20
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 4250c02..cfe2e09 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -633,17 +633,21 @@ got:
>     /* If we didn't allocate from within the initialized part of the =
inode
>      * table then we need to initialize up to this inode. */
>     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSU=
M)) {
> -        if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
> +        if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT))
>             gdp->bg_flags &=3D cpu_to_le16(~EXT4_BG_INODE_UNINIT);
> -            free =3D EXT4_INODES_PER_GROUP(sb);
> -        } else {
> -            free =3D EXT4_INODES_PER_GROUP(sb) -
> -                le16_to_cpu(gdp->bg_itable_unused);
> -        }
>=20
> -        if (ino > free)
> +        /*
> +         * Check the relative inode number against the last used
> +         * relative inode number in this group. if it is greater
> +         * we need to  update the bg_itable_unused count
> +         *
> +         */
> +        if (ino > (EXT4_INODES_PER_GROUP(sb) -
> +                    le16_to_cpu(gdp->bg_itable_unused))) {
> +
>             gdp->bg_itable_unused =3D
>                 cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
> +        }
>     }
>=20
>     gdp->bg_free_inodes_count =3D
>=20
