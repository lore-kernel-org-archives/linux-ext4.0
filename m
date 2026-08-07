Received: from SVZP279CU002.outbound.protection.outlook.com (mail-norwaywestazolkn19010000.outbound.protection.outlook.com [52.103.52.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1FD3FA5DD
	for <linux-ext4@vger.kernel.org>; Fri,  7 Aug 2026 10:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.52.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097028; cv=fail; b=tY7lRSSCVsLCvyCrePaZRRKwLDrIRhQliVRdPpu8tjYVg2kIEpWDi9NagrIx2MW+swadi7elq0uu+sNfWWiIJm1ypMTgMu7/0RvPvRWKwtgu6oCUG8NKQO9OVi2Dw0h+InLqSqY2a5Jktrt9mzqtCm2jjBR0FFXjpWwwOoYjhRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097028; c=relaxed/simple;
	bh=lTLZHYe0ea1hYixkquoAi3RP+lbRC1rb+XJfNi4y9hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CTt+XVdc0QnKv2s9WoEjWa66aWwouBgzoByAGLMYSsriIShBs3CBvqJzHqmjJP4ZnWg8AGqo0W/Q/hibw9OPwe3KFPN9GXO78+iNiZOwuMgclsytLc86EkKv0rxJOaqfixTNdTomhyJS83+RGHupgbfi767mA9B4DCD+GXF6flo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de; spf=pass smtp.mailfrom=hotmail.de; dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b=qoDH0BRV; arc=fail smtp.client-ip=52.103.52.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.DE header.i=@HOTMAIL.DE header.b="qoDH0BRV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WX3wNIXn1tekYK2hxO0nssXI2vTqyCvnJRDbaJR1/cie1AEN0CaCH2VL4oHcNVp8jQQEGZ3cIFQLESh9HrYzJmrhXUUh1CIM3LQbEeiSybNUgzjM1yd4jNMcAjkBdS6h9wlGPmCTahUTU9j2eg7gFUbNE4EjCTyxC+kv0rIGipXbGsZIhS7IxYlmULxLi6IE0yLJHGR9SPM2JZYB4GQDRwa6ExF3vlNriBikaycT80nl8Yrg2aDcPTFzmd18TjO/9ZvDdVvgTs/YRf/bLg3EDg8+54+2+dPmzwKfpEl8/p7u3BmaJkKTlRULeKVGUq1NciafbDbmDh+qzpP8OZ7OvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NHKOYJc71vByVrfJg5/stt5zS6YVkd/UqEfxfrvZyJM=;
 b=XD7tuso/x0ZWM4GNNe4784XSizr1FxTO/lQ3TgIo/ZTM+z1ox8oQ2Y4tWbDOchNjcbQBxEGzmRo8utdsBbau43i8Wig//IgytV/UzzNeCaM/m7eztP9b5iDFqjbDdMhTLcUNVoRW7OgrrLU7GaCB6KdkEOJSKGzlEcCQ3FiPM99BYUNeNdGrcKd5+vpB3AR+vgTnYZrlJ5RBcOGsvpau/HVjqnmMNi5UaPma/qEBVZMGLMDsVVr3F+rMDrb79QlbOJ+SQ1d7isVqAYBdo8NsdDaeU9H615iWV9jY5Vj48TVzUteuO+nHIB8SEdw0YQrclfeGjedddtaGUZ2KF95Mvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.DE;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHKOYJc71vByVrfJg5/stt5zS6YVkd/UqEfxfrvZyJM=;
 b=qoDH0BRVUZK02k3XmvkXsi+EqM5ry428o2sEQ9zTlQRPBtOFPdD/YdJ74t4liCSiyHVFGTdvBp0u3yix9t+t3Gm2HhkVeK2fLlfateonwG2jOk4SpnYByQEOABYwjnk3PIbWXgxCqIA3Fda+nqQmoa2OCuSveU3LuORKsc2ck5K++VQBFKLjm2ppVAAJ5kltpWA0gHqiiaaSlqw9aXxhLkMRPCIN/7KEfVnwQMzMarbcGKqBxvAfjrtAgRvFK66A0CiNsLZ+HG+2dqguI0cBZMdROjjq8n1TwiaWIixnpo3zjghhqCDbQVnT8WEJ3m4/mKmy6TnzC0K/gop0qUlDRQ==
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM (2603:10a6:e10:70::8) by
 SV0P279MB1103.NORP279.PROD.OUTLOOK.COM (2603:10a6:f10:32::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.23; Fri, 7 Aug 2026 10:03:41 +0000
Received: from OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040]) by OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 ([fe80::8f31:434c:edb2:d040%5]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 10:03:41 +0000
From: Nexory <St4yl3r30@hotmail.de>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Nexory <St4yl3r30@hotmail.de>
Subject: [PATCH e2fsprogs 2/2] tests: add d_rdump_safe for the debugfs rdump path-traversal guard
Date: Fri,  7 Aug 2026 12:03:04 +0200
Message-ID:
 <OS6P279MB1180BE9B7C39128DD2B6D891CBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
References: <OS6P279MB1180ED8E849B4768423DCF8ECBD12@OS6P279MB1180.NORP279.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0107.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::17) To OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:70::8)
X-Microsoft-Original-Message-ID: <20260807100304.2032-3-St4yl3r30@hotmail.de>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS6P279MB1180:EE_|SV0P279MB1103:EE_
X-MS-Office365-Filtering-Correlation-Id: fad5ccf0-3852-41f8-2ac7-08def46b283f
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|8060799015|19110799012|51005399006|23021999003|15080799012|24021099003|25010399006|5072599009|40105399003|2607281247196008|3412199025|440099028|260806224601699003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rM1Bty11YKNpEeB2dVdpEeNWx8/sSyjyNg0TfSHW1cdu4wExO7cNqHw+ccp4?=
 =?us-ascii?Q?snh3u1l94Gq2fOKs5/IqC87tDcqktit9uCNbEeyPeh+DQgg43heYAVXUt0B/?=
 =?us-ascii?Q?WJRwRFOJQ1z4Td1r98J8ykazpA3Yll3nxmpLf0+2NmumIgheCodlOFxd9wb7?=
 =?us-ascii?Q?dHHTjUe/6zDstFdPygQDfSI57nTxKNOP/hhPS60TD+BfKl2qsmt8qiqlVCK5?=
 =?us-ascii?Q?Ali7QBOIupGhANAGpVLZ49KLsCo6fdO6oYja8w9WotwmvqKDUsV12zq9vDqO?=
 =?us-ascii?Q?anz2ffyjFuF+0Nd/6YW2UkhfEh5UGYJAL2DFie/st5dZFrDI8eoHKWJmAMF3?=
 =?us-ascii?Q?Z+rZDmcIJ5K/FhqmAQNeogm645ywXdQacq48tPp7oPAYNhfixOZJUjvCXMti?=
 =?us-ascii?Q?GgEX+XzZwfDalfaTy3sfFP48V8yRHHZiy4fLUC0wRrL2vP/o0DaSCAIW3cLn?=
 =?us-ascii?Q?IdpEw/1/RYWDDmSrxgZlBEK9h3EpcE9WwRl1peqEQJc0AHdw1A8ZOmMAUIm4?=
 =?us-ascii?Q?8bz+5fkNvXoQfht0BBiWx8TUo/oKkQOVpSk9WogbhuzGc9vhSuh4GoGcf6X4?=
 =?us-ascii?Q?vhVNSdZ/i/dx98VJUPHqFrxwGCnoMVvjr9Txt6TDoULgEjeqOfs7fRYjez3X?=
 =?us-ascii?Q?02ss35H/AOvSyAILPSWOGiH06/hdC4DZfyLuFqAxMHp5ZMPmpr2Jy0AGhOr4?=
 =?us-ascii?Q?YATORTYtmCM9DaaEDuXJnoUDnDUx0CNHb5/cjTtM8ZDuF1WKb5vgB85qFajt?=
 =?us-ascii?Q?MqaF0B6+OFsS0i2gPTrW+/yoOQJJs5glTfuk4/4yOlzb7mvo6PDx6JBkmFlt?=
 =?us-ascii?Q?mXrHhlGtGlNZxGs/guDH86DUeHlOjXB4vzzsmGP0pPNy388lU9VvzZue9dhr?=
 =?us-ascii?Q?TwcTMxyg8aSVysQNWfAko9dZltSqZeWjAMlwYmBCru8dCeXykbxBAldJigEM?=
 =?us-ascii?Q?KvAKaJ0fiAg4ypF5skXOpy68nbfJLRBM5hf1heFTTZeT3YNo5BCy7c423hts?=
 =?us-ascii?Q?Z/iULdlkCFCUGtjbfVuvL5lE+8EsSEi/SfwFqHVnFfmPSEo=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H3CmJDOBbottESXH+f4WdinF0cBqtoKp/uW8KSDFye06++qHs9xlP4wXwjb4?=
 =?us-ascii?Q?DR/QSw3h390uS4CdYin636lC6jTjdf9jiowj3AT/3wT6VV/dVLQJpSdt93Dv?=
 =?us-ascii?Q?e7uT1Jy7G2qQFinYUJd8d/EtwqIY31Dg5zDmPlJRTdk5RtBGUXprUCt6vBQn?=
 =?us-ascii?Q?Znc6OEL8hgHbPN62xDN5IAvep2nY9eKWX36h3V8Q3Z4o2Ob80LV+lZgIiD94?=
 =?us-ascii?Q?KE2tGM7SNRGVh1+rvT2dUSzN7FKPWP1oftYUGzkTnafm7WCV2BMGv1BN95cV?=
 =?us-ascii?Q?rcyfFGEEJOaMx2DX/TblcnFlrS19bTHN/67vtbIablLtPQI9ODHGRMD//jw7?=
 =?us-ascii?Q?SDbOzNR9P0LZpEj5n5yyq5gxt8WTaElaHUnmQniKdby+2mGG9DTB/aMD3NtP?=
 =?us-ascii?Q?v7RpM//qOB4/ynKzMLEcTATT0aHY90gXKcLnJqNuFsi2zyHfQx80TS9uZk3+?=
 =?us-ascii?Q?FT6o16IqaTcsvh+q7VxA3HGm/Hf2EGE0kYs5cggMr5ZUgxXYyWd+G7rCAXAB?=
 =?us-ascii?Q?nDjyo/yyLRZAmPrzfQ0xlxhTs23orQo20nxEh8mUDiD1pfOYZPg2X8+PhCG0?=
 =?us-ascii?Q?Uvml3gK0fpIH66loRFSnw7yNwQ2s89XQFMAVgLeWDdYtwdkO4X8S8lawSWTN?=
 =?us-ascii?Q?ncdEDDUanKtzUyKOoSVIgC75nCQ/c9JdJ+4/Vj+A32EZpZHZ8Mt3KH4sJGUD?=
 =?us-ascii?Q?eHH6sYxk3JgbjgWpqRECGK6k7rpSpOCJRZp9jf7Af1sflfXyY6SjYv8GtCy1?=
 =?us-ascii?Q?c0j54BpgLRVJELjasOxJMsahW2VKR/WAzpTA7C9fhryEzRV1xR5p7mXfnftg?=
 =?us-ascii?Q?fBcXrF4kvDXxoF9Hg7ycrhRm4UNlH4FdaVPAEwtaPKJJJF50mwv4cvTzAbd6?=
 =?us-ascii?Q?/rAphlz8PV9QqqOn+/GN/IaLkV7fZ47waPt0jyqxCeRoLFVngjhWE8j5yjDP?=
 =?us-ascii?Q?3EUbtf2AuMAPFpI3Sh1cVWxU/021vPqsWh4B7XbxA8yENGitYSMdfrEpI0k3?=
 =?us-ascii?Q?tlV6o0JlsnWTb/LonuZZ3r986Qw899+hFk2q8WiSTX21b3vXbAZSzwBFMx96?=
 =?us-ascii?Q?aMEiLuI8/bZMRAD7yq3Lk5707hLKbL9SmVrFxXrp87ER8biU/18SnDOIh3sf?=
 =?us-ascii?Q?HGv22wqOa7URrC5rLfogi7ZMuso4DxB8aEbfaKzDrPxZA767UtG2qw2KBCFn?=
 =?us-ascii?Q?nFbrGnSGPwwICFXkJeiYQ0i2Qq7/n0RDKKuYfhckc0lVyO/nK3B2LudGLobo?=
 =?us-ascii?Q?8XaDAlFS3CY+WDlTl4OaI1ckCsg7yTezAvkW5IY+GfFMyz/BM/reOmBrjTgc?=
 =?us-ascii?Q?R+Ik7rfW2+2sMC0CJS8+7STxxDgGPKfwhKCulgqlGZyDBQW3sNx8t6+HXgNA?=
 =?us-ascii?Q?WKY+U1jX3P32K0SDxzCornIF58Vi?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-ecede.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fad5ccf0-3852-41f8-2ac7-08def46b283f
