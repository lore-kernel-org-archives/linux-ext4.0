From: Curt Wohlgemuth <curtw@google.com>
Subject: Re: [PATCH] ext4: Ensure zeroout blocks have no dirty metadata
Date: Tue, 15 Dec 2009 14:33:29 -0800
Message-ID: <6601abe90912151433o481cd9cp24b94f8162ae27c4@mail.gmail.com>
References: <6601abe90912100928v747671dat489aeee5dabf2c03@mail.gmail.com>
	 <8352E6B3-4561-40D7-AEC0-A4119A685F46@sun.com>
	 <6601abe90912111401t2749bc1en3d8e5b8f81787897@mail.gmail.com>
	 <71F621CE-B943-4ACC-90E9-6D03A8D2C3A6@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 216-239-44-51.google.com ([216.239.44.51]:62504 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZLOWde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2009 17:33:34 -0500
Received: from kpbe12.cbf.corp.google.com (kpbe12.cbf.corp.google.com [172.25.105.76])
	by smtp-out.google.com with ESMTP id nBFMXWWC018045
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 14:33:33 -0800
Received: from yxe8 (yxe8.prod.google.com [10.190.2.8])
	by kpbe12.cbf.corp.google.com with ESMTP id nBFMXV4A024986
	for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 14:33:32 -0800
Received: by yxe8 with SMTP id 8so418146yxe.17
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2009 14:33:31 -0800 (PST)
In-Reply-To: <71F621CE-B943-4ACC-90E9-6D03A8D2C3A6@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 11, 2009 at 3:27 PM, Andreas Dilger <adilger@sun.com> wrote=
:
> On 2009-12-11, at 15:01, Curt Wohlgemuth wrote:

>>
>> Good point, Andreas. =A0I changed this to send in the handle to
>> ext4_ext_zeroout().

> I was just thinking of checking EXT4_SB(inode->i_sb)->s_journal =3D=3D=
 NULL. =A0I
> also thought about checking EXT4_HAS_INCOMPAT_FEATURE(sb, NEEDS_RECOV=
ERY),
> but I don't know if that is 100% safe (i.e. is it possible to mount s=
uch a
> filesystem with "norecovery"?).

Arggh.  There are too many ways to check the journal use/mode...  This
patch is considerably simpler.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

This fixes a bug with no journal being used, in which new blocks return=
ed
from an extent created with ext4_ext_zeroout() can have dirty metadata =
still
associated with them.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

This is for the problem I reported on 23 Nov ("Bug in extent zeroout: b=
locks
not marked as new").  I'm not seeing the corruption with this fix that =
I was
seeing without it.

diff -uprN orig/fs/ext4/extents.c new/fs/ext4/extents.c
--- orig/fs/ext4/extents.c	2009-12-09 15:09:25.000000000 -0800
+++ new/fs/ext4/extents.c	2009-12-15 13:26:29.000000000 -0800
@@ -2474,9 +2474,28 @@ static int ext4_ext_zeroout(struct inode
 		submit_bio(WRITE, bio);
 		wait_for_completion(&event);

-		if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+		if (test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+
 			ret =3D 0;
-		else {
+
+			/* On success, if there is no journal through which
+			 * metadata is committed, we need to insure all
+			 * metadata associated with each of these blocks is
+			 * unmapped. */
+			if (EXT4_SB(inode->i_sb)->s_journal =3D=3D NULL) {
+				sector_t block =3D ee_pblock;
+
+				done =3D 0;
+				while (done < len) {
+					unmap_underlying_metadata(inode->i_sb->
+									s_bdev,
+								  block);
+
+					done++;
+					block++;
+				}
+			}
+		} else {
 			ret =3D -EIO;
 			break;
 		}
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
