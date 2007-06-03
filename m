From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC PATCH 1/1] e2fsprogs: Add undo I/O manager.
Date: Sun, 3 Jun 2007 19:17:02 -0400
Message-ID: <20070603231701.GA10140@thunk.org>
References: <4c7823c85d4ea3b4535f9fc0e4afa93078317f81.1179828850.git.aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXFCXR0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Jun 2007 19:17:26 -0400
Content-Disposition: inline
In-Reply-To: <4c7823c85d4ea3b4535f9fc0e4afa93078317f81.1179828850.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 22, 2007 at 03:47:33PM +0530, Aneesh Kumar K.V wrote:
> This I/O manager saves the contents of the location being overwritten
> to a tdb database. This helps in undoing the changes done to the
> file system.
> 
> +	/* loop through the existing entries and find if they overlap */
> +	for (key = tdb_firstkey(tdb); key.dptr; key = tdb_nextkey(tdb, key)) {
> +		data = tdb_fetch(tdb, key);
> +		/*
> +		 * we are not interested in the data
> +		 */
> +		free(data.dptr);

Youch.  This is going to be painful; it means that for every single
write, we need to iterate over every single entry in the TDB.  This
doesn't scale terribly well.  :-(

I suspect you will do much better by using a different encoding for
the tdb database; namely, one where you don't use an extent-based
encoding, but rather something which is strictly block based.  So that
means a separate entry in the tdb database for each block entry.  That
will be slightly more inefficient in terms of overhead stored in the
tdb database, yes, but as a percentage of the blocksize (typically
4k), the overhead isn't that great, and the performance improvement
will be huge.

The downside of doing this is that you need to take into account
changes in blocksize via set_blksize() (this is rare; it's only done
by mke2fs, and then only to zap various MD superblocks, et. al), and
if the size is negative (in which case it represents the size in
bytes, which could be more or less than a blocksize, and not
necessarily a multiple of a blocksize).

But that's not too bad, since now you just have to do is figure out
which block(s) need to be saved, and then check to see if a record
already exists in the tdb; if it does, the original value has been
saved, and you don't have to do anything; if it doesn't then you just
save the entire block.  The undo manager need to save the first
blocksize specified, and backup the original data in the tdb file in
terms of that first blocksize, regardless of any later changes in the
blocksize (which as I said is rare).

> +		if (req_loc < cur_loc) {
> +			if (req_loc+req_size > cur_loc) {
> +				/*  ------------------
> +				 *  |      |    |    |
> +				 *  ------------------
> +				 *  rl     cl   rs   cs
> +				 */

This looks like notes to yourself; but it's not obvious what's going
on here.  Fortunately with the above suggested change in algorith,
most of this will go away, but please make your comments more obvious.

> +	// I have libtdb1. Enable after rebasing to latest e2fsprogs that has this API
> +	//tdb_transaction_start(data->tdb);

What version of e2fsprogs are you developing against?

> +		/* FIXME!! Not sure what should be the error */
> +		//tdb_transaction_cancel(data->tdb);
> +		retval = EXT2_ET_SHORT_WRITE;
> +		goto error_out;

I would add a new error code in lib/ext2fs/ext2_err.et.in; that way we
can have a very specific error code explaining that we have a failure
to save the original version of the block.  

> +       actual = read(data->dev, tdb_data.dptr, size);
> +       if (actual != size) {

Instead of using ext2fs_llseek() and read(), please use the underlying
io_manager.  That way the undo manager might have a chance to work on
some other io manager other than unix_io.  Yes, that means that you
might in some cases need to save and restore the current blksize.  But
that's not going to be the common case, and it will make the code much
more general.

> +error_out:
> +	/* Move the location back */
> +	if (ext2fs_llseek(data->dev, cur_loc, SEEK_SET) != cur_loc) {
> +		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
> +		goto error_out;
> +	}

Why do you need to move the location back?  As far as I know nothing
should be depending on current offset of the file descriptor.

						- Ted
