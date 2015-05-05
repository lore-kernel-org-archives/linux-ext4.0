From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/35] libext2fs: support atexit cleanups
Date: Tue, 5 May 2015 10:31:47 -0400
Message-ID: <20150505143147.GC9260@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023539.25243.26702.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45895 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993187AbbEEObt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:31:49 -0400
Content-Disposition: inline
In-Reply-To: <20150402023539.25243.26702.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:35:39PM -0700, Darrick J. Wong wrote:
> Use the atexit() function to provide a means for the library to clean
> itself up on program exit.  This will be used by the undo IO manager
> to flush the undo file state to disk if the program should terminate
> without closing the io channel, since most e2fsprogs clients will
> simply exit() when they hit errors.
> 
> This won't help for signal termination; client programs must set
> up signal handlers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, but in undo_io.c:

> @@ -769,11 +792,14 @@ static errcode_t undo_close(io_channel channel)
>  	err = write_undo_indexes(data);
>  	if (data->real)
>  		retval = io_channel_close(data->real);
> +	if (data->tdb_file)
> +		free(data->tdb_file);
>  	if (data->undo_file)
>  		io_channel_close(data->undo_file);
>  	ext2fs_free_mem(&data->keyb);
>  	if (data->written_block_map)
>  		ext2fs_free_generic_bitmap(data->written_block_map);
> +	ext2fs_remove_exit_fn(undo_atexit, data);
>  	ext2fs_free_mem(&channel->private_data);
>  	if (channel->name)
>  		ext2fs_free_mem(&channel->name);
> 

I've moved the call to ext2fs_remove_exit_fn() to right after the call
to write_undo_indexes().  This avoids a write if there is a signal
killing the process right after the call free the data->keyb and
before the call to ext2fs_remove_exit_fn().

						- Ted
