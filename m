From: Jan Kara <jack@suse.cz>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re: [PATCH v4
 13/17] khwasan: add hooks implementation)
Date: Mon, 6 Aug 2018 22:20:17 +0200
Message-ID: <20180806202017.lrzihv42b4mtcgrn@quack2.suse.cz>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com>
 <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com>
 <CA+55aFzHR1+YbDee6Cduo6YXHO9LKmLN1wP=MVzbP41nxUb5=g@mail.gmail.com>
 <CA+55aFzYLgyNp1jsqsvUOjwZdO_1Piqj=iB=rzDShjScdNtkbg@mail.gmail.com>
 <CACT4Y+aYZumcc-Od5T1AnP4mwn8-FaWfxvfb93MnNwQPqG8TDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Dave Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>,
 linux-mm <linux-mm@kvack.org>, Eric Dumazet <edumazet@google.com>,
 Christoph Lameter <cl@linux.com>, Gerrit Renker <gerrit@erg.abdn.ac.uk>,
 dccp@vger.kernel.org, coreteam@netfilter.org,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>, linux-ext4@vger.kernel.org,
 Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Andrey Konovalov <andreyknvl@google.com>,
 intel-gfx <intel-gfx@lists.freedesktop.org>, Jan Kara <jack@suse.com>,
 Ursula Braun <ubraun@linux.ibm.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Theodore Ts'o <tytso@mit.edu>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Network Development <netdev@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
 Linux Kernel Mailing List <linux-kernel@vg
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+aYZumcc-Od5T1AnP4mwn8-FaWfxvfb93MnNwQPqG8TDw@mail.gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
List-Id: linux-ext4.vger.kernel.org

T24gV2VkIDAxLTA4LTE4IDEwOjQ2OjM1LCBEbWl0cnkgVnl1a292IHdyb3RlOgo+IEkgZ3Vlc3Mg
aXQgd291bGQgYmUgdXNlZnVsIHRvIGhhdmUgc3VjaCBleHRlbnNpdmUgY29tbWVudCBmb3IgZWFj
aAo+IFNMQUJfVFlQRVNBRkVfQllfUkNVIHVzZSBleHBsYWluaW5nIHdoeSBpdCBpcyBuZWVkZWQg
YW5kIGhvdyBhbGwgdGhlCj4gdHJpY2t5IGFzcGVjdHMgYXJlIGhhbmRsZWQuCj4gCj4gRm9yIGV4
YW1wbGUsIHRoZSBvbmUgaW4gamJkMiBpcyBpbnRlcmVzdGluZyBiZWNhdXNlIGl0IG1lbXNldHMg
dGhlCj4gd2hvbGUgb2JqZWN0IGJlZm9yZSBmcmVlaW5nIGl0IGludG8gU0xBQl9UWVBFU0FGRV9C
WV9SQ1Ugc2xhYjoKPiAKPiBtZW1zZXQoamgsIEpCRDJfUE9JU09OX0ZSRUUsIHNpemVvZigqamgp
KTsKPiBrbWVtX2NhY2hlX2ZyZWUoamJkMl9qb3VybmFsX2hlYWRfY2FjaGUsIGpoKTsKPiAKPiBJ
IGd1ZXNzIHRoZXJlIGFyZSBhbHNvIHRyaWNreSB3YXlzIGhvdyBpdCBjYW4gYWxsIHdvcmsgaW4g
dGhlIGVuZAo+ICh0eXBlLXN0YWJsZSBzdGF0ZSBpcyBvbmx5IGEgYnl0ZSwgb3Igd2UgY2hlY2sg
Zm9yIGFsbCBwb3NzaWJsZQo+IGNvbWJpbmF0aW9ucyBvZiBiZWluZyBvdmVyd3JpdHRlbiB3aXRo
IEpCRDJfUE9JU09OX0ZSRUUpLiBCdXQgYXQgZmlyc3QKPiBzaWdodCBpdCBkb2VzIGxvb2sgZmlz
aHkuCgpUaGUgUkNVIGFjY2VzcyBpcyB1c2VkIGZyb20gYSBzaW5nbGUgcGxhY2U6Cgpmcy9qYmQy
L3RyYW5zYWN0aW9uLmM6IGpiZDJfd3JpdGVfYWNjZXNzX2dyYW50ZWQoKQoKVGhlcmUgYXJlIGFs
c28gcXVpdGUgc29tZSBjb21tZW50cyBleHBsYWluaW5nIHdoeSB3aGF0IGl0IGRvZXMgaXMgc2Fm
ZS4gVGhlCm92ZXJ3cml0ZSBieSBKQkQyX1BPSVNPTl9GUkVFIGlzIG11Y2ggb2xkZXIgdGhhbiB0
aGlzIFJDVSBzdHVmZiAoaG9uZXN0bHkgSQpkaWRuJ3Qga25vdyBhYm91dCBpdCB1bnRpbCB0aGlz
IG1vbWVudCkgYW5kIGhhcyBub3RoaW5nIHRvIGRvIHdpdGggdGhlCnNhZmV0eSBvZiBSQ1UgYWNj
ZXNzLgoKCQkJCQkJCQlIb256YQoKLS0gCkphbiBLYXJhIDxqYWNrQHN1c2UuY29tPgpTVVNFIExh
YnMsIENSCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmRy
aS1kZXZlbCBtYWlsaW5nIGxpc3QKZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRw
czovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2RyaS1kZXZlbAo=
