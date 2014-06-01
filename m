From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH] fully and properly gettextize two error messages in e2fsck
Date: Sun, 01 Jun 2014 23:27:49 +0200
Message-ID: <1401658069.328.123945581.4DB549FE@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="_----------=_14016580693281"; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47486 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbaFAV1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2014 17:27:51 -0400
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id D514320C73
	for <linux-ext4@vger.kernel.org>; Sun,  1 Jun 2014 17:27:49 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--_----------=_14016580693281
Content-Transfer-Encoding: 7bit
Content-Type: text/plain


It is better to gettextize entire sentences, and not synthesize
them from fragments, so the grammar can be kept correct in
translations.

-- 
http://www.fastmail.fm - The way an email service should be


--_----------=_14016580693281
Content-Disposition: attachment; filename="0010-e2fsck-fully-and-properly-gettextize-two-error-messa.patch"
Content-Id: <1401658064.32720.235b770a08b9903670d66f58d958ea5d657840ce.3C33D651@content.messagingengine.com>
Content-Transfer-Encoding: base64
Content-Type: text/x-diff; name="0010-e2fsck-fully-and-properly-gettextize-two-error-messa.patch"

RnJvbSBmMTFhYjczZDE2MDYzMTMyYjQzNGIwMThkYzMxZmMzOWZhMmNkNjc4
IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCZW5ubyBTY2h1bGVu
YmVyZyA8YmVuc2JlcmdAanVzdGVtYWlsLm5ldD4KRGF0ZTogU3VuLCAxIEp1
biAyMDE0IDE5OjA4OjIyICswMjAwClN1YmplY3Q6IFtQQVRDSCAxMC8xNF0g
ZTJmc2NrOiBmdWxseSBhbmQgcHJvcGVybHkgZ2V0dGV4dGl6ZSB0d28gZXJy
b3IgbWVzc2FnZXMKClRoZSBwaHJhc2VzICJtb3VudGVkIiBhbmQgImluIHVz
ZSIgd2VyZSBmaWxsZWQgaW4gdW50cmFuc2xhdGVkIGludG8KdGhlIG1lc3Nh
Z2VzLiAgQnV0IGl0IGlzIGJldHRlciB0byBnZXR0ZXh0aXplIGVudGlyZSBz
ZW50ZW5jZXMsIGFuZApub3Qgc3ludGhlc2l6ZSB0aGVtIGZyb20gZnJhZ21l
bnRzLgoKU2lnbmVkLW9mZi1ieTogQmVubm8gU2NodWxlbmJlcmcgPGJlbnNi
ZXJnQGp1c3RlbWFpbC5uZXQ+Ci0tLQogZTJmc2NrL3VuaXguYyB8ICAgMTYg
KysrKysrKysrKy0tLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2UyZnNjay91
bml4LmMgYi9lMmZzY2svdW5peC5jCmluZGV4IDIyNjdhMDIuLjQyOGM4ZmIg
MTAwNjQ0Ci0tLSBhL2UyZnNjay91bml4LmMKKysrIGIvZTJmc2NrL3VuaXgu
YwpAQCAtMjQ5LDE1ICsyNDksMTkgQEAgc3RhdGljIHZvaWQgY2hlY2tfbW91
bnQoZTJmc2NrX3QgY3R4KQogCSAgICAgKChjdHgtPm9wdGlvbnMgJiBFMkZf
T1BUX0ZPUkNFKSAmJgogCSAgICAgIChjdHgtPm1vdW50X2ZsYWdzICYgRVhU
Ml9NRl9SRUFET05MWSkpKSAmJgogCSAgICAhKGN0eC0+b3B0aW9ucyAmIEUy
Rl9PUFRfV1JJVEVDSEVDSykpIHsKLQkJbG9nX291dChjdHgsIF8oIldhcm5p
bmchICAlcyBpcyAlcy5cbiIpLAotCQkJY3R4LT5maWxlc3lzdGVtX25hbWUs
Ci0JCQljdHgtPm1vdW50X2ZsYWdzICYgRVhUMl9NRl9NT1VOVEVEID8KLQkJ
CQkibW91bnRlZCIgOiAiaW4gdXNlIik7CisJCWlmIChjdHgtPm1vdW50X2Zs
YWdzICYgRVhUMl9NRl9NT1VOVEVEKQorCQkJbG9nX291dChjdHgsIF8oIldh
cm5pbmchICAlcyBpcyBtb3VudGVkLlxuIiksCisJCQkJCWN0eC0+ZmlsZXN5
c3RlbV9uYW1lKTsKKwkJZWxzZQorCQkJbG9nX291dChjdHgsIF8oIldhcm5p
bmchICAlcyBpcyBpbiB1c2UuXG4iKSwKKwkJCQkJY3R4LT5maWxlc3lzdGVt
X25hbWUpOwogCQlyZXR1cm47CiAJfQogCi0JbG9nX291dChjdHgsIF8oIiVz
IGlzICVzLlxuIiksIGN0eC0+ZmlsZXN5c3RlbV9uYW1lLAotCQljdHgtPm1v
dW50X2ZsYWdzICYgRVhUMl9NRl9NT1VOVEVEID8gIm1vdW50ZWQiIDogImlu
IHVzZSIpOworCWlmIChjdHgtPm1vdW50X2ZsYWdzICYgRVhUMl9NRl9NT1VO
VEVEKQorCQlsb2dfb3V0KGN0eCwgXygiJXMgaXMgbW91bnRlZC5cbiIpLCBj
dHgtPmZpbGVzeXN0ZW1fbmFtZSk7CisJZWxzZQorCQlsb2dfb3V0KGN0eCwg
XygiJXMgaXMgaW4gdXNlLlxuIiksIGN0eC0+ZmlsZXN5c3RlbV9uYW1lKTsK
IAlpZiAoIWN0eC0+aW50ZXJhY3RpdmUgfHwgY3R4LT5tb3VudF9mbGFncyAm
IEVYVDJfTUZfQlVTWSkKIAkJZmF0YWxfZXJyb3IoY3R4LCBfKCJDYW5ub3Qg
Y29udGludWUsIGFib3J0aW5nLlxuXG4iKSk7CiAJcHV0cygiXDAwN1wwMDdc
MDA3XDAwNyIpOwotLSAKMS43LjAuNAoK

--_----------=_14016580693281--

