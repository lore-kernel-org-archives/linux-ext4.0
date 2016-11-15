From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RESEND] fs: ext4: Use current_time() for inode
	timestamps
Date: Mon, 14 Nov 2016 21:53:20 -0500
Message-ID: <20161115025320.oax4e56om5zcjynt@thunk.org>
References: <1478889177-4107-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
 adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org, arnd@arndb.de
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <1478889177-4107-1-git-send-email-deepa.kernel@gmail.com>
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

T24gRnJpLCBOb3YgMTEsIDIwMTYgYXQgMTA6MzI6NTdBTSAtMDgwMCwgRGVlcGEgRGluYW1hbmkg
d3JvdGU6Cj4gQ1VSUkVOVF9USU1FX1NFQyBhbmQgQ1VSUkVOVF9USU1FIGFyZSBub3QgeTIwMzgg
c2FmZS4KPiBjdXJyZW50X3RpbWUoKSB3aWxsIGJlIHRyYW5zaXRpb25lZCB0byBiZSB5MjAzOCBz
YWZlCj4gYWxvbmcgd2l0aCB2ZnMuCj4gCj4gY3VycmVudF90aW1lKCkgcmV0dXJucyB0aW1lc3Rh
bXBzIGFjY29yZGluZyB0byB0aGUKPiBncmFudWxhcml0aWVzIHNldCBpbiB0aGUgc3VwZXJfYmxv
Y2suCj4gVGhlIGdyYW51bGFyaXR5IGNoZWNrIGluIGV4dDRfY3VycmVudF90aW1lKCkgdG8gY2Fs
bAo+IGN1cnJlbnRfdGltZSgpIG9yIENVUlJFTlRfVElNRV9TRUMgaXMgbm90IHJlcXVpcmVkLgo+
IFVzZSBjdXJyZW50X3RpbWUoKSBkaXJlY3RseSB0byBvYnRhaW4gdGltZXN0YW1wcwo+IHVuY29u
ZGl0aW9uYWxseSwgYW5kIHJlbW92ZSBleHQ0X2N1cnJlbnRfdGltZSgpLgo+IAo+IFF1b3RhIGZp
bGVzIGFyZSBhc3N1bWVkIHRvIGJlIG9uIHRoZSBzYW1lIGZpbGVzeXN0ZW0uCj4gSGVuY2UsIHVz
ZSBjdXJyZW50X3RpbWUoKSBmb3IgdGhlc2UgZmlsZXMgYXMgd2VsbC4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBEZWVwYSBEaW5hbWFuaSA8ZGVlcGEua2VybmVsQGdtYWlsLmNvbT4KPiBSZXZpZXdlZC1i
eTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KClRoYW5rcywgYXBwbGllZC4KCgkJCQkJ
LSBUZWQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIw
MzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5h
cm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
