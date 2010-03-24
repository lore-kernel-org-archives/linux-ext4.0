From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by
	CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 12:05:04 +0100
Message-ID: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6497e02f96431048289e6d1
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42750 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0CXLFG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Mar 2010 07:05:06 -0400
Received: by wwe15 with SMTP id 15so4936470wwe.19
        for <linux-ext4@vger.kernel.org>; Wed, 24 Mar 2010 04:05:04 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e6497e02f96431048289e6d1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

today I pulled ext4 for_linus GIT branch into linus-tree (2.6.24-rc2-git1).

Unfortunately, the build breaks here:
...
  CC [M]  fs/ext4/super.o
  CC [M]  sound/isa/wavefront/wavefront_fx.o
  CC [M]  drivers/ata/pata_acpi.o
fs/ext4/super.c: In function =E2=80=98ext4_fill_super=E2=80=99:
fs/ext4/super.c:2553: error: =E2=80=98ext3_fs_type=E2=80=99 undeclared (fir=
st use in
this function)
fs/ext4/super.c:2553: error: (Each undeclared identifier is reported only o=
nce
fs/ext4/super.c:2553: error: for each function it appears in.)
make[5]: *** [fs/ext4/super.o] Error 1
...

While investigating the problem I found several typos in fs/ext4/super.c.
One of them was introduced with:

commit 2c7532a9b5fc3c27775f59e28d5f1ee4b1a1052e
"ext4: Don't use delayed allocation by default when used instead of ext3"

Furthermore, I have set the following CONFIG_EXT*FS* parameters:

$ zgrep CONFIG_EXT /proc/config.gz | grep FS
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
CONFIG_EXT4_FS=3Dm
CONFIG_EXT4_FS_XATTR=3Dy
CONFIG_EXT4_FS_POSIX_ACL=3Dy
CONFIG_EXT4_FS_SECURITY=3Dy

My patch is not fixing the problem, just the typos.
Please have a closer look into it, thanks.

--
Sedat

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git;a=3Dcommit;h=
=3D2c7532a9b5fc3c27775f59e28d5f1ee4b1a1052e

--0016e6497e02f96431048289e6d1
Content-Type: text/x-diff; charset=US-ASCII;
	name="0001-ext4-super.c-Replace-CONTIG_EXT-2-3-_FS-by-CONFIG_EX.patch"
Content-Disposition: attachment;
	filename="0001-ext4-super.c-Replace-CONTIG_EXT-2-3-_FS-by-CONFIG_EX.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g760sel40

