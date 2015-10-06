From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Tue, 6 Oct 2015 10:10:11 +0100
Message-ID: <CA+55aFxjcXJ9iaRJpCwsOchbJ5p2ch0zXs5=ywMMOuFUAair1A@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
	<5612A3F3.2040609@linux.intel.com>
	<CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
	<B602A991-01B4-42E7-AF13-1E21DFB714F8@zytor.com>
	<20151006075652.GA11757@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33264 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbbJFJKM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Oct 2015 05:10:12 -0400
In-Reply-To: <20151006075652.GA11757@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 6, 2015 at 8:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Yes, but note that those interfaces are x86 only at the moment, so they'd have to
> be factored out and generalized before we can use it in generic code.

ARM64 these days (as a part of ARM8.1) has "Privileged Access Never",
which is their name for SMAP. They do it somewhat similarly with an
instruction to clear/set the PAN bit in the pstate register.

So we really should strive to make this support generic, because by
now it's not x86-specific, and x86 and ARM64 together aren't exactly
some odd special case..

I do in fact wonder if we should aim (eventually) for the rule that
the "__" versions of the user access functions should not do the
SMAP/PAN thing, since they have to be explicitly checked for pointer
being valid anyway. And just make the rule be that since you have to
check for the pointer being valid, you might as well also have to do
the SMAP/PAN thing too.

We really should try get rid of _all_ uses of the "__" versions unless
they are very locally and obviously checked with access_ok(). We've
had way too many cases where people thought they were clever, and
weren't really.

                Linus
