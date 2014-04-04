From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 3.15
Date: Fri, 4 Apr 2014 16:23:23 -0400
Message-ID: <20140404202323.GB10275@thunk.org>
References: <20140403191558.GA8745@thunk.org>
 <CA+55aFxoA-iDdmbbgmJiYVvskrtca5aGgUAW=3CR47rM9NEMLA@mail.gmail.com>
 <20140404035308.GC2525@thunk.org>
 <20140404134429.GB26806@quack.suse.cz>
 <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
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
In-Reply-To: <CAJfpegsJd9d8NTmwozJ+u_ZS-SnUwAQFwAne6P1KqG=VZeZSTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ah yes, I had forgotten that you had sent those patches, thanks.

It looks like that since you worded it as "just RFC for now since they
aren't in 3.15 yet", the xfstests folks never actually accepted your
changes into xfstests, and so I never picked it up.

For future reference, the tests for COLLAPSE_RANGE and ZERO_RANGE were
accepted into xfstests well before the merge window opened, and that
was awfully convenience since we could pull the latest from the
xfstests.git tree and do automated testing while those patches were in
the ext4 and xfs trees.

So feel free to be a bit more insistent about asking for your xfstests
to be merged upstream; you don't have to wait until the changes reach
mainline.  If it's clear that the patches are going to be accepted,
and they are in the subsystem trees, that's a fine time to push to get
the changes into xfstests.

Cheers,

						- Ted
