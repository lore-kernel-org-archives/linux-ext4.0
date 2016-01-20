From: "vikram.jadhav07" <vikramjadhavpucsd2007@gmail.com>
Subject: [PATCH] ext4: Buffer Head Leak In mmp
Date: Wed, 20 Jan 2016 21:18:02 +0530
Message-ID: <CAJ-febOhan58G=Aw+-CD6OD2iKuFY3dxkzBfVMCwBd6vXs1rFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e013cbeb4481a7d0529c5e9dc
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38292 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbcATPsE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2016 10:48:04 -0500
Received: by mail-ig0-f178.google.com with SMTP id mw1so14699951igb.1
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2016 07:48:03 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--089e013cbeb4481a7d0529c5e9dc
Content-Type: text/plain; charset=UTF-8

Description:  ext4: Buffer Head Leak In mmp

There is memory leak as both caller function kmmpd() and callee
read_mmp_block() not releasing bh_check  (i.e buffer_head).
Given patch fixes this problem.

Signed-off-by: Jadhav Vikram <vikramjadhavpucsd2007@gmail.com>

Patch:
=====
--- /root/linux.orig/fs/ext4/mmp.c      2016-01-18 07:23:06.227519005 +0530
+++ /root/linux/fs/ext4/mmp.c   2016-01-18 07:31:18.545518552 +0530
@@ -98,12 +98,17 @@
        }

        mmp = (struct mmp_struct *)((*bh)->b_data);
-       if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC)
+       if (le32_to_cpu(mmp->mmp_magic) != EXT4_MMP_MAGIC) {
                ret = -EFSCORRUPTED;
-       else if (!ext4_mmp_csum_verify(sb, mmp))
+               brelse(*bh);
+               *bh = NULL;
+       } else if (!ext4_mmp_csum_verify(sb, mmp)) {
                ret = -EFSBADCRC;
-       else
+               brelse(*bh);
+               *bh = NULL;
+       } else {
                return 0;
+       }

 warn_exit:
        ext4_warning(sb, "Error %d while reading MMP block %llu",
@@ -225,6 +230,7 @@
                                             "The filesystem seems to have been"
                                             " multiply mounted.");
                                ext4_error(sb, "abort");
+                               put_bh(bh_check);
                                goto failed;
                        }
                        put_bh(bh_check);

--089e013cbeb4481a7d0529c5e9dc
Content-Type: application/octet-stream; name="ext4-mmp-brelse.patch"
Content-Disposition: attachment; filename="ext4-mmp-brelse.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ijmzp5s60

LS0tIC9yb290L2xpbnV4Lm9yaWcvZnMvZXh0NC9tbXAuYwkyMDE2LTAxLTE4IDA3OjIzOjA2LjIy
NzUxOTAwNSArMDUzMAorKysgL3Jvb3QvbGludXgvZnMvZXh0NC9tbXAuYwkyMDE2LTAxLTE4IDA3
OjMxOjE4LjU0NTUxODU1MiArMDUzMApAQCAtOTgsMTIgKzk4LDE3IEBACiAJfQogCiAJbW1wID0g
KHN0cnVjdCBtbXBfc3RydWN0ICopKCgqYmgpLT5iX2RhdGEpOwotCWlmIChsZTMyX3RvX2NwdSht
bXAtPm1tcF9tYWdpYykgIT0gRVhUNF9NTVBfTUFHSUMpCisJaWYgKGxlMzJfdG9fY3B1KG1tcC0+
bW1wX21hZ2ljKSAhPSBFWFQ0X01NUF9NQUdJQykgewogCQlyZXQgPSAtRUZTQ09SUlVQVEVEOwot
CWVsc2UgaWYgKCFleHQ0X21tcF9jc3VtX3ZlcmlmeShzYiwgbW1wKSkKKwkJYnJlbHNlKCpiaCk7
CisJCSpiaCA9IE5VTEw7CisJfSBlbHNlIGlmICghZXh0NF9tbXBfY3N1bV92ZXJpZnkoc2IsIG1t
cCkpIHsKIAkJcmV0ID0gLUVGU0JBRENSQzsKLQllbHNlCisJCWJyZWxzZSgqYmgpOworCQkqYmgg
PSBOVUxMOworCX0gZWxzZSB7CiAJCXJldHVybiAwOworCX0KIAogd2Fybl9leGl0OgogCWV4dDRf
d2FybmluZyhzYiwgIkVycm9yICVkIHdoaWxlIHJlYWRpbmcgTU1QIGJsb2NrICVsbHUiLApAQCAt
MjI1LDYgKzIzMCw3IEBACiAJCQkJCSAgICAgIlRoZSBmaWxlc3lzdGVtIHNlZW1zIHRvIGhhdmUg
YmVlbiIKIAkJCQkJICAgICAiIG11bHRpcGx5IG1vdW50ZWQuIik7CiAJCQkJZXh0NF9lcnJvcihz
YiwgImFib3J0Iik7CisJCQkJcHV0X2JoKGJoX2NoZWNrKTsKIAkJCQlnb3RvIGZhaWxlZDsKIAkJ
CX0KIAkJCXB1dF9iaChiaF9jaGVjayk7Cg==
--089e013cbeb4481a7d0529c5e9dc--
