From: Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH, RFC] support discard in non-journal ext4
Date: Thu, 13 May 2010 17:29:45 -0700
Message-ID: <AANLkTinniD1Acxh8CmMd1oE72fzYvmA8aEVWEWB4TS1j@mail.gmail.com>
References: <20100513050014.879651BC316@ruihe.smo.corp.google.com>
	 <4BEBC191.7060305@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e646060add0385048682f80e
Cc: linux-ext4@vger.kernel.org
To: coly.li@suse.de
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:9077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab0ENA3s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 May 2010 20:29:48 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id o4E0Tlko027269
	for <linux-ext4@vger.kernel.org>; Thu, 13 May 2010 17:29:47 -0700
Received: from gyh4 (gyh4.prod.google.com [10.243.50.196])
	by wpaz33.hot.corp.google.com with ESMTP id o4E0Tk1u005879
	for <linux-ext4@vger.kernel.org>; Thu, 13 May 2010 17:29:46 -0700
Received: by gyh4 with SMTP id 4so1002894gyh.31
        for <linux-ext4@vger.kernel.org>; Thu, 13 May 2010 17:29:46 -0700 (PDT)
In-Reply-To: <4BEBC191.7060305@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--0016e646060add0385048682f80e
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, May 13, 2010 at 2:08 AM, Coly Li <coly.li@suse.de> wrote:
>
>
> On 05/13/2010 01:00 PM, Jiaying Zhang Wrote:
> > This patch issues discard request for freed blocks in ext4_free_blocks(=
)
> > if ext4 is mounted with discard option and without journal.
> >
> > Author: Jiaying Zhang <jiayingz@google.com>
> > Date: =A0 Wed May 12 21:11:46 2010 -0700
> >
> > =A0 =A0 Issue discard request in ext4_free_blocks() when ext4 has no jo=
urnal and
> > =A0 =A0 is mounted with discard option.
> >
> > =A0 =A0 Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> >
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index a291cc3..d51b79a 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -2513,6 +2513,22 @@ int ext4_mb_release(struct super_block *sb)
> > =A0 =A0 =A0 return 0;
> > =A0}
> >
> > +static void ext4_issue_discard(struct super_block *sb, ext4_group_t bl=
ock_group,
> > + =A0 =A0 =A0 =A0 =A0 =A0 ext4_grpblk_t block, int count)
> > +{
> > + =A0 =A0 int ret;
> > + =A0 =A0 ext4_fsblk_t discard_block;
> > +
> > + =A0 =A0 discard_block =3D block + ext4_group_first_block_no(sb, block=
_group);
> > + =A0 =A0 trace_ext4_discard_blocks(sb,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned long long) discard_=
block, count);
> > + =A0 =A0 ret =3D sb_issue_discard(sb, discard_block, count);
> > + =A0 =A0 if (ret =3D=3D EOPNOTSUPP) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "discard not supported, disa=
bling");
> > + =A0 =A0 =A0 =A0 =A0 =A0 clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
> > + =A0 =A0 }
> > +}
> > +
>
> How about make it as an inline routine? Thanks.

Ok. I changed it to inline. The modified patch is attached.

Thanks!

Jiaying

>
> --
> Coly Li
> SuSE Labs

--0016e646060add0385048682f80e
Content-Type: text/x-patch; charset=US-ASCII; name="ext4-discard-nojournal.v2.patch"
Content-Disposition: attachment; filename="ext4-discard-nojournal.v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g969tfh10

