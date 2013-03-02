From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL URGENT] ext4 regression fix for 3.9
Date: Sat, 2 Mar 2013 18:15:06 -0500
Message-ID: <20130302231506.GH22941@thunk.org>
References: <20130227174553.GA224@x4>
 <CA+55aFwWA1jPEEQNx_5oJ6Ze=3yFb6=E9nraBfX-Ve=WjRkQMw@mail.gmail.com>
 <20130227184912.GA19624@thunk.org>
 <20130227185625.GA224@x4>
 <20130227191923.GA1121@redhat.com>
 <20130227192907.GB14253@thunk.org>
 <20130227201217.GD14253@thunk.org>
 <20130301033005.GA7081@redhat.com>
 <20130301040039.GA4452@thunk.org>
 <CA+55aFxEfKTeGmX57R0s+2MaQwfgqvVnf+M3zkwNk0rN0j7Ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Jones <davej@redhat.com>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	"gnehzuil.liu" <gnehzuil.liu@gmail.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Borislav Petkov <bp@alien8.de>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxEfKTeGmX57R0s+2MaQwfgqvVnf+M3zkwNk0rN0j7Ksg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Mar 02, 2013 at 11:54:37AM -0800, Linus Torvalds wrote:
> 
> This needs to be fixed or reverted. I traced back some user
> interaction problems to this same issue. It literally gets so bad that
> the whole system is choppy, and a profile shows that a lot of time is
> being spent in the spin-lock protecting these data structures. Called
> from ext4_es_reclaim_extents_count, ext4_es_lru_add and
> ext4_es_shrink.

I'm doing final testing on a pull request that will fix these
problems.  I'll send it to you later this evening.

	   	     	       	     - Ted
