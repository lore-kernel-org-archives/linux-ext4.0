From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
 dax_clear_sectors
Date: Tue, 29 Mar 2016 18:57:16 +0000
Message-ID: <1459277829.6412.3.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	 <1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
	 <CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
	 <1458939796.5501.8.camel@intel.com>
	 <CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
	 <1459195288.15523.3.camel@intel.com>
	 <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"axboe@fb.com" <axboe@fb.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <64C5EAC5F614C94A96594C71EC7AFD03@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

T24gTW9uLCAyMDE2LTAzLTI4IGF0IDE2OjM0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQoN
Cjw+DQoNCj4gU2VlbXMga2luZCBvZiBzYWQgdG8gZmFpbCB0aGUgZmF1bHQgZHVlIHRvIGEgYmFk
IGJsb2NrIHdoZW4gd2Ugd2VyZQ0KPiBnb2luZyB0byB6ZXJvIGl0IGFueXdheSwgcmlnaHQ/wqDC
oEknbSBub3Qgc2VlaW5nIGEgY29tcGVsbGluZyByZWFzb24gdG8NCj4ga2VlcCBhbnkgemVyb2lu
ZyBpbiBmcy9kYXguYy4NCg0KQWdyZWVkIC0gYnV0IGhvdyBkbyB3ZSBkbyB0aGlzPyBjbGVhcl9w
bWVtIG5lZWRzIHRvIGJlIGFibGUgdG8gY2xlYXIgYW4NCmFyYml0cmFyeSBudW1iZXIgb2YgYnl0
ZXMsIGJ1dCB0byBnbyB0aHJvdWdoIHRoZSBkcml2ZXIsIHdlJ2QgbmVlZCB0bw0Kc2VuZCBkb3du
IGEgYmlvPyBJZiBvbmx5IHRoZSBkcml2ZXIgaGFkIGFuIHJ3X2J5dGVzIGxpa2UgaW50ZXJmYWNl
IHRoYXQNCmNvdWxkIGJlIHVzZWQgYnkgYW55b25lLi4uIDop
