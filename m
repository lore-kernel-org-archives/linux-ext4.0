From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Wed, 25 Jun 2014 18:37:03 -0400
Message-ID: <20140625223703.GC10397@thunk.org>
References: <20140403191558.GA8745@thunk.org>
 <alpine.LFD.2.11.1406242251230.23403@eddie.linux-mips.org>
 <53A9FE04.2000306@hp.com>
 <CA+55aFzbC9QgO46m2H47NbUMWssDm-t4YQ8bJggGrZj2h-_9EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	T Makphaibulchoke <tmac@hp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzbC9QgO46m2H47NbUMWssDm-t4YQ8bJggGrZj2h-_9EQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 25, 2014 at 10:08:02AM -0700, Linus Torvalds wrote:
> Ted,
>  going through pending issues, and wondering if I'm expected to pick
> this up directly? The original came through your tree (commit
> 1f3e55fe02d1: "fs/mbcache.c: doucple the locking of local from global
> data") and is in 3.15 too, so the patch should be marked for stable as
> well.
> 
> It's hopefully limited to just very bad gcc versions for odd
> architectures, so it's not exactly high-impact, but still..

Yes, I'll get something to you soon.  Sorry, I was on travel to NYC
earlier this week, so I'm a bit behind on the bug fix patches that I
needed to send to you now that the merge window is closed.

       	       	      	       	   	 	- Ted
