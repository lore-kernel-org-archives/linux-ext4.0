From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SLAB_TYPESAFE_BY_RCU without constructors (was Re:
 [PATCH v4 13/17] khwasan: add hooks implementation)
Date: Tue, 31 Jul 2018 10:49:28 -0700
Message-ID: <CA+55aFzHR1+YbDee6Cduo6YXHO9LKmLN1wP=MVzbP41nxUb5=g@mail.gmail.com>
References: <e3b48104-3efb-1896-0d46-792419f49a75@virtuozzo.com>
 <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Dave Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>,
 linux-mm <linux-mm@kvack.org>, Eric Dumazet <edumazet@google.com>,
 Network Development <netdev@vger.kernel.org>, gerrit@erg.abdn.ac.uk,
 dccp@vger.kernel.org, coreteam@netfilter.org,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>, linux-ext4@vger.kernel.org,
 Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Andrey Konovalov <andreyknvl@google.com>,
 intel-gfx <intel-gfx@lists.freedesktop.org>,
 Ursula Braun <ubraun@linux.ibm.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Dmitry Vyukov <dvyukov@google.com>, Theodore Ts'o <tytso@mit.edu>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Florian Westphal <fw@strlen.de>,
 Linux Kernel Mailing List <linu
To: Christoph Lameter <cl@linux.com>
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <01000164f169bc6b-c73a8353-d7d9-47ec-a782-90aadcb86bfb-000000@email.amazonses.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
List-Id: linux-ext4.vger.kernel.org

