From: TR Reardon <thomas_reardon@hotmail.com>
Subject: dumpe2fs: only print 'unused inodes' once
Date: Tue, 9 Sep 2014 15:32:56 -0400
Message-ID: <BAY179-W101B94761503C2D6FBA0CBFDCE0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc1s4.hotmail.com ([65.54.190.15]:63879 "EHLO
	BAY004-OMC1S4.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaIITc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2014 15:32:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

just a minor nit...and I don't think fixing this harms any existing tes=
ts.

+Reardon


diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index a1c5ba2..d30cf87 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -205,8 +205,6 @@ static void list_desc (ext2_filsys fs)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(" =A0Checksum =
0x%04x"), csum);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (csum !=3D exp_csum)
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(=
_(" (EXPECTED 0x%04x)"), exp_csum);
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printf(_(", unused inodes=
 %u\n"),
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_bg_=
itable_unused(fs, i));
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 has_super =3D ((i=3D=3D0) || super_blk)=
;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (has_super) {


 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
