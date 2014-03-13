From: Cedric Le Goater <clg@fr.ibm.com>
Subject: ext4 extent issue when page size > block size
Date: Thu, 13 Mar 2014 19:00:06 +0100
Message-ID: <5321F226.80505@fr.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020006060009080800090009"
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, anton@samba.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:47168 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaCMSB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2014 14:01:26 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <clg@fr.ibm.com>;
	Thu, 13 Mar 2014 18:01:25 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 69F8F1B0805F
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2014 18:01:09 +0000 (GMT)
Received: from d06av05.portsmouth.uk.ibm.com (d06av05.portsmouth.uk.ibm.com [9.149.37.229])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2DI1AuX66977848
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2014 18:01:10 GMT
Received: from d06av05.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av05.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2DI1KYY032020
	for <linux-ext4@vger.kernel.org>; Thu, 13 Mar 2014 12:01:21 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020006060009080800090009
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

While running openldap unit tests on a ppc64 system, we have had 
issues with the cp command. cp uses the FS_IOC_FIEMAP ioctl to
optimize the copy and it appeared that the ext4 extent list of 
the file did not match all the data which was 'written' on disk. 

The system we use has a 64kB page size but the page size being 
greater than the filesystem block seems to be the top level reason 
of the problem. One can use a 1kB block size filesystem to reproduce 
the issue on a 4kB page size system.

Attached is a simple test case from Anton, which creates extents
as follow :

	lseek(48K -1)		-> creates [11/1)
	p = mmap(128K)
	*(p) = 1		-> creates [0/1) with a fault
	lseek(128K)		-> creates [31/1) 
	*(p + 49K) = 1		-> creates [12/1) and then merges in [11/2) 
	munmap(128K)
	

On a 4kB page size system, the extent list returned by FS_IOC_FIEMAP 
looks correct :

	Extent 0: logical: 0 physical: 0 length: 4096 flags 0x006
	Extent 1: logical: 45056 physical: 0 length: 8192 flags 0x006
	Extent 2: logical: 126976 physical: 0 length: 4096 flags 0x007


But, with a 64kB page size, we miss the in-the-middle extent (no page
fault but the data is on disk) :

	Extent 0: logical: 0 physical: 0 length: 49152 flags 0x006
	Extent 1: logical: 126976 physical: 0 length: 4096 flags 0x007


This looks wrong. Right ? Or are we doing something wrong ? I have been 
digging in the ext4 page writeback code. There are some caveats when 
blocksize < pagesize but I am not sure my understanding is correct. 


Many thanks,

C.


--------------020006060009080800090009
Content-Type: text/plain; charset=UTF-8;
 name="mmap_lseek_issue0.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="mmap_lseek_issue0.c"

