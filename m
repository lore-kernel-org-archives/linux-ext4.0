From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Wed, 17 Sep 2008 11:25:41 -0400
Message-ID: <20080917152541.GD10562@mit.edu>
References: <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu> <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59898 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752730AbYIQPZ5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Sep 2008 11:25:57 -0400
Content-Disposition: inline
In-Reply-To: <20080917150212.GD22613@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 17, 2008 at 04:02:12PM +0100, Jamie Lokier wrote:
> 
> I'm not clear about something from the above description.
> 
> If I were writing a journalling / tree-like filesystem, and I did
> store data in blocks without encoding, but fsync() only waits for them
> to be committed to journal, not their final destination, and also they
> might be moved around - should I set DATA_ENCODED or not?  (And should
> I return the temporary location in the long-running journal since
> that's the only place the data is committed at the time of the call?)

I can imagine two ways of requiring this.  One would be that you
should only set DATA_ENCODED if you knew that the data had reached its
final destination, possibly with some way of inducing the filesystem
to wait until this had happened.  The other approach would be to
require in the specification that the filesystem would have to be
unmounted at least once.  I prefer the latter as it is much simpler,
and the number of users who actually care about DATA_ENCODED is quite
small.

The other observation I would make is that for filesystems where
"final location" has no meaning (i.e., a log structured filesystem
where its log cleaner is constantly moving data blocks around for
compaction and/or flash wear leveling purposes), it will probably need
to set some bit that means LOCATION_UNSTABLE, as well as setting
DATA_ENCODED.  This is would be a little confusing since what
DATA_ENCODED really means is, "application that might want to read
this file contents on an unmounted filesystem --- think again".  So
maybe a better name would be NO_UNMOUNTED_IO.

							- Ted


P.S.  If such filesystems want to be used by boot loaders that need
fixed bootstrap blocks, they would probably need to have a flag that
pinned the data blocks and caused them not be moved by the log
cleaner.  Reiser3 had to have something like this to work for LILO,
but iirc this was just to disable tail packing.  Same concept, though;
it was a specialized per-filesystem flag that was needed if that
filesystem wanted to be used by a particular boot loader with direct
(unmounted) I/O requirements to access bootstrap code/data.

