From: Jan Kara <jack@suse.cz>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Mon, 4 Feb 2008 18:40:38 +0100
Message-ID: <20080204174038.GG3426@duck.suse.cz>
References: <20080204101228.GA1939@skywalker> <20080204163156.GC3426@duck.suse.cz> <20080204171208.GA8034@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34257 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754249AbYBDRkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2008 12:40:39 -0500
Content-Disposition: inline
In-Reply-To: <20080204171208.GA8034@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 04-02-08 22:42:08, Aneesh Kumar K.V wrote:
> On Mon, Feb 04, 2008 at 05:31:56PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> > On Mon 04-02-08 15:42:28, Aneesh Kumar K.V wrote:
> > > This is with the new ext3 -> ext4 migrate code added. The recently added
> > > lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
> > > on the ext3 inode during migration to prevent walking the ext3 inode
> > > when it is being converted to ext4 format. Also we want to avoid 
> > > file truncation and new blocks being added while converting to ext4.
> > > Also we dont want to reserve large number of credits for journal.
> > > Any idea how to fix this ?
> >   Hmm, while briefly looking at the code - why do you introduce i_data_sem
> > and not use i_alloc_sem which is already in VFS inode? That is aimed
> > exactly at the serialization of truncates, writes and similar users.
> 
> How about read ? We are changing the format of inode. We don't want even
> the read to go through.
  I just meant that the code could use i_alloc_sem instead of i_data_sem in
all the places, remove i_data_sem and you safe some memory... It's just a
suggestion for a cleanup.

> >   One (stupid) solution to your problem is to make i_data_sem be
> > always locked before the transaction is started. It could possibly have
> > negative performance impact because you'd have to hold the semaphore for
> > a longer time and thus a writer would block readers for longer time. So one
> > would have to measure how big difference that would make.
> >   Another possibility is to start a single transaction for migration and
> > extend it as long as you can (as truncate does it). And when you can't
> > extend any more, you drop the i_data_sem and start a new transaction and
> > acquire the semaphore again. This has the disadvantage that after dropping
> > the semaphore you have to resync your original inode with the temporary
> > one your are building which probably ends up being ugly as night... Hmm,
> > but maybe we could get rid of this - hold i_mutex to protect against all
> > writes (that ranks outside of transaction start so you can hold it for the
> > whole migration time - maybe you even hold it if you are called from the
> > write path...). After dropping i_data_sem you let some readers proceed
> > but writers still wait on i_mutex so the file shouldn't change under you
> > (but I suggest adding some BUG_ONs to verify that the file really doesn't
> > change :).
> 
> A quick look says truncate can happen even when we hold i_mutex ??
  No, it shouldn't happen - do_truncate() in fs/open.c acquires i_mutex
before it calls notify_change().

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
