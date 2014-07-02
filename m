From: "Zwisler, Ross" <ross.zwisler@intel.com>
Subject: Re: [PATCH] ext4: remove readpage() check up for mmap file
Date: Wed, 2 Jul 2014 15:15:54 +0000
Message-ID: <1404314153.24795.4.camel@rzwisler-mobl1.amr.corp.intel.com>
References: <1404273488-4612-1-git-send-email-zhenzhang.zhang@huawei.com>
	 <53B38434.7030500@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>
To: "zhenzhang.zhang@huawei.com" <zhenzhang.zhang@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57863 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbaGBPPz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Jul 2014 11:15:55 -0400
In-Reply-To: <53B38434.7030500@huawei.com>
Content-Language: en-US
Content-ID: <CEC5CA4CB0C4A6439626BE1154535E52@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

T24gV2VkLCAyMDE0LTA3LTAyIGF0IDEyOjAxICswODAwLCBaaGFuZyBaaGVuIHdyb3RlOg0KPiBU
aGVyZSBpcyBubyBraW5kIG9mIGZpbGUgZG9lcyBub3Qgc3VwcGx5IHBhZ2UgcmVhZGluZyBmdW5j
dGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFpoZW4gPHpoZW56aGFuZy56aGFuZ0Bo
dWF3ZWkuY29tPg0KPiAtLS0NCj4gIGZzL2V4dDQvZmlsZS5jIHwgMiAtLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZnMvZXh0NC9maWxlLmMg
Yi9mcy9leHQ0L2ZpbGUuYw0KPiBpbmRleCA4Njk1ZjcwLi5mNWMwYTE3IDEwMDY0NA0KPiAtLS0g
YS9mcy9leHQ0L2ZpbGUuYw0KPiArKysgYi9mcy9leHQ0L2ZpbGUuYw0KPiBAQCAtMjAyLDggKzIw
Miw2IEBAIHN0YXRpYyBpbnQgZXh0NF9maWxlX21tYXAoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVj
dCB2bV9hcmVhX3N0cnVjdCAqdm1hKQ0KPiAgew0KPiAgCXN0cnVjdCBhZGRyZXNzX3NwYWNlICpt
YXBwaW5nID0gZmlsZS0+Zl9tYXBwaW5nOw0KDQpBc3N1bWluZyB0aGlzIGNoYW5nZSBpcyBjb3Jy
ZWN0LCB0aGUgJ21hcHBpbmcnIHZhcmlhYmxlIGlzIG5vdyB1bnVzZWQgYW5kIGNhbg0KYWxzbyBi
ZSBkZWxldGVkLg0KDQo+IA0KPiAtCWlmICghbWFwcGluZy0+YV9vcHMtPnJlYWRwYWdlKQ0KPiAt
CQlyZXR1cm4gLUVOT0VYRUM7DQo+ICAJZmlsZV9hY2Nlc3NlZChmaWxlKTsNCj4gIAl2bWEtPnZt
X29wcyA9ICZleHQ0X2ZpbGVfdm1fb3BzOw0KPiAgCXJldHVybiAwOw0KDQo=
