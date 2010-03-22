From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] avoid scanning bitmaps for group preallocation
Date: Mon, 22 Mar 2010 16:03:10 -0600
Message-ID: <A2A61325-CB7F-40E0-B9B9-A918135BCBC6@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_Jav1o1x89yboYcOcN6mhoA)"
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60807 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab0CVWDO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 18:03:14 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2MM3Csn014873
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 15:03:14 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZP00H00E9QNR00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 22 Mar 2010 15:03:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_Jav1o1x89yboYcOcN6mhoA)
Content-type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-transfer-encoding: 7BIT

Here is the patch I mentioned today on the call.  It avoids (or at  
least reduces) serious latency (10 minutes or more) on a large  
filesystem (8TB+) on the first write, if the filesystem is nearly  
full.  The latency is entirely due to seeking to read the block  
bitmaps, so is considerably less serious on flex_bg formatted  
filesystems.

A better long-term approach would be to store in the superblock the  
last group that had space to allocate a stripe-sized chunk and/or flag  
in the group descriptor if there is not a large amount of contiguous  
free space therein (cleared on freeing blocks in the group).

Having the mount-time buddy-bitmap (and checksum verifying) scanning  
thread start at mount would only help if the first write to the  
filesystem is not immediately after mount (which it is in Lustre at  
least).  Having a filesystem-wide (r)btree for the freespace (ala XFS)  
would also only help if the btree could be (at least partially) built  
from bitmaps before the first write, unless we cache the bitmap on  
disk, which caused Lustre plenty in the past and I'm leery to do it.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_Jav1o1x89yboYcOcN6mhoA)
Content-type: application/octet-stream; name=ext4-mballoc-skip.diff;
 x-unix-mode=0644
Content-transfer-encoding: BASE64
Content-disposition: attachment; filename=ext4-mballoc-skip.diff

