From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: linux-2.6-block/for-next: Removal of BLKDEV_IFL_BARRIER and BLKDEV_IFL_WAIT
Date: Mon, 18 Oct 2010 13:11:10 +0200
Message-ID: <AANLkTiktB2UPBC1OENawF9qzr-gVvqe-UkEBGU4sLaka@mail.gmail.com>
References: <AANLkTi=EiCvRxAqnbWoPMhqYAZDQmsjaDRt+0dK-fRcV@mail.gmail.com>
	<4CBBF382.4000505@kernel.dk>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163630fe61d080e50492e23bf3
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47114 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0JRLLL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Oct 2010 07:11:11 -0400
Received: by qwa26 with SMTP id 26so441427qwa.19
        for <linux-ext4@vger.kernel.org>; Mon, 18 Oct 2010 04:11:10 -0700 (PDT)
In-Reply-To: <4CBBF382.4000505@kernel.dk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--00163630fe61d080e50492e23bf3
Content-Type: text/plain; charset=UTF-8

Hi Jens,

thanks for the fast reply.
I had a quick view on my local GIT repository after pulling both GIT branches.

Does this attached (untested) patch fix the seen issues?

Thanks in advance.

Kind Regards,
- Sedat -

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

--00163630fe61d080e50492e23bf3
Content-Type: text/plain; charset=US-ASCII;
	name="0001-ext4-Remove-BLKDEV_IFL_WAIT-and-BLKDEV_IFL_BARRIER-r.patch"
Content-Disposition: attachment;
	filename="0001-ext4-Remove-BLKDEV_IFL_WAIT-and-BLKDEV_IFL_BARRIER-r.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gff8v86z0

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
VCk7CisJCQkgICAgICAgR0ZQX05PRlMsIDApOwogCWlmIChyZXQgPiAwKQogCQlyZXQgPSAwOwog
CmRpZmYgLS1naXQgYS9mcy9leHQ0L2lhbGxvYy5jIGIvZnMvZXh0NC9pYWxsb2MuYwppbmRleCA4
N2QyMjhhLi5jYzNhMTgwIDEwMDY0NAotLS0gYS9mcy9leHQ0L2lhbGxvYy5jCisrKyBiL2ZzL2V4
dDQvaWFsbG9jLmMKQEAgLTEyMzgsNyArMTIzOCw2IEBAIGV4dGVybiBpbnQgZXh0NF9pbml0X2lu
b2RlX3RhYmxlKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IsIGV4dDRfZ3JvdXBfdCBncm91cCwKIAlo
YW5kbGVfdCAqaGFuZGxlOwogCWV4dDRfZnNibGtfdCBibGs7CiAJaW50IG51bSwgcmV0ID0gMCwg
dXNlZF9ibGtzID0gMDsKLQl1bnNpZ25lZCBsb25nIGZsYWdzID0gQkxLREVWX0lGTF9XQUlUOwog
CiAJLyogVGhpcyBzaG91bGQgbm90IGhhcHBlbiwgYnV0IGp1c3QgdG8gYmUgc3VyZSBjaGVjayB0
aGlzICovCiAJaWYgKHNiLT5zX2ZsYWdzICYgTVNfUkRPTkxZKSB7CkBAIC0xMzAzLDggKzEzMDIs
NiBAQCBleHRlcm4gaW50IGV4dDRfaW5pdF9pbm9kZV90YWJsZShzdHJ1Y3Qgc3VwZXJfYmxvY2sg
KnNiLCBleHQ0X2dyb3VwX3QgZ3JvdXAsCiAKIAlleHQ0X2RlYnVnKCJnb2luZyB0byB6ZXJvIG91
dCBpbm9kZSB0YWJsZSBpbiBncm91cCAlZFxuIiwKIAkJICAgZ3JvdXApOwotCWlmIChiYXJyaWVy
KQotCQlmbGFncyB8PSBCTEtERVZfSUZMX0JBUlJJRVI7CiAJcmV0ID0gc2JfaXNzdWVfemVyb291
dChzYiwgYmxrLCBudW0sIEdGUF9OT0ZTLCBmbGFncyk7CiAJaWYgKHJldCA8IDApCiAJCWdvdG8g
ZXJyX291dDsKZGlmZiAtLWdpdCBhL2ZzL2V4dDQvcmVzaXplLmMgYi9mcy9leHQ0L3Jlc2l6ZS5j
CmluZGV4IDJmNWUzNDcuLjBmMWYzMGMgMTAwNjQ0Ci0tLSBhL2ZzL2V4dDQvcmVzaXplLmMKKysr
IGIvZnMvZXh0NC9yZXNpemUuYwpAQCAtMjI5LDcgKzIyOSw3IEBAIHN0YXRpYyBpbnQgc2V0dXBf
bmV3X2dyb3VwX2Jsb2NrcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCWV4dDRfZGVidWcoImNs
ZWFyIGlub2RlIHRhYmxlIGJsb2NrcyAlIzA0bGx4IC0+ICUjMDRsbHhcbiIsCiAJCQlibG9jaywg
c2JpLT5zX2l0Yl9wZXJfZ3JvdXApOwogCWVyciA9IHNiX2lzc3VlX3plcm9vdXQoc2IsIGdkYmxv
Y2tzICsgc3RhcnQgKyAxLCByZXNlcnZlZF9nZGIsCi0JCQkgICAgICAgR0ZQX05PRlMsIEJMS0RF
Vl9JRkxfV0FJVCk7CisJCQkgICAgICAgR0ZQX05PRlMsIDApOwogCWlmIChlcnIpCiAJCWdvdG8g
ZXhpdF9iaDsKIApAQCAtMjQ1LDcgKzI0NSw3IEBAIHN0YXRpYyBpbnQgc2V0dXBfbmV3X2dyb3Vw
X2Jsb2NrcyhzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLAogCWV4dDRfZGVidWcoImNsZWFyIGlub2Rl
IHRhYmxlIGJsb2NrcyAlIzA0bGx4IC0+ICUjMDRsbHhcbiIsCiAJCQlibG9jaywgc2JpLT5zX2l0
Yl9wZXJfZ3JvdXApOwogCWVyciA9IHNiX2lzc3VlX3plcm9vdXQoc2IsIGJsb2NrLCBzYmktPnNf
aXRiX3Blcl9ncm91cCwKLQkJCSAgICAgICBHRlBfTk9GUywgQkxLREVWX0lGTF9XQUlUKTsKKwkJ
CSAgICAgICBHRlBfTk9GUywgMCk7CiAJaWYgKGVycikKIAkJZ290byBleGl0X2JoOwogCi0tIAox
LjcuMi4zCgo=
--00163630fe61d080e50492e23bf3--
