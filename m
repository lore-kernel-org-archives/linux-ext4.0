From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp
	limits
Date: Tue, 25 Apr 2017 13:35:59 -0700
Message-ID: <CA+55aFwxqwnY7QLA8hbMG8AvwdWp5i94Tc=NoXEK+dcQnxHLMg@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
 <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
 <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
 <CA+55aFzFWma+EMB-xQ7QBPbOzUOkSc0XEwy9DgLpYfVzMYJQGg@mail.gmail.com>
 <CAK8P3a0_iRFODcbkkKirjSOxe-L5Nnk-2Pjp9icfbNye9ZzfRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Theodore Ts'o <tytso@mit.edu>, y2038 Mailman List <y2038@lists.linaro.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
 Deepa Dinamani <deepa.kernel@gmail.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a0_iRFODcbkkKirjSOxe-L5Nnk-2Pjp9icfbNye9ZzfRQ@mail.gmail.com>
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

T24gVHVlLCBBcHIgMjUsIDIwMTcgYXQgMTozMSBQTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4KPiBXb3VsZCBpdCBiZSBvayB0byBoYXZlIGEgc2ltcGxlIHdheSBvZiBy
ZW1vdmluZyB0aGUgdGltZV90IGRlZmluaXRpb24gKGUuZy4KPiBieSBwYXNzaW5nICctRFJFUVVJ
UkVfVElNRTY0JyB0byB0aGUgY29tcGlsZXIsIGJ1dCB3aXRob3V0IHRoZSBLY29uZmlnCj4gb3B0
aW9uPyBUaGF0IHdheSwgc29tZW9uZSB3aG8gd2FudHMgdG8gc2hpcCBhIHByb2R1Y3QgY2FuIGF0
IGxlYXN0Cj4gZmluZCB0aGUgb2J2aW91cyBkZXBlbmRlbmNpZXMgb24gc3R1ZmYgdGhhdCByZW1h
aW5zIGJyb2tlbi4KCkhvdyB3b3VsZCB5b3UgZmluZCB0aGVtPwoKUGVvcGxlIGRvbid0IG5lY2Vz
c2FyaWx5IHVzZSAidGltZV90Ii4gVGhleSBtaWdodCB1c2UgImludCIgb3Igd2hhdGV2ZXIuCgpU
aGVyZSBpcyBhYnNvbHV0ZWx5IHplcm8gcG9pbnQgdG8gbWFraW5nIHRoaXMgc29tZSBraW5kIG9m
IGNyYXp5CmNvbmZpZyBvcHRpb24sIGJlY2F1c2Ugc3VjaCBhbiBvcHRpb24gd2lsbCBwcm92ZSBh
YnNvbHV0ZWx5ICpOT1RISU5HKi4KClNlcmlvdXNseS4gVGhpcyB3aG9sZSBjb25jZXB0IGlzICBj
b21wbGV0ZWx5IHN0dXBpZC4KClRoZSBvbmx5IHBvc3NpYmxlIHRoaW5nIHlvdSBjYW4gZG8gaXMg
dG8KCiAoYSkgaGF2ZSBhbiBhY3R1YWwgdGVzdC1zdWl0ZQogKGIpIHNldCB0aGUgdGltZSB0byAz
MisgYml0cwogKGMpIHNlZSB3aGF0IGJyZWFrcwoKYmVjYXVzZSBvdGhlcndpc2UgaXQgc2VlbXMg
ZW50aXJlbHkgcG9pbnRsZXNzLgoKQW5kIG5vLCB3ZSdyZSBub3QgYWRkaW5nIHJhbmRvbSBjcmF6
eSBzb3VyY2UgbW9kaWZpY2F0aW9ucyBmb3IgcG9pbnRsZXNzIGNyYXAuCgogICAgICAgICAgICAg
ICAgICAgICAgTGludXMKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9s
aXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