LyoKICogbW1hcCB2cyBleHRlbnQgaXNzdWUKICoKICogQ29weXJpZ2h0IChDKSAyMDE0IEFu
dG9uIEJsYW5jaGFyZCA8YW50b25AYXUuaWJtLmNvbT4sIElCTQogKgogKiBUaGlzIHByb2dy
YW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCiAq
IG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBM
aWNlbnNlCiAqIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9u
OyBlaXRoZXIgdmVyc2lvbgogKiAyIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRp
b24pIGFueSBsYXRlciB2ZXJzaW9uLgogKi8KCiNpbmNsdWRlIDxzdGRpby5oPgojaW5jbHVk
ZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoj
aW5jbHVkZSA8c3lzL3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvbW1hbi5oPgojaW5jbHVkZSA8
c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxsaW51eC9mcy5oPgojaW5jbHVkZSA8bGludXgvZmll
bWFwLmg+CgpzdGF0aWMgdm9pZCBjaGVja19maWVtYXAoaW50IGZkKQp7CglzdHJ1Y3QgZmll
bWFwICpmaWVtYXA7Cgl1bnNpZ25lZCBsb25nIGksIGV4X3NpemU7CgoJZmllbWFwID0gbWFs
bG9jKHNpemVvZihzdHJ1Y3QgZmllbWFwKSk7CglpZiAoIWZpZW1hcCkgewoJCXBlcnJvcigi
bWFsbG9jIik7CgkJZXhpdCgxKTsKCX0KCgltZW1zZXQoZmllbWFwLCAwLCBzaXplb2Yoc3Ry
dWN0IGZpZW1hcCkpOwoJZmllbWFwLT5mbV9sZW5ndGggPSB+MDsKCglpZiAoaW9jdGwoZmQs
IEZTX0lPQ19GSUVNQVAsIGZpZW1hcCkgPT0gLTEpIHsKCQlwZXJyb3IoImlvY3RsKEZJRU1B
UCkiKTsKCQlleGl0KDEpOwoJfQoKCWV4X3NpemUgPSBzaXplb2Yoc3RydWN0IGZpZW1hcF9l
eHRlbnQpICogZmllbWFwLT5mbV9tYXBwZWRfZXh0ZW50czsKCglmaWVtYXAgPSByZWFsbG9j
KGZpZW1hcCwgc2l6ZW9mKHN0cnVjdCBmaWVtYXApICsgZXhfc2l6ZSk7CglpZiAoIWZpZW1h
cCkgewoJCXBlcnJvcigicmVhbGxvYyIpOwoJCWV4aXQoMSk7Cgl9CgoJbWVtc2V0KGZpZW1h
cC0+Zm1fZXh0ZW50cywgMCwgZXhfc2l6ZSk7CglmaWVtYXAtPmZtX2V4dGVudF9jb3VudCA9
IGZpZW1hcC0+Zm1fbWFwcGVkX2V4dGVudHM7CglmaWVtYXAtPmZtX21hcHBlZF9leHRlbnRz
ID0gMDsKCglpZiAoaW9jdGwoZmQsIEZTX0lPQ19GSUVNQVAsIGZpZW1hcCkgPCAwKSB7CgkJ
cGVycm9yKCJpb2N0bChGSUVNQVApIik7CgkJZXhpdCgxKTsKCX0KCglmb3IgKGkgPSAwOyBp
IDwgZmllbWFwLT5mbV9tYXBwZWRfZXh0ZW50czsgaSsrKSB7CgkJdW5zaWduZWQgbG9uZyBz
dGFydCA9IGZpZW1hcC0+Zm1fZXh0ZW50c1tpXS5mZV9sb2dpY2FsOwoJCXVuc2lnbmVkIGxv
bmcgZW5kID0gZmllbWFwLT5mbV9leHRlbnRzW2ldLmZlX2xvZ2ljYWwgKwoJCQkJCWZpZW1h
cC0+Zm1fZXh0ZW50c1tpXS5mZV9sZW5ndGg7CgoJCWlmIChzdGFydCA8PSA0OCoxMDI0ICYm
IGVuZCA+IDQ4KjEwMjQpIHsKCQkJcHJpbnRmKCJHT09EXG4iKTsKCQkJZXhpdCgwKTsKCQl9
Cgl9CgoJcHJpbnRmKCJCQUQ6XG4iKTsKCWZvciAoaSA9IDA7IGkgPCBmaWVtYXAtPmZtX21h
cHBlZF9leHRlbnRzOyBpKyspIHsKCQlwcmludGYoIiVsZDpcdCUwMTZsbHggJTAxNmxseFxu
IiwgaSwKCQkJZmllbWFwLT5mbV9leHRlbnRzW2ldLmZlX2xvZ2ljYWwsCgkJCWZpZW1hcC0+
Zm1fZXh0ZW50c1tpXS5mZV9sZW5ndGgpOwoJfQoKCWV4aXQoMSk7Cn0KCmludCBtYWluKGlu
dCBhcmdjLCBjaGFyICphcmd2W10pCnsKCWNoYXIgbmFtZVtdID0gIm1tYXAtbHNlZWstWFhY
WFhYIjsKCWludCBmZDsKCWNoYXIgKnA7CgoJZmQgPSBta3N0ZW1wKG5hbWUpOwoJaWYgKGZk
ID09IC0xKSB7CgkJcGVycm9yKCJta3N0ZW1wIik7CgkJZXhpdCgxKTsKCX0KCgkvKiBDcmVh
dGUgYSA0OCBrQiBmaWxlICovCglsc2VlayhmZCwgNDggKiAxMDI0IC0gMSwgU0VFS19TRVQp
OwoJaWYgKHdyaXRlKGZkLCAiXDAiLCAxKSAhPSAxKSB7CgkJcGVycm9yKCJ3cml0ZSIpOwoJ
CWV4aXQoMSk7Cgl9CgoJLyogTWFwIGl0LCBhbGxvd2luZyBzcGFjZSBmb3IgaXQgdG8gZ3Jv
dyAqLwoJcCA9IG1tYXAoTlVMTCwgMTI4ICogMTAyNCwgUFJPVF9SRUFEfFBST1RfV1JJVEUs
IE1BUF9TSEFSRUQsIGZkLCAwKTsKCWlmIChwID09IE1BUF9GQUlMRUQpIHsKCQlwZXJyb3Io
Im1tYXAiKTsKCQlleGl0KDEpOwoJfQoKCS8qIFdyaXRlIHRvIHRoZSBzdGFydCBvZiB0aGUg
ZmlsZSAqLwoJKihwKSA9IDE7CgoJLyogRXh0ZW5kIHRoZSBmaWxlICovCglsc2VlayhmZCwg
MTI4ICogMTAyNCAtIDEsIFNFRUtfU0VUKTsKCWlmICh3cml0ZShmZCwgIlwwIiwgMSkgIT0g
MSkgewoJCXBlcnJvcigid3JpdGUiKTsKCQlleGl0KDEpOwoJfQoKCS8qIHdyaXRlIHRvIHRo
ZSBuZXcgc3BhY2UgaW4gdGhlIGZpcnN0IHBhZ2UgKi8KCSoocCArIDQ5ICogMTAyNCkgPSAx
OwoKCW11bm1hcChwLCAxMjggKiAxMDI0KTsKCgljaGVja19maWVtYXAoZmQpOwoKCWNsb3Nl
KGZkKTsKCglyZXR1cm4gMDsKfQoKCg==
--------------020006060009080800090009--

