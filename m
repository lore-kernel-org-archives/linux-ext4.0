From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v6 3/4] vfs: Add timestamp_truncate() api
Date: Mon, 22 Jan 2018 12:25:56 -0800
Message-ID: <CA+55aFyNbcS8k3x1WrZ1-Ymtr6OpnCJ8NUZXBUCfacwWXYzC+g@mail.gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com>
 <20180122020426.2988-4-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
 y2038 Mailman List <y2038@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 adilger.kernel@dilger.ca, Al Viro <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org
To: Deepa Dinamani <deepa.kernel@gmail.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180122020426.2988-4-deepa.kernel@gmail.com>
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

T24gU3VuLCBKYW4gMjEsIDIwMTggYXQgNjowNCBQTSwgRGVlcGEgRGluYW1hbmkgPGRlZXBhLmtl
cm5lbEBnbWFpbC5jb20+IHdyb3RlOgo+ICsgICAgICAgICAgICAgICB0LnR2X25zZWMgLT0gdC50
dl9uc2VjICUgZ3JhbjsKClRoaXMgZG9lc24ndCBhY3R1YWxsIHl3b3JrIGlmIHR2X25zZWMgaXMg
bmVnYXRpdmUuCgpXaGljaCBtYXkgbm90IGJlIGFuIGlzc3VlIGluIG1vc3QgY2FzZXMsIGJ1dCBk
aWQgc29tZWJvZHkgY2hlY2sKdXRpbWVuc2F0KCkgb3Igd2hhdGV2ZXI/Cgo+ICsgICAgICAgICAg
ICAgICBXQVJOKDEsICJpbGxlZ2FsIGZpbGUgdGltZSBncmFudWxhcml0eTogJXUiLCBncmFuKTsK
Ci4uIHNtYWxsIG5pdDogd2UgZ2VuZXJhbGx5IHNob3VsZCB1c2UgJ2ludmFsaWQnIHJhdGhlciB0
aGFuICdpbGxlZ2FsJy4KCk5vIGNvcHMgd2lsbCBodW50IHlvdSBkb3duIGZvciB0aGluZ3MgbGlr
ZSB0aGlzLgoKICAgICAgICAgICAgICAgICAgIExpbnVzCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5s
aW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4
Cg==
