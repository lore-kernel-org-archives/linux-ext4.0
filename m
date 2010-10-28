From: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 20:20:33 +0200
Message-ID: <AANLkTikOqeT8OznyMvL7XaWS06kh7ZZ+SJLyMfOc32P4@mail.gmail.com>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
	<20101028175221.GA1578@arch.trippelsdorf.de>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf300fac9bd6cdf10493b165ad
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, sfr@canb.auug.org.au,
	Arnd Bergmann <arnd@arndb.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60290 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab0J1SUe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Oct 2010 14:20:34 -0400
In-Reply-To: <20101028175221.GA1578@arch.trippelsdorf.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--20cf300fac9bd6cdf10493b165ad
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 28, 2010 at 7:52 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Thu, Oct 28, 2010 at 12:05:05PM +0200, Sedat Dilek wrote:
>> Hi,
>>
>> I have built today linux-next as of next-20101028 in a non-BKL config
>> (kernel-config attached) on a Debian i386/sid host.
>>
>> When I start my quassel IRC-client I get reproducibly this call-trace:
>>
>> # tail -40 kern.log
>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.872957] EXT3-fs (sdb5): warning=
:
>> maximal mount count reached, running e2fsck is recommended
>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873621] EXT3-fs (sdb5): using
>> internal journal
>> Oct 28 11:42:54 tbox kernel: [ =C2=A0 32.873635] EXT3-fs (sdb5): mounted
>> filesystem with ordered data mode
>> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480401] ------------[ cut here =
]------------
>> Oct 28 11:44:16 tbox kernel: [ =C2=A0115.480598] kernel BUG at
>> /home/sd/src/linux-2.6/linux-2.6.36/debian/build/source_i386_none/fs/ext=
4/inode.c:2721!
>
> The same BUG (inode.c:2721) happend here today running latest vanilla
> git. There is nothing in my logs unfortunately, but I shot a photo of
> the trace (see attachment).
>
> --
> Markus
>

Looks like the two patches from ext/for_linus GIT-branch stabilzes
system, here (2.6.36-git11).

root@tbox:~# uptime
 20:19:42 up 19 min,  4 users,  load average: 1.27, 0.89, 0.58

- Sedat -

--20cf300fac9bd6cdf10493b165ad
Content-Type: text/x-diff; charset=UTF-8;
	name="0001-ext4-Fix-build-when-CONFIG_EXT4_FS_XATTR.patch"
Content-Disposition: attachment;
	filename="0001-ext4-Fix-build-when-CONFIG_EXT4_FS_XATTR.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gftyko0t1

RnJvbSAwNGVlMDJmNTQyYjEzZDllNDExNGEyY2FjODZiMDI4NzRhNjU4MzI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5odT4KRGF0ZTogVGh1
LCAyOCBPY3QgMjAxMCAxMjowMToxNyAtMDQwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBleHQ0OiBG
aXggYnVpbGQgd2hlbiAhQ09ORklHX0VYVDRfRlNfWEFUVFIKTUlNRS1WZXJzaW9uOiAxLjAKQ29u
dGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PVVURi04CkNvbnRlbnQtVHJhbnNmZXItRW5j
b2Rpbmc6IDhiaXQKCj4gVGhlb2RvcmUgVHMnbyAoMTgpOgo+ICAgICAgIGV4dDQ6IHJlbmFtZSB7
ZXhpdCxpbml0fV9leHQ0XyooKSB0byBleHQ0X3tleGl0LGluaXR9XyooKQoKVG9kYXkncyAtdGlw
IGZhaWxzIHRvIGJ1aWxkIGR1ZSB0byB1cHN0cmVhbSBjb21taXQgNWRhYmZjNyAoImV4dDQ6CnJl
bmFtZSB7ZXhpdCxpbml0fV9leHQ0XyooKSB0byBleHQ0X3tleGl0LGluaXR9XyooKSIpLCBvbgph
bGxbeWVzL21vZF1jb25maWcgd2l0aCBDT05GSUdfRVhUNF9GU19YQVRUUiBkaXNhYmxlZDoKCiAg
ZnMvZXh0NC9zdXBlci5jOjQ3NzY6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5j
dGlvbiDigJhleHQ0X2luaXRfeGF0dHLigJkKCkNvbW1pdCA1ZGFiZmM3IHJlbmFtZWQgaW5pdF9l
eHQ0X3hhdHRyIHRvIGV4dDRfaW5pdF94YXR0ciBidXQgZm9yZ290CnRvIHVwZGF0ZSB0aGUgZGVm
aW5pdGlvbiBpbiBmcy9leHQ0L3hhdHRyLmguIFRoZSBwYXRjaCBiZWxvdyBmaXhlcyBpdC4KClsg
TWVhIGN1bHBhLCBtZWEgY3VscGEsIG1lYSBtYXhpbXVtIGN1bHBhIC1UZWQgXQoKU2lnbmVkLW9m
Zi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGVsdGUuaHU+ClNpZ25lZC1vZmYtYnk6ICJUaGVvZG9y
ZSBUcydvIiA8dHl0c29AbWl0LmVkdT4KLS0tCiBmcy9leHQ0L3hhdHRyLmggfCAgICAyICstCiAx
IGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9mcy9leHQ0L3hhdHRyLmggYi9mcy9leHQ0L3hhdHRyLmgKaW5kZXggMjgxZGQ4My4uMWVm
MTY1MiAxMDA2NDQKLS0tIGEvZnMvZXh0NC94YXR0ci5oCisrKyBiL2ZzL2V4dDQveGF0dHIuaApA
QCAtMTIyLDcgKzEyMiw3IEBAIGV4dDRfeGF0dHJfcHV0X3N1cGVyKHN0cnVjdCBzdXBlcl9ibG9j
ayAqc2IpCiB9CiAKIHN0YXRpYyBfX2luaXQgaW5saW5lIGludAotaW5pdF9leHQ0X3hhdHRyKHZv
aWQpCitleHQ0X2luaXRfeGF0dHIodm9pZCkKIHsKIAlyZXR1cm4gMDsKIH0KLS0gCjEuNy4yLjMK
Cg==
--20cf300fac9bd6cdf10493b165ad
Content-Type: text/x-diff; charset=UTF-8;
	name="0002-fs-build-fix-when-CONFIG_BLOCK.patch"
