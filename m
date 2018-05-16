From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Wed, 16 May 2018 14:56:42 +0000
Message-ID: <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
References: <0000000000009b212b056ae6dbad@google.com>
         <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
         <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jthumshirn@suse.de" <jthumshirn@suse.de>,
        "alan.christopher.jenkins@gmail.com"
        <alan.christopher.jenkins@gmail.com>, "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "dvyukov@google.com" <dvyukov@google.com>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "martin@lichtvoll.de" <martin@lichtvoll.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "hare@suse.com" <hare@suse.com>,
        "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
        "keith.busch@intel.com" <keith.busch@intel.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com"
        <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "penguin-kernel@I-love.SAKURA.ne.jp"
        <penguin-kernel@I-love.SAKURA.ne.jp>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
Content-Language: en-US
Content-ID: <D1CA9707F198184EA5F02F5680C69B6C@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCAyMDE4LTA1LTE2IGF0IDIyOjA1ICswOTAwLCBUZXRzdW8gSGFuZGEgd3JvdGU6DQo+
IE9uZSBvcmUgbW9yZSB0aHJlYWRzIGFyZSB3YWl0aW5nIGZvciBxLT5tcV9mcmVlemVfZGVwdGgg
dG8gYmVjb21lIDAuIEJ1dCB0aGUNCj4gdGhyZWFkIHdobyBpbmNyZW1lbnRlZCBxLT5tcV9mcmVl
emVfZGVwdGggYXQgYmxrX2ZyZWV6ZV9xdWV1ZV9zdGFydChxKSBmcm9tDQo+IGJsa19mcmVlemVf
cXVldWUoKSBpcyB3YWl0aW5nIGF0IGJsa19tcV9mcmVlemVfcXVldWVfd2FpdCgpLiBUaGVyZWZv
cmUsDQo+IGF0b21pY19yZWFkKCZxLT5tcV9mcmVlemVfZGVwdGgpID09IDAgY29uZGl0aW9uIGZv
ciB3YWl0X2V2ZW50KCkgaW4NCj4gYmxrX3F1ZXVlX2VudGVyKCkgd2lsbCBuZXZlciBiZSBzYXRp
c2ZpZWQuIEJ1dCB3aGF0IGRvZXMgdGhhdCB3YWl0X2V2ZW50KCkNCj4gd2FudCB0byBkbz8gSXNu
J3QgInN0YXJ0IGZyZWV6aW5nIiBhIHNvcnQgb2YgYmxrX3F1ZXVlX2R5aW5nKHEpID09IHRydWU/
DQo+IFNpbmNlIHBlcmNwdV9yZWZfdHJ5Z2V0X2xpdmUoJnEtPnFfdXNhZ2VfY291bnRlcikgZmFp
bGVkIGFuZCB0aGUgcXVldWUgaXMNCj4gYWJvdXQgdG8gYmUgZnJvemVuLCBzaG91bGRuJ3Qgd2Ug
dHJlYXQgYXRvbWljX3JlYWQoJnEtPm1xX2ZyZWV6ZV9kZXB0aCkgIT0gMA0KPiBhcyBpZiBibGtf
cXVldWVfZHlpbmcocSkgPT0gdHJ1ZT8gVGhhdCBpcywgc29tZXRoaW5nIGxpa2UgYmVsb3c6DQo+
IA0KPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLWNvcmUuYyBiL2Jsb2NrL2Jsay1jb3JlLmMNCj4g
aW5kZXggODU5MDliNC4uNTllMjQ5NiAxMDA2NDQNCj4gLS0tIGEvYmxvY2svYmxrLWNvcmUuYw0K
PiArKysgYi9ibG9jay9ibGstY29yZS5jDQo+IEBAIC05NTEsMTAgKzk1MSwxMCBAQCBpbnQgYmxr
X3F1ZXVlX2VudGVyKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBibGtfbXFfcmVxX2ZsYWdzX3Qg
ZmxhZ3MpDQo+ICAJCXNtcF9ybWIoKTsNCj4gIA0KPiAgCQl3YWl0X2V2ZW50KHEtPm1xX2ZyZWV6
ZV93cSwNCj4gLQkJCSAgIChhdG9taWNfcmVhZCgmcS0+bXFfZnJlZXplX2RlcHRoKSA9PSAwICYm
DQo+IC0JCQkgICAgKHByZWVtcHQgfHwgIWJsa19xdWV1ZV9wcmVlbXB0X29ubHkocSkpKSB8fA0K
PiArCQkJICAgYXRvbWljX3JlYWQoJnEtPm1xX2ZyZWV6ZV9kZXB0aCkgfHwNCj4gKwkJCSAgIChw
cmVlbXB0IHx8ICFibGtfcXVldWVfcHJlZW1wdF9vbmx5KHEpKSB8fA0KPiAgCQkJICAgYmxrX3F1
ZXVlX2R5aW5nKHEpKTsNCj4gLQkJaWYgKGJsa19xdWV1ZV9keWluZyhxKSkNCj4gKwkJaWYgKGF0
b21pY19yZWFkKCZxLT5tcV9mcmVlemVfZGVwdGgpIHx8IGJsa19xdWV1ZV9keWluZyhxKSkNCj4g
IAkJCXJldHVybiAtRU5PREVWOw0KPiAgCX0NCj4gIH0NCg0KVGhhdCBjaGFuZ2UgbG9va3Mgd3Jv
bmcgdG8gbWUuIEFkZGl0aW9uYWxseSwgSSB0aGluayB0aGF0IHlvdSBhcmUgbG9va2luZyBpbg0K
dGhlIHdyb25nIGRpcmVjdGlvbi4gU2luY2UgYmxrX21xX2ZyZWV6ZV9xdWV1ZV93YWl0KCkgYW5k
IGJsa19xdWV1ZV9lbnRlcigpDQp3b3JrIGZpbmUgZm9yIGFsbCBibG9jayBkcml2ZXJzIGV4Y2Vw
dCB0aGUgbG9vcCBkcml2ZXIgSSB0aGluayB0aGF0IHlvdSBzaG91bGQNCmhhdmUgYSBjbG9zZXIg
bG9vayBhdCBob3cgdGhlIGxvb3AgZHJpdmVyIHVzZXMgdGhpcyBibG9jayBsYXllciBmdW5jdGlv
bmFsaXR5Lg0KDQpUaGFua3MsDQoNCkJhcnQuDQoNCg0KDQo=
