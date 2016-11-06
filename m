From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC 0/6] vfs: Add timestamp range check support
Date: Sun, 06 Nov 2016 21:28:37 +0100
Message-ID: <147897712.8Iuj6e9dPp@wuerfel>
References: <1478099096-25637-1-git-send-email-deepa.kernel@gmail.com>
 <1206C36E-9CB4-47B3-A891-8EA94C3220E0@dilger.ca>
 <CABeXuvoCANJohBWy4mpJFiYvJj0XNHKVpW1RWhXVrd9ZjT5FSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
 y2038 Mailman List <y2038@lists.linaro.org>,
 Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>,
 LKML <linux-kernel@vger.kernel.org>, linux-afs@lists.infradead.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CABeXuvoCANJohBWy4mpJFiYvJj0XNHKVpW1RWhXVrd9ZjT5FSQ@mail.gmail.com>
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

T24gU3VuZGF5LCBOb3ZlbWJlciA2LCAyMDE2IDk6NDQ6MzMgQU0gQ0VUIERlZXBhIERpbmFtYW5p
IHdyb3RlOgo+IEkgd2lsbCBwb3N0IHhmcyB0ZXN0cyB0aGF0IHZhbGlkYXRlIG1vdW50IGFuZCBy
YW5nZSBjaGVja2luZy4KPiBJIHdpbGwga2VlcCB0aGUgcG9saWN5IHNhbWUgYXMgd2hhdCB0aGUg
UkZDIHN1Z2dlc3RzIGZvciBub3cuCj4gCj4gQ2xhbXBpbmcgY2FuIGJlIHZlcmlmaWVkIG9uY2Ug
dmZzIGlzIHRyYW5zaXRpb25lZCB0byB1c2luZyB0aW1lNjRfdC4KCldvbid0IGl0IGFscmVhZHkg
d29yayBhcyBleHBlY3RlZCBvbiA2NC1iaXQgYXJjaGl0ZWN0dXJlcyBhcyB0aGV5CmhhdmUgYSA2
NC1iaXQgdGltZV90PwoKCUFybmQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0
cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
