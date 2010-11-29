From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bug#605009: serious performance regression with ext4
Date: Mon, 29 Nov 2010 09:44:36 -0500
Message-ID: <20101129144436.GT2767@thunk.org>
References: <20101126093257.23480.86900.reportbug@pluto.milchstrasse.xx>
 <20101126145327.GB19399@rivendell.home.ouaza.com>
 <20101126215254.GJ2767@thunk.org>
 <20101127075831.GC24433@burratino>
 <20101127085346.GD14011@rivendell.home.ouaza.com>
 <20101129041152.GQ2767@thunk.org>
 <20101129072930.GA7213@burratino>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jonathan Nieder <jrnieder@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48100 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0K2Oop (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Nov 2010 09:44:45 -0500
Content-Disposition: inline
In-Reply-To: <20101129072930.GA7213@burratino>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 01:29:30AM -0600, Jonathan Nieder wrote:
> 
> >                        sync_file_range() is a Linux specific system
> > call that has been around for a while.  It allows program to control
> > when writeback happens in a very low-level fashion.  The first set of
> > sync_file_range() system calls causes the system to start writing back
> > each file once it has finished being extracted.  It doesn't actually
> > wait for the write to finish; it just starts the writeback.
> 
> True, using sync_file_range(..., SYNC_FILE_RANGE_WRITE) for each file
> makes later fsync() much faster.  But why?  Is this a matter of allowing
> writeback to overlap with write() or is something else going on?

So what's going on is this.  dpkg is writing a series of files.
fsync() causes the following to happen: 

	* force the file specified to be written to disk; in the case
		of ext4 with delayed allocation, this means blocks
		have to be allocated, so the block bitmap gets
		dirtied, etc.
	* force a journal commit.   This causes the block bitmap,
		inode table block for the inode, etc., to be written
		to the journal, followed by a barrier operation to make
		sure all of the file system metadata as well as the
		data blocks in the previous step, are written to disk.

If you call fsync() for each file, these two steps get done for each
file.  This means we have to do a journal commit for each and every
file.

By using sync_file_range() first, for all files, this forces the
delayed allocation to be resolved, so all of the block bitmaps, inode
data structures, etc., are updated.  Then on the first fdatasync(),
the resulting journal commit updates all of the block bitmaps and all
of the inode table blocks(), and we're done.  The subsequent
fdatasync() calls become no-ops --- which the ftrace shell script will
show.

We could imagine a new kernel interface which took an array of file
descriptors, say call it fsync_array(), which would force writeback on
all of the specified file descriptors, as well as forcing the journal
commit that would guarantee the metadata had been written to disk.
But calling sync_file_range() for each file, and then calling
fdatasync() for all of the, is something that exists today with
currently shipping kernels (and sync_file_range() has been around for
over four years; whereas a new system call wouldn't see wide
deployment for at least 2-3 years).

						- Ted

