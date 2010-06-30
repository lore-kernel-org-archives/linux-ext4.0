From: tytso@mit.edu
Subject: Re: [RFC] ext4: Don't send extra barrier during fsync if there are
 no dirty pages.
Date: Wed, 30 Jun 2010 09:44:29 -0400
Message-ID: <20100630134429.GE1333@thunk.org>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <20100504154553.GA22777@infradead.org>
 <20100630124832.GA1333@thunk.org>
 <4C2B44C0.3090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Mingming Cao <cmm@us.ibm.com>, djwong@us.ibm.com,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58023 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0F3Nod (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jun 2010 09:44:33 -0400
Content-Disposition: inline
In-Reply-To: <4C2B44C0.3090002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 30, 2010 at 09:21:04AM -0400, Ric Wheeler wrote:
> 
> The problem with not issuing a cache flush when you have dirty meta
> data or data is that it does not have any tie to the state of the
> volatile write cache of the target storage device.

We track whether or not there is any metadata updates associated with
the inode already; if it does, we force a journal commit, and this
implies a barrier operation.

The case we're talking about here is one where either (a) there is no
journal, or (b) there have been no metadata updates (I'm simplifying a
little here; in fact we track whether there have been fdatasync()- vs
fsync()- worthy metadata updates), and so there hasn't been a journal
commit to do the cache flush.

In this case, we want to track when is the last time an fsync() has
been issued, versus when was the last time data blocks for a
particular inode have been pushed out to disk.

To use an example I used as motivation for why we might want an
fsync2(int fd[], int flags[], int num) syscall, consider the situation
of:

	fsync(control_fd);
	fdatasync(data_fd);

The first fsync() will have executed a cache flush operation.  So when
we do the fdatasync() (assuming that no metadata needs to be flushed
out to disk), there is no need for the cache flush operation.

If we had an enhanced fsync command, we would also be able to
eliminate a second journal commit in the case where data_fd also had
some metadata that needed to be flushed out to disk.

> It would definitely be *very* useful to have an array of fd's that
> all need fsync()'ed at home time....

Yes, but it would require applications to change their code.

One thing that I would like about a new fsync2() system call is with a
flags field, we could add some new, more expressive flags:

#define FSYNC_DATA    0x0001 /* Only flush metadata if needed to access data */
#define FSYNC_NOWAIT  0x0002 /* Initiate the flush operations but don't wait
		      	        for them to complete */
#define FSYNC_NOBARRER 0x004 /* FS may skip the barrier if not needed for fs
		       	     	consistency */

etc.

					- Ted
