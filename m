From: David Jeffery <dhjeffery@gmail.com>
Subject: [PATCH] ext4: fix extra time handling for >32bit timestamps
Date: Mon, 1 Aug 2011 13:37:28 -0400
Message-ID: <CANghDUV1xUMkcTcKUs9eu6PuwaG-WRtMVFM9vosPWaHV-Fo68A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c1a6cce47b804a9751570
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54856 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1HARha (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Aug 2011 13:37:30 -0400
Received: by wwe5 with SMTP id 5so5885367wwe.1
        for <linux-ext4@vger.kernel.org>; Mon, 01 Aug 2011 10:37:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e64c1a6cce47b804a9751570
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 64bit systems, using ext4 to store inode times for after the 32bit
time rollover doesn't work as expected. =A0Setting a date with a time
too big for 32bits can still result in time wrapping around when read
back from disk. =A0This is do to the sign extension performed in
EXT4_INODE_GET_XTIME().  The sign extension causes any time with
the 32nd bit set to be sign extended and have a time before 1970.

For the case where there isn't any extra time storage area, this patch
leaves the sign extension as is. =A0In the event there is the >32 bit
time bits in the inode, the ext4_decode_extra_time() is patched to
clear the upper 32 time bits, set the extra time bits, and perform a
sign extension if needed.

The patch also alters ext4_encode_extra_time() for 32bit systems.
Previously, the extra time bits were never set on 32bit system. =A0The
patch now sets them so that times will remain the same when migrating
an ext4 filesystem from a 32bit system to a 64bit system.

Signed-off-by: David Jeffery <dhjeffery@gmail.com>
---
diffstat ext4_extra_time_fix.patch
ext4.h | =A0 13 ++++++++++---
1 file changed, 10 insertions(+), 3 deletions(-)

--0016e64c1a6cce47b804a9751570
Content-Type: application/octet-stream; name="ext4_extra_time_fix.patch"
Content-Disposition: attachment; filename="ext4_extra_time_fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqtpyfa30

ZGlmZiAtLWdpdCBhL2ZzL2V4dDQvZXh0NC5oIGIvZnMvZXh0NC9leHQ0LmgKaW5kZXggZmE0NGRm
OC4uMTFlMmJjZSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9leHQ0LmgKKysrIGIvZnMvZXh0NC9leHQ0
LmgKQEAgLTY2NCwxNiArNjY0LDIzIEBAIHN0cnVjdCBtb3ZlX2V4dGVudCB7CiAKIHN0YXRpYyBp
bmxpbmUgX19sZTMyIGV4dDRfZW5jb2RlX2V4dHJhX3RpbWUoc3RydWN0IHRpbWVzcGVjICp0aW1l
KQogewotICAgICAgIHJldHVybiBjcHVfdG9fbGUzMigoc2l6ZW9mKHRpbWUtPnR2X3NlYykgPiA0
ID8KLQkJCSAgICh0aW1lLT50dl9zZWMgPj4gMzIpICYgRVhUNF9FUE9DSF9NQVNLIDogMCkgfAor
ICAgICAgIGlmKHNpemVvZih0aW1lLT50dl9zZWMpID4gNCkKKwkgICAgICAgcmV0dXJuIGNwdV90
b19sZTMyKCgodGltZS0+dHZfc2VjID4+IDMyKSAmIEVYVDRfRVBPQ0hfTUFTSykgfAorICAgICAg
ICAgICAgICAgICAgICAgICAgICAoKHRpbWUtPnR2X25zZWMgPDwgRVhUNF9FUE9DSF9CSVRTKSAm
IEVYVDRfTlNFQ19NQVNLKSk7CisgICAgICAgZWxzZQorICAgICAgICAgICAgICAgcmV0dXJuIGNw
dV90b19sZTMyKCh0aW1lLT50dl9zZWMgPCAwID8gRVhUNF9FUE9DSF9NQVNLIDogMCkgfCAKICAg
ICAgICAgICAgICAgICAgICAgICAgICAgKCh0aW1lLT50dl9uc2VjIDw8IEVYVDRfRVBPQ0hfQklU
UykgJiBFWFQ0X05TRUNfTUFTSykpOwogfQogCiBzdGF0aWMgaW5saW5lIHZvaWQgZXh0NF9kZWNv
ZGVfZXh0cmFfdGltZShzdHJ1Y3QgdGltZXNwZWMgKnRpbWUsIF9fbGUzMiBleHRyYSkKIHsKLSAg
ICAgICBpZiAoc2l6ZW9mKHRpbWUtPnR2X3NlYykgPiA0KQorICAgICAgIGlmIChzaXplb2YodGlt
ZS0+dHZfc2VjKSA+IDQpeworCSAgICAgICB0aW1lLT50dl9zZWMgJj0weGZmZmZmZmZmOwogCSAg
ICAgICB0aW1lLT50dl9zZWMgfD0gKF9fdTY0KShsZTMyX3RvX2NwdShleHRyYSkgJiBFWFQ0X0VQ
T0NIX01BU0spCiAJCQkgICAgICAgPDwgMzI7CisJICAgICAgIGlmKHRpbWUtPnR2X3NlYyAmICgx
VUxMIDw8IChFWFQ0X0VQT0NIX0JJVFMgKyAzMSkpKQorCQkgICAgICB0aW1lLT50dl9zZWMgfD0g
KF9fdTY0KX5FWFQ0X0VQT0NIX01BU0sgPDwgMzI7CisgICAgICAgfQogICAgICAgIHRpbWUtPnR2
X25zZWMgPSAobGUzMl90b19jcHUoZXh0cmEpICYgRVhUNF9OU0VDX01BU0spID4+IEVYVDRfRVBP
Q0hfQklUUzsKIH0KIAo=
--0016e64c1a6cce47b804a9751570--
