From: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode)
Date: Mon, 8 Mar 2010 08:53:42 +0100
Message-ID: <201003080853.42978.borntraeger@de.ibm.com>
References: <201003072132.10579.borntraeger@de.ibm.com> <4B94367E.9080506@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57658 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0CHHxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Mar 2010 02:53:46 -0500
In-Reply-To: <4B94367E.9080506@garzik.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Montag 08 M=E4rz 2010 00:27:58 schrieb Jeff Garzik:
> I'm curious, what is the overall deployment status of ext4 defragging=
?=20
> I actually worked on this problem years ago[1], and am hopeful that I=
=20
> will see defragging in a Linux distribution sometime in my lifetime! =
 ;-)

I had to make the following patch. (There was the same patch already on=
 the
e2fsprogs mailing list, but I cannot find that at the moment. Would be =
good
if this patch can make it into the next version).

--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1605,7 +1605,7 @@ static int file_defrag(const char *file, const st=
ruct stat64 *buf,
                return 0;
        }

-       fd =3D open64(file, O_RDONLY);
+       fd =3D open64(file, O_RDWR);
        if (fd < 0) {
                if (mode_flag & DETAIL) {
                        PRINT_FILE_NAME(file);


I did use it on two machines and it does not seem to break anything.=20
Some bigger things are missing in the e4defrag tool:
- make the indirect to extend change for old files - e.g. converted ext=
3
  file systems. Adding the MIGRATE ioctl does not look very hard, but w=
ho knows?
- defragging directories (and also remove deleted entries)
- free space optimization is only done as a side effect
- overall layout considerations (e.g. putting files close to its direct=
ory or
  use the atime to move often used files to the beginning of a disk etc=
=2E)
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
