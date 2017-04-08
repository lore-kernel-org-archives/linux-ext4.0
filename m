From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp
	limits
Date: Sat, 8 Apr 2017 13:04:33 -0700
Message-ID: <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
 y2038@lists.linaro.org,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
 Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
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

T24gU2F0LCBBcHIgOCwgMjAxNyBhdCAxMjozNyBQTSwgRGVlcGEgRGluYW1hbmkgPGRlZXBhLmtl
cm5lbEBnbWFpbC5jb20+IHdyb3RlOgo+IEFsbG93IHJlYWQgb25seSBtb3VudHMgZm9yIGZpbGVz
eXN0ZW1zIHRoYXQgZG8gbm90Cj4gaGF2ZSBtYXhpbXVtIHRpbWVzdGFtcHMgYmV5b25kIHRoZSB5
MjAzOCBleHBpcnkKPiB0aW1lc3RhbXAuCgpUaGlzIG9wdGlvbiBzZWVtcyBhcmJpdHJhcnkgYW5k
IHBvaW50bGVzcy4KCk5vYm9keSBzYW5lIHNob3VsZCBldmVyIGVuYWJsZSBpdCBleGNlcHQgZm9y
IHRlc3RpbmcsIGJ1dCBmb3IgdGVzdGluZwppdCB3b3VsZCBiZSBtdWNoIGJldHRlciB0byBzaW1w
bHkgc3BlY2lmeSB3aGF0IHRoZSBsaW1pdCBzaG91bGQgYmU6CjIwMzggaXMgbm90IG1hZ2ljYWwg
Zm9yIGFsbCBmaWxlc3lzdGVtcywgYmVjYXVzZSB0aGUgYmFzZSBtYXkgYmUKZGlmZmVyZW50LgoK
QW5kIGhvbmVzdGx5LCBmb3IgdGVzdGluZywgaXQgd291bGQgYmUgbXVjaCBiZXR0ZXIgdG8ganVz
dCBtYWtlIGl0IGEKbW91bnQgb3B0aW9uIHJhdGhlciB0aGFuIHNvbWUgY3Jhenkgc3lzdGVtLXdp
ZGUgb25lLgoKICAgICAgICAgICAgICAgICAgIExpbnVzCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5s
aW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4
Cg==
