From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Thu, 19 Jun 2008 10:32:24 +0200
Message-ID: <18522.6552.622680.92788@harpo.it.uu.se>
References: <4859F075.2050207@linux.intel.com>
	<21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com>
	<20080619081146.GC17630@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Dave Airlie <airlied@gmail.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754637AbYFSIze@vger.kernel.org>
In-Reply-To: <20080619081146.GC17630@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adrian Bunk writes:
 > On Thu, Jun 19, 2008 at 03:42:34PM +1000, Dave Airlie wrote:
 > > On Thu, Jun 19, 2008 at 3:36 PM, Arjan van de Ven <arjan@linux.intel.com> wrote:
 > > > In the kerneloops.org stats, a new oops is rapidly climbing the charts.
 > > > The oops is a page fault in the ext3 "do_slit" function, and the first
 > > > report of it was with 2.6.26-rc6-git3.
 > > >
 > > > It happens with various applications; the backtraces are at:
 > > >
 > > > http://www.kerneloops.org/search.php?search=do_split
 > > 
 > > This is a bug in rawhide in gcc miscompiling something...
 > > 
 > > https://bugzilla.redhat.com/show_bug.cgi?id=451068
 > 
 > If I understand it correctly that's a bug in upstream gcc 4.3.1
 > (but not in gcc 4.3.0)?
 > 
 > Expect a lot more of this to pop up in the future.
 > Should we #error for gcc 4.3.1?

There are other nasty bugs in gcc-4.3.0. I actually
had to completely ban 4.3.0 in a user-space project
I'm involved with (Erlang) due to gcc PR36339 (fixed
in 4.3.1).

What's the gcc bugzilla number for this new 4.3.1 bug?
