From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Wed, 9 Apr 2014 18:40:57 +0200
Message-ID: <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
References: <20140403191558.GA8745@thunk.org>
	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
	<20140404035308.GC2525@thunk.org>
	<20140404134429.GB26806@quack.suse.cz>
	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
	<20140404234358.GE10275@thunk.org>
	<CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
	<20140407140745.GA8855@thunk.org>
	<CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
	<20140408134740.GB28822@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20140408134740.GB28822@thunk.org>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 8, 2014 at 3:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
>> > maintainers would have no idea that a new syscall has been added.
>>
>> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
>> inform us about it during our next kernel build.
>>
>> If you add it to x86_64 only, bad luck for anyone else ;-)
>
> Maybe we should change scripts/checksyscalls.sh to check the x86_64
> list of syscalls, and not i386?
>
> It's been a long time since "all the world's an i386" --- these days,
> it's "all the world's an x86_64".  :-)

Let the kbuild people (and their employers) fight over it...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