Content-Disposition: attachment;
	filename="0002-fs-build-fix-when-CONFIG_BLOCK.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gftyl1ot2

RnJvbSA3NGVlM2VmNTY5YWM3NmI3YTYwMGFjNjkwOTdmOGZmOTZhYWE1YjUwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbmdvIE1vbG5hciA8bWluZ29AZWx0ZS5odT4KRGF0ZTogVGh1
LCAyOCBPY3QgMjAxMCAxMjowMzowNSAtMDQwMApTdWJqZWN0OiBbUEFUQ0ggMi8yXSBmczogYnVp
bGQgZml4IHdoZW4gIUNPTkZJR19CTE9DSwpNSU1FLVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6
IHRleHQvcGxhaW47IGNoYXJzZXQ9VVRGLTgKQ29udGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJp
dAoKVG9kYXkncyAtdGlwIGZhaWxzIHRvIGJ1aWxkIG9uICFDT05GSUdfQkxPQ0ssIGR1ZSB0byB1
cHN0cmVhbSBjb21taXQKMzY3YTUxYSAoImZzOiBBZGQgRklUUklNIGlvY3RsIik6CgogaW5jbHVk
ZS9saW51eC9mcy5oOjM2OiBlcnJvcjogZXhwZWN0ZWQgc3BlY2lmaWVyLXF1YWxpZmllci1saXN0
IGJlZm9yZSDigJh1aW50NjRfdOKAmQogaW5jbHVkZS9saW51eC9mcy5oOjM2OiBlcnJvcjogZXhw
ZWN0ZWQgc3BlY2lmaWVyLXF1YWxpZmllci1saXN0IGJlZm9yZSDigJh1aW50NjRfdOKAmQogaW5j
bHVkZS9saW51eC9mcy5oOjM2OiBlcnJvcjogZXhwZWN0ZWQgc3BlY2lmaWVyLXF1YWxpZmllci1s
aXN0IGJlZm9yZSDigJh1aW50NjRfdOKAmQoKVGhlIGNvbW1pdCBhZGRzIHVpbnQ2NF90IHR5cGUg
dXNhZ2UgdG8gZnMuaCwgYnV0IGxpbnV4L3R5cGVzLmggaXMgbm90CmluY2x1ZGVkIGV4cGxpY2l0
bHkgLSBpdCdzIG9ubHkgaW5jbHVkZWQgaW1wbGljaXRseSB2aWEKbGludXgvYmxrX3R5cGVzLmgs
IGFuZCB0aGVyZSBvbmx5IGlmIENPTkZJR19CTE9DSyBpcyBlbmFibGVkLgoKQWRkIHRoZSBleHBs
aWNpdCAjaW5jbHVkZSB0byBmaXggdGhpcy4KClNpZ25lZC1vZmYtYnk6IEluZ28gTW9sbmFyIDxt
aW5nb0BlbHRlLmh1PgpTaWduZWQtb2ZmLWJ5OiAiVGhlb2RvcmUgVHMnbyIgPHR5dHNvQG1pdC5l
ZHU+Ci0tLQogaW5jbHVkZS9saW51eC9mcy5oIHwgICAgMSArCiAxIGZpbGVzIGNoYW5nZWQsIDEg
aW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L2ZzLmggYi9pbmNsdWRlL2xpbnV4L2ZzLmgKaW5kZXggNmVkN2FjZS4uMWM3M2I1MCAxMDA2NDQK
LS0tIGEvaW5jbHVkZS9saW51eC9mcy5oCisrKyBiL2luY2x1ZGUvbGludXgvZnMuaApAQCAtOSw2
ICs5LDcgQEAKICNpbmNsdWRlIDxsaW51eC9saW1pdHMuaD4KICNpbmNsdWRlIDxsaW51eC9pb2N0
bC5oPgogI2luY2x1ZGUgPGxpbnV4L2Jsa190eXBlcy5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVz
Lmg+CiAKIC8qCiAgKiBJdCdzIHNpbGx5IHRvIGhhdmUgTlJfT1BFTiBiaWdnZXIgdGhhbiBOUl9G
SUxFLCBidXQgeW91IGNhbiBjaGFuZ2UKLS0gCjEuNy4yLjMKCg==
--20cf300fac9bd6cdf10493b165ad--
