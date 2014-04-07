From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Mon, 7 Apr 2014 22:25:30 +0200
Message-ID: <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
References: <20140403191558.GA8745@thunk.org>
	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
	<20140404035308.GC2525@thunk.org>
	<20140404134429.GB26806@quack.suse.cz>
	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
	<20140404234358.GE10275@thunk.org>
	<CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
	<20140407140745.GA8855@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42005 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbaDGUZb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 16:25:31 -0400
In-Reply-To: <20140407140745.GA8855@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 7, 2014 at 4:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Apr 07, 2014 at 03:15:36PM +0200, Miklos Szeredi wrote:
>> >
>> > Is there anything obvious that I might be doing wrong?
>>
>> I only wired up the syscall for x86_64.   Who's responsible for adding
>> all the syscall tables for the various architectures?
>
> Ah, and I was testing with i386, not x86_64, so that it explains that.
>
> It's been quite a while since I've worked to add a new system call,
> but my impressure is that in general the person who creates the new
> system call needs to reach out to the architecture maintainers
> (preferably with a patch :-), since otherwise the architecture

Preferably the creator of the new system call emails linux-arch.
Patches are always nice to have, but they may cause conflicts w.r.t.
syscall numbering.

> maintainers would have no idea that a new syscall has been added.

If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
inform us about it during our next kernel build.

If you add it to x86_64 only, bad luck for anyone else ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
