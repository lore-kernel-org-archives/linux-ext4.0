From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: INFO: task hung in blk_queue_enter
Date: Wed, 16 May 2018 15:37:24 +0000
Message-ID: <6db16aa3a7c56b6dcca2d10b4e100a780c740081.camel@wdc.com>
References: <0000000000009b212b056ae6dbad@google.com>
         <343bbbf6-64eb-879e-d19e-96aebb037d47@I-love.SAKURA.ne.jp>
         <b9c33b04-08d7-87a1-3d93-d81a84e6af12@I-love.SAKURA.ne.jp>
         <43327033306c3dd2f7c3717d64ce22415b6f3451.camel@wdc.com>
         <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "jthumshirn@suse.de" <jthumshirn@suse.de>,
        "alan.christopher.jenkins@gmail.com"
        <alan.christopher.jenkins@gmail.com>,
        "syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com"
        <syzbot+c4f9cebf9d651f6e54de@syzkaller.appspotmail.com>,
        "penguin-kernel@i-love.sakura.ne.jp"
        <penguin-kernel@i-love.sakura.ne.jp>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "martin@lichtvoll.de" <martin@lichtvoll.de>,
        "hare@suse.c
To: "dvyukov@google.com" <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+ZJwvROpBmKWF08fTd2AH=dO-a5+dzCzZua_vVFjiCRBw@mail.gmail.com>
Content-Language: en-US
Content-ID: <75B75C59F0955A40B067930C3A7573DD@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

