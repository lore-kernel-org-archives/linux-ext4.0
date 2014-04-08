From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Tue, 8 Apr 2014 09:47:40 -0400
Message-ID: <20140408134740.GB28822@thunk.org>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
 <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
 <20140404234358.GE10275@thunk.org>
 <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
 <20140407140745.GA8855@thunk.org>
 <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
> > maintainers would have no idea that a new syscall has been added.
> 
> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
> inform us about it during our next kernel build.
> 
> If you add it to x86_64 only, bad luck for anyone else ;-)

Maybe we should change scripts/checksyscalls.sh to check the x86_64
list of syscalls, and not i386?

It's been a long time since "all the world's an i386" --- these days,
it's "all the world's an x86_64".  :-)

						- Ted

"Thou shalt foreswear, renounce, and abjure the vile heresy which
claimeth that ``All the world's a VAX'', and have no commerce with the
benighted heathens who cling to this barbarous belief, that the days
of thy program may be long even though the days of thy current machine
be short."  -- The Ten Commandments for C Programmers

- http://www.lysator.liu.se/c/ten-commandments.html
