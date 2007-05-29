From: Krzysztof Lichota <krzysiek@lichota.net>
Subject: ext3 and prefetching
Date: Tue, 29 May 2007 10:42:23 +0200
Message-ID: <465BE76F.6040106@lichota.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E61F0BFBC0A5E6FA72A4EE5"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 23-moo-10.acn.waw.pl ([62.121.101.23]:61590 "EHLO lichota.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761533AbXE2JFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 May 2007 05:05:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E61F0BFBC0A5E6FA72A4EE5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello everyone.
Let me introduce myself to the list :)
My name is Krzysztof Lichota, I am at the first year of PhD studies at
the Warsaw University.
This summer I will be working on "Automatic boot and application start
file prefetching" project as part of Google Summer of Code.
Part of this project is implementing offline defragmenter tool for ext3
which will lay out files on disk in a way to minimize disk seeks during
application and system start.

Two prototypes were considered for this purpose and we chose to use
ext3remapper tool created by Jan Kara. I will be starting the
implementation based on this code soon.

The design summary is put on
http://code.google.com/p/prefetch/wiki/Ext3LayoutToolDesign page and
discussed on our mailing list (mainly this thread:
http://groups.google.com/group/prefetch-devel/browse_thread/thread/2d800d=
f1ceaab5ae/e0bbb68fe61b3725#e0bbb68fe61b3725).
Currently the tool is able to relocate file data and indirect blocks,
relocating inodes is planned.
The code is available from project SVN repository:
http://prefetch.googlecode.com/svn/trunk/ext3remapper/

If you are interested in prefetching issues or have comments about ext3
tool implementation or design, you are welcome to join our project -
main project page is http://code.google.com/p/prefetch/, there is a
mailing list (http://groups.google.com/group/prefetch-devel), you can
subscribe by sending e-mail to prefetch-devel-subscribe@googlegroups.com
or you can browse archives online.

I would be grateful for reviewing the tool code for potential problems
when working on ext3 structures, your expertise will be really
appreciated :)

	Krzysztof Lichota





--------------enig4E61F0BFBC0A5E6FA72A4EE5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGW+d2SHJB/1EhaUwRAjgeAJ9yRGbd26sCKnRwjc+3OkfWG3gWFQCcCzoL
MqldXYMPk0y/dxUkJcKTRkQ=
=+c2W
-----END PGP SIGNATURE-----

--------------enig4E61F0BFBC0A5E6FA72A4EE5--
