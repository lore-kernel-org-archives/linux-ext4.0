From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
 super_operation
Date: Fri, 19 Nov 2010 11:30:13 -0500
Message-ID: <20101119163013.GJ10039@thunk.org>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org>
 <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site>
 <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen>
 <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org>
 <4CE69940.6040908@teksavvy.com>
 <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Lord <kernel@teksavvy.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 19, 2010 at 04:44:33PM +0100, Lukas Czerner wrote:
> > 
> > But, oddly, it _is_ the default for mke2fs -t ext4,
> > which really threw me for a loop recently.
> > 
> > I though my system had locked up when suddenly everything
> > went dead for a very long time (many minutes) while installing a 
> > new system.

Yeah, the assumption was doing a single big discard (which is all
mke2fs is doing) should be fast.  At least on sanely implemented SSD's
(i.e., like the Intel X25-M) it should be, since all that should
require is a flash write to the global mapping table, declaring all of
the blocks as free.

If there are some incompetently implemented SSD's out there which do a
flash erase of the entire SSD upon receiving a TRIM command (new
flash!  Part of the whole *point* of a TRIM was to increase write
endurance by eliminating the need to copy blocks that really weren't
in use any more by the OS when the SSD is doing a GC copy/compaction
of a partially written flash sector), all I can do is do a sigh, and
wish that T13 had defined a "comptently implemented SSD bit" --- not
that Indilinix would admit if it they were incompetent.  :-/

> That is exactly a reason why I posted a patch for
> "Make blkdev_issue_discard() interruptible", but nobody seems to care. As
> an addition I have patched mke2fs to inform user about ongoing discard,
> also with not much attention (Ted?).

Yeah, sorry.  I'm still recovering from the kernel summit and
plumber's.  I've got to get the critical bugfix patches out to Linus
before -rc3, and then I will try to get back to e2fsprogs.

       	      	       				- Ted