X-MS-Exchange-CrossTenant-AuthSource: OS6P279MB1180.NORP279.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 10:03:41.3695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SV0P279MB1103

Extracts a crafted image whose root directory contains a normal file and a
hostile "../escaped" hard link to it. The test confirms rdump skips the
unsafe name, does not create a file outside the destination, and still dumps
the legitimate file. Without the guard the test fails (the entry escapes the
destination directory).

The malicious name contains a '/', which a valid filesystem never has and
which mke2fs/debugfs will not create, so the image is built with a small
libext2fs helper; mkimage.sh in the test directory documents the recipe.

Signed-off-by: Nexory <St4yl3r30@hotmail.de>
---
 tests/d_rdump_safe/expect     |   6 ++++
 tests/d_rdump_safe/image.gz   | Bin 0 -> 922 bytes
 tests/d_rdump_safe/mkimage.sh |  55 ++++++++++++++++++++++++++++++++++
 tests/d_rdump_safe/name       |   1 +
 tests/d_rdump_safe/script     |  22 ++++++++++++++
 5 files changed, 84 insertions(+)
 create mode 100644 tests/d_rdump_safe/expect
 create mode 100644 tests/d_rdump_safe/image.gz
 create mode 100755 tests/d_rdump_safe/mkimage.sh
 create mode 100644 tests/d_rdump_safe/name
 create mode 100644 tests/d_rdump_safe/script

