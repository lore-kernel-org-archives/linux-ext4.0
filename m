From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp
	limits
Date: Tue, 25 Apr 2017 22:31:15 +0200
Message-ID: <CAK8P3a0_iRFODcbkkKirjSOxe-L5Nnk-2Pjp9icfbNye9ZzfRQ@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
 <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
 <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
 <CA+55aFzFWma+EMB-xQ7QBPbOzUOkSc0XEwy9DgLpYfVzMYJQGg@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CA+55aFzFWma+EMB-xQ7QBPbOzUOkSc0XEwy9DgLpYfVzMYJQGg@mail.gmail.com>
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

T24gVHVlLCBBcHIgMjUsIDIwMTcgYXQgMTA6MDIgUE0sIExpbnVzIFRvcnZhbGRzCjx0b3J2YWxk
c0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj4gT24gVHVlLCBBcHIgMjUsIDIwMTcgYXQg
MTI6NDcgUE0sIEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+IHdyb3RlOgo+Pgo+PiBUaGVy
ZSBpcyBvbmUgZ2xvYmFsIG9wdGlvbiB0aGF0IEkgd2FudCB0byBzZWUsIGFuZCB0aGF0IGlzIGZv
ciBjb21wbGV0ZWx5Cj4+IGRpc2FibGluZyBhbGwgY29tcG9uZW50cyB0aGF0IGFyZSBrbm93biB0
byBiZSBicm9rZW4gaW4geTIwMzguCj4KPiBJIHJlYWxseSBkb24ndCBzZWUgdGhlIHBvaW50Lgo+
Cj4gRG9uJ3QgZG8gaXQuIE1ha2UgaXQgc29tZSBsb2NhbCBoYWNrLCBJJ20gbm90IHRha2luZyBj
cmF6eSBwYXRjaGVzLgoKSSBoYXZlIHRoZSBsb2NhbCBoYWNrICwgYW5kIHVzZWQgaXQgdG8gZmlu
ZCBhbGwgdGhlIGRyaXZlcnMgdGhhdCB1c2UgYQozMi1iaXQgdGltZV90IGludGVybmFsbHkgKGFu
ZCBtYXJrIHRoZW0gd2l0aCBhIEtjb25maWcgZGVwZW5kZW5jeQpmb3IgdGVzdGluZykuCgpXb3Vs
ZCBpdCBiZSBvayB0byBoYXZlIGEgc2ltcGxlIHdheSBvZiByZW1vdmluZyB0aGUgdGltZV90IGRl
ZmluaXRpb24gKGUuZy4KYnkgcGFzc2luZyAnLURSRVFVSVJFX1RJTUU2NCcgdG8gdGhlIGNvbXBp
bGVyLCBidXQgd2l0aG91dCB0aGUgS2NvbmZpZwpvcHRpb24/IFRoYXQgd2F5LCBzb21lb25lIHdo
byB3YW50cyB0byBzaGlwIGEgcHJvZHVjdCBjYW4gYXQgbGVhc3QKZmluZCB0aGUgb2J2aW91cyBk
ZXBlbmRlbmNpZXMgb24gc3R1ZmYgdGhhdCByZW1haW5zIGJyb2tlbi4KCiAgICAgICBBcm5kCl9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxp
bmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9t
YWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
