From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Wed, 13 Aug 2008 17:21:20 -0400
Message-ID: <170fa0d20808131421j3e4955dcra611509f1a094547@mail.gmail.com>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at>
	 <20080801121658.GG8736@mit.edu>
	 <1217933631.14552.45.camel@kannnix.a2x.lan.at>
	 <20080806140722.GA14109@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_121966_12637926.1218662480649"
Cc: "Thomas Trauner" <tt@it-austria.net>, linux-ext4@vger.kernel.org,
	ext3-users <ext3-users@redhat.com>
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:47996 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYHMVVV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Aug 2008 17:21:21 -0400
Received: by wa-out-1112.google.com with SMTP id j37so89541waf.23
        for <linux-ext4@vger.kernel.org>; Wed, 13 Aug 2008 14:21:20 -0700 (PDT)
In-Reply-To: <20080806140722.GA14109@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

------=_Part_121966_12637926.1218662480649
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 6, 2008 at 10:07 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Tue, Aug 05, 2008 at 12:53:51PM +0200, Thomas Trauner wrote:
>> On Fri, 2008-08-01 at 08:16 -0400, Theodore Tso wrote:
>> > On Fri, Aug 01, 2008 at 11:43:40AM +0200, Thomas Trauner wrote:
>> > >
>> > > I have a problem with directories that contain more than 10000 entries
>> > > (Ubuntu 8.04.1) or with more than 70000 entries (RHEL 5.2). If you use
>> > > readdir(3) or readdir64(3) you get one entry twice, with same name and
>> > > inode.
>> > >
>> I made new tests with the code under
>> <http://www.unet.univie.ac.at/~a9100884/readdir.c> on a bunch of freshly
>> generated and empty filesystems, every about 38GB large, of type fat
>> (aborted after about 22000 entries because it took to long), ext2, xfs,
>> jfs and again ext3....
>
> OK, I have a workaroud for you.  It appears there's a kernel bug
> hiding here, since there shouldn't be duplicates returned by readdir()
> even if we have hash collisions.

Ted,

The attached patch has served my employer (IBRIX) well for 2.5 years.
It was only recently, when I re-raised this issue internally based on
this thread, that a co-worker recalled the fix.

regards,
Mike

------=_Part_121966_12637926.1218662480649
Content-Type: text/x-patch; name=ext3_dx_readdir_hash_collision_fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjufvxdd0
Content-Disposition: attachment;
 filename=ext3_dx_readdir_hash_collision_fix.patch

ZGlmZiAtLWdpdCBhL2ZzL2V4dDMvZGlyLmMgYi9mcy9leHQzL2Rpci5jCmluZGV4IDJlZWE5NmUu
LjQyYzUzOTEgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDMvZGlyLmMKKysrIGIvZnMvZXh0My9kaXIuYwpA
QCAtNDEwLDcgKzQxMCw3IEBAIHN0YXRpYyBpbnQgY2FsbF9maWxsZGlyKHN0cnVjdCBmaWxlICog
ZmlscCwgdm9pZCAqIGRpcmVudCwKIAkJCQlnZXRfZHR5cGUoc2IsIGZuYW1lLT5maWxlX3R5cGUp
KTsKIAkJaWYgKGVycm9yKSB7CiAJCQlmaWxwLT5mX3BvcyA9IGN1cnJfcG9zOwotCQkJaW5mby0+
ZXh0cmFfZm5hbWUgPSBmbmFtZS0+bmV4dDsKKwkJCWluZm8tPmV4dHJhX2ZuYW1lID0gZm5hbWU7
CiAJCQlyZXR1cm4gZXJyb3I7CiAJCX0KIAkJZm5hbWUgPSBmbmFtZS0+bmV4dDsKQEAgLTQ0OSwx
MSArNDQ5LDIxIEBAIHN0YXRpYyBpbnQgZXh0M19keF9yZWFkZGlyKHN0cnVjdCBmaWxlICogZmls
cCwKIAkgKiBJZiB0aGVyZSBhcmUgYW55IGxlZnRvdmVyIG5hbWVzIG9uIHRoZSBoYXNoIGNvbGxp
c2lvbgogCSAqIGNoYWluLCByZXR1cm4gdGhlbSBmaXJzdC4KIAkgKi8KLQlpZiAoaW5mby0+ZXh0
cmFfZm5hbWUgJiYKLQkgICAgY2FsbF9maWxsZGlyKGZpbHAsIGRpcmVudCwgZmlsbGRpciwgaW5m
by0+ZXh0cmFfZm5hbWUpKQotCQlnb3RvIGZpbmlzaGVkOwotCi0JaWYgKCFpbmZvLT5jdXJyX25v
ZGUpCisJaWYgKGluZm8tPmV4dHJhX2ZuYW1lKSB7CisgICAgICAgICAgICAgICAgaWYgKGNhbGxf
ZmlsbGRpcihmaWxwLCBkaXJlbnQsIGZpbGxkaXIsIGluZm8tPmV4dHJhX2ZuYW1lKSkKKyAgICAg
ICAgICAgICAgICAgICAgICAgIGdvdG8gZmluaXNoZWQ7CisKKyAgICAgICAgICAgICAgICBpbmZv
LT5leHRyYV9mbmFtZSA9IE5VTEw7CisgICAgICAgICAgICAgICAgaW5mby0+Y3Vycl9ub2RlID0g
cmJfbmV4dChpbmZvLT5jdXJyX25vZGUpOworICAgICAgICAgICAgICAgIGlmICghaW5mby0+Y3Vy
cl9ub2RlKSB7CisgICAgICAgICAgICAgICAgICAgICAgICBpZiAoaW5mby0+bmV4dF9oYXNoID09
IH4wKSB7CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpbHAtPmZfcG9zID0gRVhU
M19IVFJFRV9FT0Y7CisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZmluaXNo
ZWQ7CisgICAgICAgICAgICAgICAgICAgICAgICB9CisgICAgICAgICAgICAgICAgICAgICAgICBp
bmZvLT5jdXJyX2hhc2ggPSBpbmZvLT5uZXh0X2hhc2g7CisgICAgICAgICAgICAgICAgICAgICAg
ICBpbmZvLT5jdXJyX21pbm9yX2hhc2ggPSAwOworICAgICAgICAgICAgICAgIH0KKyAgICAgICAg
fSBlbHNlIGlmICghaW5mby0+Y3Vycl9ub2RlKQogCQlpbmZvLT5jdXJyX25vZGUgPSByYl9maXJz
dCgmaW5mby0+cm9vdCk7CiAKIAl3aGlsZSAoMSkgewo=
------=_Part_121966_12637926.1218662480649--
