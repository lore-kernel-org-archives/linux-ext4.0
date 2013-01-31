From: "Jon ERNST" <jonernst@gmx.com>
Subject: extents_status comment small modification
Date: Thu, 31 Jan 2013 07:08:34 +0100
Message-ID: <20130131060835.23270@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49793 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab3AaGIh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 01:08:37 -0500
Received: from mailout-eu.gmx.com ([10.1.101.214]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MSFoz-1UOoLg3Sw7-00TTVl for
 <linux-ext4@vger.kernel.org>; Thu, 31 Jan 2013 07:08:35 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 Hi list,
=20
 I guess is a small helpful typo fix.
=20
 diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
 index 564d981..ca4c810 100644
 --- a/fs/ext4/extents_status.c
 +++ b/fs/ext4/extents_status.c
 @@ -104,7 +104,7 @@
 =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0 a space.
 =C2=A0 *
 =C2=A0 *=C2=A0=C2=A0 --=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 race=
 on a delayed extent tree
 - *=C2=A0=C2=A0=C2=A0=C2=A0 Delayed extent tree is protected inode->i_=
es_lock.
 + *=C2=A0=C2=A0=C2=A0=C2=A0 Delayed extent tree is protected by inode-=
>i_es_lock.
 =C2=A0 *
 =C2=A0 *
 =C2=A0 * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
=20
=20
 Regards,
 Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
