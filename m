From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] Ext3 online defrag
Date: Thu, 26 Oct 2006 13:37:22 +0200
Message-ID: <20061026113722.GA23610@atrey.karlin.mff.cuni.cz>
References: <20061025011853.GQ8394166@melbourne.sgi.com> <200610250225.MAA23029@larry.melbourne.sgi.com> <20061025024257.GA23769@havoc.gtf.org> <20061025042753.GV8394166@melbourne.sgi.com> <20061025044844.GB32486@havoc.gtf.org> <20061025053823.GX8394166@melbourne.sgi.com> <20061025060142.GD32486@havoc.gtf.org> <20061025081137.GB8394166@melbourne.sgi.com> <20061025170052.GA19513@havoc.gtf.org> <20061026014020.GC8394166@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Garzik <jeff@garzik.org>,
	Barry Naujok <bnaujok@melbourne.sgi.com>,
	'Dave Kleikamp' <shaggy@austin.ibm.com>,
	'Alex Tomas' <alex@clusterfs.com>,
	'Theodore Tso' <tytso@mit.edu>, 'Jan Kara' <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:2183 "EHLO
	atrey.karlin.mff.cuni.cz") by vger.kernel.org with ESMTP
	id S1161019AbWJZLhY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Oct 2006 07:37:24 -0400
To: David Chinner <dgc@sgi.com>
Content-Disposition: inline
In-Reply-To: <20061026014020.GC8394166@melbourne.sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, Oct 25, 2006 at 01:00:52PM -0400, Jeff Garzik wrote:
> > On Wed, Oct 25, 2006 at 06:11:37PM +1000, David Chinner wrote:
> > > On Wed, Oct 25, 2006 at 02:01:42AM -0400, Jeff Garzik wrote:
> > > So how do you then get the generic interface to allocate blocks
> > > specified by userspace race free?
> > 
> > As has been repeatedly stated, there is no "generic".  There MUST be
> > filesystem-specific knowledge during these operations.
> 
> What information? All we need to know is where the free disk space
> is, and have a method to attempt to allocate from it. That's _easy_
> to abstract into a common interface via the VFS....
> 
> > > > Further, in the case being discussed in this thread, ext2meta has
> > > > already been proven a workable solution.
> > > 
> > > Sure, but that's not a generic solution to a problem common to
> > > all filesystems....
> > 
> > You clearly don't know what I'm talking about.  ext2meta is an example
> > of a filesystem-specific metadata access method, applicable to tasks
> > such as online optimization.
> 
> I know exactly what ext2meta is. I said it's not a generic solution
> and you say its a filesystem specific solution.  I think we're
> agreeing here. ;)
> 
> We don't need to expose anything filesystem specific to userspace to
> implement this.  Online data movement (i.e. the defrag mechanism)
> becomes something like:
> 
> 	do {
> 		get_free_list(dst_fd, location, len, list)
> 		/* select extent to use */
  Upto this point I can imagine we can be perfectly generic.

> 		alloc_from_list(dst_fd, list[X], off, len)
> 	} while (ENOALLOC)
> 	move_data(src_fd, dst_fd, off, len);
  With these two it's not clear how well can we do with just a generic
interface. Every filesystem needs to have some additional metadata to
keep list of data blocks. In case of ext2/ext3/reiserfs this is not
a negligible amount of space and placement of these metadata is important
for performance. So either we focus only on data blocks and let
implementation of alloc_from_list() allocate metadata wherever it wants
(but then we get suboptimal performace because there need not be space
for indirect blocks close before our provided extent) or we allocate
metadata from the provided list, but then we need some knowledge of fs
to know how much should we expect to spend on metadata and where these
metadata should be placed. For example if you know that indirect block
for your interval is at block B, then you'd like to allocate somewhere
close after this point or to relocate that indirect block (and all the
data it references to). But for that you need to know you have something
like indirect blocks => filesystem knowledge.
  So I think that to get this working, we also need some way to tell
the program that if it wants to allocate some data, it also needs to
count with this amount of metadata and some of it is already allocated
in given blocks...

> I see substantial benefit moving forward from having filesystem
> independent interfaces. Many features that  filesystems implement
> are common, and as time goes on the common feature set of the
> different filesystems gets larger. So why shouldn't we be
> trying to make common operations generic so that every filesystem
> can benefit from the latest and greatest tool?
  So you prefer to handle only "data blocks" part of the problem and let
filesystem sort out metadata?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
