From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: A question about EXT4_INODE_JOURNAL_DATA flag with delalloc
Date: Tue, 11 Aug 2015 03:12:56 +0000 (GMT)
Message-ID: <854180411.692591439262776858.JavaMail.weblogic@epmlwas07d>
Reply-To: daeho.jeong@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64
Cc: "daehojng@gmail.com" <daehojng@gmail.com>,
	=?utf-8?Q?=EC=A0=95=EB=8C=80=ED=98=B8?= <daeho.jeong@samsung.com>
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:48456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933326AbbHKDND (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Aug 2015 23:13:03 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NSW00J0FE9L3KA0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Tue, 11 Aug 2015 12:12:57 +0900 (KST)
MIME-version: 1.0
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

SGksIEkgYW0gc2VlaW5nIGluIHRoZSBleHQ0X2NoYW5nZV9pbm9kZV9mbGFnKCkgZnVuY3Rpb24g
YW5kIGZvdW5kIGEgcGF0Y2ggdG8gYWxsb2NhdGUNCnBoeXNpY2FsIGJsb2NrcyBmb3IgZGVsYWxs
b2MgYmxvY2tzIGluIHRoYXQgZnVuY3Rpb24uDQooPT4gaHR0cDovL3JlcG8ub3IuY3ovdy9leHQ0
LXBhdGNoLXF1ZXVlLmdpdC9ibG9iLzIwZjc3ODJiMWY1MGViMWQ1Y2JhNWUwODVkMDFmYmNlODlm
Y2U4ODE6L2FsbG9jYXRlLWRlbGFsbG9jLWJsb2Nrcy1iZWZvcmUtY2hhbmdpbmctam91cm5hbC1t
b2RlKQ0KDQpJIHRoaW5rIHRoaXMgaXMgYW4gaWRlYSB0byByZXNvbHZlIGtlcm5lbCBPT1BTIGNv
bmNlcm5lZCB3aXRoIGVuYWJsaW5nL2Rpc2FibGluZw0KZGF0YSBqb3VybmFsaW5nIG9mIGEgZmls
ZSBpbiBkZWxheWVkIGFsbG9jYXRpb24gbW9kZS4gQWN0dWFsbHksIEkgd2FudCB0byB1dGlsaXpl
IHBlciBmaWxlDQpkYXRhIGpvdXJuYWxpbmcgd2l0aCBkZWxheWVkIGFsbG9jYXRpb24sIHNvIHRo
aXMgcGF0Y2ggc2VlbWVkIHRvIGJlIHZlcnkgaGVscGZ1bCBmb3IgbWUuDQoNCkJ1dCwgYWZ0ZXIg
MSBtb250aCBmcm9tIHdoZW4gdGhlIHBhdGNoIHdhcyBhcHBsaWVkLCBhbm90aGVyIHBhdGNoIHdh
cyBzdWJtaXR0ZWQNCmFuZCBFWFQ0X0lOT0RFX0pPVVJOQUxfREFUQSBmbGFnIHdpdGggZGVsYWxs
b2Mgd2FzIGlnbm9yZWQuDQooPT4gaHR0cDovL3JlcG8ub3IuY3ovdy9leHQ0LXBhdGNoLXF1ZXVl
LmdpdC9ibG9iLzE3ZjNhOWMxNzQ3M2QwYjU5MjUxMThhNzViYTczNjNjNzllM2ZkYzM6L2lnbm9y
ZS1KT1VSTkFMX0RBVEEtZmxhZy13aXRoLWRlbGFsbG9jKQ0KDQpJIGRvbid0IHVuZGVyc3RhbmQg
dGhlIHJlYXNvbiBvZiB0aGF0IEVYVDRfSU5PREVfSk9VUk5BTF9EQVRBIGZsYWcgd2l0aCBkZWxh
bGxvYyB3YXMNCmlnbm9yZWQgYmVjYXVzZSBJIHRoaW5rIHRoZSBwcmV2aW91cyBwYXRjaCBjYW4g
aGFuZGxlIHRoZSBwcm9ibGVtIHdoaWNoIHRoZSBhYm92ZSBVUkwgZGVzY3JpYmVzLg0KDQpBbSBJ
IG1pc3Npbmcgc29tZXRoaW5nIGFuZCBjb3VsZCB5b3Ugc2hhcmUgeW91ciBpZGVhIGFib3V0IHRo
aXM/IDotKQ0K