diff --git a/tests/d_rdump_safe/expect b/tests/d_rdump_safe/expect
new file mode 100644
index 0000000..fd8ed61
--- /dev/null
+++ b/tests/d_rdump_safe/expect
@@ -0,0 +1,6 @@
+debugfs rdump path-traversal guard
+debugfs -R ''rdump / DEST/out'' image
+rdump: skipping entry with unsafe name (inode NN)
+Exit status is 0
+escaped outside destination: no
+legitimate file dumped: yes
diff --git a/tests/d_rdump_safe/image.gz b/tests/d_rdump_safe/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..dd0e617255477017429477b603a=
409d382ac1f0a
GIT binary patch
literal 922
zcmb2|=3D3sdFwj_&*`R$$k*}{nu>>s|rdo;<7<)i!7e;s~JW>zBN(@Tm)SjsaWE2xIQ
z@Dyj4jfr{l;DtuVx~A^##s6D&a~xed+qp)6dR7p3Q^wOB=3Dhba?Rv(T%A^WrKx$2!(
z29wbJHD1mZqT=3D%>2~2xrH1pnq=3D+JtjKYL>D@F$w=3D`fDngAKt6I`}bL2w&|<3^F^*%
zo1Pyp9~<KrAG6c+{{GL;PX4#JwtV($Zfo<ry2|hW9)5nkeqZji`P+?)W9q}r?IyL=3D
z^!IfK=3D}x_wbJWV@-2Y1!>m7`H7QH!NUT?zm>h+29_Zb&N9=3Dh_UeEX~`|8w-ig%`y4
z+s~fK{de`x-174~GM~#cSX9WL`uF@+-CuvHXUn%)3%*WS^J(j+{fjPd6ib@hS!#A|
zXT)>$zh_#dzS`@{w-;30|7Sk)<$t|b{~3@#19Mp1<13t=3Dw|;M&w`^}*DgXZDg>%<E
zl|K5k`e*aQtkU&+{4!LtE90iTmfu`<>2<7Z&YC;1@@uT72bdREf7(Ae^e4O2qNgGa
wf0#e<pRiZ>kIJ~>SgCvdk(Zqg+u=3DoTOOUJ`We%$l_;aoNSlGgy3=3DA9$01}hoO8@`>

literal 0
HcmV?d00001

diff --git a/tests/d_rdump_safe/mkimage.sh b/tests/d_rdump_safe/mkimage.sh
new file mode 100755
index 0000000..817f052
--- /dev/null
+++ b/tests/d_rdump_safe/mkimage.sh
@@ -0,0 +1,55 @@
+#!/bin/sh
+#
+# This is the script that was used to create the image.gz in this director=
y.
+#
+# The image is a tiny ext2 filesystem whose root directory holds a normal =
file
+# "loot" and a second, hostile directory entry whose name is the literal s=
tring
+# "../escaped" (a hard link to loot's inode).  A valid filesystem never co=
ntains
+# a name with a '/' in it, and neither mke2fs nor debugfs will create one,=
 so the
+# hostile entry is planted with a small libext2fs helper: ext2fs_link() wr=
ites
+# the raw name without validating it.
+#
+# "debugfs -R 'rdump / <dest>'" used to copy that entry to <dest>/../escap=
ed,
+# i.e. outside <dest>.  See the d_rdump_safe test.
+#
+# Requires mke2fs, debugfs and the libext2fs headers (the e2fsprogs build =
tree,
+# or the e2fslibs-dev / libext2fs-dev package).  The UUID and timestamps a=
re not
+# pinned, so a re-run yields a functionally identical but not byte-identic=
al
+# image, the same way the f_* fsck test images do.
+
+set -e -u
+
+IMG=3Dimage
+
+# 1. A tiny ext2 filesystem: 1024-byte blocks, 512 blocks, 64 inodes.
+mke2fs -F -q -b 1024 -N 64 "$IMG" 512
+
+# 2. A normal file "loot" in the root directory.
+printf 'loot-content\n' > loot-content
+debugfs -w -R "write loot-content loot" "$IMG"
+rm -f loot-content
+
+# 3. Plant a hostile hard link named "../escaped" onto loot's inode.
+cat > plant.c <<'PLANT'
+#include <ext2fs/ext2fs.h>
+
+int main(int argc, char **argv)
+{
+	ext2_filsys fs;
+	ext2_ino_t ino;
+
+	if (ext2fs_open(argv[1], EXT2_FLAG_RW, 0, 0, unix_io_manager, &fs))
+		return 1;
+	if (ext2fs_namei(fs, EXT2_ROOT_INO, EXT2_ROOT_INO, "loot", &ino))
+		return 1;
+	if (ext2fs_link(fs, EXT2_ROOT_INO, "../escaped", ino, EXT2_FT_REG_FILE))
+		return 1;
+	return ext2fs_close(fs) ? 1 : 0;
+}
+PLANT
+cc -o plant plant.c -lext2fs -lcom_err
+./plant "$IMG"
+rm -f plant plant.c
+
+# 4. Compress; the result is committed as image.gz.
+gzip -9 -f "$IMG"
diff --git a/tests/d_rdump_safe/name b/tests/d_rdump_safe/name
new file mode 100644
index 0000000..00d7a7e
--- /dev/null
+++ b/tests/d_rdump_safe/name
@@ -0,0 +1 @@
+debugfs rdump path-traversal guard
diff --git a/tests/d_rdump_safe/script b/tests/d_rdump_safe/script
new file mode 100644
index 0000000..f06637d
--- /dev/null
+++ b/tests/d_rdump_safe/script
@@ -0,0 +1,22 @@
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+OUT=3D$test_name.log
+EXP=3D$test_dir/expect
+echo "debugfs rdump path-traversal guard" > $OUT.new
+gunzip < $test_dir/image.gz > $TMPFILE
+DEST=3D$test_name.d
+rm -rf $DEST; mkdir -p $DEST/out
+echo "debugfs -R ''rdump / DEST/out'' image" >> $OUT.new
+$DEBUGFS -R "rdump / `pwd`/$DEST/out" $TMPFILE >> $OUT.new 2>&1
+echo "Exit status is $?" >> $OUT.new
+if test -e $DEST/escaped ; then echo "escaped outside destination: yes (VU=
LNERABLE)" >> $OUT.new ; else echo "escaped outside destination: no" >> $OU=
T.new ; fi
+if test -e $DEST/out/loot ; then echo "legitimate file dumped: yes" >> $OU=
T.new ; else echo "legitimate file dumped: no" >> $OUT.new ; fi
+sed -f $cmd_dir/filter.sed $OUT.new | sed -e "s;`pwd`/;;g" -e "s/inode [0-=
9]*/inode NN/" > $OUT
+rm -rf $DEST $TMPFILE $OUT.new
+cmp -s $OUT $EXP
+status=3D$?
+if [ "$status" =3D 0 ] ; then echo "$test_name: $test_description: ok"; to=
uch $test_name.ok
+else echo "$test_name: $test_description: failed"; diff $DIFF_OPTS $EXP $O=
UT > $test_name.failed; fi
+unset OUT EXP DEST
--=20
2.53.0

