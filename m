From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 06/24] fs: ext4: Use current_time() for inode
	timestamps
Date: Wed, 22 Jun 2016 15:40:06 +0200
Message-ID: <14013437.bAvQTZLQL2@wuerfel>
References: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com>
 <1466382443-11063-7-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: tytso@mit.edu, y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>, viro@zeniv.linux.org.uk,
 linux-fsdevel@vger.kernel.org, tglx@linutronix.de, linux-ext4@vger.kernel.org,
 torvalds@linux-foundation.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1466382443-11063-7-git-send-email-deepa.kernel@gmail.com>
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

T24gU3VuZGF5LCBKdW5lIDE5LCAyMDE2IDU6Mjc6MDUgUE0gQ0VTVCBEZWVwYSBEaW5hbWFuaSB3
cm90ZToKPiBAQCAtMzcyNyw2ICszNzI3LDcgQEAgc3RhdGljIGludCBleHQ0X2Nyb3NzX3JlbmFt
ZShzdHJ1Y3QgaW5vZGUgKm9sZF9kaXIsIHN0cnVjdCBkZW50cnkgKm9sZF9kZW50cnksCj4gICAg
ICAgICB9Owo+ICAgICAgICAgdTggbmV3X2ZpbGVfdHlwZTsKPiAgICAgICAgIGludCByZXR2YWw7
Cj4gKyAgICAgICBzdHJ1Y3QgdGltZXNwZWMgY3RpbWU7Cj4gIAo+ICAgICAgICAgaWYgKChleHQ0
X2VuY3J5cHRlZF9pbm9kZShvbGRfZGlyKSB8fAo+ICAgICAgICAgICAgICBleHQ0X2VuY3J5cHRl
ZF9pbm9kZShuZXdfZGlyKSkgJiYKPiBAQCAtMzgyOSw4ICszODMwLDkgQEAgc3RhdGljIGludCBl
eHQ0X2Nyb3NzX3JlbmFtZShzdHJ1Y3QgaW5vZGUgKm9sZF9kaXIsIHN0cnVjdCBkZW50cnkgKm9s
ZF9kZW50cnksCj4gICAgICAgICAgKiBMaWtlIG1vc3Qgb3RoZXIgVW5peCBzeXN0ZW1zLCBzZXQg
dGhlIGN0aW1lIGZvciBpbm9kZXMgb24gYQo+ICAgICAgICAgICogcmVuYW1lLgo+ICAgICAgICAg
ICovCj4gLSAgICAgICBvbGQuaW5vZGUtPmlfY3RpbWUgPSBleHQ0X2N1cnJlbnRfdGltZShvbGQu
aW5vZGUpOwo+IC0gICAgICAgbmV3Lmlub2RlLT5pX2N0aW1lID0gZXh0NF9jdXJyZW50X3RpbWUo
bmV3Lmlub2RlKTsKPiArICAgICAgIGN0aW1lID0gY3VycmVudF90aW1lKG9sZC5pbm9kZSk7Cj4g
KyAgICAgICBvbGQuaW5vZGUtPmlfY3RpbWUgPSBjdGltZTsKPiArICAgICAgIG5ldy5pbm9kZS0+
aV9jdGltZSA9IGN0aW1lOwo+ICAgICAgICAgZXh0NF9tYXJrX2lub2RlX2RpcnR5KGhhbmRsZSwg
b2xkLmlub2RlKTsKPiAgICAgICAgIGV4dDRfbWFya19pbm9kZV9kaXJ0eShoYW5kbGUsIG5ldy5p
bm9kZSk7Cj4gIAoKQWRkaW5nIGEgbG9jYWwgdmFyaWFibGUgaGVyZSBsb29rcyBsaWtlIGl0IGlz
IGdvaW5nIHRvIGNhdXNlIHVzIHRyb3VibGUgd2hlbiB3ZQpjaGFuZ2UgdGhlIHJldHVybiB0eXBl
IG9mIGN1cnJlbnRfdGltZSgpIHRvIHRpbWVzcGVjNjQuCgpJJ2Qgd3JpdGUgdGhpcyBhcwoKCW5l
dy5pbm9kZS0+aV9jdGltZSA9IG9sZC5pbm9kZS0+aV9jdGltZTsKCmluc3RlYWQuCgoJQXJuZApf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWls
aW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcv
bWFpbG1hbi9saXN0aW5mby95MjAzOAo=