T24gV2VkLCAyMDE4LTA1LTE2IGF0IDE3OjE2ICswMjAwLCBEbWl0cnkgVnl1a292IHdyb3RlOg0K
PiBPbiBXZWQsIE1heSAxNiwgMjAxOCBhdCA0OjU2IFBNLCBCYXJ0IFZhbiBBc3NjaGUgPEJhcnQu
VmFuQXNzY2hlQHdkYy5jb20+IHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAxOC0wNS0xNiBhdCAyMjow
NSArMDkwMCwgVGV0c3VvIEhhbmRhIHdyb3RlOg0KPiA+ID4gZGlmZiAtLWdpdCBhL2Jsb2NrL2Js
ay1jb3JlLmMgYi9ibG9jay9ibGstY29yZS5jDQo+ID4gPiBpbmRleCA4NTkwOWI0Li41OWUyNDk2
IDEwMDY0NA0KPiA+ID4gLS0tIGEvYmxvY2svYmxrLWNvcmUuYw0KPiA+ID4gKysrIGIvYmxvY2sv
YmxrLWNvcmUuYw0KPiA+ID4gQEAgLTk1MSwxMCArOTUxLDEwIEBAIGludCBibGtfcXVldWVfZW50
ZXIoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIGJsa19tcV9yZXFfZmxhZ3NfdCBmbGFncykNCj4g
PiA+ICAgICAgICAgICAgICAgc21wX3JtYigpOw0KPiA+ID4gDQo+ID4gPiAgICAgICAgICAgICAg
IHdhaXRfZXZlbnQocS0+bXFfZnJlZXplX3dxLA0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAg
ICAgIChhdG9taWNfcmVhZCgmcS0+bXFfZnJlZXplX2RlcHRoKSA9PSAwICYmDQo+ID4gPiAtICAg
ICAgICAgICAgICAgICAgICAgICAgIChwcmVlbXB0IHx8ICFibGtfcXVldWVfcHJlZW1wdF9vbmx5
KHEpKSkgfHwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICBhdG9taWNfcmVhZCgmcS0+
bXFfZnJlZXplX2RlcHRoKSB8fA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIChwcmVl
bXB0IHx8ICFibGtfcXVldWVfcHJlZW1wdF9vbmx5KHEpKSB8fA0KPiA+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgIGJsa19xdWV1ZV9keWluZyhxKSk7DQo+ID4gPiAtICAgICAgICAgICAgIGlm
IChibGtfcXVldWVfZHlpbmcocSkpDQo+ID4gPiArICAgICAgICAgICAgIGlmIChhdG9taWNfcmVh
ZCgmcS0+bXFfZnJlZXplX2RlcHRoKSB8fCBibGtfcXVldWVfZHlpbmcocSkpDQo+ID4gPiAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ID4gPiAgICAgICB9DQo+ID4gPiAg
fQ0KPiA+IA0KPiA+IFRoYXQgY2hhbmdlIGxvb2tzIHdyb25nIHRvIG1lLg0KPiANCj4gSGkgQmFy
dCwNCj4gDQo+IFdoeSBkb2VzIGl0IGxvb2sgd3JvbmcgdG8geW91Pw0KDQpCZWNhdXNlIHRoYXQg
Y2hhbmdlIGNvbmZsaWN0cyB3aXRoIHRoZSBwdXJwb3NlIG9mIHF1ZXVlIGZyZWV6aW5nIGFuZCBh
bHNvIGJlY2F1c2UNCnRoYXQgY2hhbmdlIHdvdWxkIGluamVjdCBJL08gZXJyb3JzIGluIGNvZGUg
cGF0aHMgdGhhdCBzaG91bGRuJ3QgaW5qZWN0IEkvTyBlcnJvcnMuDQpQbGVhc2UgaGF2ZSBhIGxv
b2sgYXQgZS5nLiBnZW5lcmljX21ha2VfcmVxdWVzdCgpLiBGcm9tIHRoZSBzdGFydCBvZiB0aGF0
IGZ1bmN0aW9uOg0KDQoJaWYgKGJsa19xdWV1ZV9lbnRlcihxLCBmbGFncykgPCAwKSB7DQoJCWlm
ICghYmxrX3F1ZXVlX2R5aW5nKHEpICYmIChiaW8tPmJpX29wZiAmIFJFUV9OT1dBSVQpKQ0KCQkJ
YmlvX3dvdWxkYmxvY2tfZXJyb3IoYmlvKTsNCgkJZWxzZQ0KCQkJYmlvX2lvX2Vycm9yKGJpbyk7
DQoJCXJldHVybiByZXQ7DQoJfQ0KDQpUaGUgYWJvdmUgcGF0Y2ggY2hhbmdlcyB0aGUgYmVoYXZp
b3Igb2YgYmxrX3F1ZXVlX2VudGVyKCkgY29kZSBmcm9tIHdhaXRpbmcgd2hpbGUNCnEtPm1xX2Zy
ZWV6ZV9kZXB0aCAhPSAwIGludG8gcmV0dXJuaW5nIC1FTk9ERVYgd2hpbGUgdGhlIHJlcXVlc3Qg
cXVldWUgaXMgZnJvemVuLg0KVGhhdCB3aWxsIGNhdXNlIGdlbmVyaWNfbWFrZV9yZXF1ZXN0KCkg
dG8gY2FsbCBiaW9faW9fZXJyb3IoYmlvKSB3aGlsZSBhIHJlcXVlc3QNCnF1ZXVlIGlzIGZyb3pl
biBpZiBSRVFfTk9XQUlUIGhhcyBub3QgYmVlbiBzZXQsIHdoaWNoIGlzIHRoZSBkZWZhdWx0IGJl
aGF2aW9yLiBTbw0KYW55IG9wZXJhdGlvbiB0aGF0IGZyZWV6ZXMgdGhlIHF1ZXVlIHRlbXBvcmFy
aWx5LCBlLmcuIGNoYW5naW5nIHRoZSBxdWV1ZSBkZXB0aCwNCmNvbmN1cnJlbnRseSB3aXRoIEkv
TyBwcm9jZXNzaW5nIGNhbiBjYXVzZSBJL08gdG8gZmFpbCB3aXRoIC1FTk9ERVYuIEFzIHlvdQ0K
cHJvYmFibHkga25vdyBmYWlsdXJlIG9mIHdyaXRlIHJlcXVlc3RzIGhhcyB2ZXJ5IGFubm95aW5n
IGNvbnNlcXVlbmNlcy4gSXQgZS5nLg0KY2F1c2VzIGZpbGVzeXN0ZW1zIHRvIGdvIGludG8gcmVh
ZC1vbmx5IG1vZGUuIFRoYXQncyB3aHkgSSB0aGluayB0aGF0IHRoZSBhYm92ZQ0KY2hhbmdlIGlz
IGNvbXBsZXRlbHkgd3JvbmcuDQoNCkJhcnQuDQoNCg0K