UmVkdWNlIHRoZSBzaXplIG9mIGdyb3VwIHByZWFsbG9jYXRpb24gY2h1bmtzIHRv
IGEgc2luZ2xlIFJBSUQNCnN0cmlwZSwgb3IgMU1CIGlmIHRoYXQgaXMgbm90IHNw
ZWNpZmllZC4gIFNpbmNlIGl0IGlzIGxpa2VseSB0aGUNCnNtYWxsIGZpbGVzIHdp
bGwgYmUgcmVhZCBiYWNrIGluIGFuIHVucmVsYXRlZCBvcmRlciBhbnl3YXksIHRo
ZQ0KbWFpbiBiZW5lZml0IG9mIGFnZ3JlZ2F0aW9uIGlzIHRvIGF2b2lkIHJlYWQt
bW9kaWZ5LXdyaXRlLCB3aGljaA0KaXMgc3RpbGwgc2F0aXNmaWVkIGJ5IHRoZSBz
bWFsbGVyIGRlZmF1bHQgc2l6ZS4NCg0KQWxzbyBza2lwIHJlYWRpbmcgb2YgYmxv
Y2sgYml0bWFwcyBpZiB0aGVyZSBpcyBhYnNvbHV0ZWx5IG5vIGNoYW5jZQ0Kb2Yg
ZmluZGluZyBhIGJldHRlciBleHRlbnQgaW4gdGhhdCBncm91cCwgYmVjYXVzZSB0
aGUgbnVtYmVyIG9mDQpmcmVlIGJsb2NrcyBpcyBsZXNzIHRoYW4gdGhlIG51bWJl
ciBvZiBibG9ja3MgaW4gdGhlIGJlc3QgZXh0ZW50DQpmb3VuZCBzbyBmYXIuICBB
IGJldHRlciBkZWNpc2lvbiBjYW4gYmUgbWFkZSBhZnRlciB0aGUgYml0bWFwIGlz
DQpsb2FkZWQsIGJ1dCBpbiBhIGxhcmdlIGZpbGVzeXN0ZW0gdGhlcmUgY2FuIGJl
IHRlbnMgb2YgdGhvdXNhbmRzDQpvZiBncm91cHMsIGFuZCByZWFkaW5nIHRoZW0g
YWxsIGluIGNhbiB0YWtlIG1pbnV0ZXMgaWYgdGhlIGZpbGVzeXN0ZW0NCmlzIG5l
YXJseSBmdWxsLg0KDQpTaWduZWQtb2ZmLWJ5OiBBbmRyZWFzIERpbGdlciA8YWRp
bGdlckBzdW4uY29tPg0KDQpkaWZmIC0tZ2l0IGEvZnMvZXh0NC9tYmFsbG9jLmMg
Yi9mcy9leHQ0L21iYWxsb2MuYw0KaW5kZXggNTRkZjIwOS4uNjAzOGZhZCAxMDA2
NDQNCi0tLSBhL2ZzL2V4dDQvbWJhbGxvYy5jDQorKysgYi9mcy9leHQ0L21iYWxs
b2MuYw0KQEAgLTEyNSw4ICsxMjUsNyBAQA0KICAqIGxpc3QuIEluIGNhc2Ugb2Yg
aW5vZGUgcHJlYWxsb2NhdGlvbiB3ZSBmb2xsb3cgYSBsaXN0IG9mIGhldXJpc3Rp
Y3MNCiAgKiBiYXNlZCBvbiBmaWxlIHNpemUuIFRoaXMgY2FuIGJlIGZvdW5kIGlu
IGV4dDRfbWJfbm9ybWFsaXplX3JlcXVlc3QuIElmDQogICogd2UgYXJlIGRvaW5n
IGEgZ3JvdXAgcHJlYWxsb2Mgd2UgdHJ5IHRvIG5vcm1hbGl6ZSB0aGUgcmVxdWVz
dCB0bw0KLSAqIHNiaS0+c19tYl9ncm91cF9wcmVhbGxvYy4gRGVmYXVsdCB2YWx1
ZSBvZiBzX21iX2dyb3VwX3ByZWFsbG9jIGlzDQotICogNTEyIGJsb2Nrcy4gVGhp
cyBjYW4gYmUgdHVuZWQgdmlhDQorICogc2JpLT5zX21iX2dyb3VwX3ByZWFsbG9j
LiAgVGhpcyBjYW4gYmUgdHVuZWQgdmlhDQogICogL3N5cy9mcy9leHQ0LzxwYXJ0
aXRpb24vbWJfZ3JvdXBfcHJlYWxsb2MuIFRoZSB2YWx1ZSBpcyByZXByZXNlbnRl
ZCBpbg0KICAqIHRlcm1zIG9mIG51bWJlciBvZiBibG9ja3MuIElmIHdlIGhhdmUg
bW91bnRlZCB0aGUgZmlsZSBzeXN0ZW0gd2l0aCAtTw0KICAqIHN0cmlwZT08dmFs
dWU+IG9wdGlvbiB0aGUgZ3JvdXAgcHJlYWxsb2MgcmVxdWVzdCBpcyBub3JtYWxp
emVkIHRvIHRoZQ0KQEAgLTIwMjksOSArMjAyOCwxMiBAQCByZXBlYXQ6DQogCQkJ
aWYgKGdyb3VwID09IG5ncm91cHMpDQogCQkJCWdyb3VwID0gMDsNCiANCi0JCQkv
KiBxdWljayBjaGVjayB0byBza2lwIGVtcHR5IGdyb3VwcyAqLw0KKwkJCS8qIElm
IHRoZXJlJ3Mgbm8gY2hhbmNlIHRoYXQgdGhpcyBncm91cCBoYXMgYSBiZXR0ZXIN
CisJCQkgKiBleHRlbnQsIGp1c3Qgc2tpcCBpdCBpbnN0ZWFkIG9mIHNlZWtpbmcg
dG8gcmVhZA0KKwkJCSAqIGJsb2NrIGJpdG1hcCBmcm9tIGRpc2suIEluaXRpYWxs
eSBhY19iX2V4LmZlX2xlbiA9IDAsDQorCQkJICogc28gdGhpcyBhbHdheXMgc2tp
cHMgZ3JvdXBzIHdpdGggbm8gZnJlZSBzcGFjZS4gKi8NCiAJCQlncnAgPSBleHQ0
X2dldF9ncm91cF9pbmZvKHNiLCBncm91cCk7DQotCQkJaWYgKGdycC0+YmJfZnJl
ZSA9PSAwKQ0KKwkJCWlmIChncnAtPmJiX2ZyZWUgPD0gYWMtPmFjX2JfZXguZmVf
bGVuKQ0KIAkJCQljb250aW51ZTsNCiANCiAJCQllcnIgPSBleHQ0X21iX2xvYWRf
YnVkZHkoc2IsIGdyb3VwLCAmZTRiKTsNCmRpZmYgLS1naXQgYS9mcy9leHQ0L21i
YWxsb2MuaCBiL2ZzL2V4dDQvbWJhbGxvYy5oDQppbmRleCBiNjE5MzIyLi5kZjUx
NmM4IDEwMDY0NA0KLS0tIGEvZnMvZXh0NC9tYmFsbG9jLmgNCisrKyBiL2ZzL2V4
dDQvbWJhbGxvYy5oDQpAQCAtOTAsOSArOTAsOSBAQCBleHRlcm4gdTggbWJfZW5h
YmxlX2RlYnVnOw0KICNkZWZpbmUgTUJfREVGQVVMVF9PUkRFUjJfUkVRUwkJMg0K
IA0KIC8qDQotICogZGVmYXVsdCBncm91cCBwcmVhbGxvYyBzaXplIDUxMiBibG9j
a3MNCisgKiBkZWZhdWx0IGdyb3VwIHByZWFsbG9jIHNpemUgaW4gYmxvY2tzDQog
ICovDQotI2RlZmluZSBNQl9ERUZBVUxUX0dST1VQX1BSRUFMTE9DCTUxMg0KKyNk
ZWZpbmUgTUJfREVGQVVMVF9HUk9VUF9QUkVBTExPQwkyNTYNCiANCiANCiBzdHJ1
Y3QgZXh0NF9mcmVlX2RhdGEgew0K

--Boundary_(ID_Jav1o1x89yboYcOcN6mhoA)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT





--Boundary_(ID_Jav1o1x89yboYcOcN6mhoA)--
