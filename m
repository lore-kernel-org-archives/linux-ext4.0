From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Fri, 30 May 2008 19:20:47 +0100
Message-ID: <1212171647.7508.46.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@Sun.COM>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:41529 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbYE3S2G (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 14:28:06 -0400
Received: from fe-emea-09.sun.com (gmp-eb-lb-2-fe1.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m4UIKp2I011099
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 18:20:53 GMT
Received: from conversion-daemon.fe-emea-09.sun.com by fe-emea-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K1P002011JD6K00@fe-emea-09.sun.com>
 (original mail from Ricardo.M.Correia@Sun.COM) for linux-ext4@vger.kernel.org;
 Fri, 30 May 2008 19:20:51 +0100 (BST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds ZFS filesystem detection to libblkid.

It probes for VDEV_BOOT_MAGIC in the first 2 ZFS labels in big-endian
and little-endian formats.
Unfortunately the probe table doesn't support probing from the end of
the device, otherwise we could also probe in the 3rd and 4th labels (in
case the first 2 labels were accidentally overwritten)..

Eventually we would set the =EF=BB=BFUUID from the ZFS pool GUID and th=
e LABEL tag
from the pool name, but that requires parsing an XDR encoding of the po=
ol
configuration which is not trivial.

Signed-off-by: Ricardo M. Correia <Ricardo.M.Correia@Sun.COM>
Signed-off-by: Andreas Dilger <adilger@sun.com>
---
diff --git a/lib/blkid/probe.c b/lib/blkid/probe.c
index c8bc840..cad0860 100644
--- a/lib/blkid/probe.c
+++ b/lib/blkid/probe.c
@@ -774,6 +774,18 @@ static int probe_jfs(struct blkid_probe *probe,
 	return 0;
 }
=20
+static int probe_zfs(struct blkid_probe *probe, struct blkid_magic *id=
,
+		     unsigned char *buf)
+{
+	char *vdev_label;
+	const char *pool_name =3D 0;
+
+	/* read nvpair data for pool name, pool GUID (complex) */
+	//blkid_set_tag(probe->dev, "LABEL", pool_name, sizeof(pool_name));
+	//set_uuid(probe->dev, pool_guid, 0);
+	return 0;
+}
+
 static int probe_luks(struct blkid_probe *probe,
 		       struct blkid_magic *id __BLKID_ATTR((unused)),
 		       unsigned char *buf)
@@ -1095,15 +1107,6 @@ static int probe_lvm2(struct blkid_probe *probe,
 	return 0;
 }
 /*
- * BLKID_BLK_OFFS is at least as large as the highest bim_kboff define=
d
- * in the type_array table below + bim_kbalign.
- *
- * When probing for a lot of magics, we handle everything in 1kB
buffers so
- * that we don't have to worry about reading each combination of block
sizes.
- */
-#define BLKID_BLK_OFFS	64	/* currently reiserfs */
-
-/*
  * Various filesystem magics that we can check for.  Note that kboff
and
  * sboff are in kilobytes and bytes respectively.  All magics are in
  * byte strings so we don't worry about endian issues.
@@ -1153,6 +1156,10 @@ static struct blkid_magic type_array[] =3D {
   { "iso9660",	32,	 1,  5, "CD001",		probe_iso9660 },
   { "iso9660",	32,	 9,  5, "CDROM",		probe_iso9660 },
   { "jfs",	32,	 0,  4, "JFS1",			probe_jfs },
+  { "zfs",       8,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c",
probe_zfs },
+  { "zfs",       8,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0",
probe_zfs },
+  { "zfs",     264,	 0,  8, "\0\0\x02\xf5\xb0\x07\xb1\x0c",
probe_zfs },
+  { "zfs",     264,	 0,  8, "\x0c\xb1\x07\xb0\xf5\x02\0\0",
probe_zfs },
   { "hfsplus",	 1,	 0,  2, "BD",			probe_hfsplus },
   { "hfsplus",	 1,	 0,  2, "H+",			0 },
   { "hfs",	 1,	 0,  2, "BD",			0 },
@@ -1288,7 +1295,7 @@ try_again:
 		if (!buf)
 			continue;
=20
-		if (memcmp(id->bim_magic, buf + (id->bim_sboff&0x3ff),
+		if (memcmp(id->bim_magic, buf + (id->bim_sboff & 0x3ff),
 			   id->bim_len))
 			continue;
=20
@@ -1318,7 +1325,7 @@ try_again:
 		dev =3D 0;
 		goto found_type;
 	}
-	=09
+
 found_type:
 	if (dev && type) {
 		dev->bid_devno =3D st.st_rdev;
@@ -1327,7 +1334,7 @@ found_type:
 		cache->bic_flags |=3D BLKID_BIC_FL_CHANGED;
=20
 		blkid_set_tag(dev, "TYPE", type, 0);
-			=09
+
 		DBG(DEBUG_PROBE, printf("%s: devno 0x%04llx, type %s\n",
 			   dev->bid_name, (long long)st.st_rdev, type));
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
