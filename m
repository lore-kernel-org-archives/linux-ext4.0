From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] Please reserve INCOMPAT_DIRDATA flag
Date: Mon, 30 Nov 2009 14:16:48 -0700
Message-ID: <C19F99B4-0EBA-412B-8570-339B002DC028@sun.com>
References: <20090906092546.GU4197@webber.adilger.int>
 <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
 <CE613B31-EA68-40A0-8F79-8A70A4CFD209@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_FmU5QndSp7KcL2pCNejgNw)"
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57261 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZK3VQo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2009 16:16:44 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAULGoPK021560
	for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2009 13:16:51 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTX00I00WVSKV00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 30 Nov 2009 13:16:50 -0800 (PST)
In-reply-to: <CE613B31-EA68-40A0-8F79-8A70A4CFD209@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_FmU5QndSp7KcL2pCNejgNw)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

Attached is a patch to reserve the data-in-dirent feature flag.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--Boundary_(ID_FmU5QndSp7KcL2pCNejgNw)
Content-type: application/octet-stream; name=e2fsprogs-incompat_dirdata.diff;
 x-unix-mode=0644
Content-transfer-encoding: BASE64
Content-disposition: attachment; filename=e2fsprogs-incompat_dirdata.diff

UmVzZXJ2ZSB0aGUgRVhUNF9GRUFUVVJFX0lOQ09NUEFUX0RJUkRBVEEgZmVhdHVy
ZSBmbGFnDQpmb3IgYWRkaW5nIGV4dHJhIGZpbGUgZGF0YSBpbiBleHQyX2Rpcl9l
bnRyeV8yIGVudHJpZXMuDQoNClRoaXMgY2hhbmdlcyB0aGUgb24tZGlzayBsYXlv
dXQgaW4gdGhlIGZvbGxvd2luZyB3YXkuDQoNCkZpcnN0bHksIHRoZSBleHQyX2Rp
cl9lbnRyeV8yIGZpbGVfdHlwZSBmaWVsZCBub3cgaGFzIGEgbWFzazoNCiNkZWZp
bmUgRVhUNF9GVF9NQVNLIDB4Zg0KdGhhdCBsaW1pdHMgdGhlICJmaWxldHlwZSIg
aW5mb3JtYXRpb24gdG8gdGhlIGxvdyA0IGJpdHMgb2YNCnRoaXMgZmllbGQuICBT
aW5jZSB0aGVzZSB2YWx1ZXMgYXJlIHNlcXVlbnRpYWxseSBhc3NpZ25lZCwNCnRo
aXMgYWxsb3dzIGZvciB1cCB0byA3IG1vcmUgZmlsZXR5cGVzIHRvIGJlIGFzc2ln
bmVkLiAgV2hlbg0KcmVhZGluZyB0aGUgImZpbGV0eXBlIiBmaWVsZCwgdGhlIGhp
Z2ggNCBiaXRzIHNob3VsZCBiZSBtYXNrZWQNCm9mZiB3aGVuIGNvbnZlcnRpbmcg
dG8gRFRfKiBmaWxldHlwZXMgZm9yIHVzZXJzcGFjZS4NCg0KVGhlIGhpZ2ggNCBi
aXRzIG9mICJmaWxldHlwZSIgYXJlIHVzZWQgYXMgYSBiaXRtYXNrIHRvIHJlZ2lz
dGVyDQp1cCB0byA0IGRpZmZlcmVudCAiZXh0ZW5kZWQiIGRpcmVjdG9yeSBlbnRy
eSBmaWVsZHMuICBFeHRlbmRlZA0KZGF0YSBmaWVsZHMgYXJlIHBhY2tlZCB3aXRo
b3V0IGFsaWdubWVudCBpbnRvIHRoZSBkaXJlY3RvcnkgZW50cnkNCmFmdGVyIHRo
ZSAibmFtZSIgZmllbGQgaW4gb3JkZXIgb2YgaW5jcmVhc2luZyBiaXRtYXNrIHZh
bHVlLCBmb3INCmVhY2ggZmllbGQgd2hlcmUgYml0IGlzIHNldC4gIEluIG9yZGVy
IHRvIGF2b2lkIHRoZSBuZWVkIHRvDQoidW5kZXJzdGFuZCIgZWFjaCBvZiB0aGUg
ZXh0ZW5kZWQgZmllbGRzLCB0aGUgZmlyc3QgYnl0ZSBvZiBlYWNoDQpleHRlbmRl
ZCBkYXRhIGZpZWxkIGhvbGRzIHRoZSBzaXplIG9mIHRoYXQgZGF0YSBmaWVsZCAo
aW5jbHVkaW5nDQp0aGUgc2l6ZSBpdHNlbGYpLCBzbyB0aGV5IGNhbiBiZSBza2lw
cGVkIGlmIG5vdCB1bmRlcnN0b29kLiAgRm9yDQpmaWVsZHMgdGhhdCBjaGFuZ2Ug
dGhlIHNlbWFudGljcyBvZiB0aGUgZmlsZXN5c3RlbSBpdCBpcyBleHBlY3RlZA0K
dGhhdCBhIHNlcGFyYXRlIFJPQ09NUEFUIG9yIElOQ09NUEFUIGZpZWxkIGlzIHJl
Z2lzdGVyZWQuDQoNClRoZXJlIGlzIGEgc2luZ2xlIGRpcmVudCBkYXRhIHR5cGUg
ZGVmaW5lZCBjdXJyZW50bHksIGZvciBMdXN0cmU6DQojZGVmaW5lIEVYVDRfRElS
RU5UX0xVRklEIAkJMHgxMA0Kd2hpY2ggaG9sZHMgYSAxMjgtYml0IGZpbGUgaWRl
bnRpZmllci4gIEl0IGlzIGV4cGVjdGVkIHRoYXQNCmlmIHRoZXJlIGFyZSA2NC1i
aXQgaW5vZGUgdmFsdWVzIHRoYXQgdGhpcyB3aWxsIGJlIGFzc2lnbmVkDQp0aGUg
MHgyMCB2YWx1ZS4NCg0KU2hvdWxkIGEgbmVlZCBldmVyIGFyaXNlIHRvIHVzZSBh
bGwgNCBvZiB0aGUgZXh0ZW5kZWQgZGlyZW50DQpkYXRhIGZpZWxkcywgaXQgd291
bGQgYmUgcG9zc2libGUgdG8ga2VlcCB0aGUgbGFzdCBiaXQgKDB4ODApDQpmb3Ig
dXNlIGFzIGEgbXVsdGlwbGV4b3IgdGhhdCBzdG9yZXMgYSAxLWJ5dGUgYWdncmVn
YXRlIGRhdGEgDQpzaXplLCB0aGVuIGEgc2VyaWVzIG9mICI8dThfc2l6ZT48dThf
dHlwZT48ZGF0YT4iIHJlY29yZHMgaW4NCnRoZSBsYXN0IGV4dGVuZGVkIGRhdGEg
cmVjb3JkLiAgSXQgaXMgbm90IGV4cGVjdGVkIHRoYXQgdGhpcw0Kd2lsbCBhY3R1
YWxseSBiZSBuZWVkZWQgaW4gdGhlIGxpZmV0aW1lIG9mIGV4dDQuDQoNClNpZ25l
ZC1vZmYtYnk6IEFuZHJlYXMgRGlsZ2VyIDxhZGlsZ2VyQHN1bi5jb20+DQoNCmRp
ZmYgLS1naXQgYS9saWIvZXh0MmZzL2V4dDJfZnMuaCBiL2xpYi9leHQyZnMvZXh0
Ml9mcy5oDQppbmRleCAxMTRiMDAxLi4xOGY2OTA5IDEwMDY0NA0KLS0tIGEvbGli
L2V4dDJmcy9leHQyX2ZzLmgNCisrKyBiL2xpYi9leHQyZnMvZXh0Ml9mcy5oDQpA
QCAtNjQ4LDYgKzY0OCw3IEBAIHN0cnVjdCBleHQyX3N1cGVyX2Jsb2NrIHsNCiAj
ZGVmaW5lIEVYVDRfRkVBVFVSRV9JTkNPTVBBVF9NTVAJCTB4MDEwMA0KICNkZWZp
bmUgRVhUNF9GRUFUVVJFX0lOQ09NUEFUX0ZMRVhfQkcJCTB4MDIwMA0KICNkZWZp
bmUgRVhUNF9GRUFUVVJFX0lOQ09NUEFUX0VBX0lOT0RFCQkweDA0MDANCisjZGVm
aW5lIEVYVDRfRkVBVFVSRV9JTkNPTVBBVF9ESVJEQVRBCQkweDEwMDANCiANCiAN
CiAjZGVmaW5lIEVYVDJfRkVBVFVSRV9DT01QQVRfU1VQUAkwDQo=

--Boundary_(ID_FmU5QndSp7KcL2pCNejgNw)--
