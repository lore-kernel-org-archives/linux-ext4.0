From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Sat, 27 Jun 2015 10:07:43 -0400
Message-ID: <20150627140743.GF474@thunk.org>
References: <20150625034626.GA21682@thunk.org>
 <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
 <20150627040237.GC474@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150627040237.GC474@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jun 27, 2015 at 12:02:37AM -0400, Theodore Ts'o wrote:
> 
> I would tend to agree.  The weird thing though is that I haven't seen
> this problem myself, despite running multiple regression tests before
> I sent the pull request, as well as running it on my laptop and doing
> kernel compiles with make -j16 and reading e-mail (I'm typing this
> e-mail on a 4.1 kernel merged with the ext4 patches for this merge
> window, so I have this commit running in my development laptop, and it
> hasn't triggered for me).

Update: I've been able to reproduce the crash using a post merge
kernel (of course, I had to use CONFIG_SLUB since CONFIG_SLAB is
busted) a single time.  Unfortunately, I've not been able to reproduce
it reliably so I can't speak to whether reverting 2143c1965a76 will
fix things.  But it does seem very likely.

    	     	    	      	   - Ted
