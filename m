From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH 1/2] ext4, dax: update dax check to skip journal inode
Date: Tue, 11 Sep 2018 18:11:39 +0000
Message-ID: <19388d015c54202ee3d1e8526677ccdf7d46cd02.camel@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
         <20180911154246.6844-2-toshi.kani@hpe.com>
         <CAPcyv4j0zF+OjqPywkmZLgGiSjNdH_9SwpXjS=92bqT9OXZ_MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4j0zF+OjqPywkmZLgGiSjNdH_9SwpXjS=92bqT9OXZ_MQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <4A8A9F59A15EEE4EB1D10A8094F9B84B@NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

T24gVHVlLCAyMDE4LTA5LTExIGF0IDEwOjU5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgU2VwIDExLCAyMDE4IGF0IDg6NDIgQU0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4gd3JvdGU6DQo+ID4gRXh0NCBtb3VudCBwYXRoIGNhbGxzIGV4dDRfaWdldCgpIHRv
IG9idGFpbiB0aGUgam91cm5hbCBpbm9kZS4gIFRoaXMNCj4gPiBpbm9kZSBkb2VzIG5vdCBzdXBw
b3J0IERBWCwgYW5kICdleHQ0X2RhX2FvcHMnIG5lZWRzIHRvIGJlIHNldC4gIEl0DQo+ID4gY3Vy
cmVudGx5IHdvcmtzIGZvciB0aGUgREFYIG1vdW50IGNhc2UgYmVjYXVzZSBleHQ0X2lnZXQoKSBh
bHdheXMgc2V0DQo+ID4gJ2V4dDRfZGFfYW9wcycgdG8gYW55IHJlZ3VsYXIgZmlsZXMuDQo+ID4g
DQo+ID4gICBleHQ0X2ZpbGxfc3VwZXINCj4gPiAgICAgZXh0NF9sb2FkX2pvdXJuYWwNCj4gPiAg
ICAgICBleHQ0X2dldF9qb3VybmFsX2lub2RlDQo+ID4gICAgICAgICBleHQ0X2lnZXQNCj4gPiAN
Cj4gPiBJbiBwcmVwYXJhdGlvbiB0byBmaXggZXh0NF9pZ2V0KCkgdG8gc2V0ICdleHQ0X2RheF9h
b3BzJyBmb3IgREFYIGZpbGVzLA0KPiA+IHVwZGF0ZSBleHQ0X3Nob3VsZF91c2VfZGF4KCkgdG8g
cmV0dXJuIGZhbHNlIGZvciB0aGUgam91cm5hbCBpbm9kZS4NCj4gPiANCj4gPiBGaXhlczogNWYw
NjYzYmI0YTY0ZjU4OGYwYTJkZDZkMWJlNjhkNDBmOWFmMDA4Ng0KPiANCj4gSnVzdCBhIG1pbm9y
IGZvcm1hdCByZWNvbW1lbmRhdGlvbjoNCj4gDQo+IEZpeGVzOiA1ZjA2NjNiYjRhNjQgKCJleHQ0
LCBkYXg6IGludHJvZHVjZSBleHQ0X2RheF9hb3BzIikNCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPg0KDQpXaWxsIGRvLg0KDQo+IA0KPiBUaGlzIGxvb2tzIGdvb2QgdG8gbWUuDQo+IA0K
PiBSZXZpZXdlZC1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoN
ClRoYW5rcyENCi1Ub3NoaQ0KDQo=
