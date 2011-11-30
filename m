From: Michael Tokarev <mjt@tls.msk.ru>
Subject: what happened with dccaf33fa37 "ext4: flush any pending end_io requests
 before DIO" for 3.0?
Date: Thu, 01 Dec 2011 00:38:07 +0400
Message-ID: <4ED6942F.7070006@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBEA045EE1588DA5E4CC6B678"
Cc: linux-ext4@vger.kernel.org
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:35134 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1K3UiO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Nov 2011 15:38:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBEA045EE1588DA5E4CC6B678
Content-Type: multipart/mixed;
 boundary="------------010800080901080905040500"

This is a multi-part message in MIME format.
--------------010800080901080905040500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello.

Back in August 2011, a commit has been tagged to be included
into stable, this one:

commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Fri Aug 19 19:13:32 2011 -0400

    ext4: flush any pending end_io requests before DIO reads w/dioread_no=
lock

    There is a race between ext4 buffer write and direct_IO read with
    dioread_nolock mount option enabled. The problem is that we clear
    PageWriteback flag during end_io time but will do
    uninitialized-to-initialized extent conversion later with dioread_nol=
ock.
    If an O_direct read request comes in during this period, ext4 will re=
turn
    zero instead of the recently written data.

    This patch checks whether there are any pending uninitialized-to-init=
ialized
    extent conversion requests before doing O_direct read to close the ra=
ce.
    Note that this is just a bandaid fix. The fundamental issue is that w=
e
    clear PageWriteback flag before we really complete an IO, which is
    problem-prone. To fix the fundamental issue, we may need to implement=
 an
    extent tree cache that we can use to look up pending to-be-converted =
extents.

    Signed-off-by: Jiaying Zhang <jiayingz@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@kernel.org


There was one more ext4 commit at that time, which made its way into
stable but this one did not.

I wonder if the reason for that was the fact that it needed a small
"backport" for 3.0, since in 3.1+ the code has been moved into another
file, and the context is slightly different.  In that case, attached
is the "backport" which we use with 3.0.x since that time.

Thanks!

/mjt

--------------010800080901080905040500
Content-Type: text/x-diff;
 name="ext4-flush-any-pending-end_io-requests-before-DIO-reads-w-dioread_nolock-dccaf33fa3.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="ext4-flush-any-pending-end_io-requests-before-DIO-reads-w-di";
 filename*1="oread_nolock-dccaf33fa3.diff"

(backported to 3.0 by mjt)

commit dccaf33fa37a1bc5d651baeb3bfeb6becb86597b
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Fri Aug 19 19:13:32 2011 -0400

    ext4: flush any pending end_io requests before DIO reads w/dioread_no=
lock
   =20
    There is a race between ext4 buffer write and direct_IO read with
    dioread_nolock mount option enabled. The problem is that we clear
    PageWriteback flag during end_io time but will do
    uninitialized-to-initialized extent conversion later with dioread_nol=
ock.
    If an O_direct read request comes in during this period, ext4 will re=
turn
    zero instead of the recently written data.
   =20
    This patch checks whether there are any pending uninitialized-to-init=
ialized
    extent conversion requests before doing O_direct read to close the ra=
ce.
    Note that this is just a bandaid fix. The fundamental issue is that w=
e
    clear PageWriteback flag before we really complete an IO, which is
    problem-prone. To fix the fundamental issue, we may need to implement=
 an
    extent tree cache that we can use to look up pending to-be-converted =
extents.
   =20
    Signed-off-by: Jiaying Zhang <jiayingz@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
    Cc: stable@kernel.org

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index b8602cd..0962642 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3507,12 +3507,17 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *=
iocb,
 	}
=20
 retry:
-	if (rw =3D=3D READ && ext4_should_dioread_nolock(inode))
+	if (rw =3D=3D READ && ext4_should_dioread_nolock(inode)) {
+		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
+			mutex_lock(&inode->i_mutex);
+			ext4_flush_completed_IO(inode);
+			mutex_unlock(&inode->i_mutex);
+		}
 		ret =3D __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
 				 ext4_get_block, NULL, NULL, 0);
-	else {
+	} else {
 		ret =3D blockdev_direct_IO(rw, iocb, inode,
				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
=20

--------------010800080901080905040500--

--------------enigBEA045EE1588DA5E4CC6B678
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAk7WlDQACgkQUlPFrXTwyDiMMQQAj/6MV9F3cQW48yQMTYJp+j92
bwfEqMqS0y3SCE7MGqoVwn8+7wQAFqpFwGoGcKssAxpqm4tEzGNWC6KYHNKnwJal
ar+ZHCxtjMm4/ZVL0ABU23YIpEWyOXZUDGQWV5zDCLyl8UQYxDW9sj6LAjzOXedt
FKYnJUA7D5P3CR8nFqg=
=rpBy
-----END PGP SIGNATURE-----

--------------enigBEA045EE1588DA5E4CC6B678--
