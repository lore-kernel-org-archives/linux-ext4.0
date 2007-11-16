From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] ext3,4:fdatasync should skip metadata writeout
Date: Fri, 16 Nov 2007 11:47:27 +0900
Message-ID: <6.0.0.20.2.20071116114652.03b9e4e8@172.19.0.2>
Mime-Version: 1.0
Content-Type: multipart/mixed;	boundary="=====================_5216595==_"
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:35741 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbXKPDVo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2007 22:21:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=====================_5216595==_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi.
Currently fdatasync is identical to fsync in ext3,4.
I think fdatasync should skip journal flush in data=ordered and data=writeback mode
because this syscall is not required to synchronize the metadata.

My patch as below is similar to the approach of GFS2's fsync code(gfs2_fsync).

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

diff -Nrup linux-2.6.24-rc2.org/fs/ext3/fsync.c linux-2.6.24-rc2/fs/ext3/fsync.c
--- linux-2.6.24-rc2.org/fs/ext3/fsync.c	2007-11-07 06:57:46.000000000 +0900
+++ linux-2.6.24-rc2/fs/ext3/fsync.c	2007-11-15 17:50:24.000000000 +0900
@@ -72,6 +72,9 @@ int ext3_sync_file(struct file * file, s
 		goto out;
 	}
 
+	if (datasync)
+		goto out;	
+
 	/*
 	* The VFS has written the file data.  If the inode is unaltered
 	* then we need not start a commit.
diff -Nrup linux-2.6.24-rc2.org/fs/ext4/fsync.c linux-2.6.24-rc2/fs/ext4/fsync.c
--- linux-2.6.24-rc2.org/fs/ext4/fsync.c	2007-11-07 06:57:46.000000000 +0900
+++ linux-2.6.24-rc2/fs/ext4/fsync.c	2007-11-15 17:50:54.000000000 +0900
@@ -72,6 +72,9 @@ int ext4_sync_file(struct file * file, s
 		goto out;
 	}
 
+	if (datasync)
+		goto out;
+
 	/*
 	* The VFS has written the file data.  If the inode is unaltered
 	* then we need not start a commit.
--=====================_5216595==_
Content-Type: application/octet-stream; name="patch-2624rc2-ext34-fdatasync.txt";
 x-mac-type="54455854"; x-mac-creator="74747874"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="patch-2624rc2-ext34-fdatasync.txt"

ZGlmZiAtTnJ1cCBsaW51eC0yLjYuMjQtcmMyLm9yZy9mcy9leHQzL2ZzeW5jLmMgbGludXgtMi42
LjI0LXJjMi9mcy9leHQzL2ZzeW5jLmMNCi0tLSBsaW51eC0yLjYuMjQtcmMyLm9yZy9mcy9leHQz
L2ZzeW5jLmMJMjAwNy0xMS0wNyAwNjo1Nzo0Ni4wMDAwMDAwMDAgKzA5MDANCisrKyBsaW51eC0y
LjYuMjQtcmMyL2ZzL2V4dDMvZnN5bmMuYwkyMDA3LTExLTE1IDE3OjUwOjI0LjAwMDAwMDAwMCAr
MDkwMA0KQEAgLTcyLDYgKzcyLDkgQEAgaW50IGV4dDNfc3luY19maWxlKHN0cnVjdCBmaWxlICog
ZmlsZSwgcw0KIAkJZ290byBvdXQ7DQogCX0NCiANCisJaWYgKGRhdGFzeW5jKQ0KKwkJZ290byBv
dXQ7CQ0KKw0KIAkvKg0KIAkgKiBUaGUgVkZTIGhhcyB3cml0dGVuIHRoZSBmaWxlIGRhdGEuICBJ
ZiB0aGUgaW5vZGUgaXMgdW5hbHRlcmVkDQogCSAqIHRoZW4gd2UgbmVlZCBub3Qgc3RhcnQgYSBj
b21taXQuDQpkaWZmIC1OcnVwIGxpbnV4LTIuNi4yNC1yYzIub3JnL2ZzL2V4dDQvZnN5bmMuYyBs
aW51eC0yLjYuMjQtcmMyL2ZzL2V4dDQvZnN5bmMuYw0KLS0tIGxpbnV4LTIuNi4yNC1yYzIub3Jn
L2ZzL2V4dDQvZnN5bmMuYwkyMDA3LTExLTA3IDA2OjU3OjQ2LjAwMDAwMDAwMCArMDkwMA0KKysr
IGxpbnV4LTIuNi4yNC1yYzIvZnMvZXh0NC9mc3luYy5jCTIwMDctMTEtMTUgMTc6NTA6NTQuMDAw
MDAwMDAwICswOTAwDQpAQCAtNzIsNiArNzIsOSBAQCBpbnQgZXh0NF9zeW5jX2ZpbGUoc3RydWN0
IGZpbGUgKiBmaWxlLCBzDQogCQlnb3RvIG91dDsNCiAJfQ0KIA0KKwlpZiAoZGF0YXN5bmMpDQor
CQlnb3RvIG91dDsNCisNCiAJLyoNCiAJICogVGhlIFZGUyBoYXMgd3JpdHRlbiB0aGUgZmlsZSBk
YXRhLiAgSWYgdGhlIGlub2RlIGlzIHVuYWx0ZXJlZA0KIAkgKiB0aGVuIHdlIG5lZWQgbm90IHN0
YXJ0IGEgY29tbWl0Lg0K
--=====================_5216595==_--
