From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/21] fs: ext4: Use current_fs_time() for inode
	timestamps
Date: Sat, 11 Jun 2016 00:19:17 +0200
Message-ID: <3299877.khhcQSIs8Z@wuerfel>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Deepa Dinamani <deepa.kernel@gmail.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>
To: y2038@lists.linaro.org
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CA+55aFx7ES7D_9uVL3T1htJj6onQP2Z2TrDqTG+Qd9AuHnVf-g@mail.gmail.com>
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

T24gVGh1cnNkYXksIEp1bmUgOSwgMjAxNiAxMTo0NTowMSBBTSBDRVNUIExpbnVzIFRvcnZhbGRz
IHdyb3RlOgo+IE9uIFdlZCwgSnVuIDgsIDIwMTYgYXQgMTA6MDQgUE0sIERlZXBhIERpbmFtYW5p
IDxkZWVwYS5rZXJuZWxAZ21haWwuY29tPiB3cm90ZToKPiA+IENVUlJFTlRfVElNRV9TRUMgYW5k
IENVUlJFTlRfVElNRSBhcmUgbm90IHkyMDM4IHNhZmUuCj4gPiBjdXJyZW50X2ZzX3RpbWUoKSB3
aWxsIGJlIHRyYW5zaXRpb25lZCB0byBiZSB5MjAzOCBzYWZlCj4gPiBhbG9uZyB3aXRoIHZmcy4K
PiA+Cj4gPiBjdXJyZW50X2ZzX3RpbWUoKSByZXR1cm5zIHRpbWVzdGFtcHMgYWNjb3JkaW5nIHRv
IHRoZQo+ID4gZ3JhbnVsYXJpdGllcyBzZXQgaW4gdGhlIHN1cGVyX2Jsb2NrLgo+IAo+IEFsbCBl
eGlzdGluZyB1c2VycyBhbmQgYWxsIHRoZSBvbmVzIGluIHRoaXMgcGF0Y2ggKGFuZCB0aGUgb3Ro
ZXJzIHRvbywKPiBhbHRob3VnaCBJIGRpZG4ndCBnbyB0aHJvdWdoIHRoZW0gdmVyeSBjYXJlZnVs
bHkpIHJlYWxseSB3b3VsZCBwcmVmZXIKPiBqdXN0IHBhc3NpbmcgaW4gdGhlIGlub2RlIGRpcmVj
dGx5LCByYXRoZXIgdGhhbiB0aGUgc3VwZXJibG9jay4KPiAKPiBTbyBJIGRvbid0IHdhbnQgdG8g
YWRkIG1vcmUgdXNlcnMgb2YgdGhpcyBicm9rZW4gaW50ZXJmYWNlLiAgSXQgd2FzIGEKPiBtaXN0
YWtlIHRvIHVzZSB0aGUgc3VwZXJibG9jay4gVGhlIGZhY3QgdGhhdCB0aGUgdGltZSBncmFudWxh
cml0eQo+IGV4aXN0cyB0aGVyZSBpcyBwcmV0dHkgbXVjaCBpcnJlbGV2YW50LiBJZiBldmVyeSBz
aW5nbGUgdXNlciB3YW50cyB0bwo+IHVzZSBhbiBpbm9kZSBwb2ludGVyLCB0aGVuIHRoYXQgaXMg
d2hhdCB0aGUgZnVuY3Rpb24gc2hvdWxkIGdldC4KCkkgZ3Vlc3MgaXQgd291bGQgaGVscCB0byBn
aXZlIHRoZSBmdW5jdGlvbiBhIG5ldyBuYW1lIGluIHRoZSBwcm9jZXNzLAppZiBvbmx5IHRvIGF2
b2lkIHBvc3NpYmxlIGNvbmZsaWN0cy4gVGhhdCBuZXcgbmFtZSBvZiBjb3Vyc2UgbmVlZHMgdG8K
YmUgYXQgbGVhc3QgYXMgaW50dWl0aXZlIGFzIHRoZSBvbGQgb25lLiBIb3cgYWJvdXQKCnN0cnVj
dCB0aW1lc3BlYyBmc190aW1lc3RhbXAoc3RydWN0IGlub2RlICopOwoKPyAKCglBcm5kCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcg
bGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWls
bWFuL2xpc3RpbmZvL3kyMDM4Cg==
