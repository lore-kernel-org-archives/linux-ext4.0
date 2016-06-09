From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with
	current_fs_time()
Date: Thu, 9 Jun 2016 09:35:07 +0200
Message-ID: <20160609073507.GA2790@quack2.suse.cz>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, Bob Copeland <me@bobcopeland.com>,
 Adrian Hunter <adrian.hunter@intel.com>, David Howells <dhowells@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-afs@lists.infradead.org,
 y2038@lists.linaro.org, codalist@coda.cs.cmu.edu,
 Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu,
 linux-ext4@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
 Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
 Thomas Gleixner <tglx@linutronix.de>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Harkes <jaharkes@cs.cmu.edu>,
 Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>,
 linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-karma-devel@lists.
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
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

T24gV2VkIDA4LTA2LTE2IDIyOjA0OjQ1LCBEZWVwYSBEaW5hbWFuaSB3cm90ZToKPiBDVVJSRU5U
X1RJTUVfU0VDIGlzIG5vdCB5MjAzOCBzYWZlLiBjdXJyZW50X2ZzX3RpbWUoKSB3aWxsCj4gYmUg
dHJhbnNpdGlvbmVkIHRvIHVzZSA2NCBiaXQgdGltZSBhbG9uZyB3aXRoIHZmcyBpbiBhCj4gc2Vw
YXJhdGUgcGF0Y2guCj4gVGhlcmUgaXMgbm8gcGxhbiB0byB0cmFuc2lzdGlvbiBDVVJSRU5UX1RJ
TUVfU0VDIHRvIHVzZQo+IHkyMDM4IHNhZmUgdGltZSBpbnRlcmZhY2VzLgo+IAo+IGN1cnJlbnRf
ZnNfdGltZSgpIHdpbGwgYWxzbyBiZSBleHRlbmRlZCB0byB1c2Ugc3VwZXJibG9jawo+IHJhbmdl
IGNoZWNraW5nIHBhcmFtZXRlcnMgd2hlbiByYW5nZSBjaGVja2luZyBpcyBpbnRyb2R1Y2VkLgo+
IAo+IFRoaXMgd29ya3MgYmVjYXVzZSBhbGxvY19zdXBlcigpIGZpbGxzIGluIHRoZSB0aGUgc190
aW1lX2dyYW4KPiBpbiBzdXBlciBibG9jayB0byBOU0VDX1BFUl9TRUMuCj4gCj4gQWxzbyBub3Rl
IHRoYXQgZmlsZXN5c3RlbSBzcGVjaWZpYyB0aW1lcyBsaWtlIHRoZSBiaXJ0aHRpbWUsCj4gY3Jl
YXRpb24gdGltZSB0aGF0IHdlcmUgdXNpbmcgc2FtZSBpbnRlcmZhY2VzIHRvIG9idGFpbiB0aW1l
Cj4gcmV0YWluIHNhbWUgbG9naXN0aWNzLgoKWW91IGNyZWF0ZSBsaW5lIGxvbmdlciB0aGFuIDgw
IGNoYXJhY3RlcnMgZm9yIGFmZnMgYW5kIHJlaXNlcmZzLiBQbGVhc2UKd3JhcCB0aG9zZSBsaW5l
cyBwcm9wZXJseS4gT3RoZXIgdGhhbiB0aGF0IGZlZWwgZnJlZSB0byBhZGQ6CgpBY2tlZC1ieTog
SmFuIEthcmEgPGphY2tAc3VzZS5jej4KCgkJCQkJCQkJSG9uemEKLS0gCkphbiBLYXJhIDxqYWNr
QHN1c2UuY29tPgpTVVNFIExhYnMsIENSCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3Jn
Cmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
