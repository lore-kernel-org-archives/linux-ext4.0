From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Mon, 29 Jul 2013 21:57:47 -0400
Message-ID: <20130730015747.GA20629@thunk.org>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130721143226.GA13473@gmail.com>
 <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37132 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab3G3B5z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 21:57:55 -0400
Content-Disposition: inline
In-Reply-To: <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 29, 2013 at 11:28:38AM -0400, Jeff Moyer wrote:
> I think it's important to call out the exact failure scenario you're
> trying to address.  For hard disks, if you get a read error, it can
> typically be recovered by re-writing the block.  I imagine this is what
> fsck would be doing for metadata repair.  So, I'm not at all sure why
> you'd want to track bad blocks in the file system itself.  Could you
> elaborate, please?

The basic idea why we had a similar patch in Google was so that when
we discovered a potential problem in an allocation bitmap (i.e.,
either a read error, or finding that we had freed a bloc/inode which
was already marked as freed), instead of panic'ing the entire server,
or remounting the file system read/only (or otherwise taking it
off-line), you can just avoid allocating any blocks/inodes in that
block group (since we can't trust the allocation bitmap), but we can
keep using the file system, in a somewhat degraded mode.

Of course, eventually you'd want to take the machine off-line and run
fsck on the whole thing, and then rewrite the broken allocation
bitmap.  But in the meantime, there might be circumstances where it
would be inconvenient (or violate some pesky SLA :-), to take down the
server or even the individual storage device to run fsck on it.

Regards,

						- Ted
