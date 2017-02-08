From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/2] ext4: fix DAX write locking
Date: Wed, 8 Feb 2017 09:14:10 -0800
Message-ID: <20170208171410.GA27359@infradead.org>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
 <1484063288-18255-2-git-send-email-hch@lst.de>
 <20170111090136.GE16116@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Ted Tso <tytso-3s7WtUTddSA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170111090136.GE16116-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCBKYW4gMTEsIDIwMTcgYXQgMTA6MDE6MzZBTSArMDEwMCwgSmFuIEthcmEgd3JvdGU6
Cj4gT24gVHVlIDEwLTAxLTE3IDE2OjQ4OjA3LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToKPiA+
IFVubGlrZSBPX0RJUkVDVCBEQVggaXMgbm90IGFuIG9wdGlvbmFsIG9wdC1pbiBmZWF0dXJlIHNl
bGVjdGVkIGJ5IHRoZQo+ID4gYXBwbGljYXRpb24sIHNvIHdlJ2xsIGhhdmUgdG8gcHJvdmlkZSB0
aGUgdHJhZGl0aW9uYWwgc3luY2hyb27RlnphdGlvbgo+ID4gb2Ygb3ZlcmxhcHBpbmcgd3JpdGVz
IGFzIHdlIGRvIGZvciBidWZmZXJlZCB3cml0ZXMuCj4gPiAKPiA+IFRoaXMgd2FzIGJyb2tlbiBo
aXN0b3JpY2FsbHkgZm9yIERBWCwgYnV0IGdvdCBmaXhlZCBmb3IgZXh0MiBhbmQgWEZTCj4gPiBh
cyBwYXJ0IG9mIHRoZSBpb21hcCBjb252ZXJzaW9uLiAgRml4IHVwIGV4dDQgYXMgd2VsbC4KPiA+
IAo+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+Cj4gCj4g
TWFrZXMgc2Vuc2UuIFlvdSBjYW4gYWRkOgo+IAo+IFJldmlld2VkLWJ5OiBKYW4gS2FyYSA8amFj
a0BzdXNlLmN6Pgo+IAo+IFRlZCwgY2FuIHlvdSBwbGVhc2UgcGljayBpdCB1cD8gVGhhbmtzIQoK
RGlkIHRoaXMgZ2V0IHBpY2tlZCB1cD8KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
