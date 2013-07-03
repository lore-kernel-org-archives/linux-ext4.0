From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Date: Wed, 3 Jul 2013 07:35:20 -0400
Message-ID: <20130703113520.GA21189@thunk.org>
References: <nsxbo6mxu38.fsf@lambda.thunk.org>
 <CA+55aFyRLc81s03ULLZ26N0qwRqxS-9+6XpyhxVH62qx2b5o2A@mail.gmail.com>
 <20130702180447.GB16282@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130702180447.GB16282@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 02, 2013 at 08:04:47PM +0200, Jan Kara wrote:
>   That's caused by my patches (only for certain gcc versions). map->m_len
> is guaranteed to be > 0 in the first iteration (the function is called from
> under if (map->m_len > 0)). I though Ted silenced that warning but
> apparently he did not. The cleanest fix is likely to make a do-while loop
> from that one. I'll send Ted a patch for that.

Sorry, I fixed it with a code simplification (I thought the while loop
wasn't needed at all), but when you explained why in fact we still
needed it, I dropped my commit, and forgot that this also dropped the
fix which silenced the warning.  I'll grab your patch and included
with any other fixes that we might need for this merge window.

Linus, are you in a hurry to get this fixed up?  It's a false warning
on gcc's part, so it's not actually causing any actual problems.  If
not, I can wait until a week or so to see if there are any other bug
fixes that are required and push the fix to you towards the end of the
merge window.

							- Ted
