From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with
	current_fs_time()
Date: Fri, 10 Jun 2016 22:03:14 -0700
Message-ID: <CABeXuvp9MV720nFVHfEOdL0q11xadKezThpsh+5wd1O5KYk6Yg@mail.gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
 <3091973.UMxUogx2eG@wuerfel>
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
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <3091973.UMxUogx2eG@wuerfel>
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

T24gRnJpLCBKdW4gMTAsIDIwMTYgYXQgMzoyMSBQTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4gT24gV2VkbmVzZGF5LCBKdW5lIDgsIDIwMTYgMTA6MDQ6NDUgUE0gQ0VT
VCBEZWVwYSBEaW5hbWFuaSB3cm90ZToKPj4gQ1VSUkVOVF9USU1FX1NFQyBpcyBub3QgeTIwMzgg
c2FmZS4gY3VycmVudF9mc190aW1lKCkgd2lsbAo+PiBiZSB0cmFuc2l0aW9uZWQgdG8gdXNlIDY0
IGJpdCB0aW1lIGFsb25nIHdpdGggdmZzIGluIGEKPj4gc2VwYXJhdGUgcGF0Y2guCj4+IFRoZXJl
IGlzIG5vIHBsYW4gdG8gdHJhbnNpc3Rpb24gQ1VSUkVOVF9USU1FX1NFQyB0byB1c2UKPj4geTIw
Mzggc2FmZSB0aW1lIGludGVyZmFjZXMuCj4+Cj4+IGN1cnJlbnRfZnNfdGltZSgpIHdpbGwgYWxz
byBiZSBleHRlbmRlZCB0byB1c2Ugc3VwZXJibG9jawo+PiByYW5nZSBjaGVja2luZyBwYXJhbWV0
ZXJzIHdoZW4gcmFuZ2UgY2hlY2tpbmcgaXMgaW50cm9kdWNlZC4KPj4KPj4gVGhpcyB3b3JrcyBi
ZWNhdXNlIGFsbG9jX3N1cGVyKCkgZmlsbHMgaW4gdGhlIHRoZSBzX3RpbWVfZ3Jhbgo+PiBpbiBz
dXBlciBibG9jayB0byBOU0VDX1BFUl9TRUMuCj4+Cj4+IEFsc28gbm90ZSB0aGF0IGZpbGVzeXN0
ZW0gc3BlY2lmaWMgdGltZXMgbGlrZSB0aGUgYmlydGh0aW1lLAo+PiBjcmVhdGlvbiB0aW1lIHRo
YXQgd2VyZSB1c2luZyBzYW1lIGludGVyZmFjZXMgdG8gb2J0YWluIHRpbWUKPj4gcmV0YWluIHNh
bWUgbG9naXN0aWNzLgo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBEZWVwYSBEaW5hbWFuaSA8ZGVlcGEu
a2VybmVsQGdtYWlsLmNvbT4KPgo+IG9uZSBxdWVzdGlvbjoKPgo+IEluIGFuIGVhcmxpZXIgdmVy
c2lvbiwgeW91IGhhZCBhIHNtYWxsIG9wdGltaXphdGlvbiB0bwo+IHVzZSBrdGltZV9nZXRfcmVh
bF9zZWNvbmRzKCkgaW5zdGVhZCBvZiBjdXJyZW50X2tlcm5lbF90aW1lKCkKPiB3aGVuIHRoZSBn
cmFudWxhcml0eSBpcyBzZWNvbmRzLgo+Cj4gRG8geW91IHN0aWxsIHBsYW4gdG8gc2VuZCB0aGF0
IG9uZSwgb3IgZGlkIHlvdSBkZWNpZGUgd2UgZG9uJ3QKPiBuZWVkIGl0PwoKSSB3YXMgYWN0dWFs
bHkgcGxhbm5pbmcgdG8gdXNlIGdldF9zZWNvbmRzKCkgaW5zdGVhZCBvZiBjdXJyZW50X2tlcm5l
bF90aW1lKCkuCkFuZCwgdHJhbnNpdGlvbiBib3RoIGFsb25nIHdpdGggdmZzIHRvIHkyMDM4IHNh
ZmUgYXBpcy4KRGlmZmVyZW5jZSBiZXR3ZWVuIGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSBhbmQg
Y3VycmVudF9rZXJuZWxfdGltZTY0KCkKaXMgbm90IG11Y2ggYmVjYXVzZSB0aGV5IGJvdGggcmVx
dWlyZSBzZXF1ZW5jZSBjb3VudGVyLgoKSXQgZGlkbid0IG1ha2Ugc2Vuc2UgdG8gbWUgdG8gb3B0
aW1pemUgY3VycmVudF9mc190aW1lKCkgZm9yIHNlY29uZHMKb25seSwgYW5kIG5vdCBvcHRpbWl6
ZSBmb3IgMW5zIGdyYW51bGFyaXR5IGFsc28uCkkgcGxhbiB0byBtYWtlIGNoYW5nZXMgdG8gdGhl
IGZ1bmN0aW9uIGRlcGVuZGluZyBvbiBob3cgd2UgZW5kIHVwCnVzaW5nIHRpbWVzcGVjX3RydW5j
KCkKYWZ0ZXIgdGhlIGFkZGl0aW9uIG9mIHJhbmdlIGNoZWNraW5nLgoKVGhhbmtzIGZvciB0aGUg
Z3VpZGFuY2Ugb24gaW5jbHVzaW9uIG9mIHJldmlld2Vycy4gSSdsbCBmb2xsb3cgdGhpcwphcHBy
b2FjaCB3aGVuIEkgcG9zdCB2MiBvZiB0aGUgc2VyaWVzLgoKLURlZXBhCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAz
OEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL3kyMDM4Cg==
