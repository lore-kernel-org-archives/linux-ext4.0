From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v6 4/5] dax: for truncate/hole-punch, do zeroing through
 the driver if possible
Date: Tue, 10 May 2016 19:49:01 +0000
Message-ID: <1462909729.29294.21.camel@intel.com>
References: <1462906156-22303-1-git-send-email-vishal.l.verma@intel.com>
	 <1462906156-22303-5-git-send-email-vishal.l.verma@intel.com>
	 <20160510192507.GA29312@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-nvdimm@ml01.01.org"
	<linux-nvdimm@ml01.01.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com"
	<ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "boaz@plexistor.com" <boaz@plexistor.com>,
	"david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
To: "hch@infradead.org" <hch@infradead.org>, "axboe@fb.com" <axboe@fb.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160510192507.GA29312@infradead.org>
Content-Language: en-US
Content-ID: <21F7193DF9ABD64A97ED656576D4EB94@intel.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

T24gVHVlLCAyMDE2LTA1LTEwIGF0IDEyOjI1IC0wNzAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90
ZToNCj4gSGkgVmlzaGFsLA0KPiANCj4gY2FuIHlvdSBhbHNvIHBpY2sgdXAgdGhlIG15IHBhdGNo
IHRvIGFkZCBhIGxvdy1sZXZlbCBfX2RheF96ZXJvX3JhbmdlDQo+IHRoYXQgSSBjY2VkIHlvdSBv
bj/CoMKgVGhhdCB3YXkgd2UgY2FuIGF2b2lkIGEgbmFzdHkgbWVyZ2UgY29uZmxpY3Qgd2l0aA0K
PiBteSB4ZnMvaW9tYXAgY2hhbmdlcy4NCg0KR29vZCBpZGVhIC0gSSdsbCBkbyB0aGF0IGZvciB0
aGUgbmV4dCBwb3N0aW5nLiBJJ2xsIHdhaXQgYSBkYXkgb3IgdHdvDQpmb3IgYW55IGFkZGl0aW9u
YWwgcmV2aWV3cy9hY2tzLg0KDQpJJ20gbG9va2luZyB0byBnZXQgYWxsIHRoaXMgaW50byBhIGJy
YW5jaCBpbiB0aGUgbnZkaW1tIHRyZWUgb25jZSBKYW4NCnNwbGl0cyB1cCBoaXMgZGF4LWxvY2tp
bmcgc2VyaWVzLi4NCg0KTW9zdGx5IEkgZ3Vlc3MgSSdtIGxvb2tpbmcgZm9yIGEgeWF5IG9yIG5h
eSBmb3IgdGhlIGJsb2NrIGxheWVyIGNoYW5nZXMNCihwYXRjaCAyKS4gSmVucz8=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
