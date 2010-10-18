From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: linux-2.6-block/for-next: Removal of BLKDEV_IFL_BARRIER and BLKDEV_IFL_WAIT
Date: Mon, 18 Oct 2010 15:01:55 +0200
Message-ID: <AANLkTimrSTJHeWS5t++w_D5SVv4Jqp3kj3pasvcVe2jt@mail.gmail.com>
References: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
	<4CBBF382.4000505@kernel.dk>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=485b397dd013e3eb5e0492e3c735
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46691 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab0JRNB4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Oct 2010 09:01:56 -0400
Received: by qwa26 with SMTP id 26so521355qwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Oct 2010 06:01:55 -0700 (PDT)
In-Reply-To: <4CBBF382.4000505@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--485b397dd013e3eb5e0492e3c735
Content-Type: text/plain; charset=UTF-8

Commit 4bcf787b503fa96c5a2f529ce15807dc670853ed from ext4/next [1]:
"Add helper function for blkdev_issue_zeroout (sb_issue_discard)"

...lead to some rework of my initial patch, so here is v2 attached.

As blkdev_issue_zeroout() has no more "flags", this has to be
considered also in sb_issue_zeroout() and also in my v2 patch.

[ block/blk-lib.c ]
...
int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
                        sector_t nr_sects, gfp_t gfp_mask)
...

Looks like this is compiling w/o errors in fs/ext4 tree.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=4bcf787b503fa96c5a2f529ce15807dc670853ed

On Mon, Oct 18, 2010 at 9:13 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-10-18 02:11, Sedat Dilek wrote:
>> Hi,
>>
>> today, I pulled linux-2.6-block/for-next GIT branch [1] on top of
>> Linus-tree (2.6.36-rc8-git3).
>>
>> Unfortunately, ext4/next GIT branch [2] is not "GIT-pull-able" on top
>> of this local GIT repository.
>> The cause for this is the removal of BLKDEV_IFL_BARRIER and
>> BLKDEV_IFL_WAIT in linux-2.6-block/for-next.
>>
>> As there are few days left for 2.6.36-final, it would be great when
>> ext4/next could be prepared to work with linux-2.6-block/for-next.
>> Thanks in advance.
>
> The argument just has to be removed. linux-next has had a fixup
> patch for this for a long time.
>
> --
> Jens Axboe
>
>

--485b397dd013e3eb5e0492e3c735
Content-Type: text/plain; charset=US-ASCII;
	name="0001-ext4-Remove-BLKDEV_IFL_WAIT-and-BLKDEV_IFL_BARRIER-r-v2.patch"
Content-Disposition: attachment;
	filename="0001-ext4-Remove-BLKDEV_IFL_WAIT-and-BLKDEV_IFL_BARRIER-r-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gffbum8c0

