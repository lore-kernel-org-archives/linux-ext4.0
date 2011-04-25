From: Manish Katiyar <mkatiyar@gmail.com>
Subject: Re: [PATCH 4/5] ext4 : Add missing posix_acl_release() in
 ext4_xattr_set_acl() in error path.
Date: Sun, 24 Apr 2011 17:21:05 -0700
Message-ID: <BANLkTinTywZpzNEk9oMztAfLWoFVJuLAfQ@mail.gmail.com>
References: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64bd5641ac13d04a1b3300b
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	mkatiyar@gmail.com
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53558 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1DYAVZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Apr 2011 20:21:25 -0400
Received: by qwk3 with SMTP id 3so799127qwk.19
        for <linux-ext4@vger.kernel.org>; Sun, 24 Apr 2011 17:21:25 -0700 (PDT)
In-Reply-To: <BANLkTin4PDgtZUHgrPnQbg_0+dN6_Fj_Gg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e64bd5641ac13d04a1b3300b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 24, 2011 at 5:18 PM, Manish Katiyar <mkatiyar@gmail.com> wrote:
> This patch fixes the following.
>
> a) Incase journal transaction allocation fails due to ENOMEM don't
> call ext4_std_error() since it will
> =A0 =A0remount the fs as readonly and logs the message in kernel log.
> b) Call posix_acl_release() incase journal allocation fails in case of
> error paths.
>
>
> Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
> ---
> =A0fs/ext4/acl.c | =A0 =A07 ++++---
> =A01 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index 21eacd7..0c98710 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -354,7 +354,6 @@ ext4_acl_chmod(struct inode *inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4_DATA_=
TRANS_BLOCKS(inode->i_sb));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(handle)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D PTR_ERR(handle);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_std_error(inode->i_sb,=
 error);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D ext4_set_acl(handle, inode, ACL_=
TYPE_ACCESS, clone);
> @@ -450,8 +449,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const
> char *name, const void *value,
>
> =A0retry:
> =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCK=
S(inode->i_sb));
> - =A0 =A0 =A0 if (IS_ERR(handle))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(handle);
> + =A0 =A0 =A0 if (IS_ERR(handle)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D PTR_ERR(handle);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto release_and_out;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0error =3D ext4_set_acl(handle, inode, type, acl);
> =A0 =A0 =A0 =A0ext4_journal_stop(handle);
> =A0 =A0 =A0 =A0if (error =3D=3D -ENOSPC && ext4_should_retry_alloc(inode-=
>i_sb, &retries))
> --
> 1.7.1
>
> --
> Thanks -
> Manish
>



--=20
Thanks -
Manish

--0016e64bd5641ac13d04a1b3300b
Content-Type: text/x-patch; charset=US-ASCII;
	name="0004-This-patch-fixes-the-following.-a-Incase-journal-tra.patch"
Content-Disposition: attachment;
	filename="0004-This-patch-fixes-the-following.-a-Incase-journal-tra.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmwnvfhf0

RnJvbSAzOTBjNWFkZDNkNGMwZGVmYTRhY2JlYmM4NWZiNzQxYjIxNDk1ZjA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW5pc2ggS2F0aXlhciA8bWthdGl5YXJAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI0IEFwciAyMDExIDAxOjM4OjI0IC0wNzAwClN1YmplY3Q6IFtQQVRDSCA0LzVd
IFRoaXMgcGF0Y2ggZml4ZXMgdGhlIGZvbGxvd2luZy4gYSkgSW5jYXNlIGpvdXJuYWwgdHJhbnNh
Y3Rpb24gYWxsb2NhdGlvbiBmYWlscyBkdWUgdG8gRU5PTUVNIGRvbid0IGNhbGwgZXh0NF9zdGRf
ZXJyb3IoKSBzaW5jZSBpdCB3aWxsIHJlbW91bnQgdGhlIGZzIGFzIHJlYWRvbmx5IGFuZCBsb2dz
IHRoZSBtZXNzYWdlIGluIGtlcm5lbCBsb2cuCgpiKSBDYWxsIHBvc2l4X2FjbF9yZWxlYXNlKCkg
aW5jYXNlIGpvdXJuYWwgYWxsb2NhdGlvbiBmYWlscyBpbiBjYXNlCm9mIGVycm9yIHBhdGhzLgoK
U2lnbmVkLW9mZi1ieTogTWFuaXNoIEthdGl5YXIgPG1rYXRpeWFyQGdtYWlsLmNvbT4KLS0tCiBm
cy9leHQ0L2FjbC5jIHwgICAgNyArKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9leHQ0L2FjbC5jIGIvZnMvZXh0
NC9hY2wuYwppbmRleCAyMWVhY2Q3Li4wYzk4NzEwIDEwMDY0NAotLS0gYS9mcy9leHQ0L2FjbC5j
CisrKyBiL2ZzL2V4dDQvYWNsLmMKQEAgLTM1NCw3ICszNTQsNiBAQCBleHQ0X2FjbF9jaG1vZChz
dHJ1Y3QgaW5vZGUgKmlub2RlKQogCQkJCUVYVDRfREFUQV9UUkFOU19CTE9DS1MoaW5vZGUtPmlf
c2IpKTsKIAkJaWYgKElTX0VSUihoYW5kbGUpKSB7CiAJCQllcnJvciA9IFBUUl9FUlIoaGFuZGxl
KTsKLQkJCWV4dDRfc3RkX2Vycm9yKGlub2RlLT5pX3NiLCBlcnJvcik7CiAJCQlnb3RvIG91dDsK
IAkJfQogCQllcnJvciA9IGV4dDRfc2V0X2FjbChoYW5kbGUsIGlub2RlLCBBQ0xfVFlQRV9BQ0NF
U1MsIGNsb25lKTsKQEAgLTQ1MCw4ICs0NDksMTAgQEAgZXh0NF94YXR0cl9zZXRfYWNsKHN0cnVj
dCBkZW50cnkgKmRlbnRyeSwgY29uc3QgY2hhciAqbmFtZSwgY29uc3Qgdm9pZCAqdmFsdWUsCiAK
IHJldHJ5OgogCWhhbmRsZSA9IGV4dDRfam91cm5hbF9zdGFydChpbm9kZSwgRVhUNF9EQVRBX1RS
QU5TX0JMT0NLUyhpbm9kZS0+aV9zYikpOwotCWlmIChJU19FUlIoaGFuZGxlKSkKLQkJcmV0dXJu
IFBUUl9FUlIoaGFuZGxlKTsKKwlpZiAoSVNfRVJSKGhhbmRsZSkpIHsKKwkJZXJyb3IgPSBQVFJf
RVJSKGhhbmRsZSk7CisJCWdvdG8gcmVsZWFzZV9hbmRfb3V0OworCX0KIAllcnJvciA9IGV4dDRf
c2V0X2FjbChoYW5kbGUsIGlub2RlLCB0eXBlLCBhY2wpOwogCWV4dDRfam91cm5hbF9zdG9wKGhh
bmRsZSk7CiAJaWYgKGVycm9yID09IC1FTk9TUEMgJiYgZXh0NF9zaG91bGRfcmV0cnlfYWxsb2Mo
aW5vZGUtPmlfc2IsICZyZXRyaWVzKSkKLS0gCjEuNy4xCgo=
--0016e64bd5641ac13d04a1b3300b--
