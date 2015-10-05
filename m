From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Mon, 5 Oct 2015 21:22:44 +0100
Message-ID: <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
	<5612A3F3.2040609@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Anvin <hpa@zytor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5612A3F3.2040609@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 5, 2015 at 5:23 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
>
> One thing I've been noticing on Skylake is that barriers (implicit and
> explicit) are showing up more in profiles.

Ahh, you're on skylake?

It's entirely possible that the issue is that the whole
"stac/mov/clac" is much more expensive because skylake actually ends
up supporting those AC instructions. That would make sense.

We could probably do them outside the loop, rather than tightly around
the actual move instructions. Peter (hpa), is there some sane
interface to try to do that?

>  What we're seeing here
> probably isn't actually stac/clac overhead, but the cost of finishing
> some other operations that are outstanding before we can proceed through
> here.

I suspect it actually _is_ stac/clac overhead. It might well be that
clac/stac ends up serializing loads some way. Last I heard, they were
reasonably cheap but certainly not free - and when we're talking about
something that just loops over bringing the line into cache, it might
be relatively expensive.

How did you do the profile? Use "-e cycles:pp" to get the precise
profile information, which should actually attribute the cost to the
instruction that really causes it.

              Linus
