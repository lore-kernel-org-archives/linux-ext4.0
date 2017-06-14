From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: CRASH : RCU detected stall
Date: Wed, 14 Jun 2017 08:55:24 -0400
Message-ID: <20170614125524.qxg3dkfbcaqxscp3@thunk.org>
References: <CAKEzZ8wRAFxXOcgxzu2KkntvNz8QvGocWpH_xDbRxRg=7LgbPA@mail.gmail.com>
 <20170613173044.sdibg23cfvpwwxud@thunk.org>
 <CAKEzZ8yb_n+iCy8+_fYujc1LAbijjjd97+dEh9qrwNfx0GAqUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
To: Ramin Farajpour Cami <ramin.blackhat@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKEzZ8yb_n+iCy8+_fYujc1LAbijjjd97+dEh9qrwNfx0GAqUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 14, 2017 at 10:02:00AM +0430, Ramin Farajpour Cami wrote:
> 
> Unfortunately it's not reproducible. do you have idea about it?

Nope.  Note that this isn't necessarily an ext4 bug.  We have two
complaints about an rcu_sched thread getting staved and an NMI handler
getting taking too long to run:

rcu_sched kthread starved for 22270 jiffies! g2951 c2950 f0x0
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 2.762 msecs

We also happened be doing writeback on another CPU and the ext4 thread
was doing a slab allocation.

What ultimiately caused the RCU starvation is not at all clear.  Were
we spinning inside the slab allocator, or not?  Getting some
magic-sysrq triggers to see if the PC was always in the slab allocator
would be useful.  And if that's the case, it's not clear what might
have caused us to spinning in the slab allocator.  It could be due to
some slab state getting corrupted by a previous system call, and ext4
was just unlucky enough to do the slab allocation which caused it to
go for a loop.

We just don't have enough information to do any kind of useful
investigation.

					- Ted
