From: Andreas Dilger <adilger@sun.com>
Subject: Re: Please reserve INCOMPAT_EA_INODE flag
Date: Mon, 30 Nov 2009 12:31:40 -0700
Message-ID: <CE613B31-EA68-40A0-8F79-8A70A4CFD209@sun.com>
References: <20090906092546.GU4197@webber.adilger.int>
 <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_TJizDhu8UNlk/nZW3Zb3cA)"
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:61653 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZK3Tbm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Nov 2009 14:31:42 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nAUJVlnc002377
	for <linux-ext4@vger.kernel.org>; Mon, 30 Nov 2009 11:31:49 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KTX00100SLLBL00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 30 Nov 2009 11:31:47 -0800 (PST)
In-reply-to: <853282DF-4A37-4677-9E4C-F7C26A00C890@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_TJizDhu8UNlk/nZW3Zb3cA)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

Attached is a patch to reserve the EA inode feature flag.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--Boundary_(ID_TJizDhu8UNlk/nZW3Zb3cA)
Content-type: application/octet-stream; name=e2fsprogs-incompat_large_ea.diff;
 x-unix-mode=0644
Content-transfer-encoding: BASE64
Content-disposition: attachment; filename=e2fsprogs-incompat_large_ea.diff

UmVzZXJ2ZSB0aGUgRVhUNF9JTkNPTVBBVF9FQV9JTk9ERSBmZWF0dXJlIGZsYWcg
Zm9yIHVzZSB3aXRoDQpsYXJnZSBleHRlbmRlZCBhdHRyaWJ1dGVzIHRoYXQgYXJl
IHN0b3JlZCBpbiBhIHNlcGFyYXRlIGlub2RlLg0KVGhpcyBjaGFuZ2VzIHRoZSBv
bi1kaXNrIGZvcm1hdCBpbiBzZXZlcmFsIHdheXM6DQoNCkZpcnN0LCByZXBsYWNl
IHRoZSBlX3ZhbHVlX2Jsb2NrIGZpZWxkIHdpdGggZV92YWx1ZV9pbnVtLCBzbyB0
aGF0DQphbiB4YXR0ciBlbnRyeSBjYW4gcmVmZXJlbmNlIGFuIGV4dGVybmFsIGlu
b2RlLiAgVGhpcyBmaWVsZCBpcw0KY3VycmVudGx5IHVudXNlZCwgYXMgYWxsIG9m
IHRoZSBlbnRyaWVzIGxpdmUgaW4gdGhlIHNhbWUgYmxvY2suDQoNCnN0cnVjdCBl
eHQyX2V4dF9hdHRyX2VudHJ5IHsNCiAJX191OAllX25hbWVfbGVuOwkvKiBsZW5n
dGggb2YgbmFtZSAqLw0KIAlfX3U4CWVfbmFtZV9pbmRleDsJLyogYXR0cmlidXRl
IG5hbWUgaW5kZXggKi8NCiAJX19sZTE2CWVfdmFsdWVfb2ZmczsJLyogb2Zmc2V0
IGluIGRpc2sgYmxvY2sgb2YgdmFsdWUgKi8NCj4JX19sZTMyCWVfdmFsdWVfaW51
bTsJLyogaW5vZGUgaW4gd2hpY2ggdGhlIHZhbHVlIGlzIHN0b3JlZCAqLw0KIAlf
X2xlMzIJZV92YWx1ZV9zaXplOwkvKiBzaXplIG9mIGF0dHJpYnV0ZSB2YWx1ZSAq
Lw0KIAlfX2xlMzIJZV9oYXNoOwkJLyogaGFzaCB2YWx1ZSBvZiBuYW1lIGFuZCB2
YWx1ZSAqLw0KIAljaGFyCWVfbmFtZVswXTsJLyogYXR0cmlidXRlIG5hbWUgKi8N
Cn0NCg0KU2Vjb25kLCBhZGQgYSBmbGFnIHRvIHRoZSBpbm9kZSB0aGF0IGluZGlj
YXRlcyBpdCBpcyB1c2luZyBhIGxhcmdlDQooZXh0ZXJuYWwpIGV4dGVuZGVkIGF0
dHJpYnV0ZS4gIFRoaXMgaXMgbmVlZGVkIHNvIHRoYXQgd2hlbiB1bmxpbmtpbmcN
CmFuIGlub2RlIHRoZSB4YXR0cnMgd2lsbCBiZSBzY2FubmVkIHRvIHVubGluayB0
aGUgeGF0dHIgaW5vZGVzDQpyZWZlcmVuY2VkIGJ5IHRoZSBtYWluIGlub2RlLg0K
DQpUaGlyZCwgZm9yIGlub2RlcyB0aGF0IGhhdmUgYSBudW1iZXIgb2YgeGF0dHJz
IHRoYXQgYXJlIGxhcmdlciB0aGFuDQphIHNpbmdsZSBibG9jaywgYnV0IG5vdCBs
YXJnZSBlbm91Z2ggdG8ganVzdGlmeSBhbiBleHRlcm5hbCBpbm9kZQ0KKGxlc3Mg
dGhhbiA2NGtCIHRvdGFsIHhhdHRyIHNpemUsIGR1ZSB0byBlX3ZhbHVlX29mZnMg
bGltaXRhdGlvbikNCnRoZSBleHQyX2V4dF9hdHRyX2hlYWRlci0+aF9ibG9ja3Mg
ZmllbGQgY2FuIGdyb3cgYmV5b25kIGEgc2luZ2xlDQpibG9jayB0byByZXByZXNl
bnQgYSBjb250aWd1b3VzIGFsbG9jYXRpb24gb2YgYmxvY2tzIGZvciB0aGUgeGF0
dHIuDQoNClNpZ25lZC1vZmYtYnk6IEFuZHJlYXMgRGlsZ2VyIDxhZGlsZ2VyQHN1
bi5jb20+DQoNCmRpZmYgLS1naXQgYS9saWIvZXh0MmZzL2V4dDJfZnMuaCBiL2xp
Yi9leHQyZnMvZXh0Ml9mcy5oDQppbmRleCAxMTRiMDAxLi42YTEwNGNiIDEwMDY0
NA0KLS0tIGEvbGliL2V4dDJmcy9leHQyX2ZzLmgNCisrKyBiL2xpYi9leHQyZnMv
ZXh0Ml9mcy5oDQpAQCAtMjc2LDYgKzI3Niw3IEBAIHN0cnVjdCBleHQyX2R4X2Nv
dW50bGltaXQgew0KICNkZWZpbmUgRVhUMl9UT1BESVJfRkwJCQkweDAwMDIwMDAw
IC8qIFRvcCBvZiBkaXJlY3RvcnkgaGllcmFyY2hpZXMqLw0KICNkZWZpbmUgRVhU
NF9IVUdFX0ZJTEVfRkwgICAgICAgICAgICAgICAweDAwMDQwMDAwIC8qIFNldCB0
byBlYWNoIGh1Z2UgZmlsZSAqLw0KICNkZWZpbmUgRVhUNF9FWFRFTlRTX0ZMIAkJ
MHgwMDA4MDAwMCAvKiBJbm9kZSB1c2VzIGV4dGVudHMgKi8NCisjZGVmaW5lIEVY
VDRfRUFfSU5PREVfRkwJCTB4MDAyMDAwMDAgLyogSW5vZGUgaGFzIEVBIGlub2Rl
ICovDQogI2RlZmluZSBFWFQyX1JFU0VSVkVEX0ZMCQkweDgwMDAwMDAwIC8qIHJl
c2VydmVkIGZvciBleHQyIGxpYiAqLw0KIA0KICNkZWZpbmUgRVhUMl9GTF9VU0VS
X1ZJU0lCTEUJCTB4MDAwQkRGRkYgLyogVXNlciB2aXNpYmxlIGZsYWdzICovDQpA
QCAtNjQ3LDYgKzY0OCw3IEBAIHN0cnVjdCBleHQyX3N1cGVyX2Jsb2NrIHsNCiAj
ZGVmaW5lIEVYVDRfRkVBVFVSRV9JTkNPTVBBVF82NEJJVAkJMHgwMDgwDQogI2Rl
ZmluZSBFWFQ0X0ZFQVRVUkVfSU5DT01QQVRfTU1QCQkweDAxMDANCiAjZGVmaW5l
IEVYVDRfRkVBVFVSRV9JTkNPTVBBVF9GTEVYX0JHCQkweDAyMDANCisjZGVmaW5l
IEVYVDRfRkVBVFVSRV9JTkNPTVBBVF9FQV9JTk9ERQkJMHgwNDAwDQogDQogDQog
I2RlZmluZSBFWFQyX0ZFQVRVUkVfQ09NUEFUX1NVUFAJMA0K

--Boundary_(ID_TJizDhu8UNlk/nZW3Zb3cA)--
