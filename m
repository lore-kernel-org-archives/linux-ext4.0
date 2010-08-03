From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
	no dirty pages.
Date: Mon, 2 Aug 2010 17:09:39 -0700
Message-ID: <20100803000939.GA2109@tux1.beaverton.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com> <1272934667.2544.3.camel@mingming-laptop> <4BE02C45.6010608@redhat.com> <20100504154553.GA22777@infradead.org> <20100630124832.GA1333@thunk.org> <4C2B44C0.3090002@redhat.com> <20100630134429.GE1333@thunk.org> <20100721171609.GC1215@atrey.karlin.mff.cuni.cz>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37438 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0HCAJo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Aug 2010 20:09:44 -0400
Content-Disposition: inline
In-Reply-To: <20100721171609.GC1215@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 21, 2010 at 07:16:09PM +0200, Jan Kara wrote:
>   Hi,
> 
> > On Wed, Jun 30, 2010 at 09:21:04AM -0400, Ric Wheeler wrote:
> > > 
> > > The problem with not issuing a cache flush when you have dirty meta
> > > data or data is that it does not have any tie to the state of the
> > > volatile write cache of the target storage device.
> > 
> > We track whether or not there is any metadata updates associated with
> > the inode already; if it does, we force a journal commit, and this
> > implies a barrier operation.
> > 
> > The case we're talking about here is one where either (a) there is no
> > journal, or (b) there have been no metadata updates (I'm simplifying a
> > little here; in fact we track whether there have been fdatasync()- vs
> > fsync()- worthy metadata updates), and so there hasn't been a journal
> > commit to do the cache flush.
> > 
> > In this case, we want to track when is the last time an fsync() has
> > been issued, versus when was the last time data blocks for a
> > particular inode have been pushed out to disk.
> > 
> > To use an example I used as motivation for why we might want an
> > fsync2(int fd[], int flags[], int num) syscall, consider the situation
> > of:
> > 
> > 	fsync(control_fd);
> > 	fdatasync(data_fd);
> > 
> > The first fsync() will have executed a cache flush operation.  So when
> > we do the fdatasync() (assuming that no metadata needs to be flushed
> > out to disk), there is no need for the cache flush operation.
> > 
> > If we had an enhanced fsync command, we would also be able to
> > eliminate a second journal commit in the case where data_fd also had
> > some metadata that needed to be flushed out to disk.
>   Current implementation already avoids journal commit because of
> fdatasync(data_fd). We remeber a transaction ID when inode metadata has
> last been updated and do not force a transaction commit if it is already
> committed. Thus the first fsync might force a transaction commit but second
> fdatasync likely won't.
>   We could actually improve the scheme to work for data as well. I wrote
> a proof-of-concept patches (attached) and they nicely avoid second barrier
> when doing:
> echo "aaa" >file1; echo "aaa" >file2; fsync file2; fsync file1
> 
>   Ted, would you be interested in something like this?

Well... on my fsync-happy workloads, this seems to cut the barrier count down
by about 20%, and speeds it up by about 20%.

I also have a patch to ext4_sync_files that batches the fsync requests together
for a further 20% decrease in barrier IOs, which makes it run another 20%
faster.  I'll send that one out shortly, though I've not safety-tested it at
all.

--D
