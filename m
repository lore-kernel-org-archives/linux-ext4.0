From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Re: Question about ext4_free_blocks() Behavior for Per-File Data
 Journaling Mode
Date: Tue, 08 Dec 2015 07:02:20 +0000 (GMT)
Message-ID: <2137019115.413281449558139670.JavaMail.weblogic@epmlwas04b>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: Daeho Jeong <daeho.jeong@samsung.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:37575 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbbLHHCX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2015 02:02:23 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NZ101JLN27WGW30@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 08 Dec 2015 16:02:20 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

PiBIaS4gSSBoYXZlIGEgcXVlc3Rpb24gYWJvdXQgZXh0NF9mcmVlX2Jsb2NrcygpIGJlaGF2aW9y
IGZvciBwZXItZmlsZSBkYXRhIGpvdXJuYWxpbmcNCj4gbW9kZS4gQUZBSVVJLCBpbiBleHQ0X2Zy
ZWVfYmxvY2tzKCksIGl0IGRvZXNuJ3QgaW52b2tlIGV4dDRfZm9yZ2V0KCkgZnVuY3Rpb24gZm9y
DQo+IGRhdGEgYmxvY2tzIG9mIGEgcGVyLWZpbGUgZGF0YSBqb3VybmFsaW5nIGVuYWJsZWQgZmls
ZSwgYmVjYXVzZSBhbGwgdGhlIGRhdGEgYmxvY2tzDQo+IG9mIHRoZSBmaWxlIGFyZSBub3QgbGlu
a2VkIHRvIHRoZSBibG9jayBkZXZpY2UncyBhZGRyZXNzIHNwYWNlIG9mIHRoZSBmaWxlLCBidXQg
dGhlDQo+IGFkZHJlc3Mgc3BhY2Ugb2YgdGhlIGlub2RlIG9mIHRoZSBmaWxlLCBzbyBhbnkgZGF0
YSBibG9ja3Mgb2YgdGhlIGZpbGUgY2Fubm90IGJlDQo+IGZvdW5kIGJ5IHNiX2ZpbmRfZ2V0X2Js
b2NrKCkgZnVuY3Rpb24uIEl0IHNlZW1zIGEgYnVnLCBidXQgSSBhbSBub3Qgc3VyZS4NCj4gSXMg
dGhpcyBhIHByb2JsZW0/DQoNCkkganVzdCBhbnN3ZXIgbXkgb3duIHF1ZXN0aW9uLiBJdCB3YXMg
YSBzaWxseSBxdWVzdGlvbiwgYmVjYXVzZSBhbGwgdGhlIGRhdGEgYnVmZmVycw0Kb2YgcGVyLWZp
bGUgZGF0YSBqb3VybmFsbGVkIGZpbGUgYXJlIGZvcmdvdHRlbiBieSBqYmQyX2pvdXJuYWxfaW52
YWxpZGF0ZXBhZ2UoKSBpbiBhZHZhbmNlDQpvZiBpbnZva2luZyBleHQ0X2ZyZWVfYmxvY2tzKCku
DQoNCkFueXdheSwgdGhlIHJldm9rZSBvcGVyYXRpb24gdG8gdGhlIGRhdGEgYmxvY2tzIGlzIHN0
aWxsIG1pc3NpbmcgaW4gZXh0NF9mcmVlX2Jsb2NrcygpLg0KSSB3aWxsIGZpeCB0aGlzIHByb2Js
ZW0uIDotKQ0K


