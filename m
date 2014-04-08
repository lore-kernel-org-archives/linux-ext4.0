From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Tue, 8 Apr 2014 13:25:33 +0200
Message-ID: <20140408112533.GB4504@osiris>
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
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMuHMdVHyAJwJv5nh+nQUOQJk6=2+Rr+pEqAZPgJUsA7A9A3hQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 07, 2014 at 10:25:30PM +0200, Geert Uytterhoeven wrote:
> On Mon, Apr 7, 2014 at 4:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Mon, Apr 07, 2014 at 03:15:36PM +0200, Miklos Szeredi wrote:
> >> >
> >> > Is there anything obvious that I might be doing wrong?
> >>
> >> I only wired up the syscall for x86_64.   Who's responsible for adding
> >> all the syscall tables for the various architectures?
> >
> > Ah, and I was testing with i386, not x86_64, so that it explains that.
> >
> > It's been quite a while since I've worked to add a new system call,
> > but my impressure is that in general the person who creates the new
> > system call needs to reach out to the architecture maintainers
> > (preferably with a patch :-), since otherwise the architecture
> 
> Preferably the creator of the new system call emails linux-arch.
> Patches are always nice to have, but they may cause conflicts w.r.t.
> syscall numbering.
> 
> > maintainers would have no idea that a new syscall has been added.
> 
> If i386 has the new syscall, scripts/checksyscalls.sh will catch it and
> inform us about it during our next kernel build.
> 
> If you add it to x86_64 only, bad luck for anyone else ;-)

Also it would be nice if somebody would pick up the patch below as well :)

>From 97cdc756ca508f2200ae0cebf1cf1f1b8daa711b Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 8 Apr 2014 12:55:46 +0200
Subject: [PATCH] include/linux/syscalls.h: add sys_renameat2() prototype

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/syscalls.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2aa8b749f13d..697ceb70a9a9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -748,6 +748,9 @@ asmlinkage long sys_linkat(int olddfd, const char __user *oldname,
 			   int newdfd, const char __user *newname, int flags);
 asmlinkage long sys_renameat(int olddfd, const char __user * oldname,
 			     int newdfd, const char __user * newname);
+asmlinkage long sys_renameat2(int olddfd, const char __user *oldname,
+			      int newdfd, const char __user *newname,
+			      unsigned int flags);
 asmlinkage long sys_futimesat(int dfd, const char __user *filename,
 			      struct timeval __user *utimes);
 asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
-- 
1.8.5.5
