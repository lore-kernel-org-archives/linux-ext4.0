From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v2 06/24] fs: ext4: Use current_time() for inode
	timestamps
Date: Fri, 24 Jun 2016 16:08:51 -0700
Message-ID: <CABeXuvpD_xJjLRkEc=oTRKypmhCJ6uZhSGAzALS2fX6J9__CcQ@mail.gmail.com>
References: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com>
 <1466382443-11063-7-git-send-email-deepa.kernel@gmail.com>
 <14013437.bAvQTZLQL2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, y2038 Mailman List <y2038@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <14013437.bAvQTZLQL2@wuerfel>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
List-Id: linux-ext4.vger.kernel.org

Pj4gQEAgLTM3MjcsNiArMzcyNyw3IEBAIHN0YXRpYyBpbnQgZXh0NF9jcm9zc19yZW5hbWUoc3Ry
dWN0IGlub2RlICpvbGRfZGlyLCBzdHJ1Y3QgZGVudHJ5ICpvbGRfZGVudHJ5LAo+PiAgICAgICAg
IH07Cj4+ICAgICAgICAgdTggbmV3X2ZpbGVfdHlwZTsKPj4gICAgICAgICBpbnQgcmV0dmFsOwo+
PiArICAgICAgIHN0cnVjdCB0aW1lc3BlYyBjdGltZTsKPj4KPj4gICAgICAgICBpZiAoKGV4dDRf
ZW5jcnlwdGVkX2lub2RlKG9sZF9kaXIpIHx8Cj4+ICAgICAgICAgICAgICBleHQ0X2VuY3J5cHRl
ZF9pbm9kZShuZXdfZGlyKSkgJiYKPj4gQEAgLTM4MjksOCArMzgzMCw5IEBAIHN0YXRpYyBpbnQg
ZXh0NF9jcm9zc19yZW5hbWUoc3RydWN0IGlub2RlICpvbGRfZGlyLCBzdHJ1Y3QgZGVudHJ5ICpv
bGRfZGVudHJ5LAo+PiAgICAgICAgICAqIExpa2UgbW9zdCBvdGhlciBVbml4IHN5c3RlbXMsIHNl
dCB0aGUgY3RpbWUgZm9yIGlub2RlcyBvbiBhCj4+ICAgICAgICAgICogcmVuYW1lLgo+PiAgICAg
ICAgICAqLwo+PiAtICAgICAgIG9sZC5pbm9kZS0+aV9jdGltZSA9IGV4dDRfY3VycmVudF90aW1l
KG9sZC5pbm9kZSk7Cj4+IC0gICAgICAgbmV3Lmlub2RlLT5pX2N0aW1lID0gZXh0NF9jdXJyZW50
X3RpbWUobmV3Lmlub2RlKTsKPj4gKyAgICAgICBjdGltZSA9IGN1cnJlbnRfdGltZShvbGQuaW5v
ZGUpOwo+PiArICAgICAgIG9sZC5pbm9kZS0+aV9jdGltZSA9IGN0aW1lOwo+PiArICAgICAgIG5l
dy5pbm9kZS0+aV9jdGltZSA9IGN0aW1lOwo+PiAgICAgICAgIGV4dDRfbWFya19pbm9kZV9kaXJ0
eShoYW5kbGUsIG9sZC5pbm9kZSk7Cj4+ICAgICAgICAgZXh0NF9tYXJrX2lub2RlX2RpcnR5KGhh
bmRsZSwgbmV3Lmlub2RlKTsKPj4KPgo+IEFkZGluZyBhIGxvY2FsIHZhcmlhYmxlIGhlcmUgbG9v
a3MgbGlrZSBpdCBpcyBnb2luZyB0byBjYXVzZSB1cyB0cm91YmxlIHdoZW4gd2UKPiBjaGFuZ2Ug
dGhlIHJldHVybiB0eXBlIG9mIGN1cnJlbnRfdGltZSgpIHRvIHRpbWVzcGVjNjQuCj4KPiBJJ2Qg
d3JpdGUgdGhpcyBhcwo+Cj4gICAgICAgICBuZXcuaW5vZGUtPmlfY3RpbWUgPSBvbGQuaW5vZGUt
PmlfY3RpbWU7Cj4KPiBpbnN0ZWFkLgoKVGhpcyBzaG91bGQgYmUgZmluZS4KVGhlcmUgYXJlIGFs
cmVhZHkgaW5zdGFuY2VzIHRoYXQgdXNlIGxvY2FsIHRpbWVzcGVjcyBmb3IgaW5vZGUgdGltZSBh
c3NpZ25tZW50cy4KClRoZXNlIGNhbiBiZSBjaGFuZ2VkIHRoaXMgd2F5OgoKKyAgICAgICBjdGlt
ZSA9IHZmc190aW1lX3RvX3RpbWVzcGVjKGN1cnJlbnRfdGltZShvbGQuaW5vZGUpKTsKKyAgICAg
ICBvbGQuaW5vZGUtPmlfY3RpbWUgPSB0aW1lc3BlY190b192ZnNfdGltZShjdGltZSk7CisgICAg
ICAgbmV3Lmlub2RlLT5pX2N0aW1lID0gdGltZXNwZWNfdG9fdmZzX3RpbWUoY3RpbWUpOwoKVGhp
cyBjb3VsZCBiZSBhIGxpdHRsZSBpbmVmZmljaWVudCwgYnV0IG9ubHkgdGVtcG9yYXJ5LgpUaGUg
bG9jYWwgdmFyaWFibGUgY2FuIGJlIGNoYW5nZWQgdG8gdGltZXNwZWM2NCB3aGVuIHRoZSBtYWNy
b3MgYXJlIGRlbGV0ZWQuCgpJJ20gdHJ5aW5nIHRvIG1ha2UgbWluaW1hbCBjaGFuZ2VzLgoKLURl
ZXBhCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4
IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJv
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