T24gVHVlLCBKdWwgMzEsIDIwMTggYXQgMTA6MzYgQU0gQ2hyaXN0b3BoZXIgTGFtZXRlciA8Y2xA
bGludXguY29tPiB3cm90ZToKPgo+IElmIHRoZXJlIGlzIHJlZmNvdW50aW5nIGdvaW5nIG9uIHRo
ZW4gd2h5IHVzZSBTTEFCX1RZUEVTQUZFX0JZX1JDVT8KCi4uIGJlY2F1c2UgdGhlIG9iamVjdCBj
YW4gYmUgYWNjZXNzZWQgKGJ5IFJDVSkgYWZ0ZXIgdGhlIHJlZmNvdW50IGhhcwpnb25lIGRvd24g
dG8gemVybywgYW5kIHRoZSB0aGluZyBoYXMgYmVlbiByZWxlYXNlZC4KClRoYXQncyB0aGUgd2hv
bGUgYW5kIG9ubHkgcG9pbnQgb2YgU0xBQl9UWVBFU0FGRV9CWV9SQ1UuCgpUaGF0IGZsYWcgYmFz
aWNhbGx5IHNheXM6CgogICJJIG1heSBlbmQgdXAgYWNjZXNzaW5nIHRoaXMgb2JqZWN0ICphZnRl
ciogaXQgaGFzIGJlZW4gZnJlZSdkLApiZWNhdXNlIHRoZXJlIG1heSBiZSBSQ1UgbG9va3VwcyBp
biBmbGlnaHQiCgpUaGlzIGhhcyBub3RoaW5nIHRvIGRvIHdpdGggY29uc3RydWN0b3JzLiBJdCdz
IG9rIGlmIHRoZSBvYmplY3QgZ2V0cwpyZXVzZWQgYXMgYW4gb2JqZWN0IG9mIHRoZSBzYW1lIHR5
cGUgYW5kIGRvZXMgKm5vdCogZ2V0CnJlLWluaXRpYWxpemVkLCBiZWNhdXNlIHdlJ3JlIHBlcmZl
Y3RseSBmaW5lIHNlZWluZyBvbGQgc3RhbGUgZGF0YS4KCldoYXQgaXQgZ3VhcmFudGVlcyBpcyB0
aGF0IHRoZSBzbGFiIGlzbid0IHNoYXJlZCB3aXRoIGFueSBvdGhlciBraW5kCm9mIG9iamVjdCwg
X2FuZF8gdGhhdCB0aGUgdW5kZXJseWluZyBwYWdlcyBhcmUgZnJlZSdkIGFmdGVyIGFuIFJDVQpx
dWllc2NlbnQgcGVyaW9kIChzbyB0aGUgcGFnZXMgYXJlbid0IHNoYXJlZCB3aXRoIGFub3RoZXIg
a2luZCBvZgpvYmplY3QgZWl0aGVyIGR1cmluZyBhbiBSQ1Ugd2FsaykuCgpBbmQgaXQgZG9lc24n
dCBuZWNlc3NhcmlseSBoYXZlIHRvIGhhdmUgYSBjb25zdHJ1Y3RvciwgYmVjYXVzZSB0aGUKdGhp
bmcgdGhhdCBhIFJDVSB3YWxrIHdpbGwgY2FyZSBhYm91dCBpcwoKIChhKSBndWFyYW50ZWVkIHRv
IGJlIGFuIG9iamVjdCB0aGF0ICpoYXMqIGJlZW4gb24gc29tZSBSQ1UgbGlzdCAoc28KaXQncyBu
b3QgYSAibmV3IiBvYmplY3QpCgogKGIpIHRoZSBSQ1Ugd2FsayBuZWVkcyB0byBoYXZlIGxvZ2lj
IHRvIHZlcmlmeSB0aGF0IGl0J3Mgc3RpbGwgdGhlCipzYW1lKiBvYmplY3QgYW5kIGhhc24ndCBi
ZWVuIHJlLXVzZWQgYXMgc29tZXRoaW5nIGVsc2UuCgpTbyB0aGUgcmUtdXNlIG1pZ2h0IGluaXRp
YWxpemUgdGhlIGZpZWxkcyBsYXppbHksIG5vdCBuZWNlc3NhcmlseSB1c2luZyBhIGN0b3IuCgpB
bmQgdGhlIHBvaW50IG9mIHVzaW5nIFNMQUJfVFlQRVNBRkVfQllfUkNVIGlzIHRoYXQgdXNpbmcg
dGhlIG1vcmUKdHJhZGl0aW9uYWwgUkNVIGZyZWVpbmcgLSB3aGVyZSB5b3UgZnJlZSBlYWNoIG9i
amVjdCBvbmUgYnkgb25lIHdpdGgKYW4gUkNVIGRlbGF5IC0gY2FuIGJlIHByb2hpYml0aXZlbHkg
c2xvdyBhbmQgaGF2ZSBhIGh1Z2UgbWVtb3J5Cm92ZXJoZWFkIChiZWNhdXNlIG9mIGJpZyBjaHVu
a3Mgb2YgbWVtb3J5IHRoYXQgYXJlIHF1ZXVlZCBmb3IKZnJlZWluZykuCgpJbiBjb250cmFzdCwg
YSBTTEFCX1RZUEVTQUZFX0JZX1JDVSBtZW1vcnkgZ2V0cyBmcmVlJ2QgYW5kIHJlLXVzZWQKaW1t
ZWRpYXRlbHksIGJ1dCBiZWNhdXNlIGl0IGdldHMgcmV1c2VkIGFzIHRoZSBzYW1lIGtpbmQgb2Yg
b2JqZWN0LAp0aGUgUkNVIHdhbGtlciBjYW4gImtub3ciIHdoYXQgcGFydHMgaGF2ZSBtZWFuaW5n
IGZvciByZS11c2UsIGluIGEgd2F5Cml0IGNvdWlkbid0IGlmIHRoZSByZS11c2Ugd2FzIHJhbmRv
bS4KClRoYXQgc2FpZCwgaXQgKmlzKiBzdWJ0bGUsIGFuZCBwZW9wbGUgc2hvdWxkIGJlIGNhcmVm
dWwuCgogICAgICAgICAgICAgICAgIExpbnVzCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QKSW50ZWwtZ2Z4QGxpc3Rz
LmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xp
c3RpbmZvL2ludGVsLWdmeAo=
