From: Jan Kara <jack@suse.cz>
Subject: Re: EXT4 regression caused 4eec7
Date: Mon, 13 May 2013 15:38:43 +0200
Message-ID: <20130513133843.GH400@quack.suse.cz>
References: <31302271.2821368363898561.JavaMail.weblogic@epml17>
 <20130513131809.GG400@quack.suse.cz>
 <20130513133036.GB4845@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, EUNBONG SONG <eunb.song@samsung.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130513133036.GB4845@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 13-05-13 09:30:36, Ted Tso wrote:
> On Mon, May 13, 2013 at 03:18:09PM +0200, Jan Kara wrote:
> > Grumble. In this case I think bitfields are not worth the trouble with gcc.
> > It's a pitty we have to spend additional 8 bytes for every journal_head but
> > we'll survive... I'll send Ted a partial revert and add a comment so that
> > we won't repeat this mistake in future.
> 
> Or just switch things to use explicit 32-bit boolean operations.
> Sounds the safest way to go is to simply not trust bitfields to be
> something gcc is competent to compile correctly, and just open code it
> in standard C.  (Large portions of ext4 and e2fsprogs do this
> manually, for historical reasons, and it sounds like we have a good
> reason to do it going forward.)
  Yeah, but in this case b_jlist testing / setting would require accessor
functions which is slightly ugly. For now I just submitted a revert of the
bitfield part and if someone feels like saving 8 bytes in struct
journal_head is worth the hassle, then we can later go that route.

> Jan, Dmitry --- I still have in my tree a revert for commit 4eec708d2:
> ext4: use io_end for multiple bios, since I belive Dmitry still
> bisected a regression for xfstests 299.  Dmitry, can you confirm that
> you are definitely seeing a regression here?  Jan, do you mind if we
> try to figure out how to fix this during the next development cycle,
> since it was part of your much longer, extensive patch series anyway?
  Yeah, for now just send a revert to Linus. I'll look into that failure
now but since I didn't hit the problem in my testing it may take a while.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
