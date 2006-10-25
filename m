From: David Chinner <dgc@sgi.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 14:27:53 +1000
Message-ID: <20061025042753.GV8394166@melbourne.sgi.com>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Barry Naujok <bnaujok@melbourne.sgi.com>,
	"'David Chinner'" <dgc@sgi.com>,
	"'Dave Kleikamp'" <shaggy@austin.ibm.com>,
	"'Alex Tomas'" <alex@clusterfs.com>,
	"'Theodore Tso'" <tytso@mit.edu>, "'Jan Kara'" <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Content-Disposition: inline
In-Reply-To: <20061025024257.GA23769@havoc.gtf.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 24, 2006 at 10:42:57PM -0400, Jeff Garzik wrote:
> On Wed, Oct 25, 2006 at 12:30:02PM +1000, Barry Naujok wrote:
> > Could we have a more abstract method for asking the filesystem where the 
> > free blocks are and then using the same block addressing to tell the
> > fs where to allocate/move the file's data to?
> 
> That's fundamentally racy, so you might as well just read the
> filesystem metadata from userspace.  No need to go through the kernel
> for that.

But it a race that is _easily_ handled, and applications only need to
implement one interface, not a different method for every
filesystem that requires deeep filesystem knowledge.

Besides, you still have to handle the case where the block you want
has already been allocated because reading the metadata from
userspace doesn't prevent the kernel from allocating the block you
want before you ask for it...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
