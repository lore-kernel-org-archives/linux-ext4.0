From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Mon, 7 Apr 2014 10:07:45 -0400
Message-ID: <20140407140745.GA8855@thunk.org>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
 <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
 <20140404234358.GE10275@thunk.org>
 <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 07, 2014 at 03:15:36PM +0200, Miklos Szeredi wrote:
> >
> > Is there anything obvious that I might be doing wrong?
> 
> I only wired up the syscall for x86_64.   Who's responsible for adding
> all the syscall tables for the various architectures?

Ah, and I was testing with i386, not x86_64, so that it explains that.

It's been quite a while since I've worked to add a new system call,
but my impressure is that in general the person who creates the new
system call needs to reach out to the architecture maintainers
(preferably with a patch :-), since otherwise the architecture
maintainers would have no idea that a new syscall has been added.

					- Ted
