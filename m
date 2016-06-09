From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/21] fs: ext4: Use current_fs_time() for inode
	timestamps
Date: Thu, 9 Jun 2016 11:45:01 -0700
Message-ID: <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-3-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
 y2038@lists.linaro.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1465448705-25055-3-git-send-email-deepa.kernel@gmail.com>
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

T24gV2VkLCBKdW4gOCwgMjAxNiBhdCAxMDowNCBQTSwgRGVlcGEgRGluYW1hbmkgPGRlZXBhLmtl
cm5lbEBnbWFpbC5jb20+IHdyb3RlOgo+IENVUlJFTlRfVElNRV9TRUMgYW5kIENVUlJFTlRfVElN
RSBhcmUgbm90IHkyMDM4IHNhZmUuCj4gY3VycmVudF9mc190aW1lKCkgd2lsbCBiZSB0cmFuc2l0
aW9uZWQgdG8gYmUgeTIwMzggc2FmZQo+IGFsb25nIHdpdGggdmZzLgo+Cj4gY3VycmVudF9mc190
aW1lKCkgcmV0dXJucyB0aW1lc3RhbXBzIGFjY29yZGluZyB0byB0aGUKPiBncmFudWxhcml0aWVz
IHNldCBpbiB0aGUgc3VwZXJfYmxvY2suCgpBbGwgZXhpc3RpbmcgdXNlcnMgYW5kIGFsbCB0aGUg
b25lcyBpbiB0aGlzIHBhdGNoIChhbmQgdGhlIG90aGVycyB0b28sCmFsdGhvdWdoIEkgZGlkbid0
IGdvIHRocm91Z2ggdGhlbSB2ZXJ5IGNhcmVmdWxseSkgcmVhbGx5IHdvdWxkIHByZWZlcgpqdXN0
IHBhc3NpbmcgaW4gdGhlIGlub2RlIGRpcmVjdGx5LCByYXRoZXIgdGhhbiB0aGUgc3VwZXJibG9j
ay4KClNvIEkgZG9uJ3Qgd2FudCB0byBhZGQgbW9yZSB1c2VycyBvZiB0aGlzIGJyb2tlbiBpbnRl
cmZhY2UuICBJdCB3YXMgYQptaXN0YWtlIHRvIHVzZSB0aGUgc3VwZXJibG9jay4gVGhlIGZhY3Qg
dGhhdCB0aGUgdGltZSBncmFudWxhcml0eQpleGlzdHMgdGhlcmUgaXMgcHJldHR5IG11Y2ggaXJy
ZWxldmFudC4gSWYgZXZlcnkgc2luZ2xlIHVzZXIgd2FudHMgdG8KdXNlIGFuIGlub2RlIHBvaW50
ZXIsIHRoZW4gdGhhdCBpcyB3aGF0IHRoZSBmdW5jdGlvbiBzaG91bGQgZ2V0LgoKICAgICAgICAg
ICAgICAgICBMaW51cwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xp
c3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
