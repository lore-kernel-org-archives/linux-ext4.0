From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: make journal y2038 safe
Date: Sun, 19 Jun 2016 17:53:47 +0200
Message-ID: <20160619155347.GB2734@quack2.suse.cz>
References: <20160617153916.444842-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
 Jan Kara <jack@suse.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <20160617153916.444842-1-arnd@arndb.de>
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

T24gRnJpIDE3LTA2LTE2IDE3OjM5OjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOgo+IFRoZSBqYmQy
IGpvdXJuYWwgc3RvcmVzIHRoZSBjb21taXQgdGltZSBpbiA2NC1iaXQgc2Vjb25kcyBhbmQgMzIt
Yml0Cj4gbmFub3NlY29uZHMsIHdoaWNoIGF2b2lkcyBhbiBvdmVyZmxvdyBpbiAyMDM4LCBidXQg
aXQgZ2V0cyB0aGUgbnVtYmVycwo+IGZyb20gY3VycmVudF9rZXJuZWxfdGltZSgpLCB3aGljaCB1
c2VzICdsb25nJyBzZWNvbmRzIG9uIDMyLWJpdAo+IGFyY2hpdGVjdHVyZXMuCj4gCj4gVGhpcyBz
aW1wbHkgY2hhbmdlcyB0aGUgY29kZSB0byBjYWxsIGN1cnJlbnRfa2VybmVsX3RpbWU2NCgpIHNv
Cj4gd2UgdXNlIDY0LWJpdCBzZWNvbmRzIGNvbnNpc3RlbnRseS4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPgoKVGhlIHBhdGNoIGxvb2tzIGdvb2QuIFlv
dSBjYW4gYWRkOgoKUmV2aWV3ZWQtYnk6IEphbiBLYXJhIDxqYWNrQHN1c2UuY3o+CgoJCQkJCQkJ
CUhvbnphCgo+IC0tLQo+ICBmcy9qYmQyL2NvbW1pdC5jIHwgMiArLQo+ICAxIGZpbGUgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKPiAKPiBkaWZmIC0tZ2l0IGEvZnMvamJk
Mi9jb21taXQuYyBiL2ZzL2piZDIvY29tbWl0LmMKPiBpbmRleCA4ZjdkMTMzOWM5NzMuLjViYjU2
NWY5OTg5YyAxMDA2NDQKPiAtLS0gYS9mcy9qYmQyL2NvbW1pdC5jCj4gKysrIGIvZnMvamJkMi9j
b21taXQuYwo+IEBAIC0xMjQsNyArMTI0LDcgQEAgc3RhdGljIGludCBqb3VybmFsX3N1Ym1pdF9j
b21taXRfcmVjb3JkKGpvdXJuYWxfdCAqam91cm5hbCwKPiAgCXN0cnVjdCBjb21taXRfaGVhZGVy
ICp0bXA7Cj4gIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJoOwo+ICAJaW50IHJldDsKPiAtCXN0cnVj
dCB0aW1lc3BlYyBub3cgPSBjdXJyZW50X2tlcm5lbF90aW1lKCk7Cj4gKwlzdHJ1Y3QgdGltZXNw
ZWM2NCBub3cgPSBjdXJyZW50X2tlcm5lbF90aW1lNjQoKTsKPiAgCj4gIAkqY2JoID0gTlVMTDsK
PiAgCj4gLS0gCj4gMi45LjAKPiAKLS0gCkphbiBLYXJhIDxqYWNrQHN1c2UuY29tPgpTVVNFIExh
YnMsIENSCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClky
MDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGlu
YXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
