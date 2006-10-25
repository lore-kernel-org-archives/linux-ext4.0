From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 20:25:30 +0200
Message-ID: <20061025182530.GC9940@atrey.karlin.mff.cuni.cz>
References: <20061023141641.GA29649@thunk.org> <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org> <20061024230020.GZ3509@schatzie.adilger.int> <20061025145450.GF21082@atrey.karlin.mff.cuni.cz> <20061025170224.GB19513@havoc.gtf.org> <20061025175851.GA9940@atrey.karlin.mff.cuni.cz> <20061025180821.GE19513@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@clusterfs.com, Theodore Tso <tytso@mit.edu>,
	David Chinner <dgc@sgi.com>, Alex Tomas <alex@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025180821.GE19513@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, Oct 25, 2006 at 07:58:51PM +0200, Jan Kara wrote:
> >   I've briefly looked at this and this kind of interface has some
> > appeal. On the other hand it's not obvious to me, how to implement in
> > this interface *atomic* operation "copy data from file F to given set of
> > blocks and rewrite pointers to original blocks with pointers to new
> > blocks". Something like this is needed for what we want to do...
> > Also if we'd like to implement operation like "add this block to file F
> > at position P" we have to make sure that all the necessary updates
> > (bitmap updates, inode updates, indirect block updates) go into one
> > transaction. Which basically mean that either ext3meta has to have a way
> > how to do this in a single operation, or we have to give userspace a way
> > to start/stop transaction and that starts to be really a mess because of
> > various deadlocks and so on.
> 
> Agreed, this issues exist.  But these issues exist independent of
> whether an ioctl or ext3meta is used.  It's all the responsibility
> of the implementor to define the interface.
> 
> My contention is that ext3meta interface method would be much more
> robust than ioctl.  It's a namespace inside which you can define any
> inodes/dirents you wish, for the operations you desire.
  I see. So you mean that in our ext3meta filesystem we'd have a file
named "add_this_extent_to_inode" and a file "reloc_inode_interval" and
they'd be fed essentially the same info as the current ioctl interface and
do the same thing as we currently do. Hmm, I don't find it that nice any
more but yes, this would work.

> Heck, according to my sf.net/projects/gkernel CVS log, you offered
> some helpful review comments to me when I was implementing ext2meta ;-)
  Looking at those mails it was already quite some time ago so I
forgot about it  ;)
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
