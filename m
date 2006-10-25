From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC] Ext3 online defrag
Date: Wed, 25 Oct 2006 14:33:06 -0400
Message-ID: <20061025183306.GF19513@havoc.gtf.org>
References: <m3vembnlwz.fsf@bzzz.home.net> <20061024041433.GB12506@havoc.gtf.org> <20061024135928.GB11034@melbourne.sgi.com> <20061024194416.GB16087@thunk.org> <20061024230020.GZ3509@schatzie.adilger.int> <20061025145450.GF21082@atrey.karlin.mff.cuni.cz> <20061025170224.GB19513@havoc.gtf.org> <20061025175851.GA9940@atrey.karlin.mff.cuni.cz> <20061025180821.GE19513@havoc.gtf.org> <20061025182530.GC9940@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger@clusterfs.com, Theodore Tso <tytso@mit.edu>,
	David Chinner <dgc@sgi.com>, Alex Tomas <alex@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061025182530.GC9940@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 25, 2006 at 08:25:30PM +0200, Jan Kara wrote:
>   I see. So you mean that in our ext3meta filesystem we'd have a file
> named "add_this_extent_to_inode" and a file "reloc_inode_interval" and
> they'd be fed essentially the same info as the current ioctl interface and
> do the same thing as we currently do. Hmm, I don't find it that nice any
> more but yes, this would work.

It depends on the operation.  ext2meta[1] works fine for online
defrag, just exporting metadata objects and providing read(1)
and write(2) operations on them.  Adding 'trigger' files (like your
add_this_extent_to_inode) may make sense for some operations, indeed,
but we need to see the whole picture before really understanding
whether that interface is optimal.

	Jeff


[1] http://linux.yyz.us/misc/ext2meta.c
