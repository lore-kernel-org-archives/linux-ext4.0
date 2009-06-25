From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Need to potentially watch stack usage for ext4 and AIO...
Date: Wed, 24 Jun 2009 19:32:58 -0500
Message-ID: <4A42C5BA.8020804@redhat.com>
References: <E1MHiN1-0002TX-Cu@closure.thunk.org> <4A3C3F64.70007@redhat.com> <20090621004919.GA6798@mit.edu> <4A42513C.6020607@redhat.com> <4A4256A6.7070707@redhat.com> <20090625000558.GD7035@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44515 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbZFYAc7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jun 2009 20:32:59 -0400
In-Reply-To: <20090625000558.GD7035@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Wed, Jun 24, 2009 at 11:39:02AM -0500, Eric Sandeen wrote:
>> Eric Sandeen wrote:
>>> Theodore Tso wrote:
>>>> I can see some things we can do to optimize stack usage; for example,
>>>> struct ext4_allocation_request is allocated on the stack, and the
>>>> structure was laid out without any regard to space wastage caused by
>>>> alignment requirements.  That won't help on x86 at all, but it will
>>>> help substantially on x86_64 (since x86_64 requires that 8 byte
>>>> variables must be 8-byte aligned, where as x86_64 only requires 4 byte
>>>> alignment, even for unsigned long long's).  But it's going have to be
>>>> a whole series of incremental improvements; I don't see any magic
>>>> bullet solution to our stack usage.
>>> XFS forces gcc to not inline any static function; it's extreme, but
>>> maybe it'd help here too.
>> Giving a blanket noinline treatment to mballoc.c yields some significant
>> stack savings:
> 
> So stupid question.  I can see how using noinline reduces the static
> stack savings, but does it actually reduce the run-time stack usage?
> After all, if function ext4_mb_foo() call ext4_mb_bar(), using
> noinline is a great way for seeing which function is actually
> responsible for chewing up disk space, but if ext4_mb_foo() always
                             ^^stack :)
> calls ext4_mb_bar(), and ext4_mb_bar() is a static inline only called
> once by ext4_mb_foo() unconditionally, won't we ultimately end up
> using more disk space (since we also have to save registers and save
> the return address on the stack)?

True, so maybe I should be a bit more careful w/ that patch I sent, and
do more detailed callchain analysis to be sure that it's all warranted.

But here's how the noinlining can help, at least:

foo()
  bar()
  baz()
  whoop()

If they're each 100 bytes of stack usage on their own, and bar() baz()
and whoop() all get inlined into foo(), then foo() uses ~400 bytes,
because it's all taken off the stack when we subtract from %rsp when we
enter foo().

But if we don't inline bar() baz() and whoop(), then at worst we have
~200 bytes used; 100 when we enter foo(), 100 more (200 total) when we
enter bar(), then we return to foo() (popping the stack back to 100),
and again at 200 when we enter baz(), and again only 200 when we get
into whoop().

if it were just:

foo()
  bar()

then you're right, noinlining bar() wouldn't help, and probably hurts -
so I probably need to look more closely at the shotgun approach patch I
sent.  :)

I had found some tools once to do static callchain analysis & graph
them, maybe time to break it out again.

-Eric
