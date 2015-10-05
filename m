From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Mon, 5 Oct 2015 22:55:56 +0100
Message-ID: <CA+55aFz9hH26=iQa832J5789Kf1ufYEJPt5L_D1wcDhCycUCFQ@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
	<5612A3F3.2040609@linux.intel.com>
	<CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
	<5612E23B.7070606@linux.intel.com>
	<CA+55aFwkA1EODc0bsrdmob945DYfDW_jE+nmrFKpq2YmBn+W4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a113ed818f3c21c05216293b5
Cc: Peter Anvin <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwkA1EODc0bsrdmob945DYfDW_jE+nmrFKpq2YmBn+W4Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--001a113ed818f3c21c05216293b5
Content-Type: text/plain; charset=UTF-8

On Mon, Oct 5, 2015 at 10:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Your ext4 patch may well fix the issue, and be the right thing to do
> (_regardless_ of the revert, in fact - while it might make the revert
> unnecessary, it might also be a good idea even if we do revert).

Thinking a bit more about your patch, I actually am getting more and
more convinced that it's the wrong thing to do.

Why?

Because the whole "Setting copied=0 will tell the upper layers to
repeat the write" just seems a nasty layering violation, where the
low-level filesystem uses a magic return code to introduce a special
case at the upper layers. But the upper layers are actually already
*aware* of the special case, and in fact have a comment about it.

So I think that the whole "setting copied to 0" would actually make a
lot more sense in the *caller*. Just do it in generic_perform_write()
instead. Then all the special cases and the restarting is all
together.

What do you guys think? This basically simplifies the low-level
filesystem rules, and says:

 - the filesystem will only ever see a partial "->write_end()" for the
case where the page was up-to-date, so that there is no issue with
"oops, we now have part of the page that may not have been written at
all"

 - if the page wasn't up-to-date before, ->write_end() will either be
everything we said we'd do in ->write_begin(), or it will be nothing
at all.

Hmm? This would seem to keep the special cases at the right layer, and
actually allow low-level filesystems to simplify things (ie the
special "copied = 0" special case in ext4 goes away.

The ext4 side still worries me, though. You made that
"page_zero_new_buffers()" conditional on "copied" being non-zero, but
I'm not convinced it can be conditional. Even if we retry, that retry
may end up failing (for example, because the source isn't mapped, so
we return -EFAULT rather than re-doing the write), but we have those
new buffers that got allocated in write_begin(), and now nobody has
ever written any data to them at all, so they have random stale
contents.

So I do think this needs more thought. Or at least somebody should
explain to me better why it's all ok.

I'm attaching the "copied = 0" special case thing at the
generic_perform_write() level as a patch for comments. But for now I
still think that reverting would seem to be the safer thing (which
still possibly leaves things buggy with a racy unmap, but at least
it's the old bug that we've never hit in practice).

Dave? Ted? Comments?

               Linus

--001a113ed818f3c21c05216293b5
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ifeh4szj0

IG1tL2ZpbGVtYXAuYyB8IDE0ICsrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTQgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL21tL2ZpbGVtYXAuYyBiL21tL2ZpbGVtYXAuYwppbmRl
eCA3Mjk0MGZiMzg2NjYuLmU4ZDAxOTM2ODE3YSAxMDA2NDQKLS0tIGEvbW0vZmlsZW1hcC5jCisr
KyBiL21tL2ZpbGVtYXAuYwpAQCAtMjQ5Myw2ICsyNDkzLDIwIEBAIGFnYWluOgogCQlwYWdlZmF1
bHRfZW5hYmxlKCk7CiAJCWZsdXNoX2RjYWNoZV9wYWdlKHBhZ2UpOwogCisJCS8qCisJCSAqIElm
IHdlIGRpZG4ndCBzdWNjZXNzZnVsbHkgY29weSBhbGwgdGhlIGRhdGEgZnJvbSB1c2VyIHNwYWNl
LAorCQkgKiBhbmQgdGhlIHRhcmdldCBwYWdlIGlzIG5vdCB1cC10by1kYXRlLCB3ZSB3aWxsIGhh
dmUgdG8gcHJlZmF1bHQKKwkJICogdGhlIHNvdXJjZS4gQW5kIGlmIHRoZSBwYWdlIHdhc24ndCB1
cC10by1kYXRlIGJlZm9yZSB0aGUgd3JpdGUsCisJCSAqIHRoZSAid3JpdGVfZW5kKCkiIG1heSBu
ZWVkIHRvICptYWtlKiBpdCB1cC10by1kYXRlLCBhbmQgdGh1cworCQkgKiBvdmVyd3JpdGUgb3Vy
IHBhcnRpYWwgY29weS4KKwkJICoKKwkJICogU28gZm9yIHRoYXQgY2FzZSwgdGhvdyBhd2F5IHRo
ZSB3aG9sZSB0aGluZyBhbmQgZm9yY2UgYSBmdWxsCisJCSAqIHJlc3RhcnQgKHNlZSBjb21tZW50
IGFib3ZlLCBhbmQgaW92X2l0ZXJfZmF1bHRfaW5fcmVhZGFibGUoKQorCQkgKiBiZWxvdykuCisJ
CSAqLworCQlpZiAoY29waWVkIDwgYnl0ZXMgJiYgIVBhZ2VVcHRvZGF0ZShwYWdlKSkKKwkJCWNv
cGllZCA9IDA7CisKIAkJc3RhdHVzID0gYV9vcHMtPndyaXRlX2VuZChmaWxlLCBtYXBwaW5nLCBw
b3MsIGJ5dGVzLCBjb3BpZWQsCiAJCQkJCQlwYWdlLCBmc2RhdGEpOwogCQlpZiAodW5saWtlbHko
c3RhdHVzIDwgMCkpCg==
--001a113ed818f3c21c05216293b5--
