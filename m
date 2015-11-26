From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix unreclaimed pages after truncate in
 data=journal mode
Date: Thu, 26 Nov 2015 15:12:53 -0500
Message-ID: <20151126201253.GB2632@thunk.org>
References: <1448354851-25405-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53470 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbbKZUNM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Nov 2015 15:13:12 -0500
Content-Disposition: inline
In-Reply-To: <1448354851-25405-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Nov 24, 2015 at 09:47:31AM +0100, Jan Kara wrote:
> Ted and Namjae have reported that truncated pages don't get timely
> reclaimed after being truncated in data=journal mode. The following test
> triggers the issue easily:
> 
> for (i = 0; i < 1000; i++) {
> 	pwrite(fd, buf, 1024*1024, 0);
> 	fsync(fd);
> 	fsync(fd);
> 	ftruncate(fd, 0);
> }
> 
> The reason is that journal_unmap_buffer() finds that truncated buffers
> are not journalled (jh->b_transaction == NULL), they are part of
> checkpoint list of a transaction (jh->b_cp_transaction != NULL) and have
> been already written out (!buffer_dirty(bh)). We clean such buffers but
> we leave them in the checkpoint list. Since checkpoint transaction holds
> a reference to the journal head, these buffers cannot be released until
> the checkpoint transaction is cleaned up. And at that point we don't
> call release_buffer_page() anymore so pages detached from mapping are
> lingering in the system waiting for reclaim to find them and free them.
> 
> Fix the problem by removing buffers from transaction checkpoint lists
> when journal_unmap_buffer() finds out they don't have to be there
> anymore.
> 
> Reported-and-tested-by: Namjae Jeon <namjae.jeon@samsung.com>
> Fixes: de1b794130b130e77ffa975bb58cb843744f9ae5
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks, applied.  Many thanks to Namjae and Jan for tracking this down!!

		       	      	 	    - Ted
