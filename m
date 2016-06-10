From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with
	current_fs_time()
Date: Sat, 11 Jun 2016 00:21:54 +0200
Message-ID: <3091973.UMxUogx2eG@wuerfel>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, Adrian Hunter <adrian.hunter@intel.com>,
 David Howells <dhowells@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 linux-afs@lists.infradead.org, y2038@lists.linaro.org,
 Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu,
 linux-ext4@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
 Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Harkes <jaharkes@cs.cmu.edu>,
 Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>,
 linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-karma-devel@lists.sourceforge.net
To: Deepa Dinamani <deepa.kernel@gmail.com>, Bob Copeland <me@bobcopeland.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
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

T24gV2VkbmVzZGF5LCBKdW5lIDgsIDIwMTYgMTA6MDQ6NDUgUE0gQ0VTVCBEZWVwYSBEaW5hbWFu
aSB3cm90ZToKPiBDVVJSRU5UX1RJTUVfU0VDIGlzIG5vdCB5MjAzOCBzYWZlLiBjdXJyZW50X2Zz
X3RpbWUoKSB3aWxsCj4gYmUgdHJhbnNpdGlvbmVkIHRvIHVzZSA2NCBiaXQgdGltZSBhbG9uZyB3
aXRoIHZmcyBpbiBhCj4gc2VwYXJhdGUgcGF0Y2guCj4gVGhlcmUgaXMgbm8gcGxhbiB0byB0cmFu
c2lzdGlvbiBDVVJSRU5UX1RJTUVfU0VDIHRvIHVzZQo+IHkyMDM4IHNhZmUgdGltZSBpbnRlcmZh
Y2VzLgo+IAo+IGN1cnJlbnRfZnNfdGltZSgpIHdpbGwgYWxzbyBiZSBleHRlbmRlZCB0byB1c2Ug
c3VwZXJibG9jawo+IHJhbmdlIGNoZWNraW5nIHBhcmFtZXRlcnMgd2hlbiByYW5nZSBjaGVja2lu
ZyBpcyBpbnRyb2R1Y2VkLgo+IAo+IFRoaXMgd29ya3MgYmVjYXVzZSBhbGxvY19zdXBlcigpIGZp
bGxzIGluIHRoZSB0aGUgc190aW1lX2dyYW4KPiBpbiBzdXBlciBibG9jayB0byBOU0VDX1BFUl9T
RUMuCj4gCj4gQWxzbyBub3RlIHRoYXQgZmlsZXN5c3RlbSBzcGVjaWZpYyB0aW1lcyBsaWtlIHRo
ZSBiaXJ0aHRpbWUsCj4gY3JlYXRpb24gdGltZSB0aGF0IHdlcmUgdXNpbmcgc2FtZSBpbnRlcmZh
Y2VzIHRvIG9idGFpbiB0aW1lCj4gcmV0YWluIHNhbWUgbG9naXN0aWNzLgo+IAo+IFNpZ25lZC1v
ZmYtYnk6IERlZXBhIERpbmFtYW5pIDxkZWVwYS5rZXJuZWxAZ21haWwuY29tPgoKb25lIHF1ZXN0
aW9uOgoKSW4gYW4gZWFybGllciB2ZXJzaW9uLCB5b3UgaGFkIGEgc21hbGwgb3B0aW1pemF0aW9u
IHRvCnVzZSBrdGltZV9nZXRfcmVhbF9zZWNvbmRzKCkgaW5zdGVhZCBvZiBjdXJyZW50X2tlcm5l
bF90aW1lKCkKd2hlbiB0aGUgZ3JhbnVsYXJpdHkgaXMgc2Vjb25kcy4KCkRvIHlvdSBzdGlsbCBw
bGFuIHRvIHNlbmQgdGhhdCBvbmUsIG9yIGRpZCB5b3UgZGVjaWRlIHdlIGRvbid0Cm5lZWQgaXQ/
CgoJQXJuZApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZ
MjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxp
bmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