RnJvbSBhYTFmZjMwMDljM2NmOTk3NWNhZjBiYWVhOWMxZjc1MTA3ZjNlYjFlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBNb24sIDE4IE9jdCAyMDEwIDEzOjAxOjA3ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gZXh0
NDogUmVtb3ZlIEJMS0RFVl9JRkxfV0FJVCBhbmQgQkxLREVWX0lGTF9CQVJSSUVSIHJlbGljdHMK
ClRoZXNlIHJlbW92YWxzIHdlcmUgbmVjZXNzYXJ5IGFmdGVyIHB1bGxpbmcgZXh0NC9uZXh0IEdJ
VCBicmFuY2ggb24gdG9wIG9mIGxpbnV4LTIuNi1ibG9jay9mb3ItbmV4dC4KRm9yIG1vcmUgRGV0
YWlscyBzZWUgYWxzbyBbMV0uCgpbMV0gaHR0cDovL21hcmMuaW5mby8/bD1saW51eC1leHQ0Jm09
MTI4NzM2MDY4ODA5ODE0Jnc9MgotLS0KIGZzL2V4dDQvZXh0ZW50cy5jIHwgICAgMiArLQogZnMv
ZXh0NC9pYWxsb2MuYyAgfCAgICAzIC0tLQogZnMvZXh0NC9yZXNpemUuYyAgfCAgICA0ICsrLS0K
IDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvZXh0ZW50cy5jIGIvZnMvZXh0NC9leHRlbnRzLmMKaW5kZXggYTBlNjIz
MC4uYjczOGU2ZiAxMDA2NDQKLS0tIGEvZnMvZXh0NC9leHRlbnRzLmMKKysrIGIvZnMvZXh0NC9l
eHRlbnRzLmMKQEAgLTI1NDYsNyArMjU0Niw3IEBAIHN0YXRpYyBpbnQgZXh0NF9leHRfemVyb291
dChzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZXh0NF9leHRlbnQgKmV4KQogCWVlX3BibG9j
ayA9IGV4dF9wYmxvY2soZXgpOwogCiAJcmV0ID0gc2JfaXNzdWVfemVyb291dChpbm9kZS0+aV9z
YiwgZWVfcGJsb2NrLCBlZV9sZW4sCi0JCQkgICAgICAgR0ZQX05PRlMsIEJMS0RFVl9JRkxfV0FJ
VCk7CisJCQkgICAgICAgR0ZQX05PRlMpOwogCWlmIChyZXQgPiAwKQogCQlyZXQgPSAwOwogCmRp
ZmYgLS1naXQgYS9mcy9leHQ0L2lhbGxvYy5jIGIvZnMvZXh0NC9pYWxsb2MuYwppbmRleCA4N2Qy
MjhhLi5jYzNhMTgwIDEwMDY0NAotLS0gYS9mcy9leHQ0L2lhbGxvYy5jCisrKyBiL2ZzL2V4dDQv
aWFsbG9jLmMKQEAgLTEyMzgsNyArMTIzOCw2IEBAIGV4dGVybiBpbnQgZXh0NF9pbml0X2lub2Rl
X3RhYmxlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGV4dDRfZ3JvdXBfdCBncm91cCwKIAloYW5k
bGVfdCAqaGFuZGxlOwogCWV4dDRfZnNibGtfdCBibGs7CiAJaW50IG51bSwgcmV0ID0gMCwgdXNl
ZF9ibGtzID0gMDsKLQl1bnNpZ25lZCBsb25nIGZsYWdzID0gQkxLREVWX0lGTF9XQUlUOwogCiAJ
LyogVGhpcyBzaG91bGQgbm90IGhhcHBlbiwgYnV0IGp1c3QgdG8gYmUgc3VyZSBjaGVjayB0aGlz
ICovCiAJaWYgKHNiLT5zX2ZsYWdzICYgTVNfUkRPTkxZKSB7CkBAIC0xMzAzLDggKzEzMDIsNiBA
QCBleHRlcm4gaW50IGV4dDRfaW5pdF9pbm9kZV90YWJsZShzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNi
LCBleHQ0X2dyb3VwX3QgZ3JvdXAsCiAKIAlleHQ0X2RlYnVnKCJnb2luZyB0byB6ZXJvIG91dCBp
bm9kZSB0YWJsZSBpbiBncm91cCAlZFxuIiwKIAkJICAgZ3JvdXApOwotCWlmIChiYXJyaWVyKQot
CQlmbGFncyB8PSBCTEtERVZfSUZMX0JBUlJJRVI7CiAJcmV0ID0gc2JfaXNzdWVfemVyb291dChz
YiwgYmxrLCBudW0sIEdGUF9OT0ZTLCBmbGFncyk7CiAJaWYgKHJldCA8IDApCiAJCWdvdG8gZXJy
X291dDsKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvcmVzaXplLmMgYi9mcy9leHQ0L3Jlc2l6ZS5jCmlu
ZGV4IDJmNWUzNDcuLjBmMWYzMGMgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvcmVzaXplLmMKKysrIGIv
ZnMvZXh0NC9yZXNpemUuYwpAQCAtMjI5LDcgKzIyOSw3IEBAIHN0YXRpYyBpbnQgc2V0dXBfbmV3
X2dyb3VwX2Jsb2NrcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCWV4dDRfZGVidWcoImNsZWFy
IGlub2RlIHRhYmxlIGJsb2NrcyAlIzA0bGx4IC0+ICUjMDRsbHhcbiIsCiAJCQlibG9jaywgc2Jp
LT5zX2l0Yl9wZXJfZ3JvdXApOwogCWVyciA9IHNiX2lzc3VlX3plcm9vdXQoc2IsIGdkYmxvY2tz
ICsgc3RhcnQgKyAxLCByZXNlcnZlZF9nZGIsCi0JCQkgICAgICAgR0ZQX05PRlMsIEJMS0RFVl9J
RkxfV0FJVCk7CisJCQkgICAgICAgR0ZQX05PRlMpOwogCWlmIChlcnIpCiAJCWdvdG8gZXhpdF9i
aDsKIApAQCAtMjQ1LDcgKzI0NSw3IEBAIHN0YXRpYyBpbnQgc2V0dXBfbmV3X2dyb3VwX2Jsb2Nr
cyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCWV4dDRfZGVidWcoImNsZWFyIGlub2RlIHRhYmxl
IGJsb2NrcyAlIzA0bGx4IC0+ICUjMDRsbHhcbiIsCiAJCQlibG9jaywgc2JpLT5zX2l0Yl9wZXJf
Z3JvdXApOwogCWVyciA9IHNiX2lzc3VlX3plcm9vdXQoc2IsIGJsb2NrLCBzYmktPnNfaXRiX3Bl
cl9ncm91cCwKLQkJCSAgICAgICBHRlBfTk9GUywgQkxLREVWX0lGTF9XQUlUKTsKKwkJCSAgICAg
ICBHRlBfTk9GUyk7CiAJaWYgKGVycikKIAkJZ290byBleGl0X2JoOwogCi0tIAoxLjcuMi4zCgo=
--485b397dd013e3eb5e0492e3c735
Content-Type: text/plain; charset=US-ASCII;
	name="ext4-Fix-error-too-many-arguments-to-function-blkdev_issue_zeroout.patch"
