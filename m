From: Benno Schulenberg <bensberg@justemail.net>
Subject: [patch] gettextize an overlooked mke2fs error message
Date: Sun, 01 Jun 2014 23:25:20 +0200
Message-ID: <1401657920.32083.123944857.33711BB8@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_----------=_1401657920320833";
 charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59173 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbaFAVZU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2014 17:25:20 -0400
Received: from compute4.internal (compute4.nyi.mail.srv.osa [10.202.2.44])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 7A6572107C
	for <linux-ext4@vger.kernel.org>; Sun,  1 Jun 2014 17:25:20 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--_----------=_1401657920320833
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="ISO-8859-1"


Although, maybe it needs the =AB "%s", _("...") =BB construction to
avoid problems with other compilers.

--=20
http://www.fastmail.fm - Or how I learned to stop worrying and
                          love email again


--_----------=_1401657920320833
Content-Disposition: attachment; filename="0013-mke2fs-gettextize-an-overlooked-error-message.patch"
Content-Id: <1401657912.32071.4dee6e65a51b9e7e9f18b4dbe89b1ff4e2bfe6a0.1ACA3CE6@content.messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-diff; name="0013-mke2fs-gettextize-an-overlooked-error-message.patch"

RnJvbSBiNWNiNjBiZDU1Mjg2NWFjNzkyMGM3ZmJhMTMwZmM1ZGM1NjViZGQ5
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCZW5ubyBTY2h1bGVu
YmVyZyA8YmVuc2JlcmdAanVzdGVtYWlsLm5ldD4KRGF0ZTogU3VuLCAxIEp1
biAyMDE0IDIyOjI0OjA5ICswMjAwClN1YmplY3Q6IFtQQVRDSCAxMy8xNF0g
bWtlMmZzOiBnZXR0ZXh0aXplIGFuIG92ZXJsb29rZWQgZXJyb3IgbWVzc2Fn
ZQoKU2lnbmVkLW9mZi1ieTogQmVubm8gU2NodWxlbmJlcmcgPGJlbnNiZXJn
QGp1c3RlbWFpbC5uZXQ+Ci0tLQogbWlzYy9ta2UyZnMuYyB8ICAgIDIgKy0K
IDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL21pc2MvbWtlMmZzLmMgYi9taXNjL21rZTJm
cy5jCmluZGV4IDU1YmJlOWUuLmI0NTFjYzMgMTAwNjQ0Ci0tLSBhL21pc2Mv
bWtlMmZzLmMKKysrIGIvbWlzYy9ta2UyZnMuYwpAQCAtMzQxLDcgKzM0MSw3
IEBAIHN0YXRpYyB2b2lkIHdyaXRlX3Jlc2VydmVkX2lub2RlcyhleHQyX2Zp
bHN5cyBmcykKIAogCXJldHZhbCA9IGV4dDJmc19nZXRfbWVtemVybyhFWFQy
X0lOT0RFX1NJWkUoZnMtPnN1cGVyKSwgJmlub2RlKTsKIAlpZiAocmV0dmFs
KSB7Ci0JCWNvbV9lcnIoImlub2RlX2luaXQiLCByZXR2YWwsICJ3aGlsZSBh
bGxvY2F0aW5nIG1lbW9yeSIpOworCQljb21fZXJyKCJpbm9kZV9pbml0Iiwg
cmV0dmFsLCBfKCJ3aGlsZSBhbGxvY2F0aW5nIG1lbW9yeSIpKTsKIAkJZXhp
dCgxKTsKIAl9CiAKLS0gCjEuNy4wLjQKCg==

--_----------=_1401657920320833--