Y29tbWl0IDQzZTQxODZiNTAyZTEzOTU3NTQ0OTkxYzZhNDU2NDQ3YTZhYTNhYTkKQXV0aG9yOiBK
aWF5aW5nIFpoYW5nIDxqaWF5aW5nekBnb29nbGUuY29tPgpEYXRlOiAgIFdlZCBNYXkgMTIgMjE6
MTE6NDYgMjAxMCAtMDcwMAoKICAgIElzc3VlIGRpc2NhcmQgcmVxdWVzdCBpbiBleHQ0X2ZyZWVf
YmxvY2tzKCkgd2hlbiBleHQ0IGhhcyBubyBqb3VybmFsIGFuZAogICAgaXMgbW91bnRlZCB3aXRo
IGRpc2NhcmQgb3B0aW9uLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBKaWF5aW5nIFpoYW5nIDxq
aWF5aW5nekBnb29nbGUuY29tPgoKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvbWJhbGxvYy5jIGIvZnMv
ZXh0NC9tYmFsbG9jLmMKaW5kZXggYTI5MWNjMy4uZWNhZjdlNyAxMDA2NDQKLS0tIGEvZnMvZXh0
NC9tYmFsbG9jLmMKKysrIGIvZnMvZXh0NC9tYmFsbG9jLmMKQEAgLTI1MTMsNiArMjUxMywyMiBA
QCBpbnQgZXh0NF9tYl9yZWxlYXNlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpCiAJcmV0dXJuIDA7
CiB9CiAKK3N0YXRpYyBpbmxpbmUgdm9pZCBleHQ0X2lzc3VlX2Rpc2NhcmQoc3RydWN0IHN1cGVy
X2Jsb2NrICpzYiwKKwkJZXh0NF9ncm91cF90IGJsb2NrX2dyb3VwLCBleHQ0X2dycGJsa190IGJs
b2NrLCBpbnQgY291bnQpCit7CisJaW50IHJldDsKKwlleHQ0X2ZzYmxrX3QgZGlzY2FyZF9ibG9j
azsKKworCWRpc2NhcmRfYmxvY2sgPSBibG9jayArIGV4dDRfZ3JvdXBfZmlyc3RfYmxvY2tfbm8o
c2IsIGJsb2NrX2dyb3VwKTsKKwl0cmFjZV9leHQ0X2Rpc2NhcmRfYmxvY2tzKHNiLAorCQkJKHVu
c2lnbmVkIGxvbmcgbG9uZykgZGlzY2FyZF9ibG9jaywgY291bnQpOworCXJldCA9IHNiX2lzc3Vl
X2Rpc2NhcmQoc2IsIGRpc2NhcmRfYmxvY2ssIGNvdW50KTsKKwlpZiAocmV0ID09IEVPUE5PVFNV
UFApIHsKKwkJZXh0NF93YXJuaW5nKHNiLCAiZGlzY2FyZCBub3Qgc3VwcG9ydGVkLCBkaXNhYmxp
bmciKTsKKwkJY2xlYXJfb3B0KEVYVDRfU0Ioc2IpLT5zX21vdW50X29wdCwgRElTQ0FSRCk7CisJ
fQorfQorCiAvKgogICogVGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgYnkgdGhlIGpiZDIgbGF5ZXIg
b25jZSB0aGUgY29tbWl0IGhhcyBmaW5pc2hlZCwKICAqIHNvIHdlIGtub3cgd2UgY2FuIGZyZWUg
dGhlIGJsb2NrcyB0aGF0IHdlcmUgcmVsZWFzZWQgd2l0aCB0aGF0IGNvbW1pdC4KQEAgLTI1MzIs
MjIgKzI1NDgsOSBAQCBzdGF0aWMgdm9pZCByZWxlYXNlX2Jsb2Nrc19vbl9jb21taXQoam91cm5h
bF90ICpqb3VybmFsLCB0cmFuc2FjdGlvbl90ICp0eG4pCiAJCW1iX2RlYnVnKDEsICJnb25uYSBm
cmVlICV1IGJsb2NrcyBpbiBncm91cCAldSAoMHglcCk6IiwKIAkJCSBlbnRyeS0+Y291bnQsIGVu
dHJ5LT5ncm91cCwgZW50cnkpOwogCi0JCWlmICh0ZXN0X29wdChzYiwgRElTQ0FSRCkpIHsKLQkJ
CWludCByZXQ7Ci0JCQlleHQ0X2ZzYmxrX3QgZGlzY2FyZF9ibG9jazsKLQotCQkJZGlzY2FyZF9i
bG9jayA9IGVudHJ5LT5zdGFydF9ibGsgKwotCQkJCWV4dDRfZ3JvdXBfZmlyc3RfYmxvY2tfbm8o
c2IsIGVudHJ5LT5ncm91cCk7Ci0JCQl0cmFjZV9leHQ0X2Rpc2NhcmRfYmxvY2tzKHNiLAotCQkJ
CQkodW5zaWduZWQgbG9uZyBsb25nKWRpc2NhcmRfYmxvY2ssCi0JCQkJCWVudHJ5LT5jb3VudCk7
Ci0JCQlyZXQgPSBzYl9pc3N1ZV9kaXNjYXJkKHNiLCBkaXNjYXJkX2Jsb2NrLCBlbnRyeS0+Y291
bnQpOwotCQkJaWYgKHJldCA9PSBFT1BOT1RTVVBQKSB7Ci0JCQkJZXh0NF93YXJuaW5nKHNiLAot
CQkJCQkiZGlzY2FyZCBub3Qgc3VwcG9ydGVkLCBkaXNhYmxpbmciKTsKLQkJCQljbGVhcl9vcHQo
RVhUNF9TQihzYiktPnNfbW91bnRfb3B0LCBESVNDQVJEKTsKLQkJCX0KLQkJfQorCQlpZiAodGVz
dF9vcHQoc2IsIERJU0NBUkQpKQorCQkJZXh0NF9pc3N1ZV9kaXNjYXJkKHNiLCBlbnRyeS0+Z3Jv
dXAsCisJCQkJCWVudHJ5LT5zdGFydF9ibGssIGVudHJ5LT5jb3VudCk7CiAKIAkJZXJyID0gZXh0
NF9tYl9sb2FkX2J1ZGR5KHNiLCBlbnRyeS0+Z3JvdXAsICZlNGIpOwogCQkvKiB3ZSBleHBlY3Qg
dG8gZmluZCBleGlzdGluZyBidWRkeSBiZWNhdXNlIGl0J3MgcGlubmVkICovCkBAIC00NjAwLDYg
KzQ2MDMsOCBAQCBkb19tb3JlOgogCQltYl9jbGVhcl9iaXRzKGJpdG1hcF9iaC0+Yl9kYXRhLCBi
aXQsIGNvdW50KTsKIAkJbWJfZnJlZV9ibG9ja3MoaW5vZGUsICZlNGIsIGJpdCwgY291bnQpOwog
CQlleHQ0X21iX3JldHVybl90b19wcmVhbGxvY2F0aW9uKGlub2RlLCAmZTRiLCBibG9jaywgY291
bnQpOworCQlpZiAodGVzdF9vcHQoc2IsIERJU0NBUkQpKQorCQkJZXh0NF9pc3N1ZV9kaXNjYXJk
KHNiLCBibG9ja19ncm91cCwgYml0LCBjb3VudCk7CiAJfQogCiAJcmV0ID0gZXh0NF9mcmVlX2Js
a3NfY291bnQoc2IsIGdkcCkgKyBjb3VudDsK
--0016e646060add0385048682f80e--
