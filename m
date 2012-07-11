From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Some warnings
Date: Wed, 11 Jul 2012 12:56:11 +0300
Message-ID: <1342000571.2963.145.camel@sauron>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QBh5tWE9LjprgzkDxwnd"
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28313 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2GKJv4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 05:51:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-QBh5tWE9LjprgzkDxwnd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ted,

just out of curiosity I've checked the patches you have in the 'dev'
branch with aiaiai - it did not fine anything very bad (but sometimes it
does!), but detected that few warnings.

---------------------------------------------------------------------------=
-----

Successfully built configuration "x86_64_defconfig,x86_64,", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+fs/ext4/ext4.h:1670:47: error: bad constant expression [sparse]
+fs/ext4/ext4.h:1670:47: error: bad constant expression [sparse]
@@ @@
+fs/ext4/resize.c: In function =E2=80=98ext4_update_super=E2=80=99:
+fs/ext4/resize.c:1200:9: warning: unused variable =E2=80=98ret=E2=80=99 [-=
Wunused-variable]
@@ @@
+fs/ext4/super.c: In function =E2=80=98ext4_statfs=E2=80=99:
+fs/ext4/super.c:4779:15: warning: variable =E2=80=98overhead=E2=80=99 set =
but not used [-Wunused-but-set-variable]

---------------------------------------------------------------------------=
-----

The first one is sparse complaining about using dynamic array as a local
variable which has a potential to blow the stack, generally speaking.

The other ones are just gcc warnings.

In short, aiaia is a script which builds the kernel before patching (and
uses sparse/smatch/coccinelle/cppplus while building) and after patching
and compares to build logs in a smart way, and then tells you about new
warnings/complaints from gcc/sparse/smatch/coccinelle. It also checks
bisectability and reports about failures. I find it very useful for
verifying incoming patches.

--=20
Best Regards,
Artem Bityutskiy

--=-QBh5tWE9LjprgzkDxwnd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/U27AAoJECmIfjd9wqK0RQMQAJMr0/IErtxe4ZexRfFOSRft
0U5G4Qiw3NFb/cMjvoBjdWv/4K6HEV69Omwhs7vx+YfLjfWfo576WO5keIRzCGz5
dNWIudQwE0B/wxY7a7WYF+pqUSHEBYPOtpfKAWFLQD/laJwISpX9Xqz7efpEhRHU
KlpjpkkQB9kr8lgY1SmNvjqslppWAIb9XF7/GATvIbGoFZPrBvPsSnUCfA2JK3Dp
VoQTUodhUI6nU8QLyurNxejo6A1SKCPwVuBDtOzcj3KpBawWFxmUmSNRkPEOAm1c
+U+G296lGkulUoxqBJHR3Ky9d8C4N9NhdEkRuxhEqmms4+xUErTUJiJoGoZlro+r
S2l57HLfjOEbGTzzuKCLsqiKS/jGQh9B6a6BkdTPnE99zOv/LrpypMt1CiVPKE3d
Y39XneNOjq123tChQE5QurAGMUKHm6Mqq+pm84jDF0CHBEylY6DCGdl/z3pXt7fr
pvhiN8TVS2Xi7aVPKvuAGlL7QMkpLJJr4lcF9LbJGPaLUBN5rWcDUedNZvjCR57b
jPmmtQpghFVGaUA6Zy42zhU1TMZUYsOblW/cNtPIesNUXYFa5aswz7G3bNCEk3dP
NvAp2sb9ZVYWKXPTHUqmeuuWgRsUV4dhLseLqdTXmhGkTZ7/cMs6cCHuQ2vIBqNo
kqlzKiNZtRr/Gvoo09kz
=wzZU
-----END PGP SIGNATURE-----

--=-QBh5tWE9LjprgzkDxwnd--

