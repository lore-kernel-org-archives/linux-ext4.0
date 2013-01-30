From: Anders Lind <anderslindgaard@yahoo.com>
Subject: [ext4] minor. consecutive shift is not necessary
Date: Tue, 29 Jan 2013 22:57:58 -0800 (PST)
Message-ID: <1359529078.28633.YahooMailNeo@web164603.mail.gq1.yahoo.com>
Reply-To: Anders Lind <anderslindgaard@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nm31-vm1.bullet.mail.gq1.yahoo.com ([98.136.216.208]:42140 "EHLO
	nm31-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab3A3HEU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jan 2013 02:04:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Hi,

Since pb is at least 64-bits, shifting by 32 will not invoke UB. I dont=
 see reason doing that.


diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 487fda1..eb40d98 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -259,7 +259,7 @@ static inline void ext4_ext_store_pblock(struct ext=
4_extent *ex,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext4_fsblk_t pb)
=A0{
=A0=A0=A0=A0=A0=A0=A0 ex->ee_start_lo =3D cpu_to_le32((unsigned long) (=
pb & 0xffffffff));
-=A0=A0=A0=A0=A0=A0 ex->ee_start_hi =3D cpu_to_le16((unsigned long) ((p=
b >> 31) >> 1) &
+=A0=A0=A0=A0=A0=A0 ex->ee_start_hi =3D cpu_to_le16((unsigned long) (pb=
 >> 32) &
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0xffff);
=A0}
=A0
@@ -272,7 +272,7 @@ static inline void ext4_idx_store_pblock(struct ext=
4_extent_idx *ix,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ext4_fsblk_t pb)
=A0{
=A0=A0=A0=A0=A0=A0=A0 ix->ei_leaf_lo =3D cpu_to_le32((unsigned long) (p=
b & 0xffffffff));
-=A0=A0=A0=A0=A0=A0 ix->ei_leaf_hi =3D cpu_to_le16((unsigned long) ((pb=
 >> 31) >> 1) &
+=A0=A0=A0=A0=A0=A0 ix->ei_leaf_hi =3D cpu_to_le16((unsigned long) (pb =
>> 32)=A0 &
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0xffff);
=A0}

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
