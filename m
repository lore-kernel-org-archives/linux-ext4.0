From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: Question about ext4_free_blocks() Behavior for Per-File Data
 Journaling Mode
Date: Wed, 14 Oct 2015 04:39:06 +0000 (GMT)
Message-ID: <260827543.974111444797545780.JavaMail.weblogic@epmlwas03a>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "tytso@mit.edu" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56122 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbJNEko (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2015 00:40:44 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NW702Q3G0ZHGU00@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 14 Oct 2015 13:40:29 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SGkuIEkgaGF2ZSBhIHF1ZXN0aW9uIGFib3V0IGV4dDRfZnJlZV9ibG9ja3MoKSBiZWhhdmlvciBm
b3IgcGVyLWZpbGUgZGF0YSBqb3VybmFsaW5nDQptb2RlLiBBRkFJVUksIGluIGV4dDRfZnJlZV9i
bG9ja3MoKSwgaXQgZG9lc24ndCBpbnZva2UgZXh0NF9mb3JnZXQoKSBmdW5jdGlvbiBmb3INCmRh
dGEgYmxvY2tzIG9mIGEgcGVyLWZpbGUgZGF0YSBqb3VybmFsaW5nIGVuYWJsZWQgZmlsZSwgYmVj
YXVzZSBhbGwgdGhlIGRhdGEgYmxvY2tzDQpvZiB0aGUgZmlsZSBhcmUgbm90IGxpbmtlZCB0byB0
aGUgYmxvY2sgZGV2aWNlJ3MgYWRkcmVzcyBzcGFjZSBvZiB0aGUgZmlsZSwgYnV0IHRoZQ0KYWRk
cmVzcyBzcGFjZSBvZiB0aGUgaW5vZGUgb2YgdGhlIGZpbGUsIHNvIGFueSBkYXRhIGJsb2NrcyBv
ZiB0aGUgZmlsZSBjYW5ub3QgYmUNCmZvdW5kIGJ5IHNiX2ZpbmRfZ2V0X2Jsb2NrKCkgZnVuY3Rp
b24uIEl0IHNlZW1zIGEgYnVnLCBidXQgSSBhbSBub3Qgc3VyZS4NCklzIHRoaXMgYSBwcm9ibGVt
Pw0KDQpJIHRoaW5rIHRoYXQsIGluIGV4dDRfZnJlZV9ibG9ja3MoKSwgd2UgaGF2ZSB0byBmaW5k
IGJ1ZmZlciBoZWFkcyBvZiB0aGUgZmlsZSdzIGRhdGENCix3aGljaCBhcmUgam91cm5hbGVkLCBh
bmQgdHJhbnNmZXIgdGhlIGZvdW5kIGJ1ZmZlciBoZWFkcyB0byBleHQ0X2ZvcmdldCgpIGluDQpv
cmRlciB0byBmb3JnZXQgYW5kIHJldm9rZSB0aGUgYnVmZmVyIGhlYWQgcmVsYXRlZCBqb3VybmFs
IHJlY29yZC4gRm9yIHRoYXQsIA0Kd2UgbWlnaHQgbmVlZCB0byB0cmFuc2ZlciB0aGUgbG9naWNh
bCBibG9jayBudW1iZXJzIG9mIHRoZSBidWZmZXIgaGVhZHMgb2YgDQpmaWxlcycgZGF0YSBibG9j
a3MgdG8gZXh0NF9mcmVlX2Jsb2NrcygpLiBEbyB5b3UgaGF2ZSBhIGJldHRlciBpZGVhIHRvIHJl
c29sdmUNCnRoaXMgcHJvYmxlbT8=


