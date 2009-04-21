From: Amir Goldor <amir73il@users.sourceforge.net>
Subject: Re: Errors reported by Coverity in ext3
Date: Tue, 21 Apr 2009 12:01:55 +0300
Message-ID: <18730dc50904210201h454e9790y434e35c364dbb9d1@mail.gmail.com>
References: <18730dc50904120458m1649aaf7tab395436d159105a@mail.gmail.com>
	 <20090413220240.GT17302@webber.adilger.int>
	 <18730dc50904160230ue3cbdccqd223e0a6f2edf06e@mail.gmail.com>
	 <20090420221441.GI3209@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636c5bbd1169a0f04680ce6b5
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50500 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbZDUJB6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2009 05:01:58 -0400
Received: by fxm2 with SMTP id 2so2397441fxm.37
        for <linux-ext4@vger.kernel.org>; Tue, 21 Apr 2009 02:01:56 -0700 (PDT)
In-Reply-To: <20090420221441.GI3209@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--001636c5bbd1169a0f04680ce6b5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Thanks for your corrections.

Attached is a new patch against kernel 2.6.29.1.
I applied most of your corrections, see my comments inline.
Please review take #2.

Thanks,
Amir.

On Tue, Apr 21, 2009 at 1:14 AM, Andreas Dilger <adilger@sun.com> wrote:
>
> Thanks for the patch, unfortunately it is a NACK, since there are a few
> bugs in the error handling, and some additional cleanups that can be done=
.
>
> More comments inline.
>
>> @@ -2302,7 +2310,9 @@ static int ext3_rename (struct inode * o
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(new_bh, "get write access");
>> - =A0 =A0 =A0 =A0 =A0 =A0 ext3_journal_get_write_access(handle, new_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_get_write_access(handl=
e, new_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto end_rename;
>
> Similarly, this also needs a "brelse(new_bh)" before "goto end_rename".

brelse(new_bh) as well as brelse(dir_bh) are called on end_rename.

>
>> @@ -2360,7 +2370,14 @@ static int ext3_rename (struct inode * o
>> =A0 =A0 =A0 ext3_update_dx_flag(old_dir);
>> =A0 =A0 =A0 if (dir_bh) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUFFER_TRACE(dir_bh, "get_write_access");
>> + =A0 =A0 =A0 =A0 =A0 =A0 retval =3D ext3_journal_get_write_access(handl=
e, dir_bh);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (retval) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3_warning(old_dir->i_sb, "e=
xt3_rename",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 "Updating new directory (%lu) parent link, %d, error=3D%d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 new_dir->i_ino, new_dir->i_nlink, retval);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>
> At this point, if we cannot get write access to the directory buffer, it
> is really a bit too late to do much about it. =A0It may make more sense t=
o
> instead call ext3_journal_get_write_access() right after ext3_bread() is
> called dor this buffer, so that the error can be checked and the rename
> aborted before any changes are made.
>

good idea. I moved it up.

> Note also that there are some places where ext3_journal_dirty_metadata()
> are called in these same code paths, but the error is not checked by the
> caller.
>

true, but as with the case above, handling errors before the changes
are made is much easier,
and I am only aiming for 'best effort' in this patch.

--001636c5bbd1169a0f04680ce6b5
Content-Type: application/octet-stream;
	name="ext3-namei-check-jbd-errors-2.6.29.1.patch"
Content-Disposition: attachment;
	filename="ext3-namei-check-jbd-errors-2.6.29.1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftscua8l0

ZGlmZiAtdXAgbGludXgtMi42LjI5LjEub3JpZy9mcy9leHQzL25hbWVpLmMgbGludXgtMi42LjI5
LjEvZnMvZXh0My9uYW1laS5jCi0tLSBsaW51eC0yLjYuMjkuMS5vcmlnL2ZzL2V4dDMvbmFtZWku
YwkyMDA5LTA0LTIxIDEwOjQ0OjAxLjAwMDAwMDAwMCArMDMwMAorKysgbGludXgtMi42LjI5LjEv
ZnMvZXh0My9uYW1laS5jCTIwMDktMDQtMjEgMTE6MzU6MTIuMDAwMDAwMDAwICswMzAwCkBAIC0x
NjI3LDcgKzE2MjcsNyBAQCBzdGF0aWMgaW50IGV4dDNfZGVsZXRlX2VudHJ5IChoYW5kbGVfdCAq
CiAJCQkgICAgICBzdHJ1Y3QgYnVmZmVyX2hlYWQgKiBiaCkKIHsKIAlzdHJ1Y3QgZXh0M19kaXJf
ZW50cnlfMiAqIGRlLCAqIHBkZTsKLQlpbnQgaTsKKwlpbnQgaSwgZXJyOwogCiAJaSA9IDA7CiAJ
cGRlID0gTlVMTDsKQEAgLTE2MzcsNyArMTYzNyw5IEBAIHN0YXRpYyBpbnQgZXh0M19kZWxldGVf
ZW50cnkgKGhhbmRsZV90ICoKIAkJCXJldHVybiAtRUlPOwogCQlpZiAoZGUgPT0gZGVfZGVsKSAg
ewogCQkJQlVGRkVSX1RSQUNFKGJoLCAiZ2V0X3dyaXRlX2FjY2VzcyIpOwotCQkJZXh0M19qb3Vy
bmFsX2dldF93cml0ZV9hY2Nlc3MoaGFuZGxlLCBiaCk7CisJCQllcnIgPSBleHQzX2pvdXJuYWxf
Z2V0X3dyaXRlX2FjY2VzcyhoYW5kbGUsIGJoKTsKKwkJCWlmIChlcnIpCisJCQkJcmV0dXJuIGVy
cjsKIAkJCWlmIChwZGUpCiAJCQkJcGRlLT5yZWNfbGVuID0gZXh0M19yZWNfbGVuX3RvX2Rpc2so
CiAJCQkJCWV4dDNfcmVjX2xlbl9mcm9tX2Rpc2socGRlLT5yZWNfbGVuKSArCkBAIC0xNzg0LDcg
KzE3ODYsMTUgQEAgcmV0cnk6CiAJCWdvdG8gb3V0X3N0b3A7CiAJfQogCUJVRkZFUl9UUkFDRShk
aXJfYmxvY2ssICJnZXRfd3JpdGVfYWNjZXNzIik7Ci0JZXh0M19qb3VybmFsX2dldF93cml0ZV9h
Y2Nlc3MoaGFuZGxlLCBkaXJfYmxvY2spOworCWVyciA9IGV4dDNfam91cm5hbF9nZXRfd3JpdGVf
YWNjZXNzKGhhbmRsZSwgZGlyX2Jsb2NrKTsKKwlpZiAoZXJyKSB7CisJCWRyb3BfbmxpbmsoaW5v
ZGUpOyAvKiBpcyB0aGlzIG5saW5rID09IDA/ICovCisJCXVubG9ja19uZXdfaW5vZGUoaW5vZGUp
OworCQlleHQzX21hcmtfaW5vZGVfZGlydHkoaGFuZGxlLCBpbm9kZSk7CisJCWlwdXQgKGlub2Rl
KTsKKwkJYnJlbHNlIChkaXJfYmxvY2spOworCQlnb3RvIG91dF9zdG9wOworCX0KIAlkZSA9IChz
dHJ1Y3QgZXh0M19kaXJfZW50cnlfMiAqKSBkaXJfYmxvY2stPmJfZGF0YTsKIAlkZS0+aW5vZGUg
PSBjcHVfdG9fbGUzMihpbm9kZS0+aV9pbm8pOwogCWRlLT5uYW1lX2xlbiA9IDE7CkBAIC0yMzE4
LDYgKzIzMjgsMTAgQEAgc3RhdGljIGludCBleHQzX3JlbmFtZSAoc3RydWN0IGlub2RlICogbwog
CQlpZiAoIW5ld19pbm9kZSAmJiBuZXdfZGlyIT1vbGRfZGlyICYmCiAJCQkJbmV3X2Rpci0+aV9u
bGluayA+PSBFWFQzX0xJTktfTUFYKQogCQkJZ290byBlbmRfcmVuYW1lOworCQlCVUZGRVJfVFJB
Q0UoZGlyX2JoLCAiZ2V0X3dyaXRlX2FjY2VzcyIpOworCQlyZXR2YWwgPSBleHQzX2pvdXJuYWxf
Z2V0X3dyaXRlX2FjY2VzcyhoYW5kbGUsIGRpcl9iaCk7CisJCWlmIChyZXR2YWwpCisJCQlnb3Rv
IGVuZF9yZW5hbWU7CiAJfQogCWlmICghbmV3X2JoKSB7CiAJCXJldHZhbCA9IGV4dDNfYWRkX2Vu
dHJ5IChoYW5kbGUsIG5ld19kZW50cnksIG9sZF9pbm9kZSk7CkBAIC0yMzI1LDcgKzIzMzksOSBA
QCBzdGF0aWMgaW50IGV4dDNfcmVuYW1lIChzdHJ1Y3QgaW5vZGUgKiBvCiAJCQlnb3RvIGVuZF9y
ZW5hbWU7CiAJfSBlbHNlIHsKIAkJQlVGRkVSX1RSQUNFKG5ld19iaCwgImdldCB3cml0ZSBhY2Nl
c3MiKTsKLQkJZXh0M19qb3VybmFsX2dldF93cml0ZV9hY2Nlc3MoaGFuZGxlLCBuZXdfYmgpOwor
CQlyZXR2YWwgPSBleHQzX2pvdXJuYWxfZ2V0X3dyaXRlX2FjY2VzcyhoYW5kbGUsIG5ld19iaCk7
CisJCWlmIChyZXR2YWwpCisJCQlnb3RvIGVuZF9yZW5hbWU7CiAJCW5ld19kZS0+aW5vZGUgPSBj
cHVfdG9fbGUzMihvbGRfaW5vZGUtPmlfaW5vKTsKIAkJaWYgKEVYVDNfSEFTX0lOQ09NUEFUX0ZF
QVRVUkUobmV3X2Rpci0+aV9zYiwKIAkJCQkJICAgICAgRVhUM19GRUFUVVJFX0lOQ09NUEFUX0ZJ
TEVUWVBFKSkKQEAgLTIzODIsOCArMjM5OCw2IEBAIHN0YXRpYyBpbnQgZXh0M19yZW5hbWUgKHN0
cnVjdCBpbm9kZSAqIG8KIAlvbGRfZGlyLT5pX2N0aW1lID0gb2xkX2Rpci0+aV9tdGltZSA9IENV
UlJFTlRfVElNRV9TRUM7CiAJZXh0M191cGRhdGVfZHhfZmxhZyhvbGRfZGlyKTsKIAlpZiAoZGly
X2JoKSB7Ci0JCUJVRkZFUl9UUkFDRShkaXJfYmgsICJnZXRfd3JpdGVfYWNjZXNzIik7Ci0JCWV4
dDNfam91cm5hbF9nZXRfd3JpdGVfYWNjZXNzKGhhbmRsZSwgZGlyX2JoKTsKIAkJUEFSRU5UX0lO
TyhkaXJfYmgtPmJfZGF0YSkgPSBjcHVfdG9fbGUzMihuZXdfZGlyLT5pX2lubyk7CiAJCUJVRkZF
Ul9UUkFDRShkaXJfYmgsICJjYWxsIGV4dDNfam91cm5hbF9kaXJ0eV9tZXRhZGF0YSIpOwogCQll
eHQzX2pvdXJuYWxfZGlydHlfbWV0YWRhdGEoaGFuZGxlLCBkaXJfYmgpOwo=
--001636c5bbd1169a0f04680ce6b5--
