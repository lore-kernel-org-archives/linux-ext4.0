From: Eric <erpo41@gmail.com>
Subject: files mapped funny? (related to online defragmentation)
Date: Mon, 21 May 2007 06:49:58 -0700
Message-ID: <1179755398.389.24.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-r1LvZIMaRi6l3uLJvANI"
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:2433 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589AbXEUNuH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 May 2007 09:50:07 -0400
Received: by wx-out-0506.google.com with SMTP id i26so289332wxd
        for <linux-ext4@vger.kernel.org>; Mon, 21 May 2007 06:50:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-r1LvZIMaRi6l3uLJvANI
Content-Type: multipart/mixed; boundary="=-9ZjQUMwxcCMSK57msf6C"


--=-9ZjQUMwxcCMSK57msf6C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm getting strange results when I map out the blocks used in files
larger than a several thousand KB. I never seem to get any more than
1024 contiguous data blocks in a row.=20

Here's a portion of the output of my script when I run it on a 176MB
file in my home directory:
...
Contiguous chunk 67: 2385568 - 2385591  (24 blocks)
Contiguous chunk 68: 2385608 - 2386448  (841 blocks)
Contiguous chunk 69: 2386450 - 2387473  (1024 blocks)
Contiguous chunk 70: 2387475 - 2388498  (1024 blocks)
Contiguous chunk 71: 2388500 - 2389523  (1024 blocks)
...

Maybe this is a bug in my script? Can anyone explain why this would
happen?

I'm attaching my script in case other ext2/3/4 newbies can get any use
out of it, and in case anyone needs to see it in order to answer my
question. It's pretty self-explanatory, though.

Cheers,

Eric


--=-9ZjQUMwxcCMSK57msf6C
Content-Disposition: attachment; filename=fibmap.py
Content-Transfer-Encoding: base64
Content-Type: text/x-python; name=fibmap.py; charset=UTF-8

IyEvdXNyL2Jpbi9weXRob24NCg0KIyBFcmljJ3MgZmlyc3QgcHl0aG9uIHByb2dyYW0gOikNCg0K
aW1wb3J0IHN5cyAjZm9yIHN5cy5hcmd2DQppbXBvcnQgZmNudGwgI2ZvciBmY250bC5pb2N0bA0K
aW1wb3J0IG9zICNmb3Igb3MuYWNjZXNzDQppbXBvcnQgc3RydWN0ICMgZm9yIHN0cnVjdC5wYWNr
IGFuZCBzdHJ1Y3QudW5wYWNrDQoNCnByaW50ICJXQVJOSU5HOiBUaGlzIHNjcmlwdCBtYXkgbm90
IHdvcmsgZm9yIGZpbGVzIHdpdGggaG9sZXMuIg0KDQppZiBsZW4oc3lzLmFyZ3YpICE9IDI6DQoJ
cHJpbnQgIlVzYWdlOiAiICsgc3lzLmFyZ3ZbMF0gKyAiIDxmaWxlbmFtZT4iDQoJcHJpbnQgIk5v
dGU6IFRoaXMgcHJvZ3JhbSB1c2VzIHRoZSBGSUJNQVAgaW9jdGwsIHNvIHlvdSBtdXN0IGJlIHJv
b3QuIg0KCXN5cy5leGl0KDEpDQoNCmlmIG9zLmFjY2VzcyhzeXMuYXJndlsxXSwgb3MuRl9PSykg
PT0gRmFsc2U6DQoJcHJpbnQgIkZpbGUgIiArIHN5cy5hcmd2WzFdICsgIiBkb2Vzbid0IGV4aXN0
LiINCglzeXMuZXhpdCgxKQ0KDQpmID0gb3BlbihzeXMuYXJndlsxXSwncicpDQoNCmZzQmxvY2tT
aXplID0gc3RydWN0LnVucGFjaygnaScsZmNudGwuaW9jdGwoZiwyLCcgICAgJykpWzBdDQpudW1G
aWxlQmxvY2tzID0gb3Muc3RhdChzeXMuYXJndlsxXSlbNl0gLyBmc0Jsb2NrU2l6ZQ0KaWYgKG9z
LnN0YXQoc3lzLmFyZ3ZbMV0pWzZdICUgZnNCbG9ja1NpemUpICE9IDA6DQoJbnVtRmlsZUJsb2Nr
cyArPSAxDQoNCmJsb2NrSXRlcmF0b3IgPSAwDQpibG9ja21hcCA9IFtdDQpmb3IgYmxvY2tJdGVy
YXRvciBpbiByYW5nZShudW1GaWxlQmxvY2tzKToNCgloPXN0cnVjdC5wYWNrKCdpJyxibG9ja0l0
ZXJhdG9yKQ0KCWJsb2NrbWFwICs9IHN0cnVjdC51bnBhY2soJ2knLGZjbnRsLmlvY3RsKGYsMSxo
KSkNCg0KcHJpbnQgIkZpbGVzeXN0ZW0gYmxvY2sgc2l6ZTogIiArIHN0cihmc0Jsb2NrU2l6ZSkN
CnByaW50ICJOdW1iZXIgb2YgZmlsZXN5c3RlbSBibG9ja3MgaW4gZmlsZTogIiArIHN0cihudW1G
aWxlQmxvY2tzKQ0KDQpleHRlbnRCZWdpbiA9IFtdDQpleHRlbnRFbmQgPSBbXQ0KZXh0ZW50QmVn
aW4gKz0gW2Jsb2NrbWFwWzBdXQ0KZm9yIGJsb2NrSXRlcmF0b3IgaW4gcmFuZ2UoMSxsZW4oYmxv
Y2ttYXApKToNCglpZiBibG9ja21hcFtibG9ja0l0ZXJhdG9yXS1ibG9ja21hcFtibG9ja0l0ZXJh
dG9yLTFdID09IDE6DQoJCWJsb2NrSXRlcmF0b3IgKz0gMQ0KCQljb250aW51ZQ0KCWVsc2U6DQoJ
CWV4dGVudEVuZCArPSBbYmxvY2ttYXBbYmxvY2tJdGVyYXRvci0xXV0NCgkJZXh0ZW50QmVnaW4g
Kz0gW2Jsb2NrbWFwW2Jsb2NrSXRlcmF0b3JdXQ0KCQlibG9ja0l0ZXJhdG9yICs9IDENCmV4dGVu
dEVuZCArPSBbYmxvY2ttYXBbYmxvY2tJdGVyYXRvci0xXV0NCg0KZm9yIG4gaW4gcmFuZ2UoMCxs
ZW4oZXh0ZW50QmVnaW4pKToNCglwcmludCAiQ29udGlndW91cyBjaHVuayAiICsgc3RyKG4pICsg
IjogIiArIHN0cihleHRlbnRCZWdpbltuXSkgKyAiIC0gIiArIHN0cihleHRlbnRFbmRbbl0pICsg
IiAgKCIgKyBzdHIoZXh0ZW50RW5kW25dIC0gZXh0ZW50QmVnaW5bbl0rMSkgKyAiIGJsb2Nrcyki
DQpzeXMuZXhpdCgwKQ0K


--=-9ZjQUMwxcCMSK57msf6C--

--=-r1LvZIMaRi6l3uLJvANI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGUaOGe2L37HVup3ARAphwAKDawpUOzw16yW4Bv+lYPqOQcDKApgCg2HD+
cecO9gQQwRNoofva+j/mZMI=
=SdJc
-----END PGP SIGNATURE-----

--=-r1LvZIMaRi6l3uLJvANI--
