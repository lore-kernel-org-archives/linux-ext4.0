From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH 01/21] fs: Replace CURRENT_TIME_SEC with
	current_fs_time()
Date: Thu, 9 Jun 2016 13:41:10 -0700
Message-ID: <CABeXuvqO6NsZdabHHiVWRYDNc0qB+jNRAiytR=ZyBV0DUSTEZw@mail.gmail.com>
References: <1465448705-25055-1-git-send-email-deepa.kernel@gmail.com>
 <1465448705-25055-2-git-send-email-deepa.kernel@gmail.com>
 <20160609073507.GA2790@quack2.suse.cz>
 <CA+55aFzomEx82xuREb23K12g7XqDAZgrwYHWhOpgQVp1hk3oQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, Bob Copeland <me@bobcopeland.com>,
 Adrian Hunter <adrian.hunter@intel.com>, David Howells <dhowells@redhat.com>,
 Andreas Dilger <adilger.kernel@dilger.ca>, linux-afs@lists.infradead.org,
 y2038@lists.linaro.org, codalist@coda.cs.cmu.edu,
 Christoph Hellwig <hch@infradead.org>, coda@cs.cmu.edu,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Evgeniy Dushistov <dushistov@mail.ru>, Arnd Bergmann <arnd@arndb.de>,
 Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Jan Harkes <jaharkes@cs.cmu.edu>,
 Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-mtd <linux-mtd@lists.in
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CA+55aFzomEx82xuREb23K12g7XqDAZgrwYHWhOpgQVp1hk3oQw@mail.gmail.com>
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

T24gVGh1LCBKdW4gOSwgMjAxNiBhdCAxMjoxNSBQTSwgTGludXMgVG9ydmFsZHMKPHRvcnZhbGRz
QGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToKPiBPbiBUaHUsIEp1biA5LCAyMDE2IGF0IDEy
OjM1IEFNLCBKYW4gS2FyYSA8amFja0BzdXNlLmN6PiB3cm90ZToKPj4KPj4gWW91IGNyZWF0ZSBs
aW5lIGxvbmdlciB0aGFuIDgwIGNoYXJhY3RlcnMgZm9yIGFmZnMgYW5kIHJlaXNlcmZzLiBQbGVh
c2UKPj4gd3JhcCB0aG9zZSBsaW5lcyBwcm9wZXJseS4KPgo+IE5vLCBwbGVhc2UgZG8gKk5PVCog
ZG8gdGhpbmdzIGxpa2UgdGhhdC4KPgo+IFRoZXNlIGtpbmQgb2YgbWVjaGFuaWNhbCBwYXRjaGVz
IHNob3VsZAo+Cj4gIChhKSBiZSBhcyBtZWNoYW5pY2FsIGFzIHBvc3NpYmxlIChhbmQgc2VlIGVs
c2V3aGVyZSBhYm91dCB3aHkgSSB0aGluawo+ICdzYicgc2hvdWxkIGJlICdpbm9kZScgYW5kIHRo
ZSBwYXRjaCBzaG91bGQgaGF2ZSBiZWVuIDk1JSBhdXRvbWF0ZWQKPiB3aXRoIGEgdHJpdmlhbCBz
Y3JpcHQgdGhhbmtzIHRvIHRoYXQgY2hhbmdlKQo+Cj4gIChiKSBiZSBtYWRlIGFzIGVhc3kgdG8g
dmVyaWZ5IHZpc3VhbGx5IGFzIHBvc3NpYmxlLgo+Cj4gVGhhdCAoYikgbWVhbnMgdGhhdCBhIGNv
bnZlcnNpb24gc2hvdWxkICpub3QqIGFkZCB3aGl0ZXNwYWNlIGZpeHVwcyBvcgo+IGFkZCBvdGhl
ciBub24tbWVjaGFuaWNhbCBjbGVhbnVwcywgYmVjYXVzZSBpdCdzIGEgKmxvdCogZWFzaWVyIHRv
IHNlZQo+IHRoYXQgYSBjb252ZXJzaW9uIGxpa2UKPgo+IC0gICAgICAgaW5vZGUtPmlfbXRpbWUg
PSBpbm9kZS0+aV9jdGltZSA9IENVUlJFTlRfVElNRV9TRUM7Cj4gKyAgICAgICBpbm9kZS0+aV9t
dGltZSA9IGlub2RlLT5pX2N0aW1lID0gY3VycmVudF9mc190aW1lKGlub2RlKTsKPgo+IG1ha2Vz
IG5vIG90aGVyIGNoYW5nZXMsIGJ1dCBpZiB5b3Ugc3RhcnQgZG9pbmcgbGluZS1zcGxpdHRpbmcg
b3Igb3RoZXIKPiB0cmFuc2Zvcm1hdGlvbnMgKGFkZCBuZXcgdmFyaWFibGVzIGV0YyB0byBnZXQg
YXQgJ3NiJyksIHN1ZGRlbmx5IHlvdQo+IGhhdmUgdG8gdmVyaWZ5IHRoZSBwYXRjaCBhdCBhIGNv
bXBsZXRlbHkgZGlmZmVyZW50IGxldmVsLgo+Cj4gSW4gb3RoZXIgd29yZHMsIGl0J3MgYWN0dWFs
bHkgcmVhbGx5IGltcG9ydGFudCB0byBtYWtlIHRoZXNlIGtpbmRzIG9mCj4gYnVsayBjaGFuZ2Vz
IGJlIHZlcnkgdmVyeSBvYnZpb3VzLiBJbmNsdWRpbmcgdG8gdGhlIHBvaW50IG9mIG1ha2luZwo+
IHRoZW0gdmlzdWFsbHkgZWFzaWVyIHRvIHNjYW4gYXMgYSBwYXRjaCBieSBub3QgbWFraW5nIGFu
eSBvdGhlcgo+IGNoYW5nZXMuCgpUaGFua3MgZm9yIHRoZSBndWlkZWxpbmVzLgpPbmx5IHBhdGNo
ZXMgMSBhbmQgNCBhcmUgbWVjaGFuaWNhbC4KQWxsIG90aGVycyBuZWVkIHNvbWUga2luZCBvZiBp
bnNwZWN0aW9uLyB2ZXJpZmljYXRpb24uCkkgd2lsbCBrZWVwIHRoZXNlIGluIG1pbmQgZm9yIHVw
ZGF0aW5nIDEgYW5kIDQuCgotRGVlcGEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcK
aHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
