From: Amir Goldor <amir73il@users.sourceforge.net>
Subject: Re: Errors reported by Coverity in ext3
Date: Thu, 16 Apr 2009 12:30:27 +0300
Message-ID: <18730dc50904160230ue3cbdccqd223e0a6f2edf06e@mail.gmail.com>
References: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
	 <20090413220240.GT17302@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636c5aa7cea4afc0467a8b652
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53017 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZDPJa3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Apr 2009 05:30:29 -0400
Received: by bwz17 with SMTP id 17so290625bwz.37
        for <linux-ext4@vger.kernel.org>; Thu, 16 Apr 2009 02:30:27 -0700 (PDT)
In-Reply-To: <20090413220240.GT17302@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001636c5aa7cea4afc0467a8b652
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Here it is.

Also, the patch that you posted back in 2006 mostly handled
jbd error check for "retaking write access" in ext3_clear_blocks().
Do you have a newer patch for that? are you still using that old patch?

Thanks,
Amir.

On Tue, Apr 14, 2009 at 1:02 AM, Andreas Dilger <adilger@sun.com> wrote:
>
> On Apr 12, 2009 =A014:58 +0300, Amir Goldor wrote:
> > in reply to your message from 2006
> > (http://marc.info/?l=3Dlinux-ext4&m=3D116310729115980&w=3D2)
> > I have prepared a small patch to check jbd errors on 4 occurrences in n=
amei.c
> > could you please review my patch
>
> Could you please regenerate your patch with "diff -up" so that the
> function names are included into the patch context.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>

--001636c5aa7cea4afc0467a8b652
Content-Type: application/octet-stream;
	name="ext3-namei-check-jbd-errors-2.6.28.patch"
Content-Disposition: attachment;
	filename="ext3-namei-check-jbd-errors-2.6.28.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftl9477y0

ZGlmZiAtdXAgbGludXgtMi42LjI4Lm9yaWcvZnMvZXh0My9uYW1laS5jIGxpbnV4LTIuNi4yOC9m
cy9leHQzL25hbWVpLmMKLS0tIGxpbnV4LTIuNi4yOC5vcmlnL2ZzL2V4dDMvbmFtZWkuYwkyMDA5
LTA0LTE2IDEyOjExOjQ0LjAwMDAwMDAwMCArMDMwMAorKysgbGludXgtMi42LjI4L2ZzL2V4dDMv
bmFtZWkuYwkyMDA5LTA0LTE2IDEyOjEzOjMyLjAwMDAwMDAwMCArMDMwMApAQCAtMTYxNiw3ICsx
NjE2LDcgQEAgc3RhdGljIGludCBleHQzX2RlbGV0ZV9lbnRyeSAoaGFuZGxlX3QgKgogCQkJICAg
ICAgc3RydWN0IGJ1ZmZlcl9oZWFkICogYmgpCiB7CiAJc3RydWN0IGV4dDNfZGlyX2VudHJ5XzIg
KiBkZSwgKiBwZGU7Ci0JaW50IGk7CisJaW50IGksIGVycjsKIAogCWkgPSAwOwogCXBkZSA9IE5V
TEw7CkBAIC0xNjI2LDcgKzE2MjYsOSBAQCBzdGF0aWMgaW50IGV4dDNfZGVsZXRlX2VudHJ5ICho
YW5kbGVfdCAqCiAJCQlyZXR1cm4gLUVJTzsKIAkJaWYgKGRlID09IGRlX2RlbCkgIHsKIAkJCUJV
RkZFUl9UUkFDRShiaCwgImdldF93cml0ZV9hY2Nlc3MiKTsKLQkJCWV4dDNfam91cm5hbF9nZXRf
d3JpdGVfYWNjZXNzKGhhbmRsZSwgYmgpOworCQkJZXJyID0gZXh0M19qb3VybmFsX2dldF93cml0
ZV9hY2Nlc3MoaGFuZGxlLCBiaCk7CisJCQlpZiAoZXJyKQorCQkJCXJldHVybiBlcnI7CiAJCQlp
ZiAocGRlKQogCQkJCXBkZS0+cmVjX2xlbiA9IGV4dDNfcmVjX2xlbl90b19kaXNrKAogCQkJCQll
eHQzX3JlY19sZW5fZnJvbV9kaXNrKHBkZS0+cmVjX2xlbikgKwpAQCAtMTc3MCw3ICsxNzcyLDEz
IEBAIHJldHJ5OgogCQlnb3RvIG91dF9zdG9wOwogCX0KIAlCVUZGRVJfVFJBQ0UoZGlyX2Jsb2Nr
LCAiZ2V0X3dyaXRlX2FjY2VzcyIpOwotCWV4dDNfam91cm5hbF9nZXRfd3JpdGVfYWNjZXNzKGhh
bmRsZSwgZGlyX2Jsb2NrKTsKKwllcnIgPSBleHQzX2pvdXJuYWxfZ2V0X3dyaXRlX2FjY2Vzcyho
YW5kbGUsIGRpcl9ibG9jayk7CisJaWYgKGVycikgeworCQlkcm9wX25saW5rKGlub2RlKTsgLyog
aXMgdGhpcyBubGluayA9PSAwPyAqLworCQlleHQzX21hcmtfaW5vZGVfZGlydHkoaGFuZGxlLCBp
bm9kZSk7CisJCWlwdXQgKGlub2RlKTsKKwkJZ290byBvdXRfc3RvcDsKKwl9CiAJZGUgPSAoc3Ry
dWN0IGV4dDNfZGlyX2VudHJ5XzIgKikgZGlyX2Jsb2NrLT5iX2RhdGE7CiAJZGUtPmlub2RlID0g
Y3B1X3RvX2xlMzIoaW5vZGUtPmlfaW5vKTsKIAlkZS0+bmFtZV9sZW4gPSAxOwpAQCAtMjMwMiw3
ICsyMzEwLDkgQEAgc3RhdGljIGludCBleHQzX3JlbmFtZSAoc3RydWN0IGlub2RlICogbwogCQkJ
Z290byBlbmRfcmVuYW1lOwogCX0gZWxzZSB7CiAJCUJVRkZFUl9UUkFDRShuZXdfYmgsICJnZXQg
d3JpdGUgYWNjZXNzIik7Ci0JCWV4dDNfam91cm5hbF9nZXRfd3JpdGVfYWNjZXNzKGhhbmRsZSwg
bmV3X2JoKTsKKwkJcmV0dmFsID0gZXh0M19qb3VybmFsX2dldF93cml0ZV9hY2Nlc3MoaGFuZGxl
LCBuZXdfYmgpOworCQlpZiAocmV0dmFsKQorCQkJZ290byBlbmRfcmVuYW1lOwogCQluZXdfZGUt
Pmlub2RlID0gY3B1X3RvX2xlMzIob2xkX2lub2RlLT5pX2lubyk7CiAJCWlmIChFWFQzX0hBU19J
TkNPTVBBVF9GRUFUVVJFKG5ld19kaXItPmlfc2IsCiAJCQkJCSAgICAgIEVYVDNfRkVBVFVSRV9J
TkNPTVBBVF9GSUxFVFlQRSkpCkBAIC0yMzYwLDcgKzIzNzAsMTQgQEAgc3RhdGljIGludCBleHQz
X3JlbmFtZSAoc3RydWN0IGlub2RlICogbwogCWV4dDNfdXBkYXRlX2R4X2ZsYWcob2xkX2Rpcik7
CiAJaWYgKGRpcl9iaCkgewogCQlCVUZGRVJfVFJBQ0UoZGlyX2JoLCAiZ2V0X3dyaXRlX2FjY2Vz
cyIpOwotCQlleHQzX2pvdXJuYWxfZ2V0X3dyaXRlX2FjY2VzcyhoYW5kbGUsIGRpcl9iaCk7CisJ
CXJldHZhbCA9IGV4dDNfam91cm5hbF9nZXRfd3JpdGVfYWNjZXNzKGhhbmRsZSwgZGlyX2JoKTsK
KwkJaWYgKHJldHZhbCkgeworCQkJZXh0M193YXJuaW5nKG9sZF9kaXItPmlfc2IsICJleHQzX3Jl
bmFtZSIsCisJCQkJCSJVcGRhdGluZyBuZXcgZGlyZWN0b3J5ICglbHUpIHBhcmVudCBsaW5rLCAl
ZCwgZXJyb3I9JWQiLAorCQkJCQluZXdfZGlyLT5pX2lubywgbmV3X2Rpci0+aV9ubGluaywgcmV0
dmFsKTsKKwkJfQorCX0KKwlpZiAoZGlyX2JoICYmICFyZXR2YWwpIHsKIAkJUEFSRU5UX0lOTyhk
aXJfYmgtPmJfZGF0YSkgPSBjcHVfdG9fbGUzMihuZXdfZGlyLT5pX2lubyk7CiAJCUJVRkZFUl9U
UkFDRShkaXJfYmgsICJjYWxsIGV4dDNfam91cm5hbF9kaXJ0eV9tZXRhZGF0YSIpOwogCQlleHQz
X2pvdXJuYWxfZGlydHlfbWV0YWRhdGEoaGFuZGxlLCBkaXJfYmgpOwo=
--001636c5aa7cea4afc0467a8b652--
