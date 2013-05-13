From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 09:30:36 -0400
Message-ID: <20130513133036.GB4845@thunk.org>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
 <20130513131809.GG400@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: EUNBONG SONG <eunb.song@samsung.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130513131809.GG400@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 13, 2013 at 03:18:09PM +0200, Jan Kara wrote:
> Grumble. In this case I think bitfields are not worth the trouble with gcc.
> It's a pitty we have to spend additional 8 bytes for every journal_head but
> we'll survive... I'll send Ted a partial revert and add a comment so that
> we won't repeat this mistake in future.

Or just switch things to use explicit 32-bit boolean operations.
Sounds the safest way to go is to simply not trust bitfields to be
something gcc is competent to compile correctly, and just open code it
in standard C.  (Large portions of ext4 and e2fsprogs do this
manually, for historical reasons, and it sounds like we have a good
reason to do it going forward.)

Jan, Dmitry --- I still have in my tree a revert for commit 4eec708d2:
ext4: use io_end for multiple bios, since I belive Dmitry still
bisected a regression for xfstests 299.  Dmitry, can you confirm that
you are definitely seeing a regression here?  Jan, do you mind if we
try to figure out how to fix this during the next development cycle,
since it was part of your much longer, extensive patch series anyway?

I've determined that the reason why I didn't see a problem was because
xfstests 299 was failing earlier on the baseline, and crashing my
regression tests.  So I simply commented it out just so I could
complete the testing.  It seems that xfstests 299 is problematic for
me, and I need to focus on how to make it pass successfully.  (Dmitry,
when I revert the commit which you identified, xfstests 299 is *still*
failing for me....) 

						- Ted