Content-Disposition: attachment;
	filename="ext4-Fix-error-too-many-arguments-to-function-blkdev_issue_zeroout.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gffbuzob1

SW5kZXg6IGxpbnV4LTIuNi9pbmNsdWRlL2xpbnV4L2Jsa2Rldi5oCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4LTIuNi5vcmlnL2luY2x1ZGUvbGludXgvYmxrZGV2LmgKKysrIGxpbnV4LTIuNi9pbmNsdWRl
L2xpbnV4L2Jsa2Rldi5oCkBAIC04OTIsMTIgKzg5MiwxMiBAQCBzdGF0aWMgaW5saW5lIGludCBz
Yl9pc3N1ZV9kaXNjYXJkKHN0cnVjCiAJCQkJICAgIGdmcF9tYXNrLCBmbGFncyk7CiB9CiBzdGF0
aWMgaW5saW5lIGludCBzYl9pc3N1ZV96ZXJvb3V0KHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIHNl
Y3Rvcl90IGJsb2NrLAotCQlzZWN0b3JfdCBucl9ibG9ja3MsIGdmcF90IGdmcF9tYXNrLCB1bnNp
Z25lZCBsb25nIGZsYWdzKQorCQlzZWN0b3JfdCBucl9ibG9ja3MsIGdmcF90IGdmcF9tYXNrKQog
ewogCXJldHVybiBibGtkZXZfaXNzdWVfemVyb291dChzYi0+c19iZGV2LAogCQkJCSAgICBibG9j
ayA8PCAoc2ItPnNfYmxvY2tzaXplX2JpdHMgLSA5KSwKIAkJCQkgICAgbnJfYmxvY2tzIDw8IChz
Yi0+c19ibG9ja3NpemVfYml0cyAtIDkpLAotCQkJCSAgICBnZnBfbWFzaywgZmxhZ3MpOworCQkJ
CSAgICBnZnBfbWFzayk7CiB9CiAKIGV4dGVybiBpbnQgYmxrX3ZlcmlmeV9jb21tYW5kKHVuc2ln
bmVkIGNoYXIgKmNtZCwgZm1vZGVfdCBoYXNfd3JpdGVfcGVybSk7Cg==
--485b397dd013e3eb5e0492e3c735
Content-Type: text/plain; charset=US-ASCII;
	name="ext4-Fix-error-too-many-arguments-to-function-sb_issue_zeroout.patch"
Content-Disposition: attachment;
	filename="ext4-Fix-error-too-many-arguments-to-function-sb_issue_zeroout.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gffcs1aj2

SW5kZXg6IGxpbnV4LTIuNi9mcy9leHQ0L2lhbGxvYy5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIu
Ni5vcmlnL2ZzL2V4dDQvaWFsbG9jLmMKKysrIGxpbnV4LTIuNi9mcy9leHQ0L2lhbGxvYy5jCkBA
IC0xMzAyLDcgKzEzMDIsNyBAQCBleHRlcm4gaW50IGV4dDRfaW5pdF9pbm9kZV90YWJsZShzdHJ1
Y3QKIAogCWV4dDRfZGVidWcoImdvaW5nIHRvIHplcm8gb3V0IGlub2RlIHRhYmxlIGluIGdyb3Vw
ICVkXG4iLAogCQkgICBncm91cCk7Ci0JcmV0ID0gc2JfaXNzdWVfemVyb291dChzYiwgYmxrLCBu
dW0sIEdGUF9OT0ZTLCBmbGFncyk7CisJcmV0ID0gc2JfaXNzdWVfemVyb291dChzYiwgYmxrLCBu
dW0sIEdGUF9OT0ZTKTsKIAlpZiAocmV0IDwgMCkKIAkJZ290byBlcnJfb3V0OwogCg==
--485b397dd013e3eb5e0492e3c735--
