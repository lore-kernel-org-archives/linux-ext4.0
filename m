From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/4] Add unix COW io manager
Date: Mon, 7 May 2007 09:01:22 -0400
Message-ID: <20070507130121.GA17180@thunk.org>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37119 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbXEGNBa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 09:01:30 -0400
Content-Disposition: inline
In-Reply-To: <eb16ba5f2c6f399ea747169097434ae84443728f.1178262585.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, May 04, 2007 at 02:43:21PM +0530, Aneesh Kumar K.V wrote:
> + * unix_cow_io.c --- This is the Unix (well, really POSIX) implementation
> + * 	of the COW I/O manager.

I really wish you had based this not on unix_io.c, but rather on
test_io.c, for two reasons (a) this reduces code duplication, (b) it
means that we can chain/stack I/O managers.  i.e., test_io ->
cow_manager -> unix_io.

The one change I would recommend is that instead of assigning to a
globally visible external variable (as I did in test_io, and which I
now regret as a not necessarily being portable --- different shared
library implementations have different restrictions on whether you can
access global variables defined in shared libraries from an
application or vice versa --- with AIX having some of the most peverse
shared library restritions, at least 7-8 years ago when I had the
misfortune of trying to make Kerberos v5 shared libraries work on AIX
:-).  Instead, what I would recommend is creating a function which an
application could call to set the backing I/O manager for the
cow_manager, as well as the filenames to use for the tdb journal.

The second change I would recommend is to NOT call it "cow_manager"
but rather an "undo_manager", since that makes it clear that what is
being backed up is not the work that we are about to do, but rather
the original contents of the disk.  I would also rename the
ext4_replay tool something like e2undofs, since "replay" has the
connotation that you are applying changes that were done in a log,
when in fact what you are really doing is backing out changes.

We want to make sure we avoid this confusion, since Xen and UML and
most other virtualization engines, for good reasons, do the exact
opposite --- the COW file contains the changes, and the base
file/device remains unchanged.

> +	retval = tdb_store(data->tdb, tdb_key, tdb_data, TDB_INSERT);
> +	if (retval == -1) {
> +		/* FIXME!! Not sure what should be the error */
> +		retval = EXT2_ET_SHORT_WRITE;
> +		goto error_out;
> +	}

You need to write the tdb_store() around a tdb_transaction_start() and
tdb_transaction_commit() pair, so that we can be sure the original
data is actually synced to disk.  Otherwise, on a crash, we could have
a situation where the original data on disk has been overwritten, but
the backup of the original block was never forced to disk!

						- Ted
