From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Wed, 09 Apr 2014 09:55:28 -0700
Message-ID: <53457B80.1080307@zytor.com>
References: <20140403191558.GA8745@thunk.org>	<CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>	<20140404035308.GC2525@thunk.org>	<20140404134429.GB26806@quack.suse.cz>	<CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>	<20140404234358.GE10275@thunk.org>	<CAJfpegv_Ng1cXbpCqicG4e3UdGK3uiDtVB4KzfRQOhDq_uhZOw@mail.gmail.com>	<20140407140745.GA8855@thunk.org>	<CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>	<20140408134740.GB28822@thunk.org> <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdW8xkBFJ5-E04rVhDk+CSubHut+kx3P6cYCn0dMhQdb-Q@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/09/2014 09:40 AM, Geert Uytterhoeven wrote:
> On Tue, Apr 8, 2014 at 3:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
>>>> maintainers would have no idea that a new syscall has been added.
>>>
>>> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
>>> inform us about it during our next kernel build.
>>>
>>> If you add it to x86_64 only, bad luck for anyone else ;-)
>>
>> Maybe we should change scripts/checksyscalls.sh to check the x86_64
>> list of syscalls, and not i386?
>>
>> It's been a long time since "all the world's an i386" --- these days,
>> it's "all the world's an x86_64".  :-)
> 
> Let the kbuild people (and their employers) fight over it...
> 

I'm missing context here, but as an x86 maintainer I have no intention
of allowing system calls that aren't x86-specific to be added to x86-64
only.

	-hpa

