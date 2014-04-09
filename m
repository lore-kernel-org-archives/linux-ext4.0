From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Wed, 9 Apr 2014 14:23:24 -0400
Message-ID: <20140409182324.GA778@thunk.org>
References: <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
 <20140404234358.GE10275@thunk.org>
 <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
 <20140407140745.GA8855@thunk.org>
 <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
 <20140408134740.GB28822@thunk.org>
 <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
 <53457B80.1080307@zytor.com>
 <CAMuHMdU9ZcCzRWk2NWfdx54Uox=C=MaR5t8sD2icUpE_xtr8cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdU9ZcCzRWk2NWfdx54Uox=C=MaR5t8sD2icUpE_xtr8cA@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 09, 2014 at 07:48:32PM +0200, Geert Uytterhoeven wrote:
> >
> > I'm missing context here, but as an x86 maintainer I have no intention
> > of allowing system calls that aren't x86-specific to be added to x86-64
> > only.
> 
> commit 520c8b16505236fc82daa352e6c5e73cd9870cff
> Author: Miklos Szeredi <mszeredi@suse.cz>
> Date:   Tue Apr 1 17:08:42 2014 +0200
> 
>     vfs: add renameat2 syscall
> 
> It was added to arch/x86/syscalls/syscall_64.tbl only.

To be fair, part of the problem is that we don't have good
documentation about best practices in what people should do if adding
new system calls.  (i.e., creating a man page and pulling in Michael
Kerrisk, adding tests, wiring up both x86_64 and i386, sending mail to
linux-arch, the scripts/checksyscalls.sh script, etc.)

I'll confess to being ignorant about the checksyscalls.sh script, and
while I had known about the existence of the linux-arch list, I had
forgotten about it, so if I had tried to add a new system call, it's
likely I would have missed at one or more of these steps.

       	       	    	      	     - Ted




> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
