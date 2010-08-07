From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 update for 2.6.36
Date: Sat, 7 Aug 2010 13:17:46 -0700
Message-ID: <AANLkTinJQ7DQK8_0ngHrbZugFBCgyM5ETUPhcDSmYGP6@mail.gmail.com>
References: <E1OhETF-0005P6-7v@tytso-glaptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0015176f0f343317e5048d417bc6
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E1OhETF-0005P6-7v@tytso-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--0015176f0f343317e5048d417bc6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 5, 2010 at 9:23 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Which is hopefully what you want. =A0If you want exactly what is shown
> below, you can also pull the "next" branch, which omits the merge, and
> then you can deal with the merge conflict by hand. =A0The results should
> be the same either way.

I did that just to see what it looked like.

One annoyance: I now get

  fs/jbd2/transaction.c: In function =91start_this_handle=92:
  fs/jbd2/transaction.c:98: warning: unused variable =91ts=92

due to that 'ts' thing only being used for the CONFIG_JBD2_DEBUG case.
Please fix. I'd suggest putting that CONFIG_JBD2_DEBUG code in a
helper function of its own, and declaring 'ts' there instead.
Suggested patch (but with a horrible helper function name) attached.

               Linus

--0015176f0f343317e5048d417bc6
Content-Type: application/octet-stream; name=diff
Content-Disposition: attachment; filename=diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gckwolav0

IGZzL2piZDIvdHJhbnNhY3Rpb24uYyB8ICAgMjkgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0KIDEgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMvamJkMi90cmFuc2FjdGlvbi5jIGIvZnMvamJkMi90cmFuc2FjdGlvbi5j
CmluZGV4IGQ5NWNjOWQuLjAzN2Q2NWQgMTAwNjQ0Ci0tLSBhL2ZzL2piZDIvdHJhbnNhY3Rpb24u
YworKysgYi9mcy9qYmQyL3RyYW5zYWN0aW9uLmMKQEAgLTgxLDYgKzgxLDIzIEBAIGpiZDJfZ2V0
X3RyYW5zYWN0aW9uKGpvdXJuYWxfdCAqam91cm5hbCwgdHJhbnNhY3Rpb25fdCAqdHJhbnNhY3Rp
b24pCiAgKiBvZiB0aGF0IG9uZSB1cGRhdGUuCiAgKi8KIAorc3RhdGljIGlubGluZSB2b2lkIHN0
YXJ0X2hhbmRsZV9kZWJ1Zyh0cmFuc2FjdGlvbl90ICp0cmFuc2FjdGlvbikKK3sKKyNpZmRlZiBD
T05GSUdfSkJEMl9ERUJVRworCXVuc2lnbmVkIGxvbmcgdHMgPSBqaWZmaWVzOworCisJaWYgKGpi
ZDJfam91cm5hbF9lbmFibGVfZGVidWcgJiYKKwkgICAgdGltZV9hZnRlcih0cmFuc2FjdGlvbi0+
dF9zdGFydCwgdHMpKSB7CisJCXRzID0gamJkMl90aW1lX2RpZmYodHMsIHRyYW5zYWN0aW9uLT50
X3N0YXJ0KTsKKwkJc3Bpbl9sb2NrKCZ0cmFuc2FjdGlvbi0+dF9oYW5kbGVfbG9jayk7CisJCWlm
ICh0cyA+IHRyYW5zYWN0aW9uLT50X21heF93YWl0KQorCQkJdHJhbnNhY3Rpb24tPnRfbWF4X3dh
aXQgPSB0czsKKwkJc3Bpbl91bmxvY2soJnRyYW5zYWN0aW9uLT50X2hhbmRsZV9sb2NrKTsKKwl9
CisjZW5kaWYKK30KKworCiAvKgogICogc3RhcnRfdGhpc19oYW5kbGU6IEdpdmVuIGEgaGFuZGxl
LCBkZWFsIHdpdGggYW55IGxvY2tpbmcgb3Igc3RhbGxpbmcKICAqIG5lZWRlZCB0byBtYWtlIHN1
cmUgdGhhdCB0aGVyZSBpcyBlbm91Z2ggam91cm5hbCBzcGFjZSBmb3IgdGhlIGhhbmRsZQpAQCAt
OTUsNyArMTEyLDYgQEAgc3RhdGljIGludCBzdGFydF90aGlzX2hhbmRsZShqb3VybmFsX3QgKmpv
dXJuYWwsIGhhbmRsZV90ICpoYW5kbGUsCiAJaW50IG5lZWRlZDsKIAlpbnQgbmJsb2NrcyA9IGhh
bmRsZS0+aF9idWZmZXJfY3JlZGl0czsKIAl0cmFuc2FjdGlvbl90ICpuZXdfdHJhbnNhY3Rpb24g
PSBOVUxMOwotCXVuc2lnbmVkIGxvbmcgdHMgPSBqaWZmaWVzOwogCiAJaWYgKG5ibG9ja3MgPiBq
b3VybmFsLT5qX21heF90cmFuc2FjdGlvbl9idWZmZXJzKSB7CiAJCXByaW50ayhLRVJOX0VSUiAi
SkJEOiAlcyB3YW50cyB0b28gbWFueSBjcmVkaXRzICglZCA+ICVkKVxuIiwKQEAgLTI1MCwxNiAr
MjY2LDcgQEAgcmVwZWF0OgogCSAqIHNlcGFyYXRlIGZsYWcsIGV2ZW50dWFsbHksIHNvIHdlIGNh
biBlbmFibGUgdGhpcwogCSAqIGluZGVwZW5kZW50bHkgb2YgZGVidWdnaW5nLgogCSAqLwotI2lm
ZGVmIENPTkZJR19KQkQyX0RFQlVHCi0JaWYgKGpiZDJfam91cm5hbF9lbmFibGVfZGVidWcgJiYK
LQkgICAgdGltZV9hZnRlcih0cmFuc2FjdGlvbi0+dF9zdGFydCwgdHMpKSB7Ci0JCXRzID0gamJk
Ml90aW1lX2RpZmYodHMsIHRyYW5zYWN0aW9uLT50X3N0YXJ0KTsKLQkJc3Bpbl9sb2NrKCZ0cmFu
c2FjdGlvbi0+dF9oYW5kbGVfbG9jayk7Ci0JCWlmICh0cyA+IHRyYW5zYWN0aW9uLT50X21heF93
YWl0KQotCQkJdHJhbnNhY3Rpb24tPnRfbWF4X3dhaXQgPSB0czsKLQkJc3Bpbl91bmxvY2soJnRy
YW5zYWN0aW9uLT50X2hhbmRsZV9sb2NrKTsKLQl9Ci0jZW5kaWYKKwlzdGFydF9oYW5kbGVfZGVi
dWcodHJhbnNhY3Rpb24pOwogCWhhbmRsZS0+aF90cmFuc2FjdGlvbiA9IHRyYW5zYWN0aW9uOwog
CWF0b21pY19pbmMoJnRyYW5zYWN0aW9uLT50X3VwZGF0ZXMpOwogCWF0b21pY19pbmMoJnRyYW5z
YWN0aW9uLT50X2hhbmRsZV9jb3VudCk7Cg==
--0015176f0f343317e5048d417bc6--
