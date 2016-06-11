From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with
	current_fs_time()
Date: Sat, 11 Jun 2016 22:55:52 +0200
Message-ID: <6859475.Y26Py76amW@wuerfel>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <3091973.UMxUogx2eG@wuerfel>
 <CABeXuvp9MV720nFVHfEOdL0q11xadKezThpsh+5wd1O5KYk6Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, Bob Copeland <me@bobcopeland.com>,
 Adrian Hunter <adrian.hunter@intel.com>, David Howells <dhowells@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-afs@lists.infradead.org,
 y2038@lists.linaro.org, Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu,
 linux-ext4@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
 Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Harkes <jaharkes@cs.cmu.edu>,
 Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Jan Kara <jack@suse.com>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 linux-mtd <linux-mtd@lists.infradead.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-karma
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CABeXuvp9MV720nFVHfEOdL0q11xadKezThpsh+5wd1O5KYk6Yg@mail.gmail.com>
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

T24gRnJpZGF5LCBKdW5lIDEwLCAyMDE2IDEwOjAzOjE0IFBNIENFU1QgRGVlcGEgRGluYW1hbmkg
d3JvdGU6Cj4gT24gRnJpLCBKdW4gMTAsIDIwMTYgYXQgMzoyMSBQTSwgQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT4gd3JvdGU6Cgo+ID4KPiA+IEluIGFuIGVhcmxpZXIgdmVyc2lvbiwgeW91
IGhhZCBhIHNtYWxsIG9wdGltaXphdGlvbiB0bwo+ID4gdXNlIGt0aW1lX2dldF9yZWFsX3NlY29u
ZHMoKSBpbnN0ZWFkIG9mIGN1cnJlbnRfa2VybmVsX3RpbWUoKQo+ID4gd2hlbiB0aGUgZ3JhbnVs
YXJpdHkgaXMgc2Vjb25kcy4KPiA+Cj4gPiBEbyB5b3Ugc3RpbGwgcGxhbiB0byBzZW5kIHRoYXQg
b25lLCBvciBkaWQgeW91IGRlY2lkZSB3ZSBkb24ndAo+ID4gbmVlZCBpdD8KPiAKPiBJIHdhcyBh
Y3R1YWxseSBwbGFubmluZyB0byB1c2UgZ2V0X3NlY29uZHMoKSBpbnN0ZWFkIG9mIGN1cnJlbnRf
a2VybmVsX3RpbWUoKS4KPiBBbmQsIHRyYW5zaXRpb24gYm90aCBhbG9uZyB3aXRoIHZmcyB0byB5
MjAzOCBzYWZlIGFwaXMuCj4gRGlmZmVyZW5jZSBiZXR3ZWVuIGt0aW1lX2dldF9yZWFsX3NlY29u
ZHMoKSBhbmQgY3VycmVudF9rZXJuZWxfdGltZTY0KCkKPiBpcyBub3QgbXVjaCBiZWNhdXNlIHRo
ZXkgYm90aCByZXF1aXJlIHNlcXVlbmNlIGNvdW50ZXIuCj4gCj4gSXQgZGlkbid0IG1ha2Ugc2Vu
c2UgdG8gbWUgdG8gb3B0aW1pemUgY3VycmVudF9mc190aW1lKCkgZm9yIHNlY29uZHMKPiBvbmx5
LCBhbmQgbm90IG9wdGltaXplIGZvciAxbnMgZ3JhbnVsYXJpdHkgYWxzby4KCkFoLCB5b3UgYXJl
IHJpZ2h0OiBhZGRpbmcgYW5vdGhlciBjaGVjayBmb3Igc2Vjb25kIGdyYW51bGFyaXR5IHdvdWxk
CnByb2JhYmx5IGNvc3QgbW9yZSB0aGFuIGl0IHdvdWxkIHNhdmUsIHNpbmNlIHdlIGFscmVhZHkg
ZG9uJ3QgY2FsY3VsYXRlCnRoZSBleGFjdCBuYW5vc2Vjb25kcyBidXQganVzdCB1c2UgdGhlIHRp
bWVzdGFtcCBvZiB0aGUgbGFzdCB0aW1lcgp0aWNrLgoKPiBJIHBsYW4gdG8gbWFrZSBjaGFuZ2Vz
IHRvIHRoZSBmdW5jdGlvbiBkZXBlbmRpbmcgb24gaG93IHdlIGVuZCB1cAo+IHVzaW5nIHRpbWVz
cGVjX3RydW5jKCkgYWZ0ZXIgdGhlIGFkZGl0aW9uIG9mIHJhbmdlIGNoZWNraW5nLgoKTWFrZXMg
c2Vuc2UuIEkgZ3Vlc3Mgd2UgY2FuIHNraXAgdGhlIHJhbmdlIGNoZWNraW5nIGZvcgpjdXJyZW50
X2ZzX3RpbWUoKSBpZiB3ZSBlbmQgdXAgbm90IGFsbG93aW5nIHdyaXRhYmxlIG1vdW50cyBvbgpm
aWxlIHN5c3RlbXMgdGhhdCBjYW5ub3QgcmVwcmVzZW50IHRoZSBjdXJyZW50IHRpbWUsIGJ1dCB3
ZQpkbyB3YW50IHRoZSByYW5nZSBjaGVja2luZyBmb3IgdGhlIG90aGVyIHVzZXJzIG9mCnRpbWVz
cGVjX3RydW5jKCkuCgoJQXJuZAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0
cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
