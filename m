From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/5] vfs: Add checks for filesystem timestamp
	limits
Date: Tue, 25 Apr 2017 23:23:41 +0200
Message-ID: <CAK8P3a0-Ysp9tBHx7e9d1Yk1tco6CJrCJdG0-vjvTWCKjH0FZQ@mail.gmail.com>
References: <1491680267-11171-1-git-send-email-deepa.kernel@gmail.com>
 <1491680267-11171-3-git-send-email-deepa.kernel@gmail.com>
 <CA+55aFymxtrw8tr6Q9vLrP7nJ5zOjShstpyQOxxr-m1Wkv9gNg@mail.gmail.com>
 <CABeXuvo6UyvV2yqcju+Mxh8Mmsihrpf209D8p+u68SV5nHf2-A@mail.gmail.com>
 <CAK8P3a002GSya0oxiLnJjDjcsfULSfmOTkf=JMTJEaV0a=dKjQ@mail.gmail.com>
 <CA+55aFzFWma+EMB-xQ7QBPbOzUOkSc0XEwy9DgLpYfVzMYJQGg@mail.gmail.com>
 <CAK8P3a0_iRFODcbkkKirjSOxe-L5Nnk-2Pjp9icfbNye9ZzfRQ@mail.gmail.com>
 <CA+55aFwxqwnY7QLA8hbMG8AvwdWp5i94Tc=NoXEK+dcQnxHLMg@mail.gmail.com>
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
In-Reply-To: <CA+55aFwxqwnY7QLA8hbMG8AvwdWp5i94Tc=NoXEK+dcQnxHLMg@mail.gmail.com>
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

T24gVHVlLCBBcHIgMjUsIDIwMTcgYXQgMTA6MzUgUE0sIExpbnVzIFRvcnZhbGRzCjx0b3J2YWxk
c0BsaW51eC1mb3VuZGF0aW9uLm9yZz4gd3JvdGU6Cj4gT24gVHVlLCBBcHIgMjUsIDIwMTcgYXQg
MTozMSBQTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gd3JvdGU6Cj4+Cj4+IFdvdWxk
IGl0IGJlIG9rIHRvIGhhdmUgYSBzaW1wbGUgd2F5IG9mIHJlbW92aW5nIHRoZSB0aW1lX3QgZGVm
aW5pdGlvbiAoZS5nLgo+PiBieSBwYXNzaW5nICctRFJFUVVJUkVfVElNRTY0JyB0byB0aGUgY29t
cGlsZXIsIGJ1dCB3aXRob3V0IHRoZSBLY29uZmlnCj4+IG9wdGlvbj8gVGhhdCB3YXksIHNvbWVv
bmUgd2hvIHdhbnRzIHRvIHNoaXAgYSBwcm9kdWN0IGNhbiBhdCBsZWFzdAo+PiBmaW5kIHRoZSBv
YnZpb3VzIGRlcGVuZGVuY2llcyBvbiBzdHVmZiB0aGF0IHJlbWFpbnMgYnJva2VuLgo+Cj4gSG93
IHdvdWxkIHlvdSBmaW5kIHRoZW0/Cj4KPiBQZW9wbGUgZG9uJ3QgbmVjZXNzYXJpbHkgdXNlICJ0
aW1lX3QiLiBUaGV5IG1pZ2h0IHVzZSAiaW50IiBvciB3aGF0ZXZlci4KCk15IG1haW4gYXBwcm9h
Y2ggaGFzIGJlZW46CgoqIEFzc3VtZSB0aGF0IGFsbCBvZiB0aGUgdGltZV90IGJhc2VkIGludGVy
ZmFjZXMgYXJlIGJyb2tlbiBvbiAzMi1iaXQgc3lzdGVtcwogIChzb21lIGFyZSBub3QsIGJ1dCBh
bG1vc3QgYWxsIGFyZSkKCiogRm9yIGVhY2ggaW50ZXJmYWNlIHRoYXQgZXhwb3NlcyBhIHRpbWVf
dCB0byBvdGhlciBmaWxlcywgaW50cm9kdWNlIGEKICByZXBsYWNlbWVudCBpbnRlcmZhY2UgdGhh
dCBpcyBrbm93biB0byB3b3JrCgoqIENoYW5nZSB1c2VycyBvZiB0aGUgb2xkIGludGVyZmFjZSBv
dmVyIHRvIHRoZSBuZXcgb25lLCBvbmUgYXQgYSB0aW1lLAogIHdoaWxlIG1hbnVhbGx5IHJldmll
d2luZyBhbGwgb3RoZXIgY29kZSB0aGlzIGludGVyYWN0cyB3aXRoLgoKTm90ZSB0aGF0IHRoZSB2
YXN0IG1ham9yaXR5IG9mIGFsbCB0aGUgaW4ta2VybmVsIHVzZXMgb2YgdGltZV90IHZhcmlhYmxl
cwphY3R1YWxseSB1c2UgdGltZXNwZWMgb3IgdGltZXZhbCBzdHJ1Y3R1cmVzIGJlY2F1c2UgdGhl
eSByZXF1aXJlCnN1Yi1zZWNvbmQgcmVzb2x1dGlvbiwgc28gd2UgYWxyZWFkeSBrbm93IHRoYXQg
dGhleSBjYW5ub3QKYWNjaWRlbnRhbGx5IGdldCBhc3NpZ25lZCB0byAnaW50Jy4gQWxzbywgd2Ug
dHlwaWNhbGx5IHJlcGxhY2UgdGhlbSB3aXRoCmt0aW1lX3QgZm9yIGVmZmljaWVuY3kuIEluIGNh
c2Ugd2UgcmVwbGFjZSBhIHRpbWVzcGVjIHdpdGggdGltZXNwZWM2NCwKd2UgZG8gaGF2ZSB0byBi
ZSBjYXJlZnVsIHRvIGVuc3VyZSB0aGF0IG5vIGNvZGUganVzdCB0cmVhdHMgdGhlCnR2X3NlYyBt
ZW1iZXIgYXMgJ2ludCcgb3IgJ2xvbmcnIHRob3VnaC4KCiAgICAgIEFybmQKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0Clky
MDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlz
dGluZm8veTIwMzgK
