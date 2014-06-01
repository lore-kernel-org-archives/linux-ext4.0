From: Benno Schulenberg <bensberg@justemail.net>
Subject: [patch] fix typo in mke2fs error message
Date: Sun, 01 Jun 2014 23:22:58 +0200
Message-ID: <1401657778.31770.123943377.423CAE78@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_----------=_1401657778317703";
 charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53836 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaFAVW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2014 17:22:59 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 1AABD20939
	for <linux-ext4@vger.kernel.org>; Sun,  1 Jun 2014 17:22:59 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--_----------=_1401657778317703
Content-Transfer-Encoding: 7bit
Content-Type: text/plain


Hi,

Attached is a tiny patch to fix a minimal typo in a mke2fs message.

Three more small patches will follow, to see if they make it into
git.  If so, there will be more.

Regards,

Benno

-- 
http://www.fastmail.fm - mmm... Fastmail...


--_----------=_1401657778317703
Content-Disposition: attachment; filename="0009-mke2fs-fix-a-typo-in-an-error-message.patch"
Content-Id: <1401657746.31825.a418b34edf80ae7306bda5317ad578fde38265f7.2BE8541F@content.messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-diff; name="0009-mke2fs-fix-a-typo-in-an-error-message.patch"

RnJvbSA1ZTczOTg2OTAyYjMwNGVkMzFlMDM3NjE5NDdjY2E2YzlhMjc2MThk
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCZW5ubyBTY2h1bGVu
YmVyZyA8YmVuc2JlcmdAanVzdGVtYWlsLm5ldD4KRGF0ZTogU3VuLCAxIEp1
biAyMDE0IDE3OjI1OjM2ICswMjAwClN1YmplY3Q6IFtQQVRDSCAwOS8xNF0g
bWtlMmZzOiBmaXggYSB0eXBvIGluIGFuIGVycm9yIG1lc3NhZ2UKClNpZ25l
ZC1vZmYtYnk6IEJlbm5vIFNjaHVsZW5iZXJnIDxiZW5zYmVyZ0BqdXN0ZW1h
aWwubmV0PgotLS0KIG1pc2MvbWtlMmZzLmMgfCAgICAyICstCiAxIGZpbGVz
IGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9taXNjL21rZTJmcy5jIGIvbWlzYy9ta2UyZnMuYwppbmRl
eCBkZDRkMjEzLi41NWJiZTllIDEwMDY0NAotLS0gYS9taXNjL21rZTJmcy5j
CisrKyBiL21pc2MvbWtlMmZzLmMKQEAgLTg2MCw3ICs4NjAsNyBAQCBzdGF0
aWMgdm9pZCBwYXJzZV9leHRlbmRlZF9vcHRzKHN0cnVjdCBleHQyX3N1cGVy
X2Jsb2NrICpwYXJhbSwKIAkJCWlmICgqcCB8fCBudW1fYmFja3VwcyA+IDIp
IHsKIAkJCQlmcHJpbnRmKHN0ZGVyciwKIAkJCQkJXygiSW52YWxpZCAjIG9m
IGJhY2t1cCAiCi0JCQkJCSAgInN1cGVyYm9ja3M6ICVzXG4iKSwKKwkJCQkJ
ICAic3VwZXJibG9ja3M6ICVzXG4iKSwKIAkJCQkJYXJnKTsKIAkJCQlyX3Vz
YWdlKys7CiAJCQkJY29udGludWU7Ci0tIAoxLjcuMC40Cgo=

--_----------=_1401657778317703--