RnJvbSBhM2Q1ODg2ZDNjZGFhZGNkYzE1NDQxMzM0N2YyMGNhMmJkYjVjNjE1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDI0IE1hciAyMDEwIDExOjIxOjI0ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gZXh0
NC9zdXBlci5jOiBSZXBsYWNlIENPTlRJR19FWFR7MiwzfV9GUyBieSBDT05GSUdfRVhUezIsM31f
RlMKCk9uZSB0eXBvIHdhcyBpbnRyb2R1Y2VkIHdpdGg6Cgpjb21taXQgMmM3NTMyYTliNWZjM2My
Nzc3NWY1OWUyOGQ1ZjFlZTRiMWExMDUyZQoiZXh0NDogRG9uJ3QgdXNlIGRlbGF5ZWQgYWxsb2Nh
dGlvbiBieSBkZWZhdWx0IHdoZW4gdXNlZCBpbnN0ZWFkIG9mIGV4dDMiCi0tLQogZnMvZXh0NC9z
dXBlci5jIHwgICAgNiArKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAz
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvc3VwZXIuYyBiL2ZzL2V4dDQvc3Vw
ZXIuYwppbmRleCAxYTFjY2Q0Li4xZGJiMzdhIDEwMDY0NAotLS0gYS9mcy9leHQ0L3N1cGVyLmMK
KysrIGIvZnMvZXh0NC9zdXBlci5jCkBAIC03MSw3ICs3MSw3IEBAIHN0YXRpYyBpbnQgZXh0NF9m
cmVlemUoc3RydWN0IHN1cGVyX2Jsb2NrICpzYik7CiBzdGF0aWMgaW50IGV4dDRfZ2V0X3NiKHN0
cnVjdCBmaWxlX3N5c3RlbV90eXBlICpmc190eXBlLCBpbnQgZmxhZ3MsCiAJCSAgICAgICBjb25z
dCBjaGFyICpkZXZfbmFtZSwgdm9pZCAqZGF0YSwgc3RydWN0IHZmc21vdW50ICptbnQpOwogCi0j
aWYgIWRlZmluZWQoQ09OVElHX0VYVDNfRlMpICYmICFkZWZpbmVkKENPTkZJR19FWFQzX0ZTX01P
RFVMRSkgJiYgZGVmaW5lZChDT05GSUdfRVhUNF9VU0VfRk9SX0VYVDIzKQorI2lmICFkZWZpbmVk
KENPTkZJR19FWFQzX0ZTKSAmJiAhZGVmaW5lZChDT05GSUdfRVhUM19GU19NT0RVTEUpICYmIGRl
ZmluZWQoQ09ORklHX0VYVDRfVVNFX0ZPUl9FWFQyMykKIHN0YXRpYyBzdHJ1Y3QgZmlsZV9zeXN0
ZW1fdHlwZSBleHQzX2ZzX3R5cGUgPSB7CiAJLm93bmVyCQk9IFRISVNfTU9EVUxFLAogCS5uYW1l
CQk9ICJleHQzIiwKQEAgLTQwODAsNyArNDA4MCw3IEBAIHN0YXRpYyBpbnQgZXh0NF9nZXRfc2Io
c3RydWN0IGZpbGVfc3lzdGVtX3R5cGUgKmZzX3R5cGUsIGludCBmbGFncywKIAlyZXR1cm4gZ2V0
X3NiX2JkZXYoZnNfdHlwZSwgZmxhZ3MsIGRldl9uYW1lLCBkYXRhLCBleHQ0X2ZpbGxfc3VwZXIs
bW50KTsKIH0KIAotI2lmICFkZWZpbmVkKENPTlRJR19FWFQyX0ZTKSAmJiAhZGVmaW5lZChDT05G
SUdfRVhUMl9GU19NT0RVTEUpICYmIGRlZmluZWQoQ09ORklHX0VYVDRfVVNFX0ZPUl9FWFQyMykK
KyNpZiAhZGVmaW5lZChDT05GSUdfRVhUMl9GUykgJiYgIWRlZmluZWQoQ09ORklHX0VYVDJfRlNf
TU9EVUxFKSAmJiBkZWZpbmVkKENPTkZJR19FWFQ0X1VTRV9GT1JfRVhUMjMpCiBzdGF0aWMgc3Ry
dWN0IGZpbGVfc3lzdGVtX3R5cGUgZXh0Ml9mc190eXBlID0gewogCS5vd25lcgkJPSBUSElTX01P
RFVMRSwKIAkubmFtZQkJPSAiZXh0MiIsCkBAIC00MTA3LDcgKzQxMDcsNyBAQCBzdGF0aWMgaW5s
aW5lIHZvaWQgcmVnaXN0ZXJfYXNfZXh0Mih2b2lkKSB7IH0KIHN0YXRpYyBpbmxpbmUgdm9pZCB1
bnJlZ2lzdGVyX2FzX2V4dDIodm9pZCkgeyB9CiAjZW5kaWYKIAotI2lmICFkZWZpbmVkKENPTlRJ
R19FWFQzX0ZTKSAmJiAhZGVmaW5lZChDT05GSUdfRVhUM19GU19NT0RVTEUpICYmIGRlZmluZWQo
Q09ORklHX0VYVDRfVVNFX0ZPUl9FWFQyMykKKyNpZiAhZGVmaW5lZChDT05GSUdfRVhUM19GUykg
JiYgIWRlZmluZWQoQ09ORklHX0VYVDNfRlNfTU9EVUxFKSAmJiBkZWZpbmVkKENPTkZJR19FWFQ0
X1VTRV9GT1JfRVhUMjMpCiBzdGF0aWMgaW5saW5lIHZvaWQgcmVnaXN0ZXJfYXNfZXh0Myh2b2lk
KQogewogCWludCBlcnIgPSByZWdpc3Rlcl9maWxlc3lzdGVtKCZleHQzX2ZzX3R5cGUpOwotLSAK
MS43LjAuMwoK
--0016e6497e02f96431048289e6d1--
