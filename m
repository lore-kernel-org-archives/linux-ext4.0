From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v1 0/5] ext4: Shut down block groups when damage is
 detected
Date: Wed, 31 Jul 2013 20:52:43 +0200
Message-ID: <20130731185243.GB28018@quack.suse.cz>
References: <20130719235532.24017.31896.stgit@blackbox.djwong.org>
 <20130721143226.GA13473@gmail.com>
 <x49txjdbd21.fsf@segfault.boston.devel.redhat.com>
 <20130730003109.GE3648@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab3GaSwq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Jul 2013 14:52:46 -0400
Content-Disposition: inline
In-Reply-To: <20130730003109.GE3648@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 30-07-13 08:31:09, Zheng Liu wrote:
> Hi Jeff,
> 
> On Mon, Jul 29, 2013 at 11:28:38AM -0400, Jeff Moyer wrote:
> > Zheng Liu <gnehzuil.liu@gmail.com> writes:
> > 
> > > My idea is to let file system can ignore the currurted block.  Namely,
> > > when we meet a currupted block, we will track it as bad block in bad
> > > block inode and find another block to save data.  This currupted block
> > > will never be used.  The first step in my mind is to detect a currpted
> > > block and mark it as bad block.  After reading the thread and Darrick's
> > > original patch, I think Darrick's patch is a good start.
> > 
> > I think it's important to call out the exact failure scenario you're
> > trying to address.  For hard disks, if you get a read error, it can
> > typically be recovered by re-writing the block.  I imagine this is what
> > fsck would be doing for metadata repair.  So, I'm not at all sure why
> > you'd want to track bad blocks in the file system itself.  Could you
> > elaborate, please?
> 
> In our product system at Taobao, we have a large CDN system around the
> country.  These servers cache the most of web pages, images, etc....
> These servers have some disks, and the disk must break down at some
> time.  Now we need to umount this disk, and the whole disk just be left
> in server until the whole server is dropped.  But as you have pointed
> out, when we meet a disk failure, the whole disk might still works.  So
> we hope that the file system could track the bad block, doesn't allocate
> them, and the rest of spaces also can be used.  This can help us to
> reduce the cost.
  Well, before spending too much time with this, try finding some study
(I've read some from Google I think, just I don't have the url at hand) on
what is the estimated lifetime of a disk after bad sectors start appearing. 
What I remember is that usually when bad sectors start appearing the disk
is going to die within weeks with high probability. So I'm not sure if the
cost saving of additional few weeks of lifetime is worth the trouble. As
Ted said, there may be other reasons why you'd want a feature like this -
kernel error causing bitmap corruption - or just that you need to keep the
machine up for a few more hours before you can take it down for
maintenance.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
